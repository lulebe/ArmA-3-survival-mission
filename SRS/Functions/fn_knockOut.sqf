
// to put into KO state:
// [player] spawn SRS_fnc_knockOut;
// to wake out of KO state
// (player getVariable "SRS_unitVariable") set [srs_knockedOut,False];

_unit = _this select 0;
if(_unit != player) exitWith{};  //only run on local clients

_unitVar = _unit getVariable "SRS_unitVariable";
if(_unitVar select srs_knockedOut) exitWith{};   //prevent double trigger

//set knockedOut status & broadcast
_unitVar set [srs_knockedOut,True];
[_unit,_unitVar,True] call SRS_fnc_unitVarSetter;
_KO = _unitVar select srs_knockedOut;

//turn off radios and create map marker
[False] call SRS_fnc_toggleRadio;
[[_unit],"SRS_fnc_createDownedMarker"] call BIS_fnc_MP;

//black out
[] spawn {
	titleText["","BLACK",0.3];
	sleep (15 + random 5);
	titleFadeOut (30 + random 15);	
};

//if dragging, drop em!
if((count (_unit getVariable "SRS_isDragging")) > 0) then{
	_toDrop = (_unit getVariable "SRS_isDragging") select 0;
	[_toDrop,_unit,100] call SRS_fnc_drop;
};

//setup GUI
if(Dialog) then{ closeDialog 0; };
disableSerialization;
createDialog "SRS_respawnGUI";
_ui = uiNamespace getVariable "SRS_respawnGUI";
_ui displayAddEventHandler ["KeyDown", "if((_this select 1)==1) then{ true }"];  //prevent escape

//if in a vehicle, eject
if(vehicle _unit != _unit) then{
	unassignVehicle _unit;
	_unit action ["eject",vehicle _unit];
};
waitUntil{vehicle _unit == _unit};
sleep 0.5;

_unit setDamage 0;
_unit setVelocity [0,0,0];
_unit allowDamage false;
_unit setCaptive true;

/*  RE-ENABLE when BI fixes some ragdoll issues...
if(isMultiplayer) then{
	[_unit] call SRS_fnc_ragdoll;
} else{
	_unit playMoveNow "AinjPpneMstpSnonWrflDnon_rolltoback";
};
*/
_unit playMoveNow "AinjPpneMstpSnonWrflDnon_rolltoback";

//loop
_time = time;
while{ _KO && ((time - _time) < SRS_reviveTimer) && (alive _unit) } do{
	_timeleft = round (SRS_reviveTimer - (time - _time));
	(_ui displayCtrl 1000) ctrlSetText format["%1",_timeleft];
	_KO = (_unit getVariable "SRS_unitVariable") select srs_knockedOut;
	sleep 0.5;
};

closeDialog 0;

//dead states (respawn or timer expires)
if((!alive _unit) || ((time - _time) >= SRS_reviveTimer)) then{

	//if unit still alive, timer expired
	if(alive _unit) then{
		["RESPAWN"] call SRS_fnc_button;
	};

}

//otherwise wake the unit up
else{ 
	[_unit] call SRS_fnc_wakeUp; 
};
