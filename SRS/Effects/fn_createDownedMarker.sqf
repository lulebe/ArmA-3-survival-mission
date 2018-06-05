// create map marker for downed players

if(!SRS_downedMarkers) exitWith{};
if(isDedicated) exitWith{};
if(!hasInterface) exitWith{};

_unit       = _this select 0;
_unitSide   = _unit getVariable "SRS_unitSide";
_playerSide = player getVariable "SRS_unitSide";

if(_unit == player) exitWith{};

if(_unitSide == _playerSide) then{
	_unitString = _unit getVariable "SRS_unitString";
	_unitMarker = format["%1_MARK",_unitString];
	_unit setVariable ["SRS_unitMarker",_unitMarker];

	_mark = createMarkerLocal [_unitMarker, position _unit];
	_mark setMarkerTextLocal format["%1 down",name _unit];
	_mark setMarkerShapeLocal "ICON";

	_markColor = "ColorRed";
	_markType  = "loc_Hospital";

	_mark setMarkerTypeLocal _markType;
	_mark setMarkerColorLocal _markColor;
};
