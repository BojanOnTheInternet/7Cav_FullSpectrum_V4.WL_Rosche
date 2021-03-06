diag_log "initServer start";

#include "\serverscripts\zeusserverscripts\secretKey.sqf"
missionNamespace setVariable["LOYALTY_CIPHER", CIPHERSECRETKEY, true];

#include "SPM\strongpoint.h"

addMissionEventHandler ["PlayerConnected", SERVER_PlayerConnected];
addMissionEventHandler ["PlayerDisconnected", SERVER_PlayerDisconnected];

_null = [] execVM "scripts\sessionTimeMessagesInit.sqf";

// Disable RHS engine start up so vehicles move immediately when spawned
RHS_ENGINE_STARTUP_OFF = 1;

// Make sure armed civilians won't attack NATO
civilian setFriend [west, 1];
// Make sure AAF won't attack CSAT
independent setFriend [east, 1];
east setFriend [independent, 1];
// Make sure AAF will attack NATO
independent setFriend [west, 0];

//BUG: Fool BIS_fnc_drawMinefields into believing that it's already running.  This turns off the automatic display of minefields on the map.  The difficulty setting in the server configuration file doesn't seem to work.
bis_fnc_drawMinefields_active = true;

// Start times selected randomly throughout the daylight hours between sunrise and one hour before sunset
waitUntil { time > 0 }; // Allow time subsystem to initialize so that missionStart is correct
private _date = missionStart select [0, 5];

private _times = [_date] call BIS_fnc_sunriseSunsetTime;
private _startTime = (_times select 0) + (random ((_times select 1) - (_times select 0) - 1));
private _startHour = floor _startTime;
private _startMinute = (_startTime - _startHour) * 60;

_date set [3, _startHour];
_date set [4, _startMinute];

setDate _date;

// Markers of format LOCATION_<type>_<id> are turned into locations of the specified type and marker text.  The id is optional and is used to make the marker names unique.  The markers will be hidden.
private _location = 0;
{
	(_x splitString "_") params ["_unused", "_type"];

	private _location = createLocation ([_type, getMarkerPos _x] + getMarkerSize _x);
	_location setText markerText _x;

	_x setMarkerAlpha 0;
} forEach (allMapMarkers select { _x find "LOCATION_" == 0 });

// Delete any group that stays empty across two checks (10-20 seconds)
[] spawn
{
	private _previouslyEmptyGroups = [];
	private _currentlyEmptyGroups = [];

	while { true } do
	{
		_currentlyEmptyGroups = [];
		{ if (_x in _previouslyEmptyGroups) then { deleteGroup _x } else { _currentlyEmptyGroups pushBack _x } } forEach (allGroups select { count units _x == 0 });
		_previouslyEmptyGroups = _currentlyEmptyGroups;

		sleep 10;
	};
};

[] call compile preprocessFile ("scripts\configure" + worldName + "Server.sqf"); // Island-specific modifications
[] call compile preprocessFile "scripts\weatherInit.sqf"; // Variable weather

[] execVM "mission\Advance\missionControl.sqf";

SpecialOperations_RunState = ["stop", "run"] select (["SpecialOperations"] call JB_MP_GetParamValue);
[] execVM "mission\SpecialOperations\missionControl.sqf";
SpecialOperations_MaxPlayers = 15;

// Delete missions when appropriate
[] execVM "mission\missionMonitor.sqf";

// Stuff involving players entering enemy-held areas
[] call SERVER_MonitorProximityRoundRequests;

["Initialize"] call BIS_fnc_dynamicGroups;

[] execVM "ASL_AdvancedSlingLoading\functions\fn_advancedSlingLoadInit.sqf";
[] execVM "AR_AdvancedRappelling\functions\fn_advancedRappellingInit.sqf";
[] execVM "AT_AdvancedTowing\functions\fn_advancedTowingInit.sqf";
[] execVM "AUR_AdvancedUrbanRappelling\functions\fn_advancedUrbanRappellingInit.sqf";

[] execVM "scripts\decals.sqf";
[] execVM "scripts\fortifyInit.sqf";

enableEnvironment [false, true];

diag_log "initServer end";
