// Add settings to ACE interact menu 
[] execVM "BFT\groups\BFT_fnc_addGroupSettings.sqf";

// Global variable for all group markers 
BFT_GroupMarkers = [];

// Set enabled variable for player group if not set yet 
if ((group player getVariable ["BFT_groupMarker_visible", objNull]) isEqualTo objNull) then {
	group player setVariable ["BFT_groupMarker_visible", true, true];
};

fnc_drawMarkerLoop = {
	while {BFT_groupMarkers_enable} do {		
		// Remove old markers
		_handleRemoveMarkers = [] execVM "BFT\groups\BFT_fnc_removeGroupMarkers.sqf";
		waitUntil{ scriptDone _handleRemoveMarkers};

		// Create new markers 
		[] execVM "BFT\groups\BFT_fnc_drawGroupMarkers.sqf";

		// Sleep 
		if (isMultiplayer) then {
			_nextUpdateTime = serverTime + BFT_groupMarkers_updateDelay;
			waitUntil {sleep 1; serverTime > _nextUpdateTime};
		} else {
			sleep (round BFT_groupMarkers_updateDelay);
		};

	};
	// final cleanup
	_handleRemoveMarkers = [] execVM "BFT\groups\BFT_fnc_removeGroupMarkers.sqf";
	waitUntil{ scriptDone _handleRemoveMarkers};
	// remove reference to ourself as clean up
	player setVariable ["BFT_groupMarker_drawLoopHandle", objNull, false];
};

["CBA_SettingChanged", {
    params ["_setting", "_value"];
	
	switch (_setting) do {
		case "BFT_groupMarkers_enable": {
			if (_value) then {
				// value is now set to true
				_currentLoop = player getVariable ["BFT_groupMarker_drawLoopHandle", objNull];
				if(isNull _currentLoop == false) then {
					diag_log "BFT Warning:: Tried to start BFT_groupMarkers loop when it is already running....terminated existing loop";
					terminate _currentLoop;
				};
				_markerLoopHandle = [] spawn fnc_drawMarkerLoop;
				player setVariable ["BFT_groupMarker_drawLoopHandle", _markerLoopHandle, false];				
			} else {
				// markers are being turned off
				[] execVM "BFT\groups\BFT_fnc_removeGroupMarkers.sqf";
			} 
		};
		default {};
	}
}] call CBA_fnc_addEventHandler;

_markerLoopHandle = [] spawn fnc_drawMarkerLoop;
player setVariable ["BFT_groupMarker_drawLoopHandle", _markerLoopHandle, false];
