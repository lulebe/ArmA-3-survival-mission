_vData = [markerPos "supplydrop_spawn", 0, "B_Heli_Light_01_F", west] call BIS_fnc_spawnVehicle;

_heli = _vData select 0;
_heli setCaptive true;
_heli engineOn true;
_heli flyInHeight 150;
_heli setPos [getPos _heli select 0, getPos _heli select 1, 150];

_group = _vData select 2;
_group setBehaviour "CARELESS";
_wp1 = _group addWaypoint [markerPos "supplydrop_droppos", 0];
_wp1 setWaypointCompletionRadius 10;
_wp1 setWaypointStatements ["true", "[] call supplyDropSpawnBox"];
_wp2 = _group addWaypoint [markerPos "supplydrop_despawn", 0];

_heli spawn {
	sleep 60;
	deleteVehicle _this;
};

supplyDropSpawnBox = {
	_box = "B_supplyCrate_F" createVehicle [markerPos "supplydrop_droppos" select 0, markerPos "supplydrop_droppos" select 1, 140];
	_box setPos [getPos _box select 0, getPos _box select 1, 140];
	_box allowDamage false;
	_box spawn {
		sleep 60;
		deleteVehicle _this;
	};
	clearWeaponCargoGlobal _box;
	clearItemCargoGlobal _box;
	clearMagazineCargoGlobal _box;
	clearBackpackCargoGlobal _box;
	_box addMagazineCargoGlobal ["30Rnd_556x45_Stanag", 30];
	_box addMagazineCargoGlobal ["30Rnd_65x39_caseless_mag", 30];
	_box addMagazineCargoGlobal ["HandGrenade", 30];
	_box addMagazineCargoGlobal ["RPG7_F", 3];
	_box addMagazineCargoGlobal ["Titan_AA", 2];
	_box addMagazineCargoGlobal ["Titan_AT", 2];
	_box addMagazineCargoGlobal ["APERSMine_Range_Mag", 10];
	_box addMagazineCargoGlobal ["DemoCharge_Remote_Mag", 6];
	_box addMagazineCargoGlobal ["SatchelCharge_Remote_Mag", 2];
	_box addItemCargoGlobal ["FirstAidKit", 5];
};