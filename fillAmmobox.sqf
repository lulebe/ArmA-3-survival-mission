_wave = _this select 0;
_playerCount = count allPlayers;


clearMagazineCargoGlobal ammoBox;
clearItemCargoGlobal ammoBox;
clearWeaponCargo ammoBox;

//add ammo
_ammo = [
	["16Rnd_9x21_Mag", _playerCount * 5, 0],
	["30Rnd_45ACP_Mag_SMG_01", (_playerCount * _wave) min (_playerCount * 10), 1],
	["30Rnd_65x39_caseless_mag", _playerCount * _wave, 5],
	["9Rnd_45ACP_Mag", (ceil (_playerCount * _wave * 0.4)) min ( _playerCount * 5), 7],
	["1Rnd_HE_Grenade_shell", _playerCount * _wave * 0.5, 10],
	["200Rnd_65x39_cased_Box", ceil (_wave * 0.2), 12],
	["30Rnd_9x21_Mag", ceil (_playerCount * 2 + _wave * 0.15), 15],
	["10Rnd_93x64_DMR_05_Mag", ceil (_wave * 0.7), 17],
	["20Rnd_762x51_Mag", ceil (_playerCount * _wave * 0.4), 18],
	["30Rnd_556x45_Stanag", ceil (_playerCount * _wave * 0.5), 20],
	["7Rnd_408_Mag", _wave, 23],
	["150Rnd_93x64_Mag", ceil (_wave * 0.2), 25],
	["HandGrenade", (ceil (_playerCount * _wave * 0.3)) min ( _playerCount * 12), 0]
];

{
	if (_wave >= (_x select 2)) then {
		ammoBox addMagazineCargoGlobal [_x select 0, _x select 1];
	};
} forEach _ammo;

//add unlockable items
if (_wave >= 10) then { //uav terminals
	ammoBox addItemCargoGlobal ["B_UavTerminal", _playerCount];
};
if (_wave >= 11) then { //red dot optics
	ammoBox addItemCargoGlobal ["optic_Aco", _playerCount];
	ammoBox addItemCargoGlobal ["optic_Aco_smg", _playerCount];
	ammoBox addItemCargoGlobal ["optic_Holosight", _playerCount];
	ammoBox addItemCargoGlobal ["optic_Holosight_smg", _playerCount];
};
if (_wave >= 16) then { //hybrid optics
	ammoBox addItemCargoGlobal ["optic_MRCO", _playerCount];
	ammoBox addItemCargoGlobal ["optic_Hamr", _playerCount];
	ammoBox addItemCargoGlobal ["optic_Arco_blk_F", _playerCount];
	ammoBox addItemCargoGlobal ["optic_ERCO_blk_F", _playerCount];
};
if (_wave >= 19) then { //zoom optics
	ammoBox addItemCargoGlobal ["optic_SOS", _playerCount];
};
if (_wave >= 22) then { //thermal optics
	ammoBox addItemCargoGlobal ["optic_tws", _playerCount];
	ammoBox addItemCargoGlobal ["optic_tws_mg", _playerCount];
};



//add new weapons
_weaponUnlocks = [
	"hgun_P07_F",
	"SMG_01_F",
	"launch_RPG7_F",
	"",
	"launch_B_Titan_F",
	"arifle_MX_F",
	"",
	"hgun_ACPC2_F",
	"launch_RPG32_F",
	"",
	"arifle_MX_GL_F",
	"",
	"LMG_Mk200_F",
	"launch_B_Titan_short_F",
	"",
	"hgun_PDW2000_F",
	"",
	"srifle_DMR_05_blk_F",
	"arifle_SPAR_03_blk_F",
	"",
	"arifle_SPAR_01_GL_blk_F",
	"",
	"",
	"srifle_LRR_F",
	"",
	"MMG_01_tan_F"
];
if (_wave <= 25 && (_weaponUnlocks select _wave) != "") then {
	weaponBox addWeaponCargoGlobal [_weaponUnlocks select _wave, ceil (_playerCount * 1.5)];
	[_weaponUnlocks select _wave] remoteExecCall ["weaponUnlockedInfo"];
};



//add recurring items
if ((_wave mod 4) == 0) then { //first aid kits
	specialBox addItemCargoGlobal ["FirstAidKit", _playerCount];
};
if (_wave >= 3) then { //apers mines
	specialBox addMagazineCargoGlobal ["APERSMine_Range_Mag", ceil (_wave * 0.4)];
};
if (_wave >= 6) then { //explosive charges
	specialBox addMagazineCargoGlobal ["DemoCharge_Remote_Mag", 1];
};
if (_wave >= 14 && (_wave == 14 || _wave mod 2 == 0)) then { //satchel charges
	specialBox addMagazineCargoGlobal ["SatchelCharge_Remote_Mag", 1];
};
if (_wave >= 2 && (_wave == 2 || _wave mod 3 == 0)) then { //RPG rockets
	specialBox addMagazineCargoGlobal ["RPG7_F", (ceil (_wave / 4.0)) min 2];
};
if (_wave >= 4 && (_wave == 4 || _wave mod 5 == 0)) then { //titan rockets
	specialBox addMagazineCargoGlobal ["Titan_AA", 2];
};
if (_wave >= 13 && (_wave == 13 || _wave mod 3 == 0)) then { //titan short rockets
	specialBox addMagazineCargoGlobal ["Titan_AT", (ceil (_wave / 4.0)) min 2];
};

_miscUnlockInfos = [
	"",
	"",
	"",
	"Apers Mines",
	"",
	"",
	"Explosive Charges",
	"",
	"",
	"",
	"UAV Terminal",
	"Red Dot Optics",
	"",
	"",
	"Satchel Charges",
	"",
	"Hybrid Optics",
	"",
	"",
	"Sniper Optics",
	"",
	"",
	"Thermal Optics",
	"",
	"",
	""
];

if (_wave <= 25 && (_miscUnlockInfos select _wave) != "") then {
	[_miscUnlockInfos select _wave] remoteExecCall ["miscUnlockedInfo"];
};