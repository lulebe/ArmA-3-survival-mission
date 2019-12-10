if !(isNull AirStrikeMapClickHandlerId) exitWith {};
openMap true;
hint "Shift-click map to cancel";
AirStrikeMapClickHandlerId = addMissionEventHandler ["MapSingleClick", {
	_mapclickpos = _this select 1;
	if (!(_this select 3) && airStrikesAvailable > 0) then {
		//spawn plane
		_airstrikeplanedata = [[(markerPos "marker_airstrikeplane_start") select 0, (markerPos "marker_airstrikeplane_start") select 1, 100], (markerPos "marker_airstrikeplane_start") getDir (markerPos "marker_airstrikeplane_end"), "B_Plane_CAS_01_dynamicLoadout_F", west] call BIS_fnc_spawnVehicle;
		(_airstrikeplanedata select 0) engineOn true;
		(_airstrikeplanedata select 0) setVelocity ((vectorDir (_airstrikeplanedata select 0)) vectorMultiply 300);
		(_airstrikeplanedata select 0) setCaptive true;
		(_airstrikeplanedata select 0) allowDamage false;

		//spawn bomb
		0 = _mapclickpos spawn {
			sleep 5;
			_bomb1 = "SatchelCharge_Remote_Ammo_Scripted" createVehicle _this;
			_bomb2 = "SatchelCharge_Remote_Ammo_Scripted" createVehicle _this;
			_bomb1 setDamage 1;
			_bomb2 setDamage 1;
		};

		//remove plane
		0 = (_airstrikeplanedata select 0) spawn {
			sleep 10;
			{deleteVehicle _x} forEach crew (_this) + [_this];
		};
		airStrikesAvailable = airStrikesAvailable - 1;
	} else {
		if (airStrikesAvailable < 1) then {
			hint "no air strikes available";
		};
	};
	openMap false;
	removeMissionEventHandler ["MapSingleClick", AirStrikeMapClickHandlerId];
	AirStrikeMapClickHandlerId = objNull;
}];