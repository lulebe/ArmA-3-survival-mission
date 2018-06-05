// handles unit reviving another

_injured    = _this select 0;
_healer     = _this select 1;
_id         = _this select 2;

if(_healer != player) exitWith{};  //only execute local

_randomMedicaAnimation = {
	private["_unit","_ranAnim","_animations"];
	_unit = _this select 0;
	_animations = [
		"AinvPknlMstpSnonWnonDnon_medic0",
		"AinvPknlMstpSnonWnonDnon_medic1",
		"AinvPknlMstpSnonWnonDnon_medic2",
		"AinvPknlMstpSnonWnonDnon_medic3"
	];
	if(!((animationState _unit) in _animations)) then{
		_ranAnim = _animations call BIS_fnc_selectRandom;
		_unit playMove _ranAnim;
	};
	true
};

_injuredVar = _injured getVariable "SRS_unitVariable";
_healerVar  = _healer  getVariable "SRS_unitVariable";

if(_injuredVar select srs_beingHealed) exitWith{
	player sidechat format["%1 is already being healed...",name _injured];
};

_healerItems = items _healer;
if(_healerItems find "Medikit" == -1 && 
   _healerItems find "FirstAidKit" == -1) exitWith{ 
player sidechat "No Medikit or FirstAidKit!"; 
};
_isMedic = False;
if(_healerItems find "Medikit" >= 0) then{ _isMedic = True; };

//set personal status
_healer setVariable ["SRS_isReviving",[_injured]];
[_injured,"REMOVE_ALL"] call SRS_fnc_menuDirector;

//set injured unit's variables, broadcast
_injuredVar set [srs_beingHealed,True];
[_injured,_injuredVar,True] call SRS_fnc_unitVarSetter;

//determine offsets for attachment
_offset = [0,0,0]; _dir = 0;
_relPos = _healer worldToModel (position _injured);
if((_relPos select 0) < 0) then{
	_offset = [-0.2,0.7,0];
	_dir = 90;
}else{
	_offset = [ 0.2,0.7,0];
	_dir = 270;	
};

//attachment
_injured attachTo [_healer,_offset];
_injured setDir _dir;

//get ready to revive!
[_healer,_injured,0] spawn SRS_fnc_dumpMedicalSupplies;
_currentCameraState = cameraView;
_healer switchCamera "EXTERNAL";

//UI shit
disableSerialization;
createDialog "SRS_revivingGUI";
_ui = uiNamespace getVariable "SRS_revivingGUI";
_ui displayAddEventHandler ["KeyDown", "if((_this select 1)==1) then{ true }"];  //prevent escape

//determine revive time
_sign           = if(random 1 < 0.5) then{ 1 } else{ -1 };
_randReviveTime = _sign * 0.25 * SRS_reviveTime;
_timeToRevive   = SRS_reviveTime + _randReviveTime;
//if(getNumber (configFile >> "CfgVehicles" >> (typeOf _healer) >> "attendant") == 1) then{
if(_isMedic) then{
	if(SRS_DEBUG) then{ player sidechat "detected medic!  reducing revive time"; };
	_timeToRevive = _timeToRevive * (1.0 - SRS_medicAdvantage);
};
_time = time;
while{
	(damage _injured == 0) &&
	(alive _healer) && (alive _injured) &&
	((_healer distance _injured) < 2) &&
	( (_injured getVariable "SRS_unitVariable") select srs_knockedOut)  &&
	(!((_healer getVariable "SRS_unitVariable") select srs_knockedOut)) &&
	(!(_healer getVariable "SRS_cancelRevive")) &&
	((time - _time) <= _timeToRevive)
} do{
	[_healer] call _randomMedicaAnimation;

	_percentage = (time - _time) / _timeToRevive;
	["Applying First Aid",_percentage] spawn SRS_fnc_progressBar;
	sleep 0.5;
};

detach _injured;
_healer switchCamera _currentCameraState;
_healer setVariable ["SRS_isReviving",[]];
[_healer,_injured,1] spawn SRS_fnc_dumpMedicalSupplies;


_injuredVar = _injured getVariable "SRS_unitVariable";
switch(true) do{

	//healer got knocked out
	case ((_healer getVariable "SRS_unitVariable") select srs_knockedOut):{
		_healer playMoveNow "AinjPpneMstpSnonWrflDnon_rolltoback";
		if(SRS_debug) then { player sidechat "healer got knocked out"; };
	};

	//healer cancelled revive
	case (_healer getVariable "SRS_cancelRevive"):{
		if(SRS_debug) then{	player sidechat "healer cancelled"; };
		closeDialog 0;
		_healer playActionNow "medicStop";

		_healer setVariable ["SRS_cancelRevive",False];
		[_injured,"CAN_HEAL"] call SRS_fnc_menuDirector;
	};

	//time expired - REVIVE COMPLETE
	case ((time-_time) >= _timeToRevive):{
		if(SRS_debug) then{ player sidechat "timeToRevive elapsed"; };
		["Applying First Aid",1] spawn SRS_fnc_progressBar;
		closeDialog 0;
		_healer playActionNow "medicStop";

		[_injured,"REMOVE_ALL"] call SRS_fnc_menuDirector;
		_injuredVar set [srs_knockedOut, False];
		_injured setDamage srs_damageValue;	
	};

	//unit died via suicide, or revive time expiration
	case(!alive _injured):{
		closeDialog 0;
		_healer playActionNow "medicStop";

		[_injured,"REMOVE_ALL"] call SRS_fnc_menuDirector;
	};

	/* below should NOT happen */

	//unit are dead?
	case(!alive _healer):{};
	case(damage _injured > 0):{ closeDialog 0; };

	//injured no longer knocked out
	case (!((_injured getVariable "SRS_unitVariable") select srs_knockedOut)):{
		closeDialog 0;
	};

	//distance criteria
	case ((_healer distance _injured) > 2):{ closeDialog 0;	};

	default{ player sidechat "DEFAULT, SHOULD NOT HAPPEN"; closeDialog 0; };
};

_injuredVar set [srs_beingHealed,False];
[_injured,_injuredVar,True] call SRS_fnc_unitVarSetter;