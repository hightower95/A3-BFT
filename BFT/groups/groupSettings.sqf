/*
	Author: Jacco Douma 

	Description: 
	Adds BFT settings to ACE interaction menu. 

	Parameter(s): 
		None

	Returns: 
	nothing

	TODO: 
	 - Also add BFT to map interactions
	 - Cusom name
	 - Update own marker whenever you change a setting
*/

// Add options to ACE menu
action_BFT = ["Jacco_BFT", "BFT", "", {true}, {leader group player == player && visibleMap}] call ace_interact_menu_fnc_createAction;
[player, 1, ["ACE_SelfActions"], action_BFT] call ace_interact_menu_fnc_addActionToObject;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Colors 
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
action_BFT_Colors = ["Jacco_BFT_Colors", "Color", "BFT\icons\colorWheel.paa", {true}, {true}] call ace_interact_menu_fnc_createAction;
[player, 1, ["ACE_SelfActions", "Jacco_BFT"], action_BFT_Colors] call ace_interact_menu_fnc_addActionToObject;

// Array with available colours and the name they're displayed as
_markerColours_side = [
	["ColorBLUFOR", "BLUFOR"],
	["ColorOPFOR", "OPFOR"],
	["colorIndependent", "Independent"],
	["colorCivilian", "Civilian"],
	["ColorUNKNOWN", "Unknown"]
];

_markerColours_other = [
	["ColorRed", "Red"],
	["ColorOrange", "Orange"],
	["ColorYellow", "Yellow"],
	["ColorGreen", "Green"],
	["ColorKhaki", "Khaki"],
	["ColorBlue", "Blue"],
	["ColorPink", "Pink"],
	["ColorBrown", "Brown"],
	["ColorGrey", "Grey"],
	["ColorBlack", "Black"],
	["ColorWhite", "White"]
];

