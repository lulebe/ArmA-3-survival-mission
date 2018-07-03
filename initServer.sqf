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
	killRewardUnit = 10;
	killRewardVehicle = 60;
	killRewardHelicopter = 120;

	staticAAPlaced = [];

	waveDelay = 30;
	addedWaveDelay = 9;
	vehicleWaves = 3;
	helicopterWaves = 5;
	heavyVehiclesStartWave = 10;
	moreVehiclesStartWave = 16;
	moreHeavyVehiclesInterval = 10;
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
	waitUntil {(time - timeAtStart) >= 180 || startNextWaveNow};
	[0] execVM "fillAmmobox.sqf";
} else {
	waitUntil {(time - timeAtStart) >= (waveDelay + (currentWave * addedWaveDelay)) || startNextWaveNow};
};

terminate _firstWaveWaitDisplayHandler;

[] execVM "spawnWaves.sqf";