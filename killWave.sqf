{
	_x removeAllEventHandlers "killed";
	_x setDamage 1;
	deleteVehicle _x;
}forEach unitsOfCurrentWave;

livingUnits = 0;
unitsOfCurrentWave = [];
noWaveReward = true;
[livingUnits] remoteExecCall ["showKill"];