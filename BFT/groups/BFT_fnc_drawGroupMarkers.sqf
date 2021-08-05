params ["_default"];

{
	if !(_x getVariable ["BFT_marker_enable", _default]) then {continue;};
	if (count units _x <= 0) then {continue;};
	if (side _x != playerSide) then {continue;};

	// Position
	// _markerPos = position leader _x; 
	_markerPos = position leader _x;
	_weight = 3 * (count units group player); // Starting weight, amount of times we count the leader position.  
	{
		// If unit is within 500m, continue
		if ((_x distance2D (leader group _x)) > 500) then {continue};

		// Ignore leader
		if (_x == leader group _x) then {continue};
		
		// Add to average position
		_markerPos = [
			(((_markerPos select 0) * _weight) + ((position _x) select 0)) / (_weight + 1),
			(((_markerPos select 1) * _weight) + ((position _x) select 1)) / (_weight + 1)
		];

		// Add weight 
		_weight = _weight + 1; 
	} forEach units _x;

	// Type & Color 
	_markerType = _x getVariable ["BFT_marker_type", "inf"];
	_markerColor = _x getVariable ["BFT_marker_color", [playerSide, true] call BIS_fnc_sideColor];

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