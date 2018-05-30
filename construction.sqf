_enterActionId = _this select 2;
player removeAction _enterActionId;


_buildOptions = [
	["low sandbags", "Land_SandbagBarricade_01_half_F", 100, [0,1,0.65], {}],
	["high sandbags", "Land_SandbagBarricade_01_F", 200, [0,1,1.3], {}],
	["Bunker", "Land_BagBunker_Small_F", 500, [0,3,0.93], {}],
	["static MG", "B_HMG_01_high_F", 500, [0,1,1.7], {
		_this enableWeaponDisassembly false;
		_this addEventHandler ["Fired", {(_this select 0) setVehicleAmmo 1;}];
	}],
	["repair building", "", 1000, [0,0,0], {(nearestBuilding player) setDamage 0}]
];
buildActionIds = [];
constructionConfirmAction = 0;
constructionCancelAction = 0;
constructionObject = objNull;


leaveConstructionMode = {
	{player removeAction _x} forEach buildActionIds;
	buildActionIds = [];
	player removeAction _this;
	player addAction ["enter build mode", "construction.sqf", [], 1.5, false, false, "", "!waveRunning"];
};
confirmBuild = {
	detach constructionObject;
	constructionObject setVariable ["unconfirmed", false];
	constructionObject = objNull;
	player setVariable ["constructionOngoing", false];
	player removeAction constructionConfirmAction;
	player removeAction constructionCancelAction;
};
cancelBuild = {
	money = money + ((_this select 3) select 0);
	publicVariable "money";
	[money] remoteExecCall ["updateMoney"];
	deleteVehicle constructionObject;
	constructionObject = objNull;
	player setVariable ["constructionOngoing", false];
	player removeAction constructionConfirmAction;
	player removeAction constructionCancelAction;
};
autoCancelBuild = {
	waitUntil { waveRunning; };
	if ((_this select 0) getVariable "unconfirmed") then {
		money = money + (_this select 1);
		publicVariable "money";
		[money] remoteExecCall ["updateMoney"];
		deleteVehicle (_this select 0);
		player setVariable ["constructionOngoing", false];
		player removeAction constructionConfirmAction;
		player removeAction constructionCancelAction;
	};
};


_buildObject = {
	_infoBuildObject = (_this select 3) select 0;
	_price = _infoBuildObject select 2;
	_class = _infoBuildObject select 1;
	_offset = _infoBuildObject select 3;
	_initScript = _infoBuildObject select 4;
	if (money >= _price) then {
		money = money - _price;
		publicVariable "money";
		[money] remoteExecCall ["updateMoney"];
		if (count _class == 0) then {
			[] call _initScript;
		} else {
			player setVariable ["constructionOngoing", true];
			_object = _class createVehicle position player;
			_object attachTo [player, _offset];
			constructionObject = _object;
			_object setVariable ["unconfirmed", true];
			constructionCancelAction = player addAction ["<t color='#ff0000'>cancel build</t>", cancelBuild, [_price], 9];
			constructionConfirmAction = player addAction ["<t color='#00ff00'>confirm build</t>", confirmBuild, [], 10];
			_object call _initScript;
			[_object, _price] spawn autoCancelBuild;
		};
	} else {
		hint "Not enough money.";
	};
};

{
	_text = "build %1: $%2";
	if (count (_x select 1) == 0) then {
		_text = "%1: $%2";
	};
	_actionId = player addAction [
		format [_text, _x select 0, _x select 2],
		_buildObject,
		[_x],
		1,
		false,
		false,
		"",
		"!(player getVariable ['constructionOngoing', false])"
	];
	buildActionIds pushBack _actionId;
} forEach _buildOptions;

leaveConstructionActionId = player addAction [
	"leave build mode",
	{(_this select 2) call leaveConstructionMode;},
	[],
	1.5,
	false,
	false,
	"",
	"!(player getVariable ['constructionOngoing', false])"
];

[] spawn {
	waitUntil {waveRunning};
	if (count buildActionIds > 0) then {
		leaveConstructionActionId call leaveConstructionMode;
	};
}