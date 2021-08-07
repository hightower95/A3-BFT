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
		[] execVM "BFT\groups\BFT_fnc_removeGroupMarkers.sqf";

		// Create new markers 
		[] execVM "BFT\groups\BFT_fnc_drawGroupMarkers.sqf";

		// Sleep 
		if (isMultiplayer) then {
			_nextUpdateTime = serverTime + BFT_groupMarkers_updateDelay;
			waitUntil {serverTime > _nextUpdateTime};
		} else {
			sleep round BFT_groupMarkers_updateDelay;
		};

	};
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
				if(_currentLoop != objNull) then {
					terminate _currentLoop;
					systemChat "Tried to start BFT_groupMarkers loop when it is already running....terminated existing loop";
				};
				_markerLoopHandle = [] call fnc_drawMarkerLoop;
				player setVariable ["BFT_groupMarker_drawLoopHandle", _markerLoopHandle, false];				
			}; 
		};
		default {};
	}
}] call CBA_fnc_addEventHandler;

_markerLoopHandle = [] call fnc_drawMarkerLoop;
player setVariable ["BFT_groupMarker_drawLoopHandle", _markerLoopHandle, false];
