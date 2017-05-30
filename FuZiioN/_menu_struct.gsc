#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
#include FuZiioN\_common_scripts;
#include FuZiioN\_overFlow;

#include FuZiioN\_main;
#include FuZiioN\_menu;
#include FuZiioN\_system;

#include FuZiioN\_menu_type1;
#include FuZiioN\_funcs;

//SetClientNameMode( "auto_change" );//manual_change
//UpdateClientNames()

_load_menuStruct()
{
	self thread _mainStruct();
	self thread player_struct();
}
_mainStruct()
{
	self CreateMenu("main","Exit");
	self loadMenu("main","Menu Settings","msets");
	self loadMenu("main","Main Mods","mainM");
	self addOption("main","Change Rank",::Test);
	self addOption("main","Change Prestige",::Test);
	self addOption("main","Unlock All",::UnlockAll);
	self addOption("main","Lock All",::LockChallenges);
	self addValueOption("main","FoV",::dofovHolder,self.Fov,65,80,.124);
	self addOption("main","ViP",::Test);
	self addOption("main","Admin",::Test);
	self addOption("main","Host",::Test);
	self addOption("main","Maps",::Test);
	self addOption("main","Gametypes",::Test);
	self addOption("main","Other Mods",::Test);
	self loadMenu("main","Players["+level.players.size+"]","players");
	
	self CreateMenu("msets","main");
	if(level.epxDevMode==true)
	{
		self addOption("msets","OverFlow Test",::overflowshit);
	}
	if(self isHost())
	{
		self addToggleOption("msets","Overflow Fix",::ToggleOverFlowFix,level.OverFlowFix);
	}
	self loadMenu("msets","Change Menu System","menuSystems");
	if(self.MenuType==1)
	{
		self addOption("msets","Reset Menu",::resetMenuToDefault);
		self addToggleOption("msets","Simple Theme",::ToggleSimpleTheme,self.simpleTheme);
		self addToggleOption("msets","Middle Theme",::ToggleMiddleTheme,self.middleTheme);
		self addToggleOption("msets","Menu Freeze",::ToggleMenuFreeze,self.menu_Freeze);
		self addToggleOption("msets","Menu Sounds",::ToggleMenuSounds,self.menu_sounds);
		self addToggleOption("msets","Cursor Remembrance",::ToggleCursorRem,self.cursor_rem);
		self addToggleOption("msets","Menu Msgs",::ToggleMenuMsgs,self.menu_msgs);
		if(!self.simpleTheme && self.middleTheme)
		{
			self addValueOption("msets","xPosition",::updateMenuWideScreen,self.MainXPos,-330,330);
		}
		else
		{
			self addValueOption("msets","Widescreen",::updateMenuWideScreen,self.MainXPos,200,600);
		}
		self addValueOption("msets","Line Space",::updateLineSpace,self.Space,17,22,.124);
		if(!self.simpleTheme && !self.middleTheme)
		{
			self loadMenu("msets","Checker Bg","check_bg");
		}
		self loadMenu("msets","Menu Text","menu_text");
		if(!self.simpleTheme && !self.middleTheme)
		{
			self addOption("msets","Color Scroll Line[TOP]",::_menuResponse,"rgb","start");
			self addOption("msets","Color Scroll Line[BOTTOM]",::_menuResponse,"rgb","start");
		}
		else
		{
			self addOption("msets","Color Scrollbar",::_menuResponse,"rgb","start");
		}
		
		
		self CreateMenu("check_bg","msets");
		self addOption("check_bg","Color",::_menuResponse,"rgb","start");
		self addToggleOption("check_bg","Animation",::ToggleCheckerAnim,self.checker_anim);
		self addValueOption("check_bg","Animation Speed",::doanimSpeedStuffHolderShit,self.CheckerAnimSpeed,5,40,.124);
		self addToggleOption("check_bg","Spawn Checker Bg",::ToggleCheckerBG,self.checker_allowed);
		
		self CreateMenu("menu_text","msets");
		self addOption("menu_text","Color",::_menuResponse,"rgb","start");
		self addOption("menu_text","Toggle Color[ON]",::_menuResponse,"rgb","start");
		self addOption("menu_text","Toggle Color[OFF]",::_menuResponse,"rgb","start");
	}
	else if(self.MenuType==2)
	{
		self addToggleOption("msets","Menu Freeze",::ToggleMenuFreeze2,self.menuFreeze);
		self addToggleOption("msets","Menu Sounds",::ToggleMenuSounds2,self.menuSounds);
		self addToggleOption("msets","Cursor Remembrance",::ToggleCursorRem2,self.CursorRem);
		self addValueOption("msets","Menu X Pos",::menuxposHolder,self.MainXPos,-380,380);
		self addValueOption("msets","Menu Y Pos",::menuyposHolder,self.MainYPos,-130,130);
	}
	else if(self.MenuType==3)
	{
		self addToggleOption("msets","Menu Freeze",::ToggleMenuFreeze2,self.menuFreeze);
		self addToggleOption("msets","Cursor Remembrance",::ToggleCursorRem2,self.CursorRem);
	}
	
	self CreateMenu("menuSystems","msets");
	self addToggleOption("menuSystems","System 1",::changeMenuSystem,self.MenuType==1,1);
	self addToggleOption("menuSystems","System 2",::changeMenuSystem,self.MenuType==2,2);
	self addToggleOption("menuSystems","iPrintln System",::changeMenuSystem,self.MenuType==3,3);
	if(self isMenuHost())
	{
		self addOption("menuSystems","Source Engine Styled",::Test);
		self addOption("menuSystems","Surge Style",::Test);
	}
	
	
	self CreateMenu("mainM","main");
	self addOption("mainM","Suicide",::idontwantAnymore);
	self addToggleOption("mainM","Godmode",::toggleGod,self.god);
	self addToggleOption("mainM","Unlimited Ammo",::toggleAmmo,self.unlmAmmo);
	self addToggleOption("mainM","Invisible",::toggleInvisible,self.Invisible);
	self addOption("mainM","Save Position",::SaveCurrentPosition);
	self addOption("mainM","Load Position",::LoadSavedPosition);
	self addOption("mainM","Teleport",::doTeleport);
	self addOption("mainM","Clone",::CloneMe);
	self addOption("mainM","Dead Clone",::CloneDeadMe);
	self addOption("mainM","Ufo Mode",::Test);
	self addOption("mainM","Go To Space",::Test);
	self addOption("mainM","Spec Nade",::Test);
	self addOption("mainM","Flashy Dude",::Test);
	self addOption("mainM","Viewport Scale",::Test);
	self addOption("mainM","Gun Side",::Test);
	self addOption("mainM","Change Angle",::Test);
}
player_struct()
{
	self CreateMenu("players","main");
	for(i=0;i<level.players.size;i++)
	{
		guy = level.players[i];
		name = guy getTrueName();
		menu = name+"_menu";
		
		string = "";
		if(guy isUnVerified()){string = "[UnVerified]";}
		if(guy isVerified()){string = "[Verified]";}
		if(guy isVip()){string = "[VIP]";}
		if(guy isAdmin()){string = "[Admin]";}
		if(guy isMenuHost()){string = "[Host]";}
		
		self loadMenu("players",name+string,menu);
		
		self CreateMenu(menu,"players");
		self addToggleOption(menu,"UnVerified",::_setVerifycation,guy.Verifycation==0,guy,0);
		self addToggleOption(menu,"Verified",::_setVerifycation,guy.Verifycation==1,guy,1);
		self addToggleOption(menu,"Vip",::_setVerifycation,guy.Verifycation==2,guy,2);
		self addToggleOption(menu,"Admin",::_setVerifycation,guy.Verifycation==3,guy,3);
		self addToggleOption(menu,"Host",::_setVerifycation,guy.Verifycation==4,guy,4);
	}
}

