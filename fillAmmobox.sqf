_wave = _this select 0;
_playerCount = playersNumber west;

//add standard stuff
ammoBox addMagazineCargoGlobal ["30Rnd_65x39_caseless_mag", _playerCount * _wave];
ammoBox addMagazineCargoGlobal ["10Rnd_9x21_Mag", _playerCount];

//add new weapons

//add special items