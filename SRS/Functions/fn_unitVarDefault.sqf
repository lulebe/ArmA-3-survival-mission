// returns default unit variable

_unit = _this select 0;

_unitString = _unit getVariable "SRS_unitString";

// unitString (str), unit (obj), KO (bool), BEINGHEALED (bool), BEINGDRAGGED (bool)
_unitVar = [_unitString,_unit,false,false,false];

_unitVar