currentWave = 1;
waveRunning = false;
publicVariable "waveRunning";
publicVariable "currentWave";
livingUnits = 0;
unitsOfCurrentWave = [];
startNextWaveNow = false;

money = 0;
publicVariable "money";

[drone] spawn { while {true} do { sleep 300; _this select 0 setFuel 1; };}; 

player addAction ["end wave", "killWave.sqf", [], 0, false];
player addAction ["skip wait", {startNextWaveNow = true;}, [], 1.5, false, true, "", "livingUnits <= 0"];

waitUntil {time >= 180 || startNextWaveNow};

[] execVM "spawnWaves.sqf";