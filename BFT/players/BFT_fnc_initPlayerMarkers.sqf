/*
	Author: Jacco Douma 

	Description: 
	Draw players on map when zoomed in far enough

	Parameter(s): none

	Returns: 
	nothing
*/

// Add ACE options to map 
action_Playermarkers_On = ["BFT_PlayerMarkers_On", "Enable unit marker", "BFT\icons\on.paa", {player setVariable ["BFT_playerMarker_visible", true, true]}, {visibleMap && !(player getVariable ["BFT_playerMarker_visible", true])}] call ace_interact_menu_fnc_createAction;
[player, 1, ["ACE_SelfActions"], action_Playermarkers_On] call ace_interact_menu_fnc_addActionToObject;

action_Playermarkers_Off = ["BFT_PlayerMarkers_Off", "Disable unit marker", "BFT\icons\off.paa", {player setVariable ["BFT_playerMarker_visible", false, true]}, {visibleMap && player getVariable ["BFT_playerMarker_visible", true]}] call ace_interact_menu_fnc_createAction;
[player, 1, ["ACE_SelfActions"], action_Playermarkers_Off] call ace_interact_menu_fnc_addActionToObject;

[] spawn {
	// Set player marker value (off if zeus)
	sleep 5; // Zeus isn't assigned instantly
	player setVariable ["BFT_playerMarker_visible", (isNull (getAssignedCuratorLogic player)), true];
};

// Wait until the map control actually exists, for some reason it doesnt work without this.
waitUntil {
	!isNull (findDisplay 12 displayCtrl 51);
};

fnc_vehicleIconColor = {
	params ["_vehicle"];

	_color = [0,0,0];
	{
		if !(_x in units group player) then {continue}; 

		_teamColor = + (_x getVariable "diwako_dui_main_compass_color"); 

		// Set color first time
		if (_color isEqualTo [0,0,0]) then {
			_color = + _teamColor; 
			continue; 
		};

		// Set color to white if the new color is different
		if !(_color isEqualTo _teamColor) then {
			_color = [1,1,1];
			break;
		}
	} forEach (crew _vehicle);

	if (_color isEqualTo [0,0,0]) then {
		_color = [playerSide, false] call BIS_fnc_sideColor;
	};

	_color; 
};

fnc_vehicleText = {
	params ["_vehicle"];

	_crew = crew _vehicle; 
	_text = name (_crew select 0);
	if (count _crew >= 2) then {_text = _text + ", " + name (_crew select 1)};
	if (count _crew >= 3) then {_text = _text + ", " + name (_crew select 2)};
	if (count _crew >= 4) then {_text = _text + " +" + str (count _crew - 3)};

	_text
};

fnc_unitIcon = {
	private _player = [] call CBA_fnc_currentUnit;
	private _iconNamespace = missionNamespace getVariable format["diwako_dui_main_icon_%1", diwako_dui_icon_style];
	[_x, _iconNamespace, _player, true] call diwako_dui_radar_fnc_getIcon;
};

fnc_getUnitsToBeMarked = {
	_units = []; 

	// Return empty if turned off  
	if !(BFT_playerMarkers_enable) exitWith {[]};

	if (BFT_playerMarkers_otherGroups) then {
		// Mark other groups
		{
			if (side group _x != side player) then {continue;};
			if ((isPlayer _x || BFT_playerMarkers_AI) && _x getVariable ["BFT_playerMarker_visible", true]) then {
				_units pushBack _x; 
			};
		} forEach allUnits;
	} else {
		// Only mark own group
		{
			if ((isPlayer _x || BFT_playerMarkers_AI) && _x getVariable ["BFT_playerMarker_visible", true]) then {
				_units pushBack _x; 
			};
		} forEach units group player;
	};

	_units
};

findDisplay 12 displayCtrl 51 ctrlAddEventHandler ["Draw", {
	params ["_control"];
	_maxScale = 250; // Max scale for the icons & text

	_scale = (10^(abs log (ctrlMapScale _control))) min _maxScale; 

	_alpha = [0.03*_scale-0.2, 0, 1] call BIS_fnc_clamp;

	if (_alpha > 0) then {
		// Players that have already been marked (when they're in a vehicle with someone else);
		private _alreadyMarkedPlayers = [];  
		
		_textSize = (0.0015 * 0.13) * _scale;

		{
			// _x = unit to mark 
			private ["_icon","_color","_pos","_dir","_text"];

			_markerSize = (1.8 * 0.13) * _scale;

			// Dont' remark already marked players 
			if (_x in _alreadyMarkedPlayers) then {continue};

			if !(_x != vehicle _x) then { // Unit is not in vehilce
				// Basic things 
				_text = name _x; 
				_pos = getPos _x; 
				_dir = getDir _x; 

				_icon = _x getVariable ["diwako_dui_radar_compass_icon", [] call fnc_unitIcon];

				// Color 
				_color = [playerSide, false] call BIS_fnc_sideColor;
				if (player in (units group _x)) then {
					_color = + (_x getVariable "diwako_dui_main_compass_color"); // + cause otherwise we get locality issues 
					if (_x getVariable ["ACE_isUnconscious", false]) then {_color = [1, 0.5, 0];};
				} else {
					_color = [playerSide, false] call BIS_fnc_sideColor;
				};
			} else { // Unit is in vehicle
				// Icon (Get from config)
				_icon = getText (configfile >> "CfgVehicles" >> typeOf vehicle _x >> "icon");

				// Color (Color if all the same team, otherwise white) (Still to do, lazy atm)
				_color = [vehicle _x] call fnc_vehicleIconColor;

				// Position 
				_pos = getPos vehicle _x; 
				_dir = getDir vehicle _x; 

				// Text
				_text = [vehicle _x] call fnc_vehicleText;

				// Increase marker size;
				_markerSize = _markerSize * 2.5; 

				// Add all units in vehicle to _alreadyMarkedPlayers
				_alreadyMarkedPlayers append (crew vehicle _x); 
			};

			// Set alpha
			_color set [3, _alpha];

			// Draw icon
			_this select 0 drawIcon [
				_icon,
				_color,
				_pos,
				_markerSize,
				_markerSize,
				_dir,
				_text,
				1,
				_textSize,
				diwako_dui_font,
				"right"
			];
		} forEach ([] call fnc_getUnitsToBeMarked);
	};
}];