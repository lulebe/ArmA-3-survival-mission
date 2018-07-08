// event handler that handles damage (obviously)
// if head or body damage exceeds the SRS_damageThreshold defined in fn_init.sqf, 
// then the player is knocked out.  Otherwise the total damage of the unit is tallied
// with each body part representing the following percentages:
// Head: 40%, Body: 40%, Legs: 10%, Hands: 10%

_unit      = _this select 0;
_selection = _this select 1;
_damage    = _this select 2;

_getTotalDamage = {
	_curUnit = _this select 0;

	_head  = _curUnit getHit "head";
	_body  = _curUnit getHit "body";
	_legs  = _curUnit getHit "legs";
	_hands = _curUnit getHit "hands";

	_totalDamage = (_head * 0.4) + (_body * 0.4) + (_legs * 0.1) + (_hands * 0.1);

	if((_head >= SRS_damageThreshold) || (_body >= SRS_damageThreshold)) then{
		_totalDamage = SRS_damageThreshold;		
	};
	_totalDamage	
};

_return = 0;

if((_unit getVariable "SRS_unitVariable") select srs_knockedOut) then{ _return = 0; }
else{

	
	_prevDamage = 0;
	if (_selection isEqualTo "") then {
		_prevDamage = damage _unit;
	} else {
		_prevDamage = _unit getHit _selection;
	};
	_addedDamage = ((_damage - _prevDamage) / 25.0);
	if (_addedDamage < 0.02) then { _addedDamage = 0.02; };
	if (_addedDamage > 0.1) then { _addedDamage = 0.1; };
	if ((_this select 4) isEqualTo "") then {
		_addedDamage = _addedDamage * 6;
	};
	if ((_unit getVariable ["hasArmor", false])) then {
		_newArmor = (_unit getVariable ["armor", 0]) - _addedDamage;
		if (_newArmor < 0) then {
			[_unit] call LLB_fnc_removeArmor;
			_addedDamage = 0 - _newArmor;
		} else {
			_unit setVariable ["armor", _newArmor];
			_addedDamage = 0;
		};
	};
	_newDamage = _prevDamage + _addedDamage;

	switch(_selection) do {

		case "body":{
			if(_newDamage > SRS_damageThreshold) then{
				_newDamage = SRS_damageThreshold;
			};
			_unit setHit ["body",_newDamage];
		};

		case "head":{
			if(_newDamage > SRS_damageThreshold) then{
				_newDamage = SRS_damageThreshold;
			};
			_unit setHit ["head",_newDamage];
		};

		case "legs":{
			_unit setHit ["legs",_newDamage];
		};

		case "hands":{
			_unit setHit ["hands",_newDamage];
		};

		case "":{
			if(_newDamage > SRS_damageThreshold) then{
				_newDamage = SRS_damageThreshold;
			};
			_unit setHit ["body",_newDamage];
		};
		default {};

	};

	_return = [_unit] call _getTotalDamage;
	if(_return >= SRS_damageThreshold) then{
		_return = 0;
		[_unit] spawn SRS_fnc_knockOut;
	};
};

BIS_hitArray = _this; BIS_wasHit = True;


[] spawn displayUnitDamage;


_return