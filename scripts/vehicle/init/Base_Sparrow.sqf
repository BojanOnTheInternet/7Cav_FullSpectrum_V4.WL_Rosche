[_this select 0,{
	_this select 0 setPylonLoadOut ["pylon3", "rhsusf_mag_gau19_melb_right", true];
	_this select 0 setPylonLoadOut ["pylon2", "rhsusf_mag_gau19_melb_left", true];
}] call JB_fnc_respawnVehicleInitialize;
[_this select 0, 300] call JB_fnc_respawnVehicleWhenKilled;
[_this select 0, 300] call JB_fnc_respawnVehicleWhenAbandoned;
