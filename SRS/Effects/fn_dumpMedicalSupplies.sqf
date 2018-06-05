// From AIS injury by Pyschobastard (http://www.armaholic.com/page.php?id=24088)
// throw random medical items on the ground

_healer  = _this select 0;
_injured = _this select 1;
_mode    = _this select 2;

switch(_mode) do{
	
	case 0:{ //distribute trash
		_medsOnGround = _healer getVariable "SRS_medSupplies";
		if(count _medsOnGround > 0) then{
			{
				deleteVehicle _x;
			}forEach _medsOnGround;
			_medsOnGround = [];
		};
		sleep (random 3);
		_nbandages = 1 + round (random 4);
		if(SRS_DEBUG) then{ player sidechat format["spawning %1 bandages...",_nbandages]; };
		for "_i" from 1 to _nbandages do{
			_bandPos = _healer modelToWorld [(random 1.3),(0.8 + (random 0.6)),0];
			_bandage = "Land_Bandage_F" createVehicle _bandPos;
			_bandage setPos _bandPos;
			_bandage setDir (random 360);
			_medsOnGround pushBack _bandage;
			_healer setVariable ["SRS_medSupplies",_medsOnGround];
			if(count (_healer getVariable "SRS_isReviving") == 0 && !SRS_DEBUG) exitWith{};
			sleep (random 5);
		};
	};

	case 1:{ //cleanup trash
		waitUntil{count (_healer getVariable "SRS_isReviving") == 0};
		sleep 8 + (random 8);
		_medsOnGround = player getVariable "SRS_medSupplies";
		{
			deleteVehicle _x;
		}forEach _medsOnGround;
		player setVariable ["SRS_medSupplies",[]];
	};

	default {};

};