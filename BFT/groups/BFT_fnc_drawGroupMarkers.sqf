{
	if !(_x getVariable ["BFT_groupMarker_visible", false]) then {continue;};
	if (count units _x <= 0) then {continue;};
	if (side _x != playerSide) then {continue;};

	// Position
	_markerPos = [_x] call compile preprocessFileLineNumbers "BFT\groups\BFT_fnc_getGroupPosition.sqf";

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