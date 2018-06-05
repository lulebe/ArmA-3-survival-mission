// initializes unit variables

_unit = _this select 0;

_unitString = "";
if(isMultiplayer) then{
	_unitString = format["SRS_%1",getPlayerUID _unit];
}else{
	_unitString = format["SRS_%1",SRS_AI_index];
	SRS_AI_index = SRS_AI_index + 1;
};
_unit setVariable ["SRS_unitString",_unitString];
_unit setVariable ["SRS_unitSide",side _unit];

//set default action states
{_unit setVariable [_x,-1];}forEach SRS_ACTIONS;

//first time init
if( (isNil {_unit getVariable "SRS_unitVariableDefined"}) && (isNil format["%1_VAR",_unitString]) ) then{

	if(SRS_debug) then{	player sidechat format["Setting up variable for %1",name _unit]; };

	_unitVar = [_unit] call SRS_fnc_unitVarDefault;
	[_unit,_unitVar,False] call SRS_fnc_unitVarSetter;

	format["%1_VAR",_unitString] addPublicVariableEventHandler {
		private["_varName","_var","_unit"];
		_varName = _this select 0;
		_var     = _this select 1;

		_unit = _var select srs_unitObject;
		_unit setVariable ["SRS_unitVariable",_var];

		//call contextual menus that read unitVariable
		[_unit] call SRS_fnc_setOtherMenuState;
	};
	
}

//re-initializing (and/or JIP)
else{

	_jip = False;
	if( (isNil {_unit getVariable "SRS_unitVariableDefined"}) && !(isNil format["%1_VAR",_unitString]) ) then{
		if(SRS_debug) then{ player sidechat "detected JIP!"; };
		_jip = True;
	};

	if(SRS_debug) then{	player sidechat format["Assigning variable for %1",name _unit]; };

	if(_unit == player) then{
		_unitVar = [_unit] call SRS_fnc_unitVarDefault;
		[_unit,_unitVar,True] call SRS_fnc_unitVarSetter;
	}else{
		_unitVar = [];
		call compile format["_unitVar = %1_VAR;",_unitString];
		_unit setVariable ["SRS_unitVariable",_unitVar];
	
		//call contextual menus that read unitVariable
		[_unit] call SRS_fnc_setOtherMenuState;
	};

	//add publicVariableEH for JIP only
	if(_jip) then{
		format["%1_VAR",_unitString] addPublicVariableEventHandler {
			private["_varName","_var","_unit"];
			_varName = _this select 0;
			_var     = _this select 1;

			_unit = _var select srs_unitObject;
			_unit setVariable ["SRS_unitVariable",_var];

			//call contextual menus that read unitVariable
			[_unit] call SRS_fnc_setOtherMenuState;
		};	
	};

};

_unit setVariable ["SRS_unitVariableDefined",True];
true