params [["_container", objNull, ["", objNull]]];

if (_container isEqualType "") exitWith { getNumber (configFile >> "CfgVehicles" >> _container >> "maximumLoad") > 0 };

getNumber (configFile >> "CfgVehicles" >> typeOf _container >> "maximumLoad") > 0