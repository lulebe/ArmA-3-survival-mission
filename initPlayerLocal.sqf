player enableFatigue false;

player addAction ["enter build mode", "construction.sqf", [], 1.5, false, false, "", "!waveRunning"];

displayUnitDamage = {
	sleep 0.02;
	_d = damage player;
	_h = 1.0 - _d;
	uiNamespace getVariable "infodspl" displayCtrl 104 progressSetPosition _h;
	uiNamespace getVariable "infodspl" displayCtrl 104 ctrlSetTextColor [
		_d,
		_h / 1.5,
		0,
		1
	];
};

[] spawn {
	while {true} do {
		if (damage player > 0) then {
			_restoredHealth = (damage player - 0.01667);
			if (_restoredHealth < 0) then {
				_restoredHealth = 0
			};
			player setDamage _restoredHealth;
		};
		[] spawn displayUnitDamage;
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
	_time = round (_this select 1);
	_text = parseText format ["<t color='#ff0000'>Wave %1 finished.</t><br/>Wave %2 starts in %3 seconds.", _pastWave, _nextWave, _time];
	if (_pastWave == 0) then {
		_text = parseText format ["First wave in %1s.", _time];
	};
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
	sleep 30;
	while {true} do {
		if (isNull (uiNamespace getVariable "infodspl")) then {
			titleRsc ["WaveInfoDisplayTitle", "PLAIN"];
			[currentWave, -1, vehicleWaves, helicopterWaves] call showWaveStart;
			[money] call updateMoney;
		};
		sleep 0.1;
	}
};

weaponUnlockedInfo = {
	_classname = _this select 0;
	_imgPath = getText (configFile >> "CfgWeapons" >> _classname >> "picture");
	_name = getText (configFile >> "CfgWeapons" >> _classname >> "displayName");
	cutRsc ["WeaponUnlockInfoDisplayTitle", "PLAIN"];
	uiNamespace getVariable "weaponunlockinfodspl" displayCtrl 201 ctrlSetStructuredText parseText ("<t align='center' color='#000000'>Unlocked " + _name + "</t><br/><img align='center' image='" + _imgPath + "' size='5' />");
};
miscUnlockedInfo = {
	_name spawn {
		sleep 6;
		cutRsc ["WeaponUnlockInfoDisplayTitle", "PLAIN"];
		uiNamespace getVariable "weaponunlockinfodspl" displayCtrl 201 ctrlSetStructuredText parseText ("<t align='center' color='#000000'>Unlocked a new Item:<br/>" + _name + "</t>");
	};
};