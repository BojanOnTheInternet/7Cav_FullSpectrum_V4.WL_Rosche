if (not isServer && hasInterface) exitWith {};

// Infantry

SPM_InfantryGarrison_RatingsSyndikat = "toLower (configName _x) find 'LOP_PMC_INFANTRY_' == 0" configClasses (configFile >> "CfgVehicles");
SPM_InfantryGarrison_RatingsSyndikat = SPM_InfantryGarrison_RatingsSyndikat apply { [configName _x, [1, 1]] };

SPM_InfantryGarrison_CallupsSyndikat =
[
	[(configfile >> "CfgGroups" >> "Indep" >> "LOP_PMC" >> "Infantry" >> "LOP_PMC_Rifle_squad"), [1, 8, 1.0]]
];

SPM_InfantryGarrison_InitialCallupsSyndikat =
[

	[(configfile >> "CfgGroups" >> "Indep" >> "LOP_PMC" >> "Infantry" >> "LOP_PMC_Rifle_squad"), [1, 8, 1.0]],
	[(configfile >> "CfgGroups" >> "Indep" >> "LOP_PMC" >> "Infantry" >> "LOP_PMC_Support_section"), [1, 4, 1.0]]
];
// Patrol cars

SPM_MissionAdvance_Patrol_CallupsSyndikat =
[
	["I_C_Offroad_02_LMG_F",
		[10, 2, 1.0, {}]],
	["I_C_Offroad_02_AT_F", [20, 3, 1.0, {}]]
];

SPM_MissionAdvance_Patrol_RatingsSyndikat = SPM_MissionAdvance_Patrol_CallupsSyndikat apply { [_x select 0, (_x select 1) select [0, 2]] };

// Transport

SPM_Transport_CallupsEastTruck =
[
	["I_C_Van_01_transport_F", [1, 3, 0.5, {}]],
	["I_G_Van_01_transport_F", [1, 3, 0.2, {}]],
	["C_Truck_02_covered_F", [1, 3, 1.0, {}]],
	["C_Truck_02_transport_F", [1, 3, 1.0, {}]]
];