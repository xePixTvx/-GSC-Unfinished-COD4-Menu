#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
#include maps\mp\gametypes\_rank;
#include FuZiioN\_overFlow;

#include FuZiioN\_menu;

createText(font, fontscale, align, relative, x, y, sort, color, alpha, glowColor, glowAlpha, text)
{
	textElem = CreateFontString( font, fontscale );
	textElem setPoint( align, relative, x, y );
	textElem.sort = sort;
	//textElem.type = "text";
	textElem.color = color;
	textElem.alpha = alpha;
	textElem.glowColor = glowColor;
	textElem.glowAlpha = glowAlpha;
	if(isDefined(text))
	{
		textElem _setText(text);
	}
	textElem.foreground = true;
	textElem.hideWhenInMenu = false;
	return textElem;
}
createRectangle(align, relative, x, y, width, height, color, alpha, sorting, shadero)
{
	barElemBG = newClientHudElem( self );
	barElemBG.elemType = "bar";
	if ( !level.splitScreen )
	{
		barElemBG.x = -2;
		barElemBG.y = -2;
	}
	barElemBG.width = width;
	barElemBG.height = height;
	barElemBG.align = align;
	barElemBG.relative = relative;
	barElemBG.xOffset = 0;
	barElemBG.yOffset = 0;
	barElemBG.children = [];
	barElemBG.color = color;
	if(isDefined(alpha))
		barElemBG.alpha = alpha;
	else
		barElemBG.alpha = 1;
	barElemBG setShader( shadero, width , height );
	barElemBG.hidden = false;
	barElemBG.sort = sorting;
	barElemBG setPoint(align,relative,x,y);
	return barElemBG;
}
createShader(shader, x, y, width, height, horzAlign, vertAlign, sort, hideWhenInMenu, color, alpha)
{
	shaderElem = newClientHudElem(self);
	shaderElem.x = x;
	shaderElem.y = y;
	shaderElem setShader( shader, width, height );
	shaderElem.horzAlign = horzAlign;
	shaderElem.vertAlign = vertAlign;
	shaderElem.sort = sort;
	shaderElem.hideWhenInMenu = hideWhenInMenu;
	shaderElem.color = color;
	if(isDefined(alpha))
		shaderElem.alpha = alpha;
	else
		shaderElem.alpha = 1;

	return shaderElem;
}
elemFadeOverTime(time,alpha)
{
	self fadeovertime(time);
	self.alpha = alpha;
}
elemMoveOverTimeY(time,y)
{
	self moveovertime(time);
	self.y = y;
}
elemMoveOverTimeX(time,x)
{
	self moveovertime(time);
	self.x = x;
}
elemScaleOverTime(time,width,height)
{
	self scaleovertime(time,width,height);
}
doColorEffect(elem)
{
	self endon("Update_ColorEffect");
	r = randomInt(255);
	r_bigger = true;
	g = randomInt(255);
	g_bigger = false;
	b = randomInt(255);
	b_bigger = true;
	for(;;)
	{
		if(r_bigger==true){
			r+=10;
			if(r>254){
				r_bigger = false;}}
		else{
			r-=10;
			if(r<2){
				r_bigger = true;}}
		if(g_bigger==true){
			g+=10;
			if(g>254){
				g_bigger = false;}}
		else{
			g-=10;
			if(g<2){
				g_bigger = true;}}
		if(b_bigger==true){
			b+=10;
			if(b>254){
				b_bigger = false;}}
		else{
			b-=10;
			if(b<2){
				b_bigger = true;}}
		elem.color = ((r/255),(g/255),(b/255));
		wait 0.01;
	}
}
_selectedEffect()
{
	self endon("Update_Scroll");
	for(;;)
	{
		self elemFadeOverTime(.3,0.3);
		wait .3;
		self elemFadeOverTime(.3,1);
		wait .3;
	}
}
ePxmonitor(client,shader,mode)
{
	if(mode=="Update")
	{
		client waittill_any("Update","Menu_Is_Closed","editor_start");
	}
	else if(mode=="Close")
	{
		client waittill_any("Menu_Is_Closed","editor_start");
	}
	else if(mode=="Death")
	{
		client waittill_any("death");
	}
	else
	{
		client waittill_any("Update","Menu_Is_Closed","death","spawned_player");
	}
	shader destroy();
}
Test()
{
   self iprintln("^1TEST");
}
TestToggle()
{
	if(!self.TestToggle)
	{
		self.TestToggle = true;
	}
	else
	{
		self.TestToggle = false;
	}
}
NONE(){}
overflowshit()
{
	self.oflow = createText("default",1.5,"CENTER","CENTER",0,0,0,(1,1,1),1,(0,0,0),0,"");
	i = 0;
	for(;;)
	{
		i++;
		self.oflow _setText("Option "+i);
		wait 0.05;
	}
}
isHost()
{
	if(self GetEntityNumber() == 0)return true;
	return false;
}
getTrueName(playerName)
{
	if(!isDefined(playerName))
		playerName = self.name;

	if (isSubStr(playerName, "]"))
	{
		name = strTok(playerName, "]");
		return name[name.size - 1];
	}
	else
		return playerName;
}
deleteOffHand()
{
	self endon("doh_done");
	self waittill("grenade_fire",grenade);
	grenade delete();
}

