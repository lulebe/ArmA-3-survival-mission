// respawn eventHandler which resets the unitVariable,
// toggles radios, and re-adds the resetSRS EH

_unit   = _this select 0;
_corpse = _this select 1;

hideBody _corpse;

_unitVar = [_unit] call SRS_fnc_unitVarDefault;
[_unit,_unitVar,True] call SRS_fnc_unitVarSetter;

_unit allowDamage true;
_unit setCaptive false;

[True] call SRS_fnc_toggleRadio;

SRS_resetAction = player addAction ["<t color='#ff0000'>Reset SRS</t>",SRS_fnc_resetSRS,[],0,false,true,"",""];