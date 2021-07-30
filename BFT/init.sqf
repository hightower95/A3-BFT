// Settings
_delay = 4; // Delay between squad marker updates 
_default = false; // Sets the default show marker value for groups

// Squad markers 
[] execVM "BFT\groups\groupSettings.sqf";
[_delay, _default] execVM "BFT\groups\groupMarkers.sqf";

// Player markers 
[] execVM "BFT\players\drawPlayers.sqf";

// Troop info 
// [] execVM "BFT\troop\troopInfo.sqf"