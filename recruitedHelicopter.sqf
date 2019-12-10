_vData = [[markerPos "marker_spawn_CAS" select 0, markerPos "marker_spawn_CAS" select 1, 100], 0, "B_Heli_Attack_01_dynamicLoadout_F", west] call BIS_fnc_spawnVehicle;
_heli = _vData select 0;
_heli engineOn true;
_heli flyInHeight 100;
{ _x allowDamage false; } forEach (_vData select 1);
_heli addEventHandler ["HandleDamage", {
	_unit = _this select 0;
	_selection = _this select 1;
	_damage = _this select 2;
	_prevDamage = 0;
	if (_selection isEqualTo "") then {
		_prevDamage = damage _unit;
	} else {
		_prevDamage = _unit getHit _selection;
	};
	_addedDamage = ((_damage - _prevDamage) / 20.0);
	if (_addedDamage < 0.01) then { _addedDamage = 0.01; };
	if (_addedDamage > 0.3) then { _addedDamage = 0.3; };
	_newDamage = _prevDamage + _addedDamage;
	_newDamage;
}];
_heli addEventHandler ["killed", {
	_u = _this select 0;
	_u removeAllEventHandlers "killed";
	{ deleteVehicle _x; } forEach (crew _u);
}];
_group = _vData select 2;
_group allowFleeing 0;
_group deleteGroupWhenEmpty true;
_group setCombatMode "RED";
_wp = _group addWaypoint [markerPos "target", 0];
_wp setWaypointType "SAD";
_wp setWaypointSpeed "NORMAL";