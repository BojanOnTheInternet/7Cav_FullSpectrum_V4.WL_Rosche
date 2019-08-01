// Init custom Ares modules
call Tac2_fnc_initAresModules;

// Initialize loyalty rewards GUI
_vehDialog = [] spawn compile PreprocessFileLineNumbers "Tac2\loyalty\loyalty_fnc.sqf";

[] spawn {
	sleep 900;
	while { true } do {
		private _lastPosition = profileNamespace getVariable ["Tac2Loyalty_lastPosition", [0,0,0]];
		private _currentPosition = getPos player;

		while {_lastPosition distance _currentPosition < 7} do {
			_currentPosition = getPos player;
			sleep 1;
		};

		[10, "for activity"] call LOYALTY_fnc_addPointsLocal;
		profileNamespace setVariable ["Tac2Loyalty_lastPosition", _currentPosition];

		sleep 900;
	};
};