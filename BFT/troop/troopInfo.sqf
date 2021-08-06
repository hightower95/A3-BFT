TroopInfoDiaryRecord = objNull;

fnc_getFriendlyTeams = {
	_side = side player;
	_friendlyTeams = [];
	
	{
		if(side _x == _side) then {
			_friendlyTeams pushBackUnique _x;
		}
		// Current result is saved in variable _x
		
	} forEach allGroups;

	_friendlyTeams
};

fnc_sortedGroups = {
	// Function sorts by group name 
	private _groups = [] call fnc_getFriendlyTeams;
	_sortedGroups = [];

	// First lets find the groups we are always interested in. We want the
	// troop lead (Zulu) to always be the first group
	_groupNames = [];
	{_groupNames pushBack (groupId _x)} forEach _groups; // create a list of group names
	_preferredGroupOrder = ["Zulu", "Lima", "Uniform", "Echo", "Whisky", "Tango"];
	{
		// Current result is saved in variable _x
		_index = -1;
		_index = _groupNames find _x;
		if(_index > -1) then {
			_sortedGroups pushBack (_groups deleteAt _index);
			_groupNames deleteAt _index;
		};
				
	} forEach _preferredGroupOrder;

	// Now lets add in the groups which have not been sorted yet (they dont have a preferred name)
	_sortedGroups = _sortedGroups + ([_groups, [], {groupId _x}] call BIS_fnc_sortBy);

	_sortedGroups;
};

fnc_rgbToHex = {
	params ["_color"];
	
	// In case of ColorBLUFOR stuff, which is:
	/*
	[
		"(profilenamespace getvariable ['Map_BLUFOR_R',0])",
		"(profilenamespace getvariable ['Map_BLUFOR_G',1])",
		"(profilenamespace getvariable ['Map_BLUFOR_B',1])",
		"(profilenamespace getvariable ['Map_BLUFOR_A',0.8])"
	]
	*/
	{
		if (typename _x == typename "") then {
			_color set [_forEachIndex, call compile _x]; 
		};
	} forEach _color;

	_r = (_color select 0) * 255; 
	_g = (_color select 1) * 255; 
	_b = (_color select 2) * 255; 

	"#" + (([_r] call ace_common_fnc_toHex) + ([_g] call ace_common_fnc_toHex) + ([_b] call ace_common_fnc_toHex)); 
};

// Return an array of strings
fnc_groupText = {
	params ["_group"];

	_lines = []; 

	// Add group name 
	private _markerSide = "b"; 
	if (playerSide == opfor) then {_markerSide = "o"};
	if (playerSide == independent) then {_markerSide = "n"};

	private _markerType = _group getVariable ["BFT_groupMarker_type", "inf"];

	// https://community.bistudio.com/wiki/BIS_fnc_colorRGBtoHTML 
	// https://community.bistudio.com/wiki/BIS_fnc_colorRGBtoHTML 

	private _markerColor = _group getVariable ["BFT_groupMarker_color", [playerSide, true] call BIS_fnc_sideColor];
	private _color = [getArray (configfile >> "CfgMarkerColors" >> _markerColor >> "color")] call fnc_rgbToHex;

	private _icon = getText (configfile >> "CfgMarkers" >> (_markerSide + "_" + _markerType) >> "icon");
	private _image = format ["<img image='%1' width='24' height='24' color='%2'/>", _icon, _color];
	private _name = format ["<font size='24' >%1</font>", groupId _group];
	_lines pushBack format ["%1 %2<br/>", _image, _name]; 

	// Add units
	{
		private _color = [+ (_x getVariable "diwako_dui_main_compass_color")] call fnc_rgbToHex; // + cause otherwise we get scope issues 
		private _image = format ["<img image='%1' width='16' height='16' color='%2'/>", _x getVariable "diwako_dui_radar_compass_icon", _color];
		private _name = format ["<font size='16' >%1</font>", name _x]; 
		_lines pushBack format ["%1  %2<br/>", _image, _name]; 
	} forEach units _group;

	// Return 
	_lines; 
};

fnc_getTroopText = {
	_groups = [] call fnc_sortedGroups; 

	// Add lines per group
	_lines = []; 
	{
		_lines append ([_x] call fnc_groupText); 
	} forEach _groups;

	// Compile final text
	_text = ""; 

	{
		_text = _text + _x; 
	} forEach _lines;

	_text; 
};

addMissionEventHandler ["Map", {
	_diarySubject = "Diary";

	if !(isNull TroopInfoDiaryRecord) then {
		player removeDiaryRecord [_diarySubject, TroopInfoDiaryRecord];
	};

	TroopInfoDiaryRecord = player createDiaryRecord [
		_diarySubject, 
		[
			"Troop",
			[] call fnc_getTroopText
		], 
		taskNull, 
		"",
		true
	];
}];