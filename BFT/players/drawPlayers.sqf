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
			// Set name
			_name = name _x;
			if (!isPlayer _x) then {
				_name = "[AI] " + _name;
			};

			// Draw icon
			_this select 0 drawIcon [
				"iconMan",
				[1,1,1,_alpha],
				getPos _x,
				_markerSize,
				_markerSize,
				getDir _x,
				name _x,
				1,
				_textSize,
				"TahomaB",
				"right"
			];
		} forEach units (side player);
	};
}];