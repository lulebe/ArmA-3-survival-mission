_helicopterHeight = 30;
_waveUnitRewardFactor = 15;

_normalUnits = ["O_Soldier_F", "O_Soldier_F", "O_Soldier_F", "O_Soldier_F", "O_Solder_AR_F", "O_Soldier_GL_F", "O_Soldier_M_F", "O_HeavyGunner_F"];
_normalHelicopters = ["O_Heli_Light_02_dynamicLoadout_F", "O_Heli_Attack_02_dynamicLoadout_F"];
_normalVehicles = ["O_LSV_02_Armed_F", "O_MRAP_02_hmg_F", "O_G_Offroad_01_armed_F"];
_heavyVehicles = ["O_MBT_02_cannon_F", "O_APC_tracked_02_cannon_F", "O_APC_wheeled_02_rcws_v2_F"];


_spawnsUnits = [
	"spawn_units_1",
	"spawn_units_2",
	"spawn_units_3",
	"spawn_units_4"
];
_spawnHelicopter = [markerPos "spawn_helicopter" select 0, markerPos "spawn_helicopter" select 1];
_spawnVehicle1 = markerPos "spawn_vehicle_1";
_spawnVehicle2 = markerPos "spawn_vehicle_2";


_setupGroup = {
	_group = _this select 0;
	_group allowFleeing 0;
	_group deleteGroupWhenEmpty true;
	_group setCombatMode "RED";
	_wp = _group addWaypoint [markerPos "target", 0];
	_wp setWaypointType "MOVE";
	_wp setWaypointSpeed "FULL";
	{_group reveal [_x, 3]} forEach allPlayers;
};

onKill = {
	if ((_this select 0) == killRewardUnit) then {
		livingUnits = livingUnits - 1;
		[livingUnits] remoteExecCall ["showKill"];
	};
	money = money + (_this select 0);
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
			_unit setSkill 0.7;
			livingUnits = livingUnits + 1;
			unitsOfCurrentWave pushBack _unit;
			_unit addEventHandler ["killed", {
				_u = _this select 0;
				_u removeAllEventHandlers "killed";
				[killRewardUnit] call onKill;
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
	_vehNum = _this select 1;
	_vehiclesList = _normalVehicles;
	if (currentWave >= (heavyVehiclesStartWave + (_vehNum * moreHeavyVehiclesInterval))) then {
		_vehiclesList = _heavyVehicles;
	};
	_vData = [_this select 0, 0, selectRandom _vehiclesList, east] call BIS_fnc_spawnVehicle;
	_vData select 0 setDir 180;
	(_vData select 0) addEventHandler ["killed", {
		_u = _this select 0;
		_u removeAllEventHandlers "killed";
		[killRewardVehicle] call onKill;
	}];
	{
		livingUnits = livingUnits + 1;
		unitsOfCurrentWave pushBack _x;
		_x addEventHandler ["killed", {
			_u = _this select 0;
			_u removeAllEventHandlers "killed";
			[killRewardUnit] call onKill;
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
	(_vData select 0) addEventHandler ["killed", {
		_u = _this select 0;
		_u removeAllEventHandlers "killed";
		[killRewardHelicopter] call onKill;
	}];
	{
		livingUnits = livingUnits + 1;
		unitsOfCurrentWave pushBack _x;
		_x addEventHandler ["killed", {
			_u = _this select 0;
			_u removeAllEventHandlers "killed";
			[killRewardUnit] call onKill;
		}];
	} forEach (_vData select 1);
	_group = _vData select 2;
	{ _group reveal [_x, 2] } forEach allPlayers;
	[_group] call _setupGroup;
	_wp2 = _group addWaypoint [markerPos "target", 5];
	_wp2 setWaypointType "SAD";
	_wp2 setWaypointSpeed "NORMAL";
	_wp2 setWaypointCompletionRadius 50;
};

_spawnNextWave = {
	{
		_x removeAllEventHandlers "killed";
		_x setDamage 1;
	} forEach unitsOfCurrentWave;
	unitsOfCurrentWave = [];
	startNextWaveNow = false;
	livingUnits = 0;
	noWaveReward = false;
	waveRunning = true;
	publicVariable "waveRunning";

	_totalUnits = floor (currentWave * 1.5 * (0.6 + ((count allPlayers) * 0.4)));
	_groups = ceil (currentWave / 7);
	_unitsPerGroup = floor (_totalUnits / _groups);
	for "_x" from 1 to _groups do {
		[_unitsPerGroup] call _spawnUnitsAsGroup; 
	};

	if ((currentWave mod vehicleWaves) == 0) then {
		[_spawnVehicle1, 0] call _spawnVehicleWithCrew;
		if (currentWave >= moreVehiclesStartWave) then {
			[_spawnVehicle2, 1] call _spawnVehicleWithCrew;
		};
	};

	if ((currentWave mod helicopterWaves) == 0) then {
		[] call _spawnHelicopterWithCrew;
	};
	[currentWave, livingUnits, vehicleWaves, helicopterWaves] remoteExecCall ["showWaveStart"];
	_waveRewardMax = livingUnits * _waveUnitRewardFactor;
	_waveStartTime = time;
	waitUntil { livingUnits <= 0; };
	waveRunning = false;
	publicVariable "waveRunning";
	waveEndTime = time;
	if (!noWaveReward) then {
		_waveReward = _waveRewardMax - round (waveEndTime - _waveStartTime);
		if (_waveReward < 0) then {
			_waveReward = 0
		};
		money = money + _waveReward;
		publicVariable "money";
		[money] remoteExecCall ["updateMoney"];
	};
	[currentWave] execVM "fillAmmobox.sqf";
	[+allDead] spawn {
		sleep 60;
		{
			deleteVehicle _x;
		} forEach (_this select 0);
	};
	nextWaveAt = time + waveDelay + (currentWave * addedWaveDelay);
	_waveEndDisplay = [] spawn {
		while {true} do {
			[currentWave, nextWaveAt - time] remoteExecCall ["showWaveEnd"];
			sleep 1;
		};
	};
	waitUntil {time >= nextWaveAt || startNextWaveNow};
	terminate _waveEndDisplay;
};

while {true} do {
	[] call _spawnNextWave;
	currentWave = currentWave + 1;
	publicVariable "currentWave";
};