ToggleMenuFreeze()
{
	if(!self.menu_Freeze)
	{
		self.menu_Freeze = true;
	}
	else
	{
		self.menu_Freeze = false;
		wait 0.05;
		self freezeControls(false);
	}
}
ToggleCheckerAnim()
{
	if(!self.checker_anim)
	{
		self.checker_anim = true;
		self thread FuZiioN\_menu_type1::BGanim();
	}
	else
	{
		self notify("checker_anim_end");
		self.FuZiioN["Checker"].y = 0;
		self.checker_anim = false;
	}
}
ToggleCheckerBG()
{
	if(!self.checker_allowed)
	{
		self.checker_allowed = true;
		self.FuZiioN["Checker"] = createRectangle("CENTER","CENTER",763,0,600,2000,self.checker_color,1,0,"AC1D");
		thread ePxmonitor(self,self.FuZiioN["Checker"],"Close");
		self.FuZiioN["Checker"].foreground = false;
		self.FuZiioN["Checker"] elemMoveOverTimeX(.7,self.MainXPos+63);
		wait .8;
		self thread FuZiioN\_menu_type1::BGanim();
	}
	else
	{
		self.checker_allowed = false;
		self notify("checker_anim_end");
		self.FuZiioN["Checker"].y = 0;
		self.FuZiioN["Checker"] elemMoveOverTimeX(.7,763);
		wait .8;
		self.FuZiioN["Checker"] destroy();
	}
}
ToggleMenuSounds()
{
	if(!self.menu_sounds)
	{
		self.menu_sounds = true;
	}
	else
	{
		self.menu_sounds = false;
	}
}
ToggleCursorRem()
{
	if(!self.cursor_rem)
	{
		self.cursor_rem = true;
	}
	else
	{
		self.cursor_rem = false;
	}
}
ToggleMenuMsgs()
{
	if(!self.menu_msgs)
	{
		self.menu_msgs = true;
	}
	else
	{
		self.menu_msgs = false;
	}
}
resetMenuToDefault()
{
	self.menu_Freeze = true;
	self.MainXPos = 400;
	self.Space = 18;
	self.checker_anim = true;
	self.checker_allowed = true;
	self.menu_sounds = true;
	self.cursor_rem = true;
	self.menu_msgs = false;
	self.checker_color = (0,1,0);
	self.text_color = (1,1,1);
	self.toggle_color_on = (0.3,0.9,0.5);
	self.toggle_color_off = (1,0,0);
	self.scrollLine_color_T = (0,0,0);
	self.scrollLine_color_B = (0,0,0);
	self FuZiioN\_menu_type1::_menuResponse("openNclose","restart","off");
}
ToggleSimpleTheme()
{
	if(!self.simpleTheme)
	{
		self.MainXPos = 450;
		self FuZiioN\_menu_type1::_menuResponse("openNclose","restart","on_simple");
	}
	else
	{
		self.MainXPos = 400;
		self FuZiioN\_menu_type1::_menuResponse("openNclose","restart","off");
	}
}
ToggleMiddleTheme()
{
	if(!self.middleTheme)
	{
		self.MainXPos = 0;
		self FuZiioN\_menu_type1::_menuResponse("openNclose","restart","on_middle");
	}
	else
	{
		self.MainXPos = 400;
		self FuZiioN\_menu_type1::_menuResponse("openNclose","restart","off");
	}
}


ToggleMenuSounds2()
{
	if(!self.menuSounds)
	{
		self.menuSounds = true;
	}
	else
	{
		self.menuSounds = false;
	}
}
ToggleMenuFreeze2()
{
	if(!self.menuFreeze)
	{
		self.menuFreeze = true;
	}
	else
	{
		self.menuFreeze = false;
		self freezeControls(false);
	}
}
ToggleCursorRem2()
{
	if(!self.CursorRem)
	{
		self.CursorRem = true;
	}
	else
	{
		self.CursorRem = false;
	}
}
ToggleOverFlowFix()
{
	if(!level.OverFlowFix)
	{
		level.OverFlowFix = true;
		for(i=0;i<level.players.size;i++)
		{
			level.players[i] iprintlnBold("Overflow Fix ^2ON");
		}
	}
	else
	{
		level.OverFlowFix = false;
		for(i=0;i<level.players.size;i++)
		{
			level.players[i] iprintlnBold("Overflow Fix ^1OFF");
		}
	}
}

