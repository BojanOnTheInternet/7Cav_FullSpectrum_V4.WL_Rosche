private _state = param [0, "", [""]];

if (_state == "init") then
{

	[] call MAP_InitializeGeneral;
	[] call HUD_Armor_Initialize;

	player setVariable ["SPM_BranchOfService", "armor"];

	[player] call CLIENT_SetArmorCrewVehiclePermissions;
};

if (_state == "respawn") then
{
	[TypeFilter_ArmoredVehicles] call JB_fnc_manualDriveInitPlayer;
};