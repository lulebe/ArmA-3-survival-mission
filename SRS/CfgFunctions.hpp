class SRS
{
	tag = "SRS";
	class SRS_init
	{
		file = "SRS";
		class init{};
	};
	class SRS_gui
	{
		file = "SRS\GUI";
		class progressBarInit{};
		class progressBar{};
		class button{};
	};
	class SRS_funcs
	{
		file = "SRS\Functions";
		class unitVarInit{};
		class unitVarDefault{};
		class unitVarGetter{};
		class unitVarSetter{};
		class handleDamage{};
		class knockOut{};
		class wakeUp{};
		class respawnEH{};
		class toggleRadio{};
		class resetSRS{};
		class revive{};
		class drag{};
		class drop{};
		class suicide{};
		class diary{ postInit = 1; };
	};
	class SRS_menu
	{
		file = "SRS\Menu";
		class menuDirector{};
		class setOtherMenuState{};
		class addAction{};
		class removeAction{};
	};
	class SRS_effects
	{
		file = "SRS\Effects";
		class dumpMedicalSupplies{};
		class createDownedMarker{};
		class removeDownedMarker{};
		class ragdoll{};
	};
};