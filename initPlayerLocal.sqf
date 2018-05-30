player enableFatigue false;

player addAction ["enter build mode", "construction.sqf", [], 1.5, false, false, "", "!waveRunning"];

player addEventHandler ["HandleDamage", {
	_unit = _this select 0;
	_selection = _this select 1;
	_damage = _this select 2;
	_prevDamage = 0;
	if (_selection isEqualTo "") then {
		_prevDamage = damage _unit;
	} else {
		_prevDamage = _unit getHit _selection;
	};
	_addedDamge = ((_damage - _prevDamage) / 17.0);
	if (_addedDamage < 0.02) then { _addedDamage = 0.02; };
	if (_addedDamage > 0.04) then { _addedDamage = 0.04; };
	_newDamage = _prevDamage + _addedDamge;
	_newDamage;
}];

[] spawn {
	while {true} do {
		if (damage player > 0) then {
			_restoredHealth = (damage player - 0.02);
			if (_restoredHealth < 0) then {
				_restoredHealth = 0
			};
			player setDamage _restoredHealth;
		};
		sleep 1;
	}
};

showWaveStart = {
	_waveNum = _this select 0;
	_enemyCount = _this select 1;
	_vehicleWaves = _this select 2;
	_helicopterWaves = _this select 3;
	if (_enemyCount != -1) then {
		[_enemyCount] call showKill;
	};
	_hasVehicle = "";
	if (_waveNum mod _vehicleWaves == 0) then {
		_hasVehicle = "<br/>Vehicle incoming";
	};
	_hasHelicopter = "";
	if (_waveNum mod _helicopterWaves == 0) then {
		_hasHelicopter = "<br/>Helicopter incoming";
	};
	_text = parseText format ["<t color='#ff0000'>Wave %1</t>%2 %3", _waveNum, _hasVehicle, _hasHelicopter];
	uiNamespace getVariable "infodspl" displayCtrl 101 ctrlSetStructuredText _text;
};

showWaveEnd = {
	_pastWave = _this select 0;
	_nextWave = _pastWave + 1;
	_time = _this select 1;
	_text = parseText format ["<t color='#ff0000'>Wave %1 finished.</t><br/>Wave %2 starts in %3 seconds.", _pastWave, _nextWave, _time];
	uiNamespace getVariable "infodspl" displayCtrl 101 ctrlSetStructuredText _text;
};

showKill = {
	_unitsLeft = _this select 0;
	_text = parseText format ["Units left: %1", _unitsLeft];
	uiNamespace getVariable "infodspl" displayCtrl 102 ctrlSetStructuredText _text;
};

updateMoney = {
	_money = _this select 0;
	_text = parseText format ["Money: $%1", _money];
	uiNamespace getVariable "infodspl" displayCtrl 103 ctrlSetStructuredText _text;
};

titleRsc ["WaveInfoDisplayTitle", "PLAIN"];

[] spawn {
	while {true} do {
		if (isNull (uiNamespace getVariable "infodspl")) then {
			titleRsc ["WaveInfoDisplayTitle", "PLAIN"];
			[currentWave, -1, vehicleWaves, helicopterWaves] call showWaveStart;
			[money] call updateMoney;
		};
		sleep 0.1;
	}
};