private _uidDevelopers = [];
private _uidMissionControllers = [];
private _uidMilitaryPolice = [];
private _uidCameraOperators = [];

private _s3File = '
	#include "\serverscripts\zeusserverscripts\zeus_assigner.sqf"
';

private _numbers = _s3File splitstring ",""";

private _uidMissionControllers = _numbers select { _x select [0,3] == "765" };

_uidDevelopers pushBackUnique "76561198168754324"; // Dakota.N
_uidDevelopers pushBackUnique "76561198114637526"; // JB
_uidDevelopers pushBackUnique "76561198048006094"; // Bojan
_uidDevelopers pushBackUnique "76561198089890491"; // Vex.W

[_uidDevelopers, _uidMissionControllers, _uidMilitaryPolice, _uidCameraOperators]