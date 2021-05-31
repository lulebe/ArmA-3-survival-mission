while {waveRunning} do {
	{
		_unit = _x;
		_closestPlayer = objNull;
		_closestDistance = 100000.0;
		{
			if ((_unit distance _x) < _closestDistance) then {
				_closestDistance = _unit distance _x;
				_closestPlayer = _x;
			};
			_unit reveal [_x, 4];
		} forEach allPlayers;
		_unit doMove getPosATL _closestPlayer;
		_unit setUnitPos "UP";
	} forEach _this;
	sleep(5);
};

{
	_x disableAI "AUTOCOMBAT";
	_x disableAI "COVER";
} forEach _this;