// button actions for KO & reviving states.

#define _callForHelpDelay 30

_button = _this select 0;

switch(_button) do{

	case "RESPAWN":{
		[] call SRS_fnc_suicide;
	};

	case "TOGGLECAMERA":{
		switch(cameraView) do{
			case "INTERNAL": { player switchCamera "EXTERNAL"; };
			case "EXTERNAL": { player switchCamera "INTERNAL"; };
			default{};
		};
	};

	case "CALLFORHELP":{
		if(player getVariable "SRS_canCallForHelp") then{
			_medicCalls = 
			[
				"a3\sounds_f\characters\human-sfx\Person0\P0_moan_13_words.wss","a3\sounds_f\characters\human-sfx\Person0\P0_moan_14_words.wss","a3\sounds_f\characters\human-sfx\Person0\P0_moan_15_words.wss","a3\sounds_f\characters\human-sfx\Person0\P0_moan_16_words.wss","a3\sounds_f\characters\human-sfx\Person0\P0_moan_17_words.wss","a3\sounds_f\characters\human-sfx\Person0\P0_moan_18_words.wss","a3\sounds_f\characters\human-sfx\Person0\P0_moan_19_words.wss","a3\sounds_f\characters\human-sfx\Person0\P0_moan_20_words.wss",
				"a3\sounds_f\characters\human-sfx\Person1\P1_moan_19_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_20_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_21_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_22_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_23_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_24_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_25_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_26_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_27_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_28_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_29_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_30_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_31_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_32_words.wss","a3\sounds_f\characters\human-sfx\Person1\P1_moan_33_words.wss",
				"a3\sounds_f\characters\human-sfx\Person2\P2_moan_19_words.wss"
			];
			playSound3D [_medicCalls call BIS_fnc_selectRandom,player, false, position player, 3];

			_curText = ctrlText 1602;
			[_curText] spawn{
				_time = time;
				while{(time - _time) < _callForHelpDelay} do{
					_timeleft = round (_callForHelpDelay - (time - _time));
					ctrlSetText [1602,format["%1",_timeleft]];
					sleep 0.5;
				};
				ctrlSetText [1602,_this select 0];
				player setVariable ["SRS_canCallForHelp",True];			
			};
			player setVariable ["SRS_canCallForHelp",False];
		};
	};

	case "CANCEL":{
		player setVariable ["SRS_cancelRevive",True];
	};

	default{};
};
true