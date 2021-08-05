// Global variable for all group markers 
BFT_GroupMarkers = [];

// Set enabled variable for player group if not set yet 
if ((group player getVariable ["BFT_groupMarker_visible", objNull]) isEqualTo objNull) then {
	group player setVariable ["BFT_groupMarker_visible", true, true];
};

fnc_drawMarkerLoop = {
	while {true} do {
		// Remove old markers
		[] execVM "BFT\groups\BFT_fnc_removeGroupMarkers.sqf";

		// Leave loop after removing markers
		if !(BFT_groupMarkers_enable) exitWith {};

		// Create new markers 
		[] execVM "BFT\groups\BFT_fnc_drawGroupMarkers.sqf";

		// Sleep 
		if (isMultiplayer) then {
			sleep(round BFT_groupMarkers_updateDelay - (serverTime % round BFT_groupMarkers_updateDelay));
		} else {
			sleep round BFT_groupMarkers_updateDelay;
		};
	};
};

["CBA_SettingChanged", {
    params ["_setting", "_value"];
	
	switch (_setting) do {
		case "BFT_groupMarkers_enable": {
			if (_value) then {
				[] spawn fnc_drawMarkerLoop;
			}
		};
		default {};
	}
}] call CBA_fnc_addEventHandler;

[] call fnc_drawMarkerLoop;