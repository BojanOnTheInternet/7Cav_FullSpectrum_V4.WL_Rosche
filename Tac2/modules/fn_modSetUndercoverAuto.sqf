params [["_position", [0,0,0], [[]], 3], ["_objectUnderCursor", objNull, [objNull]]];
private _selectedObjects = if (isNull _objectUnderCursor) then
	{
		["Objects"] call Achilles_fnc_SelectUnits;
	}
	else
	{
		[_objectUnderCursor];
	};

_dialogResult = [
        "Set undercover operation parameters",
        [
            ["Weapon spot distance m", "", "50"],
			["Enemy FOV degrees", "", "150"],
			["Suppressed weapon audible range m", "", "20"],
			["Unsuppressed weapon audible range m", "", "50"]
        ]
    ] call Ares_fnc_ShowChooseDialog;

if (count _dialogResult == 0) exitWith {};

_dialogResult params ["_a", "_b", "_c", "_d"];

{
	// We run this on the server so we can get the player's ID, so we can then run it on them
	[[[parseNumber _a, parseNumber _b, parseNumber _c, parseNumber _d], owner _x], {
		_this select 0 remoteExec ["Tac2_fnc_setUndercoverAuto", _this select 1, false];
	}] remoteExec ["call", 2, false]	
} forEach _selectedObjects