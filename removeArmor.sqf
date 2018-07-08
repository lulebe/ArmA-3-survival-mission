player setVariable ["hasArmor", false];
player setVariable ["armor", 0];

_uniformWeapons = weaponCargo (uniformContainer player);
_uniformMagazines = magazineCargo (uniformContainer player);
_uniformItems = itemCargo (uniformContainer player);

_vestWeapons = weaponCargo (vestContainer player);
_vestMagazines = magazineCargo (vestContainer player);
_vestItems = itemCargo (vestContainer player);

player addUniform "U_B_CombatUniform_mcam";
player addVest "V_PlateCarrierSpec_mtp";

{(uniformContainer player) addWeaponCargo [_x, 1]} forEach _uniformWeapons;
{(uniformContainer player) addMagazineCargo [_x, 1]} forEach _uniformMagazines;
{(uniformContainer player) addItemCargo [_x, 1]} forEach _uniformItems;

{(vestContainer player) addWeaponCargo [_x, 1]} forEach _vestWeapons;
{(vestContainer player) addMagazineCargo [_x, 1]} forEach _vestMagazines;
{(vestContainer player) addItemCargo [_x, 1]} forEach _vestItems;