params ["_delay", "_default"];

// Global variable for all group markers 
BFT_GroupMarkers = [];

if (BFT_groupMarkers_enable) then {
	while {BFT_groupMarkers_enable} do {
		// Remove old markers
		[] execVM "BFT\groups\BFT_fnc_removeGroupMarkers.sqf";

		// Create new markers 
		[_default] execVM "BFT\groups\BFT_fnc_drawGroupMarkers.sqf";

		// Sleep 
		if (isMultiplayer) then {
			sleep(_delay - (serverTime % _delay));
		} else {
			sleep _delay;
		};
	};
};