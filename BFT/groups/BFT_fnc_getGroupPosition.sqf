params ["_group"];

fnc_weightedAverage = {
	params ["_group"];

	_position = position leader _x;
	_weight = 3 * (count units _x); // Starting weight, amount of times we count the leader position.  
	{
		// If unit is within 500m, ignore them from position calculation
		if ((_x distance2D (leader group _x)) > 500) then {continue};

		// Ignore leader, we have their position already
		if (_x == leader group _x) then {continue};
		
		// Each unit in the group 'pulls' the marker towards them
		// The strength of the pull decreases 
		_position = [
			// ((running average) + (current position)) ... (averaged)
			(((_position select 0) * _weight) + ((position _x) select 0)) / (_weight + 1),
			(((_position select 1) * _weight) + ((position _x) select 1)) / (_weight + 1)
		];

		// Increase weight - as we've included one more unit now 
		_weight = _weight + 1; 
	} forEach units _x;

	_position;
};

_position = position leader _group; 

switch (BFT_groupMarkers_trackingMode) do 
{
	case "WeigtedAverage": {
		[_group] call fnc_weightedAverage;
	};
};

if (BFT_groupMarkers_trailing) then {
	// Add found position to the front of the array
	_positions = _group getVariable ["BFT_Trail_Positions", []];
	_positions = [_position] + _positions; 

	// Limit the size to trailing weight. 
	_positions = _positions select [0, round BFT_groupMarkers_trailing_count];

	// Update variable
	_group setVariable ["BFT_Trail_Positions", _positions];

	// Calculate new position 
	_weight = 1; 
	_totalWeight = 1; 
	_position = _positions select 0;
	{
		// Skip the first one
		if (_forEachIndex == 0) then {continue;};
		_weight = _weight * BFT_groupMarkers_trailing_weight;

		_position = [
			(((_position select 0) * _totalWeight) + ((_x select 0) * _weight)) / (_totalWeight + _weight),
			(((_position select 1) * _totalWeight) + ((_x select 1) * _weight)) / (_totalWeight + _weight)
		];

		_totalWeight = _totalWeight + _weight; 
	} forEach _positions;
};

// Return position
_position