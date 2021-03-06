_enterActionId = _this select 2;
player removeAction _enterActionId;


_buildOptions = [
	["low sandbags", "Land_SandbagBarricade_01_half_F",75, [0,1,0.55], {}, {true}, "", true, []],
	["high sandbags", "Land_SandbagBarricade_01_F", 130, [0,1,1.3], {}, {true}, "", true, []],
	["concrete shelter", "Land_CnCShelter_F", 130, [0,1,1], {}, {true}, "", true, []],
	["ramp", "Land_Obstacle_Ramp_F", 150, [0,2,0.5], {}, {true}, "", true, [[0,-1,0],[0,0,1]]],
	["concrete roof", "Land_ConcreteWall_01_m_4m_F", 400, [0,0,3], {
		_walkway = "Land_Sidewalk_01_narrow_4m_F" createVehicle position _this;
		_walkway attachTo [_this, [0,0,0]];
		_walkway setVectorDirAndUp [[0,0,1], [0,-1,0]];
		_walkway allowDamage false;
	}, {true}, "", true, [[0,0,-1], [1,0,0]]],
	["bunker", "Land_BagBunker_Small_F", 400, [0,3,0.93], {}, {true}, "", false, []],
	["static MG (3 rounds)", "B_HMG_01_high_F", 400, [0,1,1.7], {
		_this enableWeaponDisassembly false;
		_this addEventHandler ["Fired", {(_this select 0) setVehicleAmmo 1;}];
		_this setVariable ["builtInWave", currentWave];
		_this spawn {
			while {currentWave < ((_this getVariable "builtInWave") + 3)} do {
				sleep 5;
			};
			deleteVehicle _this;
		};
	}, {true}, "", false, []],
	["static AT (7 rounds)", "B_static_AT_F", 700, [0,1,1], {
		_this enableWeaponDisassembly false;
		_this addEventHandler ["Fired", {(_this select 0) setVehicleAmmo 1;}];
		_this setVariable ["builtInWave", currentWave];
		_this spawn {
			while {currentWave < ((_this getVariable "builtInWave") + 7)} do {
				sleep 5;
			};
			deleteVehicle _this;
		};
	}, {true}, "", false, []],
	["build/rearm automatic AA", "", 900, [0,0,0], {
		if (count staticAAPlaced > 0) then {
			{ deleteVehicle _x } forEach (staticAAPlaced select 1);
			deleteVehicle (staticAAPlaced select 0);
		};
		_vData = [markerPos "auto_aa", markerDir "auto_aa", "B_SAM_System_01_F", west] call BIS_fnc_spawnVehicle;
		staticAAPlaced = _vData;
		(_vData select 0) setCaptive true;
		(_vData select 0) setVehicleAmmo 0.3;
		publicVariable "staticAA";
	}, {true}, "AA is already installed.", false, []],
	["recruit soldier", "", 800, [0,1,0], {
		_s = (group player) createUnit ["B_Soldier_AR_F", position player, [], 0, "NONE"];
		_s execVM "recruitedSoldier.sqf";
	}, {true}, "", false, []],
	["request CAS Heli", "", 1500, [0,1,0], {
		0 execVM "recruitedHelicopter.sqf";
	}, {true}, "", false, []],
	["repair building", "", 700, [0,0,0], {
		_inclBuilding = nearestBuilding player;
		_placedBuilding = nearestObjects [player, ["House", "Building"], 100] select 0;
		_building = _inclBuilding;
		if (_placedBuilding distance2d player < _inclBuilding distance2d player) then {
			_building = _placedBuilding;
		};
		_building setDamage 0;
	}, {true}, "", false, []],
	["supply drop", "", 500, [0,0,0], {
		[] remoteExec ["supplyDrop", 2];
		"supply drop incoming..." remoteExec ["hint"];
	}, {true}, "", false, []],
	["air strike", "", 600, [0,0,0], {
		airStrikesAvailable = airStrikesAvailable + 1;
		publicVariable "airStrikesAvailable";
	}, {true}, "", false, []]
];
buildActionIds = [];
constructionConfirmAction = 0;
constructionCancelAction = 0;
constructionMoveUpAction = 0;
constructionMoveDownAction = 0;
constructionObject = objNull;


