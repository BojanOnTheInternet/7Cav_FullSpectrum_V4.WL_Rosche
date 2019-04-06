params [["_vehicle", objNull, [objNull]], ["_turretPath", [], [[]]], ["_weapon", "", [""]], ["_enable", true, [true]]];

if (isNull _vehicle) exitWith { diag_log "WARNING: JB_fnc_weaponControlInitializeVehicle called with a null vehicle" };
if (count _turretPath == 0) exitWith { diag_log "WARNING: JB_fnc_weaponControlInitializeVehicle called with an empty turret specification" };

private _turrets = (_vehicle getVariable ["JB_WC_Turrets", []]);
private _turretIndex = _turrets findIf { (_x select 0) isEqualTo _turretPath };

if (_turretIndex == -1) exitWith { diag_log "WARNING: JB_fnc_weaponControlInitializeVehicle unable to match turret specification" };

private _turret = _turrets select _turretIndex;
private _weaponIndex = (_turret select 2) findIf { _x select 0 == _weapon };

if (_weaponIndex == -1) exitWith { diag_log "WARNING: JB_fnc_weaponControlInitializeVehicle unable to match weapon on specified turret" };

[_vehicle, _turretPath, [_vehicle, _turretIndex, _weaponIndex, _enable], { _this call JB_WC_ChangeWeapon }] remoteExec ["JB_WC_SendToTurret", 2]; // Ask the server to route the request to the owner of the turret