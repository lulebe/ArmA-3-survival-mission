// wake unit from KO state

_unit = _this select 0;

if(_unit != player) exitWith{};

[[_unit],"SRS_fnc_removeDownedMarker"] call BIS_fnc_MP;

if(Dialog) then{ closeDialog 0; };

player sidechat "Waking up...";
_unit playMove "amovppnemstpsraswrfldnon";
titleFadeOut 15;

_unit allowDamage true;
_unit setCaptive false;

_unitVar = _unit getVariable "SRS_unitVariable";
_unitVar set [srs_knockedOut,False];
[_unit,_unitVar,True] call SRS_fnc_unitVarSetter;

_unit setFatigue (0.7 + random 0.3);

[True] call SRS_fnc_toggleRadio;