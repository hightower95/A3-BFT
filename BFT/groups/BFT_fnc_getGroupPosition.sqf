params ["_group"];

_position = getPos leader _group; 

switch (BFT_groupMarkers_trackingMode) do 
{
	case "WeigtedAverage": {
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
	};
};

// Return position
_position