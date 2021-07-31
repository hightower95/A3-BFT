/*
	Author: Jacco Douma 

	Description: 
	Draw players on map when zoomed in far enough

	Parameter(s): none

	Returns: 
	nothing
*/

// Wait until the map control actually exists, for some reason it doesnt work without this.
waitUntil {
	!isNull (findDisplay 12 displayCtrl 51);
};

fnc_vehicleIconColour = {

};

fnc_unitIcon = {
	private _player = [] call CBA_fnc_currentUnit;
	private _iconNamespace = missionNamespace getVariable format["diwako_dui_main_icon_%1", diwako_dui_icon_style];
	[_x, _iconNamespace, _player, true] call diwako_dui_radar_fnc_getIcon;
};

findDisplay 12 displayCtrl 51 ctrlAddEventHandler ["Draw", {
	params ["_control"];
	_maxScale = 250; // Max scale for the icons & text

	_scale = (10^(abs log (ctrlMapScale _control))) min _maxScale; 

	_markerSize = (1.8 * 0.13) * _scale;
	_textSize = (0.0015 * 0.13) * _scale;

	_alpha = [0.03*_scale-0.2, 0, 1] call BIS_fnc_clamp;

	if (_alpha > 0) then {
		// Players that have already been marked (when they're in a vehicle with someone else);
		private _alreadyMarkedPlayers = [];  
		
		{
			// _x = unit to mark 

			// Exit criteria
			if (side _x != side player) then {continue};
			if (_x in _alreadyMarkedPlayers) then {continue};
			// if (!isNull (getAssignedCuratorLogic _x)) then {continue}; // If unit is zeus

			// Basic things 
			_text = name _x; 
			_pos = getPos _x; 
			_dir = getDir _x; 

			_icon = _x getVariable ["diwako_dui_radar_compass_icon", [] call fnc_unitIcon];

			// Colour 
			private _colour = [playerSide, false] call BIS_fnc_sideColor;
			if (player in (units group _x)) then {
				_colour = + (_x getVariable "diwako_dui_main_compass_color"); // + cause otherwise we get locality issues 
			} else {
				_colour = [playerSide, false] call BIS_fnc_sideColor;
			};
			// if (_x getVariable ["ACE_isUnconscious", false]) then {_colour = [1, 0.5, 0];};

			if (_x != vehicle _x) then { // Unit is in vehicle
				// Position 
				_pos = getPos vehicle _x; 
				_dir = getDir vehicle _x; 

				// Icon (Get from config)
				_icon = getText (configfile >> "CfgVehicles" >> typeOf vehicle _x >> "icon");
				_markerSize = _markerSize * 2; 

				// Text (Driver, SL, Medic, +count) , this ugly, might redo
				_crew = crew vehicle _x; 
				_text = name (_crew select 0);
				if (count _crew >= 2) then {_text = _text + ", " + name (_crew select 1)};
				if (count _crew >= 3) then {_text = _text + ", " + name (_crew select 2)};
				if (count _crew >= 4) then {_text = _text + " +" + str (count _crew - 3)};

				// Colour (Colour if all the same team, otherwise white) (Still to do, lazy atm)
				// _colour = [1,1,1];

				// Add all units in vehicle to _alreadyMarkedPlayers
				_alreadyMarkedPlayers append (crew vehicle _x); 
			} else { // Unit is not in vehilce
				
			};

			// Set alpha
			_colour set [3, _alpha];

			// Draw icon
			_this select 0 drawIcon [
				_icon,
				_colour,
				_pos,
				_markerSize,
				_markerSize,
				_dir,
				_text,
				1,
				_textSize,
				"TahomaB",
				"right"
			];
		} forEach allPlayers;
		// } forEach allUnits;
	};
}];