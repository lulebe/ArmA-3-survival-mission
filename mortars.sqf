_positions = [markerPos "ordnance_1", markerPos "ordnance_2", markerPos "ordnance_3", markerPos "ordnance_4", markerPos "ordnance_5", markerPos "ordnance_6"];
while {true} do {
	"M_Mo_82mm_AT_LG" createVehicle (selectRandom _positions);
	sleep random 3;
	"M_Mo_82mm_AT_LG" createVehicle (selectRandom _positions);
	sleep (random 15);
};