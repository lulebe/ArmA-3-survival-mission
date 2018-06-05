// contextually add/remove actions

_unit  = _this select 0;
_state = _this select 1;

switch(_state) do{
	
	case "CAN_HEAL":{
		[_unit,"REMOVE_ALL"] call SRS_fnc_menuDirector;
		[_unit,0] call SRS_fnc_addAction;
		[_unit,1] call SRS_fnc_addAction;
	};

	case "CANNOT_HEAL":{
		[_unit,"REMOVE_ALL"] call SRS_fnc_menuDirector;
	};

	case "IS_DRAGGING":{
		[_unit,"REMOVE_ALL"] call SRS_fnc_menuDirector;
		[_unit,2] call SRS_fnc_addAction;
	};

	case "REMOVE_ALL":{
		_n = count SRS_ACTIONS;
		for "_i" from 0 to (_n-1) do{
			[_unit,_i] call SRS_fnc_removeAction;
		};
	};

	default {};
};

true