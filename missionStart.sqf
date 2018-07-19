sleep 4;

[player, "starthelitask", ["Escape before the enemies arrive.", "Get in Helicopter", "target"], "target", true, 2, true, "takeoff"] call BIS_fnc_taskCreate;

waitUntil {!(alive startheli)};

["starthelitask", "FAILED"] call BIS_fnc_taskSetState;

[player, "ammoboxtask", ["Rearm to fight the enemies.", "Rearm", "supplyboxeslocation"], "supplyboxeslocation", true, 2, true, "rearm"] call BIS_fnc_taskCreate;

waitUntil {(player distance (markerPos "supplyboxeslocation")) < 4};

["ammoboxtask", "SUCCEEDED"] call BIS_fnc_taskSetState;