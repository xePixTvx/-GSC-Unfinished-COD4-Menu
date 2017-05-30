#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

_setText(string)
{
	self setText(string);
	if(level.OverFlowFix==true)
	{
		self ClearAllTextAfterHudelem();
	}
}

init_antioverFlow()
{
	level.Strings = 0;
	level.StringList = [];
	level.StringSetAllowed = true;
	level.OverFlowFix = true;
}