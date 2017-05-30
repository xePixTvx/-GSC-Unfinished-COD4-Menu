#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
#include FuZiioN\_common_scripts;
#include FuZiioN\_overFlow;

#include FuZiioN\_menu;
#include FuZiioN\_system;

init()
{	
	level.epxDevMode = true;
	PrecacheShader("white");
	PrecacheShader("ui_host");
	PrecacheShader("minimap_background");
	PrecacheShader("AC1D");
	PrecacheShader("ui_scrollbar_arrow_right");
	precacheLocationSelector("rank_prestige10");
	level thread _preloadRankss();
	setDvar("bg_fallDamageMinHeight",9999);
	setDvar("bg_fallDamageMaxHeight",9999);
	setDvar("con_gameMsgWindow1FadeInTime",0.01);
	setDvar("con_gameMsgWindow1ScrollTime",0.01);
	level thread init_antioverFlow();
	level thread onPlayerConnect();
}
onPlayerConnect()
{
	for(;;)
	{
		level waittill("connected",player);
		player.MenuType = 1;
		player thread _setUpMenu();
		player thread _loadBools();
		player thread onPlayerSpawned();
		player thread _monitorVerifycation();
	}
}
onPlayerSpawned()
{
	self endon("disconnect");
	self.isFirstSpawn = true;
	for(;;)
	{
		self waittill("spawned_player");
		if(self.isFirstSpawn==true)
		{
			self setClientDvar("cg_fov",self.Fov);
			self thread setVerifycationOnConnect();
			self.isFirstSpawn = false;
		}
	}
}

_loadBools()
{
	self.TestToggle = false;
	self.god = false;
	self.unlmAmmo = false;
	self.Invisible = false;
	self.Fov = 65;
	self.SavedPostion = undefined;
}
_preloadRankss()
{
	level.Rankss = [];level.Rankss[1] = "rank_pfc1";
	level.Rankss[2] = "rank_pfc2";level.Rankss[3] = "rank_pfc3";level.Rankss[4] = "rank_lcpl1";
	level.Rankss[5] = "rank_lcpl2";level.Rankss[6] = "rank_lcpl3";level.Rankss[7] = "rank_cpl1";
	level.Rankss[8] = "rank_cpl2";level.Rankss[9] = "rank_cpl3";level.Rankss[10] = "rank_sgt1";
	level.Rankss[11] = "rank_sgt2";level.Rankss[12] = "rank_sgt3";level.Rankss[13] = "rank_ssgt1";
	level.Rankss[14] = "rank_ssgt2";level.Rankss[15] = "rank_ssgt3";level.Rankss[16] = "rank_gysgt1";
	level.Rankss[17] = "rank_gysgt2";level.Rankss[18] = "rank_gysgt3";level.Rankss[19] = "rank_msgt1";
	level.Rankss[20] = "rank_msgt2";level.Rankss[21] = "rank_msgt3";level.Rankss[22] = "rank_mgysgt1";
	level.Rankss[23] = "rank_mgysgt2";level.Rankss[24] = "rank_mgysgt3";level.Rankss[25] = "rank_2ndlt1";
	level.Rankss[26] = "rank_2ndlt2";level.Rankss[27] = "rank_2ndlt3";level.Rankss[28] = "rank_1stlt1";
	level.Rankss[29] = "rank_1stlt2";level.Rankss[30] = "rank_1stlt3";level.Rankss[31] = "rank_capt1";
	level.Rankss[32] = "rank_capt2";level.Rankss[33] = "rank_capt3";level.Rankss[34] = "rank_maj1";
	level.Rankss[35] = "rank_maj2";level.Rankss[36] = "rank_maj3";level.Rankss[37] = "rank_ltcol1";
	level.Rankss[38] = "rank_ltcol2";level.Rankss[39] = "rank_ltcol3";level.Rankss[40] = "rank_col1";
	level.Rankss[41] = "rank_col2";level.Rankss[42] = "rank_col3";level.Rankss[43] = "rank_bgen1";
	level.Rankss[44] = "rank_bgen2";level.Rankss[45] = "rank_bgen3";level.Rankss[46] = "rank_majgen1";
	level.Rankss[47] = "rank_majgen2";level.Rankss[48] = "rank_majgen3";level.Rankss[49] = "rank_ltgen1";
	level.Rankss[50] = "rank_ltgen2";level.Rankss[51] = "rank_ltgen3";level.Rankss[52] = "rank_gen1";
	level.Rankss[53] = "rank_gen2";level.Rankss[54] = "rank_gen3";level.Rankss[55] = "rank_comm1";
	wait 0.05;
	for(i=0;i<level.Rankss.size;i++)
	{
		precacheShader(level.Rankss[i]);
	}
	
	level.Prestigess = [];
	level.Prestigess[1] = "rank_prestige1";
	level.Prestigess[2] = "rank_prestige2";
	level.Prestigess[3] = "rank_prestige3";
	level.Prestigess[4] = "rank_prestige4";
	level.Prestigess[5] = "rank_prestige5";
	level.Prestigess[6] = "rank_prestige6";
	level.Prestigess[7] = "rank_prestige7";
	level.Prestigess[8] = "rank_prestige8";
	level.Prestigess[9] = "rank_prestige9";
	level.Prestigess[10] = "rank_prestige10";
	level.Prestigess[11] = "rank_prestige11";
	wait 0.05;
	for(i=0;i<level.Prestigess.size;i++)
	{
		precacheShader(level.Prestigess[i]);
	}
}







