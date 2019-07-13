#define cavYellow [0.922,0.78,0.161,1]
#define cavGrey [0.631,0.631,0.631,1]
#define black [0,0,0,1]
#define white [1,1,1,1]

// vehicle is defined by
// [classname, points, cooldown (minutes), max # available at once, {conditions}, {after create callback}]

[] call compile preprocessFileLineNumbers "Tac2\secure\encryptedProfile.sqf";

LoyaltyVehicles = [
	["rhsusf_mrzr4_d", 150, 10, -1, {}, {}],
	["rhsusf_M1232_M2_usarmy_d", 300, 10, -1, {}, {}],
	["rhsusf_m1a2sep1tuskiid_usarmy", 500, 20, 2, {}, {}],
	["B_T_VTOL_01_infantry_F", 800, 30, 2, {}, {}],
	["B_APC_Tracked_01_CRV_F", 1150, 60, 2, {}, {
		[_this select 0, 16] call ace_cargo_fnc_setSpace;
		[_this select 0, -1] call ace_cargo_fnc_setSize;
		[_this select 0, 6000] call ace_refuel_fnc_setFuel;
		[_this select 0, 1200] call ace_rearm_fnc_setSupplyCount;
		(_this select 0) setVariable ["ACE_isRepairVehicle", true, true];
	}],
	["rhsusf_m113d_usarmy_medical", 1500, 40, -1, {}, {
		(_this select 0) setvariable ["ace_medical_isMedicalFacility", true, true];
	}],
	["RHS_UH60M_MEV", 2000, 20, -1, {}, {
		(_this select 0) setvariable ["ace_medical_isMedicalFacility", true, true];
	}],
	["B_UAV_02_F", 2400, 60, 1, {}, {}],
	["rhs_uh1h_hidf", 2900, 40, -1, {}, {}],
	["rhsusf_m1025_w_mk19", 3400, 60, 1, {}, {}],
	["B_AFV_Wheeled_01_cannon_F", 3900, 60, 2, {}, {}],
	["I_LT_01_cannon_F", 4500, 60, 2, {}, {}],
	["B_UAV_05_F", 5200, 60, 1, {}, {}],
	["RHS_UH1Y", 5900, 90, 1, {}, {}],
	["RHS_AH1Z", 6500, 90, 1, {}, {}],
	["B_Heli_Attack_01_dynamicLoadout_F", 7200, 90, 1, {}, {}],
	["B_T_VTOL_01_armed_F", 8000, 120, 1, {}, {}]
];

LOYALTY_fnc_OpenSpawnUI = 
{	
	createDialog "RscTUTVehDialog";
	
	_serverTitleCbo = ((findDisplay 1601) displayCtrl (10));
	_title = "7Cav Loyalty Rewards";
	_serverTitleCbo ctrlSetStructuredText parseText format ["<t align='left' size='1.3'>%1</t>",_title];

	_serverTitleCbo = ((findDisplay 1601) displayCtrl (12));
	_serverTitleCbo ctrlSetStructuredText parseText format [
"
<t align='left' size='0.9' font='EtelkaMonospacePro'>Current points: <t >%1</t></t>
<br/>
<br/>
<t align='left' size='0.9'>Players recieve 10 points every 15 minutes they are active, and may recieve additional points from assuming 
leadership positions during Zeus-run operations, or by consistently providing feedback on the mission via the 7Cav forums.</t>
"
		, call LOYALTY_fnc_getPointsLocal
	];

	[] call LOYALTY_fnc_loadVehicle;

	_spawnButton = (findDisplay 1601) displayCtrl 6;
	_spawnButton ctrlShow false;
	_spawnButton ctrlEnable false;

	_dropDown = ((findDisplay 1601) displayCtrl (13));
	_dropDown ctrlShow false;
};


LOYALTY_fnc_loadVehicle = 
{
	_cbo = ((findDisplay 1601) displayCtrl (7));
	lbCLear _cbo;
	{
		_vehicleClass = _x select 0;
		_vehiclePoints = _x select 1;

		_vIndex = _cbo lbAdd(getText(configFile >> "cfgVehicles" >> _vehicleClass >> "displayName"));
		_cbo lbSetData[_vIndex, str _forEachIndex];

		_cbo lbSetValue [_vIndex,  _vehiclePoints];

		_picture = (getText(configFile >> "cfgVehicles" >> _vehicleClass >> "picture"));
		_cbo lbSetPicture[_vIndex,_picture];
	} foreach LoyaltyVehicles;

	lbSortByValue _cbo
};


