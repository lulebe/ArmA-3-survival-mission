_helicopterHeight = 30;
_waveDelay = 30;

_normalUnits = ["O_Soldier_F", "O_Soldier_F", "O_Soldier_F", "O_Soldier_F", "O_Solder_AR_F", "O_Soldier_GL_F", "O_Soldier_M_F", "O_HeavyGunner_F"];
_normalHelicopters = ["B_Heli_Light_01_dynamicLoadout_F", "O_Heli_Light_02_dynamicLoadout_F", "O_Heli_Attack_02_dynamicLoadout_F"];
_normalVehicles = ["O_LSV_02_Armed_F", "O_MRAP_02_hmg_F", "O_G_Offroad_01_armed_F"];

vehicleWaves = 3;
helicopterWaves = 5;

_spawnsUnits = [
	"spawn_units_1",
	"spawn_units_2",
	"spawn_units_3",
	"spawn_units_4"
];
_spawnHelicopter = [markerPos "spawn_helicopter" select 0, markerPos "spawn_helicopter" select 1];
_spawnVehicle = markerPos "spawn_vehicle";

publicVariable "vehicleWaves";
publicVariable "helicopterWaves";

_setupGroup = {
	_group = _this select 0;
	_group allowFleeing 0;
	_group deleteGroupWhenEmpty true;
	_group setCombatMode "RED";
	_wp = _group addWaypoint [markerPos "target", 0];
	_wp setWaypointType "MOVE";
	_wp setWaypointSpeed "FULL";
};

onKill = {
	livingUnits = livingUnits - 1;
	[livingUnits] remoteExecCall ["showKill"];
	money = money + 10;
	publicVariable "money";
	[money] remoteExecCall ["updateMoney"];
};

_spawnUnitsAsGroup = {
	_unitCount = _this select 0;
	_group = createGroup east;
	_position = markerPos (selectRandom _spawnsUnits);
	for "_x" from 1 to _unitCount do {
		_unit = _group createUnit [selectRandom _normalUnits, _position, [], 3, "FORM"];
		if (!(isNull _unit)) then {
			_unit setSkill 0.5;
			livingUnits = livingUnits + 1;
			unitsOfCurrentWave pushBack _unit;
			_unit addEventHandler ["killed", {
				_u = _this select 0;
				_u removeAllEventHandlers "killed";
				[] call onKill;
			}];
		};
	};
	[_group] spawn {
		_g = _this select 0;
		while {alive leader _g} do {
			if (!(leader _g inArea targetArea)) then {
				leader _g move markerPos "target";
			};
			sleep 2;
		};
	};
	[_group] call _setupGroup;
	_wp2 = _group addWaypoint [markerPos "target", 5];
	_wp2 setWaypointType "SAD";
	_wp2 setWaypointSpeed "FULL";
};

_spawnVehicleWithCrew = {
	_vData = [_spawnVehicle, 0, selectRandom _normalVehicles, east] call BIS_fnc_spawnVehicle;
	_vData select 0 setDir 180;
	{
		livingUnits = livingUnits + 1;
		unitsOfCurrentWave pushBack _x;
		_x addEventHandler ["killed", {
			_u = _this select 0;
			_u removeAllEventHandlers "killed";
			[] call onKill;
		}];
	} forEach (_vData select 1);
	_group = _vData select 2;
	[_group] call _setupGroup;
};

_spawnHelicopterWithCrew = {
	_vData = [_spawnHelicopter, 0, selectRandom _normalHelicopters, east] call BIS_fnc_spawnVehicle;
	_heli = _vData select 0;
	_heli engineOn true;
	_heli flyInHeight _helicopterHeight;
	_heli setPos [getPos _heli select 0, getPos _heli select 1, _helicopterHeight];
	{
		livingUnits = livingUnits + 1;
		unitsOfCurrentWave pushBack _x;
		_x addEventHandler ["killed", {
			_u = _this select 0;
			_u removeAllEventHandlers "killed";
			[] call onKill;
		}];
	} forEach (_vData select 1);
	_group = _vData select 2;
	[_group] call _setupGroup;
	_wp2 = _group addWaypoint [markerPos "target", 5];
	_wp2 setWaypointType "LOITER";
	_wp2 setWaypointSpeed "NORMAL";
	_wp2 setWaypointLoiterRadius 100;
};

_spawnNextWave = {
	startNextWaveNow = false;
	livingUnits = 0;
	waveRunning = true;
	publicVariable "waveRunning";

	_totalUnits = currentWave * 2;
	_groups = ceil (currentWave / 7);
	_unitsPerGroup = floor (_totalUnits / _groups);
	for "_x" from 1 to _groups do {
		[_unitsPerGroup] call _spawnUnitsAsGroup; 
	};

	if ((currentWave mod vehicleWaves) == 0) then {
		[] call _spawnVehicleWithCrew;
	};

	if ((currentWave mod helicopterWaves) == 0) then {
		[] call _spawnHelicopterWithCrew;
	};
	[currentWave, livingUnits, vehicleWaves, helicopterWaves] remoteExecCall ["showWaveStart"];
	waitUntil { livingUnits <= 0; };
	waveRunning = false;
	publicVariable "waveRunning";
	[currentWave, _waveDelay] remoteExecCall ["showWaveEnd"];
	unitsOfCurrentWave = [];
	[+allDead] spawn {
		sleep 60;
		{
			deleteVehicle _x;
		} forEach (_this select 0);
	};
	_nextWaveAt = time + _waveDelay;
	waitUntil {time >= _nextWaveAt || startNextWaveNow};
};

while {true} do {
	[] call _spawnNextWave;
	currentWave = currentWave + 1;
	publicVariable "currentWave";
};