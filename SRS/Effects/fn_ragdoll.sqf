// thanks to KillzoneKid
// http://killzonekid.com/arma-scripting-tutorials-forced-ragdoll/

_unit = _this select 0;

if(_unit != player) exitWith{};

_can = "Land_Can_V3_F" createVehicleLocal [0,0,0];
_can setMass 1e10;
_can attachTo [player, [0,0,0], "Spine3"];
_can setVelocity [0,0,6];
player allowDamage false;
detach _can;
0 = _can spawn {
    deleteVehicle _this;
    //player allowDamage true;
};

true