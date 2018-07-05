_name = _this select 2;
if (_this select 0) then { //is Weapon
	weaponBox addWeaponCargoGlobal [_name, count allPlayers];
	if (_name == "launch_RPG7_F") then { //RPG rockets
		specialBox addMagazineCargoGlobal ["RPG7_F", (ceil (currentWave / 3.0)) min 2];
	};
	if (_name == "launch_B_Titan_F") then { //titan rockets
		specialBox addMagazineCargoGlobal ["Titan_AA", 2];
	};
	if (_name == "launch_RPG32_F") then { //RPG42 rockets
		specialBox addMagazineCargoGlobal ["RPG32_F", (ceil (currentWave / 3.0)) min 5];
	};
	if (_name == "launch_B_Titan_short_F") then { //titan short rockets
		specialBox addMagazineCargoGlobal ["Titan_AT", (ceil (currentWave / 4.0)) min 2];
	};	
} else {
	_playerCount = count allPlayers;
	_name = _this select 2;
	if (_name == "UAV Terminal") then { //uav terminals
		ammoBox addItemCargoGlobal ["B_UavTerminal", _playerCount];
	};
	if (_name == "Red Dot Optics") then { //red dot optics
		ammoBox addItemCargoGlobal ["optic_Aco", _playerCount];
		ammoBox addItemCargoGlobal ["optic_Aco_smg", _playerCount];
		ammoBox addItemCargoGlobal ["optic_Holosight", _playerCount];
		ammoBox addItemCargoGlobal ["optic_Holosight_smg", _playerCount];
	};
	if (_name == "Hybrid Optics") then { //hybrid optics
		ammoBox addItemCargoGlobal ["optic_MRCO", _playerCount];
		ammoBox addItemCargoGlobal ["optic_Hamr", _playerCount];
		ammoBox addItemCargoGlobal ["optic_Arco_blk_F", _playerCount];
		ammoBox addItemCargoGlobal ["optic_ERCO_blk_F", _playerCount];
	};
	if (_name == "Sniper Optics") then { //zoom optics
		ammoBox addItemCargoGlobal ["optic_SOS", _playerCount];
	};
	if (_name == "Thermal Optics") then { //thermal optics
		ammoBox addItemCargoGlobal ["optic_tws", _playerCount];
		ammoBox addItemCargoGlobal ["optic_tws_mg", _playerCount];
	};
	if (_name == "APERS Mines") then { //apers mines
		specialBox addMagazineCargoGlobal ["APERSMine_Range_Mag", ceil (currentWave * 0.4)];
	};
	if (_name == "Explosive Charges") then { //explosive charges
		specialBox addMagazineCargoGlobal ["DemoCharge_Remote_Mag", 1];
	};
	if (_name == "Satchel Charges") then { //satchel charges
		specialBox addMagazineCargoGlobal ["SatchelCharge_Remote_Mag", 1];
	};
};