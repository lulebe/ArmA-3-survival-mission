_wave = _this select 0;
_playerCount = count allPlayers;

_itemIsUnlocked = {
	_isUnlocked = false;
	_index = 0;
	while {!_isUnlocked && _index < (count unlockedGear)} do {
		if (((unlockedGear select _index) select 2) == _this) then {
			_isUnlocked = true;
		};
		_index = _index + 1;
	};
	_isUnlocked
};

clearMagazineCargoGlobal ammoBox;
clearItemCargoGlobal ammoBox;
clearWeaponCargoGlobal ammoBox;

//add ammo
_ammo = [
	["16Rnd_9x21_Mag", _playerCount * 5],
	["30Rnd_45ACP_Mag_SMG_01", (_playerCount * _wave) min (_playerCount * 10)],
	["30Rnd_65x39_caseless_mag", _playerCount * _wave, 5],
	["9Rnd_45ACP_Mag", (ceil (_playerCount * _wave * 0.4)) min ( _playerCount * 5)],
	["1Rnd_HE_Grenade_shell", floor (_playerCount * _wave * 0.5)],
	["200Rnd_65x39_cased_Box", ceil (_wave * 0.2)],
	["30Rnd_9x21_Mag", ceil (_playerCount * 2 + _wave * 0.15)],
	["10Rnd_93x64_DMR_05_Mag", ceil (_wave * 0.7)],
	["20Rnd_762x51_Mag", ceil (_playerCount * _wave * 0.4)],
	["30Rnd_556x45_Stanag", ceil (_playerCount * _wave * 0.5)],
	["7Rnd_408_Mag", _wave],
	["150Rnd_93x64_Mag", ceil (_wave * 0.2)],
	["HandGrenade", (ceil (_playerCount * _wave * 0.3)) min ( _playerCount * 12)]
];

{
	ammoBox addMagazineCargoGlobal [_x select 0, _x select 1];
} forEach _ammo;

//add unlockable items
if ("UAV Terminal" call _itemIsUnlocked) then { //uav terminals
	ammoBox addItemCargoGlobal ["B_UavTerminal", _playerCount];
};
if ("Red Dot Optics" call _itemIsUnlocked) then { //red dot optics
	ammoBox addItemCargoGlobal ["optic_Aco", _playerCount];
	ammoBox addItemCargoGlobal ["optic_Aco_smg", _playerCount];
	ammoBox addItemCargoGlobal ["optic_Holosight", _playerCount];
	ammoBox addItemCargoGlobal ["optic_Holosight_smg", _playerCount];
};
if ("Hybrid Optics" call _itemIsUnlocked) then { //hybrid optics
	ammoBox addItemCargoGlobal ["optic_MRCO", _playerCount];
	ammoBox addItemCargoGlobal ["optic_Hamr", _playerCount];
	ammoBox addItemCargoGlobal ["optic_Arco_blk_F", _playerCount];
	ammoBox addItemCargoGlobal ["optic_ERCO_blk_F", _playerCount];
};
if ("Sniper Optics" call _itemIsUnlocked) then { //zoom optics
	ammoBox addItemCargoGlobal ["optic_SOS", _playerCount];
};
if ("Thermal Optics" call _itemIsUnlocked) then { //thermal optics
	ammoBox addItemCargoGlobal ["optic_tws", _playerCount];
	ammoBox addItemCargoGlobal ["optic_tws_mg", _playerCount];
};



//add recurring items
if ((_wave mod 4) == 0) then { //first aid kits
	specialBox addItemCargoGlobal ["FirstAidKit", _playerCount];
};
if ("APERS Mines" call _itemIsUnlocked) then { //apers mines
	specialBox addMagazineCargoGlobal ["APERSMine_Range_Mag", ceil (_wave * 0.4)];
};
if ("Explosive Charges" call _itemIsUnlocked) then { //explosive charges
	specialBox addMagazineCargoGlobal ["DemoCharge_Remote_Mag", 1];
};
if ("Satchel Charges" call _itemIsUnlocked && _wave mod 2 == 0) then { //satchel charges
	specialBox addMagazineCargoGlobal ["SatchelCharge_Remote_Mag", 1];
};
if ("launch_RPG7_F" call _itemIsUnlocked && _wave mod 3 == 0) then { //RPG rockets
	specialBox addMagazineCargoGlobal ["RPG7_F", (ceil (_wave / 3.0)) min 2];
};
if ("launch_B_Titan_F" call _itemIsUnlocked && _wave mod 5 == 0) then { //titan rockets
	specialBox addMagazineCargoGlobal ["Titan_AA", 2];
};
if ("launch_RPG32_F" call _itemIsUnlocked && _wave mod 3 == 0) then { //RPG42 rockets
	specialBox addMagazineCargoGlobal ["RPG32_F", (ceil (_wave / 3.0)) min 5];
};
if ("launch_B_Titan_short_F" call _itemIsUnlocked && _wave mod 3 == 0) then { //titan short rockets
	specialBox addMagazineCargoGlobal ["Titan_AT", (ceil (_wave / 4.0)) min 2];
};