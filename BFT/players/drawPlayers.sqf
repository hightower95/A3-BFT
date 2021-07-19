/*
	Author: Jacco Douma 

	Description: 
	Draw players on map when zoomed in far enough

	Parameter(s): none

	Returns: 
	nothing
*/
_size = 10; 

// Wait until the map control actually exists, for some reason it doesnt work without this.
waitUntil {
	!isNull (findDisplay 12 displayCtrl 51);
};

/*

	Icons: 
		iconMan
		iconManAT
		iconManEngineer
		iconManExplosive
		iconManLeader
		iconManMedic
		iconManMG
		iconManOfficer
		iconManRecon
		iconManVirtual

*/

findDisplay 12 displayCtrl 51 ctrlAddEventHandler ["Draw", {
	params ["_control"];

	_multiplier = 10^(abs log (ctrlMapScale _control));
	_markerSize = (1.8 * 0.15) * _multiplier;
	_textSize = (0.0012 * 0.15) * _multiplier;

	_alpha = 0.012*_multiplier-0.2;

	hintSilent str format ["%1\n%2\n%3", _multiplier, _markerSize, _textSize]; 

	if (_alpha > 0) then {
		{
			// Name
			private _name = name _x;
			if (!isPlayer _x) then {
				_name = ("[AI] " + _name);
			};

			// Icon 

			// Colour 
			private _colour = [1,1,1];
			if (_x getVariable ["ACE_isUnconscious", false]) then {
				_colour = [1, 0.5, 0];
				systemChat "Drawing unconscious...";
			};
			_colour pushBack _alpha;

			// Draw icon
			_this select 0 drawIcon [
				"iconMan",
				_colour,
				getPos _x,
				_markerSize,
				_markerSize,
				getDir _x,
				_name,
				1,
				_textSize,
				"TahomaB",
				"right"
			];
		} forEach units (playerSide);
	};
}];