// Add side colours
{
	_color = _x select 0; 
	_name = _x select 1; 

	_statement = {
		params ["_target", "_player", "_params"];
		(group player) setVariable ["BFT_marker_color", _params, true];
	};

	_action = [("Jacco_BFT_Colors_"+_name), _name, "BFT\icons\dot\"+_name+".paa", _statement, {true}, {}, _color] call ace_interact_menu_fnc_createAction;
	[player, 1, ["ACE_SelfActions", "Jacco_BFT", "Jacco_BFT_Colors"], _action] call ace_interact_menu_fnc_addActionToObject;
} forEach _markerColours_side;

// Add other colours
action_BFT_Colors_Other = ["Jacco_BFT_Colours_Other", "Other colors", "BFT\icons\plus.paa", {true}, {true}] call ace_interact_menu_fnc_createAction;
[player, 1, ["ACE_SelfActions", "Jacco_BFT", "Jacco_BFT_Colors"], action_BFT_Colors_Other] call ace_interact_menu_fnc_addActionToObject;


{
	_color = _x select 0; 
	_name = _x select 1; 

	_statement = {
		params ["_target", "_player", "_params"];
		(group player) setVariable ["BFT_marker_color", _params, true];
	};

	_action = [("Jacco_BFT_Colors_"+_name), _name, "BFT\icons\dot\"+_name+".paa", _statement, {true}, {}, _color] call ace_interact_menu_fnc_createAction;
	[player, 1, ["ACE_SelfActions", "Jacco_BFT", "Jacco_BFT_Colors", "Jacco_BFT_Colours_Other"], _action] call ace_interact_menu_fnc_addActionToObject;
} forEach _markerColours_other;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Team name
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
action_BFT_Name = ["Jacco_BFT_Name", "Name", "BFT\icons\pen.paa", {true}, {true}] call ace_interact_menu_fnc_createAction;
[player, 1, ["ACE_SelfActions", "Jacco_BFT"], action_BFT_Name] call ace_interact_menu_fnc_addActionToObject;

_teamNames = [
	"Zulu", 
	"Lima", 
	"Uniform",
	"Echo",
	"Whiskey",
	"Tango",
	"X-Ray",
	"Yankee"
];

{
	_statement = {
		params ["_target", "_player", "_params"];
		(group player) setGroupIdGlobal [_params];
	};
	_action = ["Jacco_BFT_Names_"+_x, _x, "", _statement, {true}, {}, _x] call ace_interact_menu_fnc_createAction;
	[player, 1, ["ACE_SelfActions", "Jacco_BFT", "Jacco_BFT_Name"], _action] call ace_interact_menu_fnc_addActionToObject;
} foreach _teamNames;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Team icon 
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
action_BFT_Icon = ["Jacco_BFT_Icons", "Icon", "BFT\icons\BFT.paa", {true}, {true}] call ace_interact_menu_fnc_createAction;
[player, 1, ["ACE_SelfActions", "Jacco_BFT"], action_BFT_Icon] call ace_interact_menu_fnc_addActionToObject;

_icons = [
	["inf", "Infantry"], 
	["motor_inf", "Motorized Infantry"], 
	["mech_inf", "Mechanized infantry"], 
	["air", "Air"], 
	["armor", "Armor"],
	["recon", "Recon"]
];
_additionalIcons = [
	["antiair", "Anti-Air"], 
	["art", "Artillery"], 
	["hq", "HQ"], 
	["installation", "Installation"], 
	["maint", "Maintenance"], 
	["med", "Medical"], 
	["mortar", "Mortar"], 
	["naval", "Naval"], 
	["ordnance", "Ordinance"], 
	["plane", "Plane"], 
	["service", "Service"], 
	["support", "Support"], 
	["uav", "UAV"], 
	["unknown", "Unknown"]
];

{
	_icon = _x select 0; 
	_name = _x select 1; 

	_statement = {
		params ["_target", "_player", "_params"];
		(group player) setVariable ["BFT_marker_type", _params, true]; 
	};

	_action = [("Jacco_BFT_Icons_"+_icon), _name, "", _statement, {true}, {}, _icon] call ace_interact_menu_fnc_createAction;
	[player, 1, ["ACE_SelfActions", "Jacco_BFT", "Jacco_BFT_Icons"], _action] call ace_interact_menu_fnc_addActionToObject;
} forEach _icons;

action_BFT_Icons_Other = ["Jacco_BFT_Icons_Other", "Other icons", "BFT\icons\plus.paa", {true}, {true}] call ace_interact_menu_fnc_createAction;
[player, 1, ["ACE_SelfActions", "Jacco_BFT", "Jacco_BFT_Icons"], action_BFT_Icons_Other] call ace_interact_menu_fnc_addActionToObject;

{
	_icon = _x select 0; 
	_name = _x select 1; 

	_statement = {
		params ["_target", "_player", "_params"];
		(group player) setVariable ["BFT_marker_type", _params, true]; 
	};

	_action = [("Jacco_BFT_Icons_"+_icon), _name, "", _statement, {true}, {}, _icon] call ace_interact_menu_fnc_createAction;
	[player, 1, ["ACE_SelfActions", "Jacco_BFT", "Jacco_BFT_Icons", "Jacco_BFT_Icons_Other"], _action] call ace_interact_menu_fnc_addActionToObject;
} forEach _additionalIcons;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Enable/Disable team tracker
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
action_BFT_Enable = ["Jacco_BFT_Enable", "Enable tracker", "BFT\icons\on.paa", {(group player) setVariable ["BFT_marker_enable", true, true]}, {!((group player) getVariable ["BFT_marker_enable", false]);}] call ace_interact_menu_fnc_createAction;
[player, 1, ["ACE_SelfActions", "Jacco_BFT"], action_BFT_Enable] call ace_interact_menu_fnc_addActionToObject;

action_BFT_Disable = ["Jacco_BFT_Disable", "Disable tracker", "BFT\icons\off.paa", {(group player) setVariable ["BFT_marker_enable", false, true]}, {((group player) getVariable ["BFT_marker_enable", false]);}] call ace_interact_menu_fnc_createAction;
[player, 1, ["ACE_SelfActions", "Jacco_BFT"], action_BFT_Disable] call ace_interact_menu_fnc_addActionToObject;