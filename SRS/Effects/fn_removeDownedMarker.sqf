// remove map marker for downed players

if(!SRS_downedMarkers) exitWith{};
if(isDedicated) exitWith{};
if(!hasInterface) exitWith{};

_unit       = _this select 0;

if(isNil {_unit getVariable "SRS_unitSide"}) exitWith{};

_unitSide   = _unit getVariable "SRS_unitSide";
_playerSide = player getVariable "SRS_unitSide";

if(_unit == player) exitWith{};

if(_unitSide == _playerSide) then{
	if(isNil {_unit getVariable "SRS_unitMarker"}) exitWith{};

	_unitMarker = _unit getVariable "SRS_unitMarker";
	deleteMarkerLocal _unitMarker;
};