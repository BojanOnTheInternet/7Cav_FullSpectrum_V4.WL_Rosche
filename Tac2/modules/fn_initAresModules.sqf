if !(isClass (configFile >> "CfgPatches" >> "achilles_data_f_ares")) exitWith { false };

["7Cav - Tac2", "Grant player vehicle permissions",{
    [(_this select 0)] call Tac2_fnc_addVehiclePermissions;
}] call Ares_fnc_RegisterCustomModule;