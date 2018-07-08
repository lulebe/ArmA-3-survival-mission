_soldier = _this;

_soldier disableAi "COVER";

_soldier allowFleeing 0;

_soldier setSkill 0.9;

_soldier setUnitPos "UP";

_soldier addEventHandler ["HandleDamage", {
	_unit = _this select 0;
	_selection = _this select 1;
	_damage = _this select 2;
	_prevDamage = 0;
	if (_selection isEqualTo "") then {
		_prevDamage = damage _unit;
	} else {
		_prevDamage = _unit getHit _selection;
	};
	_addedDamage = ((_damage - _prevDamage) / 30.0);
	if (_addedDamage < 0.03) then { _addedDamage = 0.03; };
	if (_addedDamage > 0.1) then { _addedDamage = 0.1; };
	_newDamage = _prevDamage + _addedDamage;
	_newDamage;
}];

_soldier addEventHandler ["fired", {(_this select 0) setVehicleAmmo 1;}];

_soldier spawn {
	while {alive _this} do {
		if (damage _this > 0) then {
			_restoredHealth = (damage _this - 0.02);
			if (_restoredHealth < 0) then {
				_restoredHealth = 0
			};
			_this setDamage _restoredHealth;
		};
		sleep 1;
	}
};

_soldier addAction ["check health", {
	_s = (_this select 0);
	hint format ["Health is %1%2", round ((1.0 - damage _s) * 100.0), "%"];
}, [], 3, true, true, "", "true", 2];