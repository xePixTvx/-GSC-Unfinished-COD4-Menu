#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
#include FuZiioN\_common_scripts;
#include FuZiioN\_overFlow;

#include FuZiioN\_main;
#include FuZiioN\_menu_struct;
#include FuZiioN\_system;

_setUpMenu()
{
	self.FuZiioN = [];
	self.Scroller = [];
	self.hasMenu = false;
	self.menuUseAllowed = true;
	
	if(self.MenuType==1)
	{
		self.simpleTheme = false;
		self.middleTheme = false;
		self.menu_Freeze = true;
		self.MainXPos = 400;
		self.Space = 18;
		self.checker_anim = true;
		self.checker_allowed = true;
		self.CheckerAnimSpeed = 30;
		self.menu_sounds = true;
		self.cursor_rem = true;
		self.menu_msgs = false;
		self.MainXPos_RGB = 0;
		self.MainYPos = 0;
		self.RGB_Select = 0;
		self.R_Scroll = 0;
		self.G_Scroll = 0;
		self.B_Scroll = 0;
		self.checker_color = (0,1,0);
		self.text_color = (1,1,1);
		self.toggle_color_on = (0.3,0.9,0.5);
		self.toggle_color_off = (1,0,0);
		self.scrollLine_color_T = (0,0,0);
		self.scrollLine_color_B = (0,0,0);
		self iprintln("^1Menu System 1 Loaded!");
	}
	else if(self.MenuType==2)
	{
		self.menuFreeze = true;
		self.menuSounds = true;
		self.MainXPos = 0;
		self.MainYPos = 0;
		self.CursorRem = true;
		self.Space = 18;
		self iprintln("^1Menu System 2 Loaded!");
	}
	else if(self.MenuType==3)
	{
		self.usePrintBold = true;
		self.menuFreeze = true;
		self.CursorRem = true;
		self.MenuMaxSize = 4;
		self.MenuMaxSizeHalf = 2;
		self.MenuMaxSizeHalfOne = 3;
		self iprintln("^1Menu System 3 Loaded!");
	}
	
	
	self _load_menuStruct();
	self freezeControls(false);
}


_giveMenu()
{
	if(!self.hasMenu)
	{
		self thread initMenu();
		self.hasMenu = true;
	}
}
_removeMenu()
{
	if(self.hasMenu==true)
	{
		if(self.FuZiioN["Menu"]["Open"])
		{
			if(self.MenuType==1)
			{
				self FuZiioN\_menu_type1::_menuResponse("openNclose","close");
			}
			else if(self.MenuType==2)
			{
				self FuZiioN\_menu_type2::_menuResponse("openNclose","close");
			}
			else if(self.MenuType==3)
			{
				self FuZiioN\_menu_type3::_menuResponse("openNclose","close");
			}
		}
		self notify("Remove_Menu");
		self.hasMenu = false;
	}
}
initMenu()
{
	self.FuZiioN["Menu"]["Open"] = false;
	self.FuZiioN["Menu"]["Locked"] = false;
	self.FuZiioN["Menu"]["Type"] = "menu";
	if(self.MenuType==1)
	{
		self.FuZiioN["Menu"]["Opening"] = false;
		self thread FuZiioN\_menu_type1::_menuOpenMonitor();
	}
	else if(self.MenuType==2)
	{
		self thread FuZiioN\_menu_type2::_menuOpenMonitor();
	}
	else if(self.MenuType==3)
	{
		self thread FuZiioN\_menu_type3::_menuOpenMonitor();
	}
}

changeMenuSystem(in)
{
	self _removeMenu();
	wait .2;
	self.MenuType = in;
	self _setUpMenu();
	self _giveMenu();
}


_valueChangeMonitor()
{
	if(self.MenuType==1)
	{
		if(self.FuZiioN[self.FuZiioN["CurrentMenu"]].func[self.Scroller[self.FuZiioN["CurrentMenu"]]]==FuZiioN\_menu_type1::updateMenuWideScreen)
		{
			self.MainXPos = self.FuZiioN[self.FuZiioN["CurrentMenu"]].holder[self.Scroller[self.FuZiioN["CurrentMenu"]]];
			self FuZiioN\_menu_type1::updateMenuWideScreen_fast();
		}
		if(self.FuZiioN[self.FuZiioN["CurrentMenu"]].func[self.Scroller[self.FuZiioN["CurrentMenu"]]]==FuZiioN\_menu_type1::updateLineSpace)
		{
			self.Space = self.FuZiioN[self.FuZiioN["CurrentMenu"]].holder[self.Scroller[self.FuZiioN["CurrentMenu"]]];
			self FuZiioN\_menu_type1::updateLineSpace();
		}
		if(self.FuZiioN[self.FuZiioN["CurrentMenu"]].func[self.Scroller[self.FuZiioN["CurrentMenu"]]]==::doanimSpeedStuffHolderShit)
		{
			self.CheckerAnimSpeed = self.FuZiioN[self.FuZiioN["CurrentMenu"]].holder[self.Scroller[self.FuZiioN["CurrentMenu"]]];
		}
	}
	else if(self.MenuType==2)
	{
		if(self.FuZiioN[self.FuZiioN["CurrentMenu"]].func[self.Scroller[self.FuZiioN["CurrentMenu"]]]==::menuxposHolder)
		{
			self.MainXPos = self.FuZiioN[self.FuZiioN["CurrentMenu"]].holder[self.Scroller[self.FuZiioN["CurrentMenu"]]];
			self FuZiioN\_menu_type2::_menuResponse("updateMenuPos");
		}
		if(self.FuZiioN[self.FuZiioN["CurrentMenu"]].func[self.Scroller[self.FuZiioN["CurrentMenu"]]]==::menuyposHolder)
		{
			self.MainYPos = self.FuZiioN[self.FuZiioN["CurrentMenu"]].holder[self.Scroller[self.FuZiioN["CurrentMenu"]]];
			self FuZiioN\_menu_type2::_menuResponse("updateMenuPos");
		}
	}
	else if(self.MenuType==3)
	{
	}
	
	
	if(self.FuZiioN[self.FuZiioN["CurrentMenu"]].func[self.Scroller[self.FuZiioN["CurrentMenu"]]]==::dofovHolder)
	{
		self.Fov = self.FuZiioN[self.FuZiioN["CurrentMenu"]].holder[self.Scroller[self.FuZiioN["CurrentMenu"]]];
		self setClientDvar("cg_fov",self.Fov);
	}
	
}