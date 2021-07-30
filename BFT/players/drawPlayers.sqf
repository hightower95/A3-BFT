/*
	Author: Jacco Douma 

	Description: 
	Draw players on map when zoomed in far enough

	Parameter(s): none

	Returns: 
	nothing
*/

/*

	Icons: 
		iconMan
		iconManLeader
		iconManMedic
		iconManMG
		iconManEngineer
		iconManAT

		iconManExplosive
		iconManOfficer
		iconManRecon
		iconManVirtual

*/

// Wait until the map control actually exists, for some reason it doesnt work without this.
waitUntil {
	!isNull (findDisplay 12 displayCtrl 51);
};

findDisplay 12 displayCtrl 51 ctrlAddEventHandler ["Draw", {
	params ["_control"];
	_maxScale = 250; // Max scale for the icons & text

	_scale = (10^(abs log (ctrlMapScale _control))) min _maxScale; 

	_markerSize = (1.8 * 0.13) * _scale;
	_textSize = (0.0015 * 0.13) * _scale;

	_alpha = [0.03*_scale-0.2, 0, 1] call BIS_fnc_clamp;

	hint str _scale; 

	if (_alpha > 0) then {
		// Players that have already been marked (when they're in a vehicle with someone else);
		private _alreadyMarkedPlayers = [];  
		
		{
			// _x = unit to mark 
			if (side _x != side player) then {continue};
			if (_x in _alreadyMarkedPlayers) then {continue};

			// Basic things 
			_icon = _x getVariable ["diwako_dui_radar_compass_icon", ""];
			_text = name _x; 
			_pos = getPos _x; 
			_dir = getDir _x; 

			if (_icon == "") then {
				
			};

			// Colour 
			private _colour = [1,1,1];
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

				// Text (Driver, SL, Medic, +count) , this ugly, might redo
				_crew = crew vehicle _x; 
				_text = name (_crew select 0);
				if (count _crew >= 2) then {_text = _text + ", " + name (_crew select 1)};
				if (count _crew >= 3) then {_text = _text + ", " + name (_crew select 2)};
				if (count _crew >= 4) then {_text = _text + " +" + str (count _crew - 3)};

				// Colour (Colour if all the same team, otherwise white) (Still to do, lazy atm)
				_colour = [1,1,1];

				// Add all units in vehicle to _alreadyMarkedPlayers
				_alreadyMarkedPlayers append (crew vehicle _x); 
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
		// } forEach allPlayers;
		} forEach units group player;
	};
}];