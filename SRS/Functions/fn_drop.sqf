
_toDrop  = _this select 0;
_dragger = _this select 1;
_id      = _this select 2;

_toDropVar = _toDrop getVariable "SRS_unitVariable";
_toDropVar set [srs_beingDragged,False];
[_toDrop,_toDropVar,True] call SRS_fnc_unitVarSetter;

_dragger setVariable ["SRS_isDragging",[]];

detach _dragger;
detach _toDrop;

_dragger playMove "amovpknlmstpsraswrfldnon";
[[_toDrop,"ainjppnemstpsnonwrfldnon"],"SRS_switchMove"] call BIS_fnc_MP;

if(alive _toDrop) then{
	[_toDrop,"CAN_HEAL"] call SRS_fnc_menuDirector;
}else{
	[_toDrop,"REMOVE_ALL"] call SRS_fnc_menuDirector;	
};
true
