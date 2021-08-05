// https://cbateam.github.io/CBA_A3/docs/files/settings/fnc_addSetting-sqf.html

// _setting	Unique setting name.  Matches resulting variable name STRING
// _settingType	Type of setting.  Can be “CHECKBOX”, “EDITBOX”, “LIST”, “SLIDER” or “COLOR” STRING
// _title	Display name or display name + tooltip (optional, default: same as setting name) <STRING, ARRAY>
// _category	Category for the settings menu + optional sub-category <STRING, ARRAY>
// _valueInfo	Extra properties of the setting depending of _settingType.  See examples below <ANY>
    // [min, max, default value, trailing decimals (-1 for whole numbers only)]
// _isGlobal	1: all clients share the same setting, 2: setting can’t be overwritten (optional, default: 0) ARRAY
// _script	Script to execute when setting is changed.  (optional) <CODE>
// _needRestart	Setting will be marked as needing mission restart after being changed.  (optional, default false) <BOOL>


[
	"BFT_groupMarkers_enable", // enabled?
	"CHECKBOX",
	"Enable group markers", 
	"BFT - Group markers",
	true // Default is true
] call CBA_fnc_addSetting; 

[
	"BFT_groupMarkers_updateDelay",
	"SLIDER",
	"Update delay", 
	"BFT - Group markers",
	[1, 60, 4, 0]
] call CBA_fnc_addSetting; 

// [
// 	"BFT_groupMarkers_markZeus",
// 	"CHECKBOX",
// 	"Enable marking zeus", 
// 	"BFT - Zeus marked",
//	1
// ] call CBA_fnc_addSetting; // maybe a server setting?