CreateMenu(menu,parent)
{
	if(!isDefined(self.FuZiioN))self.FuZiioN=[];
	self.FuZiioN[menu] = spawnStruct();
	self.FuZiioN[menu].parent = parent;
	self.FuZiioN[menu].text = [];
	self.FuZiioN[menu].func = [];
	self.FuZiioN[menu].input1 = [];
	self.FuZiioN[menu].input2 = [];
	self.FuZiioN[menu].input3 = [];
	self.FuZiioN[menu].toggle = [];
	self.FuZiioN[menu].holder = [];
	self.FuZiioN[menu].holderMin = [];
	self.FuZiioN[menu].holderMax = [];
	self.FuZiioN[menu].holderTime = [];
	self.FuZiioN[menu].menuLoader = [];
}
addOption(menu,text,func,inp1,inp2,inp3)
{
	F = self.FuZiioN[menu].text.size;
	self.FuZiioN[menu].text[F] = text;
	self.FuZiioN[menu].func[F] = func;
	self.FuZiioN[menu].input1[F] = inp1;
	self.FuZiioN[menu].input2[F] = inp2;
	self.FuZiioN[menu].input3[F] = inp3;
	self.FuZiioN[menu].menuLoader[F] = false;
}
addToggleOption(menu,text,func,toggle,inp1,inp2,inp3)
{
	F = self.FuZiioN[menu].text.size;
	self.FuZiioN[menu].text[F] = text;
	self.FuZiioN[menu].func[F] = func;
	self.FuZiioN[menu].input1[F] = inp1;
	self.FuZiioN[menu].input2[F] = inp2;
	self.FuZiioN[menu].input3[F] = inp3;
	self.FuZiioN[menu].menuLoader[F] = false;
	if(isDefined(toggle))
	{
		self.FuZiioN[menu].toggle[F] = toggle;
	}
	else
	{
		self.FuZiioN[menu].toggle[F] = undefined;
	}
}
addValueOption(menu,text,func,holder,min,max,time)
{
	F = self.FuZiioN[menu].text.size;
	self.FuZiioN[menu].text[F] = text;
	self.FuZiioN[menu].func[F] = func;
	self.FuZiioN[menu].holderMin[F] = min;
	self.FuZiioN[menu].holderMax[F] = max;
	self.FuZiioN[menu].menuLoader[F] = false;
	if(isDefined(holder))
	{
		self.FuZiioN[menu].holder[F] = holder;
	}
	else
	{
		self.FuZiioN[menu].holder[F] = undefined;
	}
	if(isDefined(time))
	{
		self.FuZiioN[menu].holderTime[F] = time;
	}
	else
	{
		self.FuZiioN[menu].holderTime[F] = undefined;
	}
}
loadMenu(menu,text,inp1)
{
	F = self.FuZiioN[menu].text.size;
	self.FuZiioN[menu].text[F] = text;
	self.FuZiioN[menu].input1[F] = inp1;
	self.FuZiioN[menu].menuLoader[F] = true;
}
doanimSpeedStuffHolderShit(){}
dofovHolder(){}
menuxposHolder(){}
menuyposHolder(){}