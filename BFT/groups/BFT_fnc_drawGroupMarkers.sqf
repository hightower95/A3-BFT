{
	if !(_x getVariable ["BFT_groupMarker_visible", false]) then {continue;};
	if (count units _x <= 0) then {continue;};
	if (side _x != playerSide) then {continue;};

	// Position
	_markerPos = position leader _x;
	_weight = 3 * (count units _x); // Starting weight, amount of times we count the leader position.  
	{
		// If unit is within 500m, ignore them from position calculation
		if ((_x distance2D (leader group _x)) > 500) then {continue};

		// Ignore leader, we have their position already
		if (_x == leader group _x) then {continue};
		
		// Each unit in the group 'pulls' the marker towards them
		// The strength of the pull decreases 
		_markerPos = [
			// ((running average) + (current position)) ... (averaged)
			(((_markerPos select 0) * _weight) + ((position _x) select 0)) / (_weight + 1),
			(((_markerPos select 1) * _weight) + ((position _x) select 1)) / (_weight + 1)
		];

		// Increase weight - as we've included one more unit now 
		_weight = _weight + 1; 
	} forEach units _x;

	// Type & Color 
	_markerType = _x getVariable ["BFT_groupMarker_type", "inf"];
	_markerColor = _x getVariable ["BFT_groupMarker_color", [playerSide, true] call BIS_fnc_sideColor];

	// Side, default to BLUFOR
	private _markerSide = "b"; 
	if (playerSide == opfor) then {_markerSide = "o"};
	if (playerSide == independent) then {_markerSide = "n"};

	// Create marker
	_marker = createMarkerLocal [groupId _x, _markerPos];
	_marker setMarkerShapeLocal "ICON";
	_marker setMarkerTypeLocal (_markerSide + "_" + _markerType);
	_marker setMarkerTextLocal groupId _x;
	_marker setMarkerColorLocal _markerColor;

	// Add marker to array 
	BFT_GroupMarkers pushBack _marker;
} forEach allGroups;