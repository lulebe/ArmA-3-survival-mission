if (!loadedFromSave) then {
	loadedFromSave = false;
	currentWave = 1;
	waveRunning = false;
	livingUnits = 0;
	unitsOfCurrentWave = [];
	startNextWaveNow = false;
	noWaveReward = false;
	ammoBoxes = [];

	money = 300;

	staticAAPlaced = [];

	waveDelay = 30;
	addedWaveDelay = 10;
	vehicleWaves = 3;
	helicopterWaves = 5;
	heavyVehiclesStartWave = 10;
	moreVehiclesStartWave = 16;
	moreHeavyVehiclesInterval = 10;

	//shopping
	allGear = [
		//[isWeapon, price, classname/type, multipleTimes]
		[true,0,"hgun_P07_F", false],
		[true,300,"hgun_Pistol_heavy_01_F", false],
		[true,150,"SMG_01_F", false],
		[true,600,"arifle_MX_F", false],
		[true,900,"arifle_MX_GL_F", false],
		[true,1500,"arifle_SPAR_03_blk_F", false],
		[true,1500,"arifle_SPAR_01_GL_blk_F", false],
		[true,1100,"LMG_Mk200_F", false],
		[true,2000,"MMG_01_tan_F", false],
		[true,1100,"srifle_DMR_05_blk_F", false],
		[true,1600,"srifle_LRR_F", false],
		[true,0,"launch_RPG7_F", false],
		[true,600,"launch_RPG32_F", false],
		[true,0,"launch_B_Titan_F", false],
		[true,900,"launch_B_Titan_short_F", false],
		[false,700,"UAV Terminal", false],
		[false,250,"APERS Mines", false],
		[false,300,"Explosive Charges", false],
		[false,1000,"Satchel Charges", false],
		[false,200,"Red Dot Optics", false],
		[false,600,"Hybrid Optics", false],
		[false,700,"Sniper Optics", false],
		[false,800,"Thermal Optics", false],
		[false,350,"Bipods", false],
		[false, 1000, "Armor", true]
	];
	unlockedGear = [];
	unlockedAmmo = [];
};


publicVariable "waveRunning";
publicVariable "currentWave";
publicVariable "money";
publicVariable "staticAA";
publicVariable "waveDelay";
publicVariable "vehicleWaves";
publicVariable "helicopterWaves";
//shopping
publicVariable "allGear";
publicVariable "unlockedGear";


clearItemCargoGlobal ammoBox;
clearWeaponCargoGlobal ammoBox;
clearMagazineCargoGlobal ammoBox;
clearBackpackCargoGlobal ammoBox; 
clearItemCargoGlobal weaponBox;
clearWeaponCargoGlobal weaponBox;
clearMagazineCargoGlobal weaponBox;
clearBackpackCargoGlobal weaponBox; 
clearItemCargoGlobal specialBox;
clearWeaponCargoGlobal specialBox;
clearMagazineCargoGlobal specialBox;
clearBackpackCargoGlobal specialBox; 


[drone] spawn { while {true} do { sleep 300; _this select 0 setFuel 1; };}; 

player addAction ["end wave", "killWave.sqf", [], 0, false];
player addAction ["skip wait", {startNextWaveNow = true;}, [], 1.5, false, true, "", "livingUnits <= 0"];

timeAtStart = time;
firstWaveAt = timeAtStart + 180;
if (loadedFromSave) then {
	firstWaveAt = timeAtStart + waveDelay + (currentWave * addedWaveDelay);
};

_firstWaveWaitDisplayHandler = [] spawn {
	while {true} do {
		[0, firstWaveAt - time] remoteExecCall ["showWaveEnd"];
		sleep 1;
	};
};

[] execVM "mortars.sqf";

if (!loadedFromSave) then {
	[1] execVM "fillAmmobox.sqf";
	waitUntil {(time - timeAtStart) >= 180 || startNextWaveNow};
} else {
	waitUntil {(time - timeAtStart) >= (waveDelay + (currentWave * addedWaveDelay)) || startNextWaveNow};
};

terminate _firstWaveWaitDisplayHandler;

[] execVM "spawnWaves.sqf";