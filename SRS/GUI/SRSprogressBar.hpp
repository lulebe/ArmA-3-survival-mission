// From AIS injury by Pyschobastard (http://www.armaholic.com/page.php?id=24088)
class SRS_ProgressBar {
	idd = -1;
	movingEnable = 0;
	objects[] = {};
	duration = 1e+011;
	name = "SRS_ProgressBar";
	onload = "_this call SRS_fnc_progressBarInit;";

	class controlsBackground {
		class mpsf_progressbar_background {
			idc = 0;
			x = "0.298906 * safezoneW + safezoneX";
			y = "0.082 * safezoneH + safezoneY";
			w = "0.407344 * safezoneW";
			h = "0.011 * safezoneH";
			type = 0;
			style = 0;
			shadow = 0;
			colorShadow[] = {0,0,0,0.5};
			font = "PuristaMedium";
			SizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
			text = "";
			colorText[] = {1,1,1,1};
			colorBackground[] = {0,0,0,0.7};
			linespacing = 1;
		};
	};
	class controls {
		class mpsf_progressbar_foreground {
			idc = 1;
			x = "0.298906 * safezoneW + safezoneX";
			y = "0.082 * safezoneH + safezoneY";
			w = "0.001 * safezoneW";
			h = "0.011 * safezoneH";
			type = 0;
			style = 0;
			shadow = 0;
			colorShadow[] = {0,0,0,0.5};
			font = "PuristaMedium";
			SizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
			text = "";
			colorText[] = {1,1,1,1};
			colorBackground[] = {0.6784, 0.7490, 0.5137, 0.7};
			linespacing = 1;
		};
		class mpsf_progressbar_text {
			idc = 2;
			type = 13;
			style = 0x00;
			colorBackground[] = {0,0,0,0};
			x = "0.298906 * safezoneW + safezoneX";
			y = "0.093 * safezoneH + safezoneY";
			w = "0.407344 * safezoneW";
			h = "0.022 * safezoneH";	
			text = "";
			size = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
			colorText[] = {0, 0, 0, 1};
			class Attributes {
				font = "EtelkaMonospaceProBold";
				color = "#FFFFFF";
				align = "left";
				valign = "middle";
				shadow = 1;
				shadowColor = "#000000";
				//size = "2.25";
			};
		};
	};
};


/*
class SRS_respawnGUI {
	idd = -1;
	movingEnable = 0;
	objects[] = {};
	duration = 1e+011;
	name = "SRS_respawnGUI";
	//onload = "_this call SRS_fnc_progressBarInit;";

	class SRS_respawnTimer: RscText
	{
		idc = 1000;
		text = "Time Left:"; //--- ToDo: Localize;
		x = 0.457461 * safezoneW + safezoneX;
		y = 0.643 * safezoneH + safezoneY;
		w = 0.100547 * safezoneW;
		h = 0.044 * safezoneH;
	};
	class SRS_respawnButton: RscButton
	{
		idc = 1600;
		text = "RESPAWN"; //--- ToDo: Localize;
		x = 0.449727 * safezoneW + safezoneX;
		y = 0.687 * safezoneH + safezoneY;
		w = 0.119883 * safezoneW;
		h = 0.055 * safezoneH;
	};
};
*/