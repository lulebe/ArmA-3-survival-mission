if (!loadedFromSave) then {
	loadedFromSave = false;
	currentWave = 1;
	waveRunning = false;
	livingUnits = 0;
	unitsOfCurrentWave = [];
	startNextWaveNow = false;
	noWaveReward = false;
	ammoBoxes = [];

	money = 150;
	killRewardUnit = 15;
	killRewardVehicle = 100;
	killRewardHelicopter = 140;

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
		//[isWeapon, price, classname/type, hasAccumulatingAmmo]
		[true,0,"hgun_P07_F"],
		[true,200,"hgun_ACPC2_F"],
		[true,500,"hgun_PDW2000_F"],
		[true,150,"SMG_01_F"],
		[true,400,"arifle_MX_F"],
		[true,600,"arifle_MX_GL_F"],
		[true,800,"arifle_SPAR_03_blk_F"],
		[true,900,"arifle_SPAR_01_GL_blk_F"],
		[true,900,"LMG_Mk200_F"],
		[true,1200,"MMG_01_tan_F"],
		[true,900,"srifle_DMR_05_blk_F"],
		[true,1200,"srifle_LRR_F"],
		[true,0,"launch_RPG7_F"],
		[true,600,"launch_RPG32_F"],
		[true,0,"launch_B_Titan_F"],
		[true,900,"launch_B_Titan_short_F"],
		[false,700,"UAV Terminal"],
		[false,250,"APERS Mines"],
		[false,300,"Explosive Charges"],
		[false,600,"Satchel Charges"],
		[false,200,"Red Dot Optics"],
		[false,600,"Hybrid Optics"],
		[false,700,"Sniper Optics"],
		[false,800,"Thermal Optics"]
	];
	unlockedGear = [];
	unlockedAmmo = [];
};


publicVariable "waveRunning";
publicVariable "currentWave";
publicVariable "money";
publicVariable "killRewardUnit";
publicVariable "killRewardVehicle";
publicVariable "killRewardHelicopter";
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

if (!loadedFromSave) then {
	[0] execVM "fillAmmobox.sqf";
	waitUntil {(time - timeAtStart) >= 180 || startNextWaveNow};
} else {
	waitUntil {(time - timeAtStart) >= (waveDelay + (currentWave * addedWaveDelay)) || startNextWaveNow};
};

terminate _firstWaveWaitDisplayHandler;

[] execVM "spawnWaves.sqf";