LOYALTY_fnc_vehicleInfo = 
{
	_spawnButton = (findDisplay 1601) displayCtrl 6;
	_spawnButton ctrlShow true;
	_spawnButton ctrlEnable true;

	disableSerialization;

	_vehicleIndex = parseNumber (lbData [7, lbCurSel 7]);
	_vehicle = LoyaltyVehicles select _vehicleIndex;
	_vehicle params ["_vehicleClass", "_pointCost", "_cooldownCost", "_maxVehicles", "_condition", "_callBack"];


	_dropDown = ((findDisplay 1601) displayCtrl (13));
	lbCLear _dropDown;
	{
		_textureIndex = _dropDown lbAdd format ["%1", getText (_x >> "displayName")];
		_dropDown lbSetData [_textureIndex, str getArray (_x >> "textures")];
	} foreach ("true" configClasses (configfile >> "CfgVehicles" >>_vehicleClass >> "textureSources"));
	_dropDown ctrlShow true;

	_textCbo = ((findDisplay 1601) displayCtrl (8));	
	_textCbo ctrlSetStructuredText parseText format 
	[
		"
		<t align='left'>Name:</t>
		<t align='left'>%1</t><br/>
		<t align='left'>Points:</t>
		<t align='left'>%2</t><br/>
		<t align='left'>Cooldown:</t>
		<t align='left'>%3 minutes</t><br/>",
		getText (configFile >> "CfgVehicles" >> _vehicleClass >> "displayName"),
		_pointCost,
		_cooldownCost
	];

	_spawnButton = (findDisplay 1601) displayCtrl 6;

	_lastSpawnTime = missionNamespace getVariable [getPlayerUID player + "Tac2Loyalty_LastSpawnTime", 0];
	_lastCooldownLength = call LOYALTY_fnc_getCooldownLocal;
	_playerPoints = call LOYALTY_fnc_getPointsLocal;

	_allowSpawn = true;
	_reason = "";
	if (_lastSpawnTime + _lastCooldownLength > serverTime) then {
		_allowSpawn = false;
		_reason = format ["Cooldown for another %1 minutes", round (((_lastSpawnTime + _lastCooldownLength) - serverTime) / 60)];
	};

	if (_playerPoints < _pointCost) then {
		_allowSpawn = false;
		_reason = "Insufficient points";
	};

	if (_maxVehicles != -1 && _vehicleClass countType vehicles >= _maxVehicles) then {
		_allowSpawn = false;
		_reason = format ["Maximum number reached (%1)", _maxVehicles];
	};

	if (!([] call _condition)) then {
		_allowSpawn = false;
		_reason = "Unavailable";
	};
	
	if (_allowSpawn) then {
		_spawnButton ctrlEnable true;
		_spawnButton ctrlSetText "Spawn";
	} else {
		_spawnButton ctrlEnable false;
		_spawnButton ctrlSetText _reason;
	};
};


LOYALTY_fnc_vehicleCreate = 
{
	_vehicleIndex = parseNumber (lbData [7, lbCurSel 7]);
	_vehicle = LoyaltyVehicles select _vehicleIndex;
	_vehicle params ["_vehicleClass", "_pointCost", "_cooldownCost", "_maxVehicles", "_condition", "_callBack"];

	_emptyPos = (getPos player) findEmptyPosition [5, 50, (_vehicleClass)];
	if (!isNull loyaltySpawn) then { 
		_emptyPos = (getPos loyaltySpawn) findEmptyPosition [5, 50, (_vehicleClass)];
	};

	if (count _emptyPos == 0) then { hint "Vehicle cannot be spawned here"; }
	else
	{	
		_veh = createVehicle [(_vehicleClass), _emptyPos, [], 0,""];
		if ((lbData [13, lbCurSel 13]) != "") then {
			_vehicleTextures = parseSimpleArray (lbData [13, lbCurSel 13]);
			{_veh setObjectTextureGlobal [ _forEachIndex, _x ] } forEach _vehicleTextures;
		};

		[_cooldownCost * 60] call LOYALTY_fnc_setCooldownLocal;
		missionNamespace setVariable [getPlayerUID player + "Tac2Loyalty_LastSpawnTime", serverTime];

		[_veh] call _callBack;		
	};
	closeDialog 1601;

};

LOYALTY_fnc_addPointsLocal =
{
	params ["_points", ["_reason", ""]];
	_playerPoints = call LOYALTY_fnc_getPointsLocal;
	["Tac2Loyalty_PlayerPoints", _playerPoints + _points] call SECURE_setProfileVariable;
	titleText [format ["Awarded +%1 loyalty points %2", _points, _reason], "plain down"];
};

LOYALTY_fnc_getPointsLocal =
{
	parseNumber (["Tac2Loyalty_PlayerPoints", 0] call SECURE_getProfileVariable);
};

LOYALTY_fnc_getCooldownLocal =
{
	missionNamespace getVariable [getPlayerUID player + "Tac2Loyalty_Cooldown", 0];
};

LOYALTY_fnc_setCooldownLocal =
{
	params ["_cooldownLength"];
	missionNamespace setVariable [getPlayerUID player + "Tac2Loyalty_Cooldown", _cooldownLength];
};