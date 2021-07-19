/*
	Author: Jacco Douma 

	Description: 
	Adds BFT settings to ACE interaction menu. 

	Parameter(s): 
		None

	Returns: 
	nothing
*/

_action_Icon = ["Jacco_BFT_PlayerIcon", "Map icon", "", {true}, {visibleMap}] call ace_interact_menu_fnc_createAction;
[player, 1, ["ACE_SelfActions"], _action_Icon] call ace_interact_menu_fnc_addActionToObject;

_icons = [
// 	  Icon 					 Description
	["", 					"Automatic"],
	["iconMan", 			"Default"],
	["iconManLeader", 		"Leader"],
	["iconManMedic", 		"Medic"],
	["iconManMG", 			"Machinegunner"],
	["iconManEngineer", 	"Engineer"],
	["iconManAT", 			"AT/AA"],
	["iconManExplosive", 	"Explosives specialist"],
	["iconManOfficer", 		"Officer"]
];

{
	_icon = _x select 0; 
	_text = _x select 1; 

	_statement = {
		params ["_target", "_player", "_params"];
		player setVariable ["BFT_player_icon", _params, true];
	};

	_action = ["Jacco_BFT_PlayerIcon_"+_icon, _text, getText (configfile >> "CfgVehicleIcons" >> _icon), _statement, {true}, {}, _icon] call ace_interact_menu_fnc_createAction;
	[player, 1, ["ACE_SelfActions", "Jacco_BFT_PlayerIcon"], _action] call ace_interact_menu_fnc_addActionToObject;
} forEach _icons;