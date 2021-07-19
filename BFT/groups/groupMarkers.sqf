/*
	Author: Jacco Douma 

	Description: 
	Marks all friendly groups every n seconds. 

	Parameter(s): 
		0: NUMBER - delay between updates
		1: STRING - side of the markers, "b" for BLUFOR, "o" for OPFOR, "n" for INDEP

	Returns: 
	nothing
*/
params ["_delay", "_onlyPlayers"];

// Map markers
_allMarkers = [];

while {true} do {
	// Delete old markers
	{
		deleteMarkerLocal _x;
	} forEach _allMarkers;

	// Create new markers
	{
		_skip = false; 
		if (_x getVariable ["BFT_marker_disable", false]) then {_skip = true;};
		if (count units _x > 0) then {_skip = true;};

		// Create marker if current group isn't skipped
		if (!_skip) then {
			_markerPos = position leader _x; 
			_markerType = _x getVariable ["BFT_marker_type", "inf"];
			_markerColor = _x getVariable ["BFT_marker_color", "colorBLUFOR"];

			// Get marker side, default to BLUFOR
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
			_allMarkers pushBack _marker;
		}
	} forEach allGroups;

	sleep(_delay);
}