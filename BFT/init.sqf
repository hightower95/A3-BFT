/*
	Group variables: 
		BFT_marker_type: marker type, can be: 
			air, antiair, armor, art, hq, inf, installation, maint, mech_inf, med, mortar, motor_inf, naval, ordinance, plane, recon, service, support, uav, unknown
		BFT_marker_color: marker color, see https://community.bistudio.com/wiki/Arma_3:_CfgMarkerColors 
		BFT_marker_disable: obvious.

	Player variables: 
		BFT_player_icon: Player icon on map, can be: 
			iconMan, iconManAT, iconManEngineer, iconManExplosive, iconManLeader, iconManMedic, iconManMG, iconManOfficer, iconManRecon, iconManVirtual
*/

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