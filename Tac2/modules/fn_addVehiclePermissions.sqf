/*
 * Author: Bojan
 * Give a select player full vehicle permissions
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Example:
 * this call Tac2_fnc_addVehiclePermissions
 *
 * Public: Yes
 */

params ["_unit"];

_unit = [_logic, false] call Ares_fnc_GetUnitUnderCursor;

if (_unit isKindOf "Man") then {

	_dialogResult = [
        "Set Player Permission Type",
        [
            ["Permissions to grant",
				[
					"All",
					"Transport Rotary",
					"Attack Rotary",
					"Fixed Wing Attack",
					"Tank / Heavy Armour",
					"Logistics Vehicles"
				],0]
        ]
    ] call Ares_fnc_ShowChooseDialog;

    if (count _dialogResult == 0) exitWith {};

    _extra_permission = switch (_dialogResult select 0) do {
        case 0: { TypeFilter_All };
        case 1: { TypeFilter_TransportRotory };
        case 2: { TypeFilter_AttackRotory };
        case 3: { TypeFilter_GroundAttackAircraft };
        case 4: { TypeFilter_ArmoredVehicles };
        case 5: { TypeFilter_LogisticsVehicles };
    };

	[_unit] call CLIENT_SetInfantryVehiclePermissions;
	{
		_unit setVariable [_x, [[_extra_permission, [], {}]] + (_unit getVariable _x)];
	} forEach ["VP_Driver", "VP_Pilot", "VP_Gunner", "VP_Turret"];

} else {
	["Not a unit!"] call Ares_fnc_ShowZeusMessage;
	playSound "FD_Start_F";
};