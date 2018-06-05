// turns on/off TFAR/ACRE radios when knocked out

if(!SRS_muteRadios) exitWith{};

_toggleTFAR = {
	_canUse = _this select 0;

	if(_canUse) then{
		player setVariable ["tf_unable_to_use_radio",false];
	}else{
		player setVariable ["tf_unable_to_use_radio",true];
	};
};

_toggleACRE = {
	_canUse = _this select 0;

	if(_canUse) then{
		player setVariable ["acre_sys_core_isDisabled",false];
	}else{
		player setVariable ["acre_sys_core_isDisabled",true];
	};
};

_radioToggle = _this select 0;  // True (on) or False (off)

if(isClass (configFile >> "CfgPatches" >> "task_force_radio")) then{
	[_radioToggle] call _toggleTFAR;	
}else{
	[_radioToggle] call _toggleACRE;	
};