leaveConstructionMode = {
	{player removeAction _x} forEach buildActionIds;
	buildActionIds = [];
	player removeAction _this;
	player addAction ["enter build mode", "construction.sqf", [], 1.5, false, false, "", "!waveRunning"];
};
confirmBuild = {
	detach constructionObject;
	constructionObject setVariable ["unconfirmed", false];
	constructionObject = objNull;
	player setVariable ["constructionOngoing", false];
	player removeAction constructionConfirmAction;
	player removeAction constructionCancelAction;
	if (constructionMoveUpAction != 0) then {
		player removeAction constructionMoveUpAction;
		player removeAction constructionMoveDownAction;
	};
	constructionConfirmAction = 0;
	constructionCancelAction = 0;
	constructionMoveUpAction = 0;
	constructionMoveDownAction = 0;
};
cancelBuild = {
	money = money + ((_this select 3) select 0);
	publicVariable "money";
	[money] remoteExecCall ["updateMoney"];
	deleteVehicle constructionObject;
	constructionObject = objNull;
	player setVariable ["constructionOngoing", false];
	player removeAction constructionConfirmAction;
	player removeAction constructionCancelAction;
	if (constructionMoveUpAction != 0) then {
		player removeAction constructionMoveUpAction;
		player removeAction constructionMoveDownAction;
	};
	constructionConfirmAction = 0;
	constructionCancelAction = 0;
	constructionMoveUpAction = 0;
	constructionMoveDownAction = 0;
};
moveBuildUp = {
	constructionObject setVariable ["translationVertical", (constructionObject getVariable ["translationVertical", 0]) + 0.1];
	_offset = constructionObject getVariable "defaultOffset";
	_offsetVertical = (_offset select 2) + (constructionObject getVariable ["translationVertical", 0]);
	detach constructionObject;
	constructionObject attachTo [player, [_offset select 0, _offset select 1, _offsetVertical]];
	_vectorDirUp = constructionObject getVariable "vectorDirUp";
	if (count _vectorDirUp > 0) then {
		constructionObject setVectorDirAndUp _vectorDirUp;
	};
};
moveBuildDown = {
	constructionObject setVariable ["translationVertical", (constructionObject getVariable ["translationVertical", 0]) - 0.1];
	_offset = constructionObject getVariable "defaultOffset";
	_offsetVertical = (_offset select 2) + (constructionObject getVariable ["translationVertical", 0]);
	detach constructionObject;
	constructionObject attachTo [player, [_offset select 0, _offset select 1, _offsetVertical]];
	_vectorDirUp = constructionObject getVariable "vectorDirUp";
	if (count _vectorDirUp > 0) then {
		constructionObject setVectorDirAndUp _vectorDirUp;
	};
};
autoCancelBuild = {
	waitUntil { waveRunning; };
	if ((_this select 0) getVariable "unconfirmed") then {
		money = money + (_this select 1);
		publicVariable "money";
		[money] remoteExecCall ["updateMoney"];
		deleteVehicle (_this select 0);
		player setVariable ["constructionOngoing", false];
		player removeAction constructionConfirmAction;
		player removeAction constructionCancelAction;
		if (constructionMoveUpAction != 0) then {
			player removeAction constructionMoveUpAction;
			player removeAction constructionMoveDownAction;
		};
		constructionConfirmAction = 0;
		constructionCancelAction = 0;
		constructionMoveUpAction = 0;
		constructionMoveDownAction = 0;
	};
};


_buildObject = {
	_infoBuildObject = (_this select 3) select 0;
	_price = _infoBuildObject select 2;
	_class = _infoBuildObject select 1;
	_offset = _infoBuildObject select 3;
	_initScript = _infoBuildObject select 4;
	_condition = _infoBuildObject select 5;
	_conditionErrorMsg = _infoBuildObject select 6;
	_canMoveUpAndDown = _infoBuildObject select 7;
	_vectorDirUp = _infoBuildObject select 8;
	if (money >= _price) then {
		if ([] call _condition) then {
			money = money - _price;
			publicVariable "money";
			[money] remoteExecCall ["updateMoney"];
			if (count _class == 0) then {
				[] call _initScript;
			} else {
				player setVariable ["constructionOngoing", true];
				_object = _class createVehicle position player;
				_object allowDamage false;
				_object attachTo [player, _offset];
				constructionObject = _object;
				constructionObject setVariable ["defaultOffset", _offset];
				constructionObject setVariable ["vectorDirUp", _vectorDirUp];
				_object setVariable ["unconfirmed", true];
				constructionCancelAction = player addAction ["<t color='#ff0000'>cancel build</t>", cancelBuild, [_price], 9];
				constructionConfirmAction = player addAction ["<t color='#00ff00'>confirm build</t>", confirmBuild, [], 10];
				if (_canMoveUpAndDown) then {
					constructionMoveUpAction = player addAction ["<t color='#00ffff'>move up (10cm)</t>", moveBuildUp, [], 8, false, false];
					constructionMoveDownAction = player addAction ["<t color='#00ffff'>move down (10cm)</t>", moveBuildDown, [], 7, false, false];
				};
				if (count _vectorDirUp > 0) then {
					_object setVectorDirAndUp _vectorDirUp;
				};
				_object call _initScript;
				[_object, _price] spawn autoCancelBuild;
			};
		} else {
			hint _conditionErrorMsg;
		};
	} else {
		hint "Not enough money.";
	};
};

{
	_text = "build %1: $%2";
	if (count (_x select 1) == 0) then {
		_text = "%1: $%2";
	};
	_actionId = player addAction [
		format [_text, _x select 0, _x select 2],
		_buildObject,
		[_x],
		2,
		false,
		false,
		"",
		"!(player getVariable ['constructionOngoing', false])"
	];
	buildActionIds pushBack _actionId;
} forEach _buildOptions;

leaveConstructionActionId = player addAction [
	"leave build mode",
	{(_this select 2) call leaveConstructionMode;},
	[],
	3,
	false,
	false,
	"",
	"!(player getVariable ['constructionOngoing', false])"
];

[] spawn {
	waitUntil {waveRunning};
	if (count buildActionIds > 0) then {
		leaveConstructionActionId call leaveConstructionMode;
	};
}