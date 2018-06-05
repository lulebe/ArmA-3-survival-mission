//this will update the public variable from the local one, and broadcast it if requested

_unit    = _this select 0;
_unitVar = _this select 1;
_bcast   = _this select 2;

_unitString = _unit getVariable "SRS_unitString";
_unit setVariable ["SRS_unitVariable",_unitVar];

call compile format["%1_VAR = _unitVar;",_unitString];

if(_bcast) then{
	publicVariable format["%1_VAR",_unitString];
};
true
