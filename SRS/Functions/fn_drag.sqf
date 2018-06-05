
_toDrag  = _this select 0;
_dragger = _this select 1;
_id      = _this select 2;

_toDragVar = _toDrag getVariable "SRS_unitVariable";
_toDragVar set [srs_beingDragged,True];
[_toDrag,_toDragVar,True] call SRS_fnc_unitVarSetter;

_dragger setVariable ["SRS_isDragging",[_toDrag]];

_toDrag attachTo [_dragger, [0,1,0.08]];
_toDrag setDir 180;

_dragger playAction "grabDrag";
[[_toDrag,"ainjppnemrunsnonwnondb_still"],"SRS_switchMove"] call BIS_fnc_MP;

[_toDrag,"IS_DRAGGING"] call SRS_fnc_menuDirector;
true
