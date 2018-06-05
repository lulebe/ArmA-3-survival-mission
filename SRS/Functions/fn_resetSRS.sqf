//function to reset the SRS system for individuals

_target    = _this select 0;
_caller    = _this select 1;
_id        = _this select 2;

if(_caller != player) exitWith{};

player removeAction _id;
player setVariable ["SRS_RESET",True];

player sidechat "Stopping SRS...";
waitUntil{!(player getVariable "SRS_RUNNING")};

detach player;
if((count (player getVariable "SRS_isDragging")) > 0) then{
	_beingDragged = (player getVariable "SRS_isDragging") select 0;
	detach _beingDragged;
	_beingDraggedVar = _beingDragged getVariable "SRS_unitVariable";
	_beingDraggedVar set [srs_beingDragged,False];
	[_beingDragged,_beingDraggedVar,True] call SRS_fnc_unitVarSetter;
};
if((count (player getVariable "SRS_isReviving")) > 0) then{
	_beingRevived = (player getVariable "SRS_isReviving") select 0;
	detach _beingRevived;
	_beingRevivedVar = _beingRevived getVariable "SRS_unitVariable";
	_beingRevivedVar set [srs_beingHealed,False];
	[_beingRevived,_beingRevivedVar,True] call SRS_fnc_unitVarSetter;
};

[True] call SRS_fnc_toggleRadio;

{
	[_x,"REMOVE_ALL"] call SRS_fnc_menuDirector;
	[_x] call SRS_fnc_removeDownedMarker;
}forEach SRS_PLAYERS;

if(SRS_downed3DMarkers) then{
	removeMissionEventHandler ["Draw3D",SRS_3DICONS];
};

player switchMove "";
player removeEventHandler ["HandleDamage",SRS_handleDamageEH];
player removeEventHandler ["Respawn",SRS_respawnEH];
/* RE-ENABLE when BI fixes ragdoll stuff
player removeEventHandler ["AnimStateChanged",SRS_ragDoll];
*/

player sidechat "Resetting SRS in 5 seconds...";
sleep 5;

[] spawn SRS_fnc_init;