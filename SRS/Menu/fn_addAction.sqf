// add heal/drag actions

//UNIT TO ADD ACTION TO!
_unit = _this select 0;
_type = _this select 1;

_unitString = _unit getVariable "SRS_unitString";
_unitVar    = _unit getVariable "SRS_unitVariable";
_unitName   = name _unit;

_actionString = SRS_ACTIONS select _type;
_action       = _unit getVariable _actionString;
if(_action != -1) exitWith{};

switch(_actionString) do{
	
	case "SRS_healAction":{
		_action = _unit addaction [
			format["<t color='#00ff00'>Revive %1</t>",_unitName],
			SRS_fnc_revive,[],
			6,false,true,"","(_target distance _this) < 3"
		];
	};

	case "SRS_dragAction":{
		_action = _unit addaction [
			format["<t color='#00ff00'>Drag %1</t>",_unitName],
			SRS_fnc_drag,[],
			5.9,false,true,"","(_target distance _this) < 3"
		];
	};

	case "SRS_dropAction":{
		_action = _unit addaction [
			format["<t color='#00ff00'>Drop %1</t>",_unitName],
			SRS_fnc_drop,[],
			6,false,true,"","(_target distance _this) < 3"
		];
	};

	default {};
};

_unit setVariable [_actionString,_action];
true
