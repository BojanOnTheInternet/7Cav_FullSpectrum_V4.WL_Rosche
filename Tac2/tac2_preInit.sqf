// Init custom Ares modules
call Tac2_fnc_initAresModules;

// Initialize loyalty rewards GUI
_vehDialog = [] spawn compile PreprocessFileLineNumbers "Tac2\dialog\loyalty_fnc.sqf";

[] spawn {
	while { true } do {
		sleep 900;
		private _lastPosition = profileNamespace getVariable ["Tac2Loyalty_lastPosition", [0,0,0]];
		private _currentPosition = getPos player;

		profileNamespace setVariable ["Tac2Loyalty_lastPosition", _currentPosition];

		if (_lastPosition distance _currentPosition > 7) then {
			[10, "for activity"] call LOYALTY_fnc_addPointsLocal;
		}
	};
};