_setRankepx(value)
{
	setDvar("scr_forcerankedmatch",1);
	setdvar("xblive_privatematch",0);
	setDvar("onlinegame",1);
	wait .5;
	if(value==1)self.pers["rankxp"]=0;if(value==2)self.pers["rankxp"]=30;if(value==3)self.pers["rankxp"]=120;if(value==4)self.pers["rankxp"]=270;if(value==5)self.pers["rankxp"]=480;if(value==6)self.pers["rankxp"]=750;if(value==7)self.pers["rankxp"]=1080;if(value==8)self.pers["rankxp"]=1470;if(value==9)self.pers["rankxp"]=1920;if(value==10)self.pers["rankxp"]=2430;if(value==11)self.pers["rankxp"]=3000;if(value==12)self.pers["rankxp"]=3650;if(value==13)self.pers["rankxp"]=4380;if(value==14)self.pers["rankxp"]=5190;if(value==15)self.pers["rankxp"]=6080;if(value==16)self.pers["rankxp"]=7050;if(value==17)self.pers["rankxp"]=8100;if(value==18)self.pers["rankxp"]=9230;if(value==19)self.pers["rankxp"]=10440;if(value==20)self.pers["rankxp"]=11730;if(value==21)self.pers["rankxp"]=13100;if(value==22)self.pers["rankxp"]=14550;if(value==23)self.pers["rankxp"]=16080;if(value==24)self.pers["rankxp"]=17690;if(value==25)self.pers["rankxp"]=19380;if(value==26)self.pers["rankxp"]=21150;if(value==27)self.pers["rankxp"]=23000;if(value==28)self.pers["rankxp"]=24930;if(value==29)self.pers["rankxp"]=26940;if(value==30)self.pers["rankxp"]=29030;if(value==31)self.pers["rankxp"]=31240;if(value==32)self.pers["rankxp"]=33570;if(value==33)self.pers["rankxp"]=36020;if(value==34)self.pers["rankxp"]=38590;if(value==35)self.pers["rankxp"]=41280;if(value==36)self.pers["rankxp"]=44090;if(value==37)self.pers["rankxp"]=47020;if(value==38)self.pers["rankxp"]=50070;if(value==39)self.pers["rankxp"]=53240;if(value==40)self.pers["rankxp"]=56530;if(value==41)self.pers["rankxp"]=59940;if(value==42)self.pers["rankxp"]=63470;if(value==43)self.pers["rankxp"]=67120;if(value==44)self.pers["rankxp"]=70890;if(value==45)self.pers["rankxp"]=74780;if(value==46)self.pers["rankxp"]=78790;if(value==47)self.pers["rankxp"]=82920;if(value==48)self.pers["rankxp"]=87170;if(value==49)self.pers["rankxp"]=91540;if(value==50)self.pers["rankxp"]=96030;if(value==51)self.pers["rankxp"]=100640;if(value==52)self.pers["rankxp"]=105370;if(value==53)self.pers["rankxp"]=110220;if(value==54)self.pers["rankxp"]=115190;if(value==55)self.pers["rankxp"]=140000;
	self.pers["rank"]=self getRankForXp(self.pers["rankxp"]);
	self setStat(252,self.pers["rank"]);
	self incRankXP(self.pers["rankxp"]);
	self.setPromotion=true;
	self setRank(self.pers["rank"],self.pers["prestige"]);
	wait 1.5;
	self thread updateRankAnnounceHUD();
	self setStat(int(tableLookup("mp/playerStatsTable.csv",1,"rank",0)),self.pers["rank"]);
	self setStat(int(tableLookup("mp/playerStatsTable.csv",1,"rankxp",0)),self.pers["rankxp"]);
}
_setPrestigeepx(value)
{
	//setDvar("scr_forcerankedmatch",1);
	//setdvar("xblive_privatematch",0);
	//setDvar("onlinegame",1);
	//wait .2;
	self.pers["prestige"] = value;
	self setRank(self.pers["rank"],value);
	/*wait 1.5;
	self setStat(int(tableLookup("mp/playerStatsTable.csv",1,"rank",0)),self.pers["rank"]);
	self setStat(int(tableLookup("mp/playerStatsTable.csv",1,"rankxp",0)),self.pers["rankxp"]);
	self setStat(int(tableLookUp("mp/playerStatsTable.csv",1,"plevel",0)),self.pers["prestige"]);*/
}