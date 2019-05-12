params ["_uid"];

private _s3File = '
	#include "\serverscripts\zeusserverscripts\zeus_assigner.sqf"
';

private _numbers = _s3File splitstring ",""";

private _uidMissionControllers = _numbers select { _x select [0,3] == "765" };

if (_uid in _uidMissionControllers) exitWith { "MC" };

private _uidMilitaryPolice =
[
	
];

if (_uid in _uidMilitaryPolice) exitWith { "MP" };

""