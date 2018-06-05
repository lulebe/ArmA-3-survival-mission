// remove heal/drag/drop actions

_unit       = _this select 0;
_type       = _this select 1;

_actionType = SRS_ACTIONS select _type;
_index      = _unit getVariable _actionType;

if(_index == -1) exitWith{};
if(SRS_debug) then{	player sidechat format["removing %1 with an index of %2 for %3",_actionType,_index,name _unit]; };
if(_index == SRS_resetAction && _unit == player) exitWith{};

_unit removeAction _index;
_unit setVariable [_actionType,-1];

true