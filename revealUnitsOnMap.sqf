_markers = [];
while { waveRunning } do {
	{
		deleteMarker _x;
	} forEach _markers;
	_markers = [];
	{
		if (alive _x) then {
			_markerName = "_USER_DEFINED markeraliveunit_" + str _foreachIndex;
			_markers pushBack _markerName;
			_marker = createMarker [_markerName, position _x];
			_marker setMarkerColor "ColorRed";
			_marker setMarkerType "mil_dot";
		};
	} foreach _this;
	sleep 5;
};
{
	deleteMarker _x;
} forEach _markers;