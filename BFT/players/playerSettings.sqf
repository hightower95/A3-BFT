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
