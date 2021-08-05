// setLightnings

[] execVM "BFT\initCBA.sqf";

// Squad markers 
[] execVM "BFT\groups\BFT_fnc_addGroupSettings.sqf";
[] execVM "BFT\groups\BFT_fnc_initGroupMarkers.sqf";

// Player markers 
[] execVM "BFT\players\drawPlayers.sqf";

// Troop info 
// [] execVM "BFT\troop\troopInfo.sqf"