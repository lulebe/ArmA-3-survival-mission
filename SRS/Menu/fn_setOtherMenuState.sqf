//set contextual unit state when OTHER units trigger the EH, not yourself!

_unit = _this select 0;

if(!alive _unit) exitWith{
	if(_unit != player) then{

		if(count (player getVariable "SRS_isDragging") > 0) then{
			_beingDragged = (player getVariable "SRS_isDragging") select 0;
			if(_unit == _beingDragged) then{
				[_unit,player,100] call SRS_fnc_drop;
			};

		};

	};
};

//play contextual drag animations
if(_unit == player) exitWith{

	_unitVar        = _unit getVariable "SRS_unitVariable";
	_isBeingHealed  = _unitVar select srs_beingHealed;
	_isBeingDragged = _unitVar select srs_beingDragged;	

	if(_isBeingHealed) then{
		_nearestDist = 1000;
		_nearestUnit = "";
		{
			_dist = _unit distance _x;
			if(_dist < _nearestDist) then{
				_nearestDist = _dist;
				_nearestUnit = _x;
			};
		}forEach playableUnits;
		_relPos = _nearestUnit worldToModel (position _unit);
		if((_relPos select 0) < 0) then{
			_unit setDir 90;
		}else{
			_unit setDir 270;
		};
	};

	if(_isBeingDragged) then{
		_unit setDir 180;
		/*
		//old animation AinjPpneMrunSnonWnonDb
		if((animationState _unit) != "ainjppnemrunsnonwnondb_still") then{
			_unit setDir 180;
			_unit playMoveNow "ainjppnemrunsnonwnondb_still";
		};
		*/
	}else{
		/*
		_transitions = [
			"AinjPpneMstpSnonWrflDnon_rolltoback",
			"ainjppnemstpsnonwrfldnon_rolltofront",
			"ainjppnemrunsnonwnondb_release", //set down
			"amovppnemstpsraswrfldnon_amovppnemstpsnonwnondnon", //weapon out on belly
			"ainjppnemstpsnonwrfldnon" //on back still
		];
		if(!((animationState _unit) in _transitions)) then{
			_unit playMoveNow "AinjPpneMstpSnonWrflDnon_rolltoback";
		};
		*/
		//if((animationState _unit) != "ainjppnemrunsnonwnondb_still") then{
		//	_unit playMoveNow "AinjPpneMstpSnonWrflDnon_rolltoback";
		//};
	};

};

_unitString = _unit getVariable "SRS_unitString";
_unitVar    = _unit getVariable "SRS_unitVariable";

_isKO           = _unitVar select srs_knockedOut;
_isBeingHealed  = _unitVar select srs_beingHealed;
_isBeingDragged = _unitVar select srs_beingDragged;

//can be healed
if(_isKO && !_isBeingHealed && !_isBeingDragged) then{
	[_unit,"CAN_HEAL"] call SRS_fnc_menuDirector;
};

//cannot be healed
if(_isKO && (_isBeingHealed || _isBeingDragged)) then{
	[_unit,"CANNOT_HEAL"] call SRS_fnc_menuDirector;
};

//no need to be healed
if(!_isKO) then{
	[_unit,"CANNOT_HEAL"] call SRS_fnc_menuDirector;
};
