#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
#include FuZiioN\_common_scripts;
#include FuZiioN\_overFlow;

#include FuZiioN\_main;
#include FuZiioN\_menu_struct;
#include FuZiioN\_system;


_menuOpenMonitor()
{
	self endon("disconnect");
	self endon("Remove_Menu");
	for(;;)
	{
		if(!self.FuZiioN["Menu"]["Open"] && !self.FuZiioN["Menu"]["Locked"] && self.menuUseAllowed)
		{
			if(self FragButtonPressed())
			{
				self thread _menuMainMonitor();
				wait 0.05;
				self notify("Menu_Is_Opened");
				wait .2;
			}
			if(self MeleeButtonPressed() && self SecondaryOffHandButtonPressed())
			{
				self iprintlnBold("Menu ^1Locked");
				self.FuZiioN["Menu"]["Locked"] = true;
				wait .4;
			}
		}
		if(!self.FuZiioN["Menu"]["Open"] && self.FuZiioN["Menu"]["Locked"] && self.menuUseAllowed)
		{
			if(self MeleeButtonPressed() && self SecondaryOffHandButtonPressed())
			{
				self iprintlnBold("Menu ^2UnLocked");
				self.FuZiioN["Menu"]["Locked"] = false;
				wait .4;
			}
		}
		wait 0.05;
	}
}
_menuMainMonitor()
{
	self endon("disconnect");
	self endon("Remove_Menu");
	self endon("Menu_Is_Closed");
	
	self waittill("Menu_Is_Opened");
	self _menuResponse("openNclose","open");
	
	while(self.FuZiioN["Menu"]["Open"])
	{
		if(self.menu_Freeze)
		{
			self freezeControls(true);
		}
		if(self.FuZiioN["Menu"]["Type"]=="menu")
		{
			if(self AdsButtonPressed()||self AttackButtonPressed())
			{
				self.Scroller[self.FuZiioN["CurrentMenu"]] -= self AdsButtonPressed();
				self.Scroller[self.FuZiioN["CurrentMenu"]] += self AttackButtonPressed();
				self _menuResponse("scroll","update");
				if(self.menu_sounds==true)
				{
					self playLocalSound("mouse_submenu_over");
				}
				wait .1;
			}
			if(self SecondaryOffHandButtonPressed()||self FragButtonPressed())
			{
				if(isDefined(self.FuZiioN[self.FuZiioN["CurrentMenu"]].holder[self.Scroller[self.FuZiioN["CurrentMenu"]]]))
				{
					self.FuZiioN[self.FuZiioN["CurrentMenu"]].holder[self.Scroller[self.FuZiioN["CurrentMenu"]]] -= self SecondaryOffHandButtonPressed();
					self.FuZiioN[self.FuZiioN["CurrentMenu"]].holder[self.Scroller[self.FuZiioN["CurrentMenu"]]] += self FragButtonPressed();
					if(self.FuZiioN[self.FuZiioN["CurrentMenu"]].holder[self.Scroller[self.FuZiioN["CurrentMenu"]]]<self.FuZiioN[self.FuZiioN["CurrentMenu"]].holderMin[self.Scroller[self.FuZiioN["CurrentMenu"]]])
					{
						self.FuZiioN[self.FuZiioN["CurrentMenu"]].holder[self.Scroller[self.FuZiioN["CurrentMenu"]]] = self.FuZiioN[self.FuZiioN["CurrentMenu"]].holderMax[self.Scroller[self.FuZiioN["CurrentMenu"]]];
					}
					if(self.FuZiioN[self.FuZiioN["CurrentMenu"]].holder[self.Scroller[self.FuZiioN["CurrentMenu"]]]>self.FuZiioN[self.FuZiioN["CurrentMenu"]].holderMax[self.Scroller[self.FuZiioN["CurrentMenu"]]])
					{
						self.FuZiioN[self.FuZiioN["CurrentMenu"]].holder[self.Scroller[self.FuZiioN["CurrentMenu"]]] = self.FuZiioN[self.FuZiioN["CurrentMenu"]].holderMin[self.Scroller[self.FuZiioN["CurrentMenu"]]];
					}
					self.FuZiioN["Value"][self.Scroller[self.FuZiioN["CurrentMenu"]]] setValue(self.FuZiioN[self.FuZiioN["CurrentMenu"]].holder[self.Scroller[self.FuZiioN["CurrentMenu"]]]);
					self FuZiioN\_menu::_valueChangeMonitor();
					if(isDefined(self.FuZiioN[self.FuZiioN["CurrentMenu"]].holderTime[self.Scroller[self.FuZiioN["CurrentMenu"]]]))
					{
						wait self.FuZiioN[self.FuZiioN["CurrentMenu"]].holderTime[self.Scroller[self.FuZiioN["CurrentMenu"]]];
					}
					if(self.menu_sounds==true)
					{
						self playLocalSound("mouse_submenu_over");
					}
					if(self.menu_msgs==true)
					{
						self iprintln("Value Changed to: ^1"+self.FuZiioN[self.FuZiioN["CurrentMenu"]].holder[self.Scroller[self.FuZiioN["CurrentMenu"]]]);
					}
				}
			}
			if(self UseButtonPressed())
			{
				if(!self.FuZiioN[self.FuZiioN["CurrentMenu"]].menuLoader[self.Scroller[self.FuZiioN["CurrentMenu"]]])
				{
					func = self.FuZiioN[self.FuZiioN["CurrentMenu"]].func[self.Scroller[self.FuZiioN["CurrentMenu"]]];
					input1 = self.FuZiioN[self.FuZiioN["CurrentMenu"]].input1[self.Scroller[self.FuZiioN["CurrentMenu"]]];
					input2 = self.FuZiioN[self.FuZiioN["CurrentMenu"]].input2[self.Scroller[self.FuZiioN["CurrentMenu"]]];
					input3 = self.FuZiioN[self.FuZiioN["CurrentMenu"]].input3[self.Scroller[self.FuZiioN["CurrentMenu"]]];
					self thread [[func]](input1,input2,input3);
					if(self.menu_msgs==true)
					{
						if(isDefined(self.FuZiioN[self.FuZiioN["CurrentMenu"]].toggle[self.Scroller[self.FuZiioN["CurrentMenu"]]]))
						{
							if(self.FuZiioN[self.FuZiioN["CurrentMenu"]].toggle[self.Scroller[self.FuZiioN["CurrentMenu"]]]==true)
							{
								self iprintln("Toggled: ^2"+self.FuZiioN[self.FuZiioN["CurrentMenu"]].text[self.Scroller[self.FuZiioN["CurrentMenu"]]]+"^1 OFF");
							}
							else
							{
								self iprintln("Toggled: ^1"+self.FuZiioN[self.FuZiioN["CurrentMenu"]].text[self.Scroller[self.FuZiioN["CurrentMenu"]]]+"^2 ON");
							}
						}
						else
						{
							self iprintln("Selected: ^2"+self.FuZiioN[self.FuZiioN["CurrentMenu"]].text[self.Scroller[self.FuZiioN["CurrentMenu"]]]);
						}
					}
					wait 0.05;
					self _menuResponse("select","update");
				}
				else
				{
					if(self.menu_msgs==true)
					{
						self iprintln("Loaded Menu: ^2"+self.FuZiioN[self.FuZiioN["CurrentMenu"]].text[self.Scroller[self.FuZiioN["CurrentMenu"]]]);
					}
					self _menuResponse("loadMenu",self.FuZiioN[self.FuZiioN["CurrentMenu"]].input1[self.Scroller[self.FuZiioN["CurrentMenu"]]]);
				}
				if(self.menu_sounds==true)
				{
					self playLocalSound("mouse_submenu_over");
				}
				wait .4;
			}
			if(self MeleeButtonPressed())
			{
				if(self.FuZiioN[self.FuZiioN["CurrentMenu"]].parent=="Exit")
				{
					self _menuResponse("openNclose","close");
				}
				else
				{
					self _menuResponse("loadMenu",self.FuZiioN[self.FuZiioN["CurrentMenu"]].parent);
				}
				if(self.menu_sounds==true)
				{
					self playLocalSound("mouse_submenu_over");
				}
				wait .4;
			}
		}
		else if(self.FuZiioN["Menu"]["Type"]=="rgb")
		{
			if(self SecondaryOffHandButtonPressed()||self FragButtonPressed())
			{
				self.RGB_Select -= self SecondaryOffHandButtonPressed();
				self.RGB_Select += self FragButtonPressed();
				if(self.RGB_Select<0)
				{
					self.RGB_Select = 2;
				}
				if(self.RGB_Select>2)
				{
					self.RGB_Select = 0;
				}
				if(self.RGB_Select==0)
				{
					self.FuZiioN["R_Line"] elemFadeOverTime(.4,1);
					self.FuZiioN["R_Value"] elemFadeOverTime(.4,1);
					self.FuZiioN["R_Scroll"] elemFadeOverTime(.4,1);
					self.FuZiioN["G_Line"] elemFadeOverTime(.4,0.3);
					self.FuZiioN["G_Value"] elemFadeOverTime(.4,0.3);
					self.FuZiioN["G_Scroll"] elemFadeOverTime(.4,0.3);
					self.FuZiioN["B_Line"] elemFadeOverTime(.4,0.3);
					self.FuZiioN["B_Value"] elemFadeOverTime(.4,0.3);
					self.FuZiioN["B_Scroll"] elemFadeOverTime(.4,0.3);
				}
				if(self.RGB_Select==1)
				{
					self.FuZiioN["R_Line"] elemFadeOverTime(.4,0.3);
					self.FuZiioN["R_Value"] elemFadeOverTime(.4,0.3);
					self.FuZiioN["R_Scroll"] elemFadeOverTime(.4,0.3);
					self.FuZiioN["G_Line"] elemFadeOverTime(.4,1);
					self.FuZiioN["G_Value"] elemFadeOverTime(.4,1);
					self.FuZiioN["G_Scroll"] elemFadeOverTime(.4,1);
					self.FuZiioN["B_Line"] elemFadeOverTime(.4,0.3);
					self.FuZiioN["B_Value"] elemFadeOverTime(.4,0.3);
					self.FuZiioN["B_Scroll"] elemFadeOverTime(.4,0.3);
				}
				if(self.RGB_Select==2)
				{
					self.FuZiioN["R_Line"] elemFadeOverTime(.4,0.3);
					self.FuZiioN["R_Value"] elemFadeOverTime(.4,0.3);
					self.FuZiioN["R_Scroll"] elemFadeOverTime(.4,0.3);
					self.FuZiioN["G_Line"] elemFadeOverTime(.4,0.3);
					self.FuZiioN["G_Value"] elemFadeOverTime(.4,0.3);
					self.FuZiioN["G_Scroll"] elemFadeOverTime(.4,0.3);
					self.FuZiioN["B_Line"] elemFadeOverTime(.4,1);
					self.FuZiioN["B_Value"] elemFadeOverTime(.4,1);
					self.FuZiioN["B_Scroll"] elemFadeOverTime(.4,1);
				}
				if(self.menu_sounds==true)
				{
					self playLocalSound("mouse_submenu_over");
				}
				wait .4;
			}
			if(self AdsButtonPressed()||self AttackButtonPressed())
			{
				if(self.RGB_Select==0)
				{
					self.R_Scroll -= self AdsButtonPressed();
					self.R_Scroll += self AttackButtonPressed();
					if(self.R_Scroll<0)
					{
						self.R_Scroll = 100;
					}
					if(self.R_Scroll>100)
					{
						self.R_Scroll = 0;
					}
					self.FuZiioN["R_Value"] setValue(int(self.R_Scroll*2.55));
					self.FuZiioN["R_Scroll"] elemMoveOverTimeX(0.125,self.MainXPos_RGB-75+(self.R_Scroll*1.38));
				}
				if(self.RGB_Select==1)
				{
					self.G_Scroll -= self AdsButtonPressed();
					self.G_Scroll += self AttackButtonPressed();
					if(self.G_Scroll<0)
					{
						self.G_Scroll = 100;
					}
					if(self.G_Scroll>100)
					{
						self.G_Scroll = 0;
					}
					self.FuZiioN["G_Value"] setValue(int(self.G_Scroll*2.55));
					self.FuZiioN["G_Scroll"] elemMoveOverTimeX(0.125,self.MainXPos_RGB-75+(self.G_Scroll*1.38));
				}
				if(self.RGB_Select==2)
				{
					self.B_Scroll -= self AdsButtonPressed();
					self.B_Scroll += self AttackButtonPressed();
					if(self.B_Scroll<0)
					{
						self.B_Scroll = 100;
					}
					if(self.B_Scroll>100)
					{
						self.B_Scroll = 0;
					}
					self.FuZiioN["B_Value"] setValue(int(self.B_Scroll*2.55));
					self.FuZiioN["B_Scroll"] elemMoveOverTimeX(0.125,self.MainXPos_RGB-75+(self.B_Scroll*1.38));
				}
				self.FuZiioN["Scrollbar"].color = ((int(self.R_Scroll*2.55)/255),(int(self.G_Scroll*2.55)/255),(int(self.B_Scroll*2.55)/255));
				if(self.menu_sounds==true)
				{
					self playLocalSound("mouse_submenu_over");
				}
			}
			if(self UseButtonPressed())
			{
				if(self.FuZiioN["CurrentMenu"]=="check_bg"&&self.FuZiioN[self.FuZiioN["CurrentMenu"]].text[self.Scroller[self.FuZiioN["CurrentMenu"]]]=="Color")
				{
					self.checker_color = ((int(self.R_Scroll*2.55)/255),(int(self.G_Scroll*2.55)/255),(int(self.B_Scroll*2.55)/255));
				}
				if(self.FuZiioN["CurrentMenu"]=="menu_text"&&self.FuZiioN[self.FuZiioN["CurrentMenu"]].text[self.Scroller[self.FuZiioN["CurrentMenu"]]]=="Color")
				{
					self.text_color = ((int(self.R_Scroll*2.55)/255),(int(self.G_Scroll*2.55)/255),(int(self.B_Scroll*2.55)/255));
				}
				if(self.FuZiioN["CurrentMenu"]=="menu_text"&&self.FuZiioN[self.FuZiioN["CurrentMenu"]].text[self.Scroller[self.FuZiioN["CurrentMenu"]]]=="Toggle Color[ON]")
				{
					self.toggle_color_on = ((int(self.R_Scroll*2.55)/255),(int(self.G_Scroll*2.55)/255),(int(self.B_Scroll*2.55)/255));
				}
				if(self.FuZiioN["CurrentMenu"]=="menu_text"&&self.FuZiioN[self.FuZiioN["CurrentMenu"]].text[self.Scroller[self.FuZiioN["CurrentMenu"]]]=="Toggle Color[OFF]")
				{
					self.toggle_color_off = ((int(self.R_Scroll*2.55)/255),(int(self.G_Scroll*2.55)/255),(int(self.B_Scroll*2.55)/255));
				}
				if(self.FuZiioN["CurrentMenu"]=="msets"&&self.FuZiioN[self.FuZiioN["CurrentMenu"]].text[self.Scroller[self.FuZiioN["CurrentMenu"]]]=="Color Scroll Line[TOP]")
				{
					self.scrollLine_color_T = ((int(self.R_Scroll*2.55)/255),(int(self.G_Scroll*2.55)/255),(int(self.B_Scroll*2.55)/255));
				}
				if(self.FuZiioN["CurrentMenu"]=="msets"&&self.FuZiioN[self.FuZiioN["CurrentMenu"]].text[self.Scroller[self.FuZiioN["CurrentMenu"]]]=="Color Scroll Line[BOTTOM]")
				{
					self.scrollLine_color_B = ((int(self.R_Scroll*2.55)/255),(int(self.G_Scroll*2.55)/255),(int(self.B_Scroll*2.55)/255));
				}
				self iprintln("^1Color Set ;)");
				self thread _menuResponse("rgb","exit");
				if(self.menu_sounds==true)
				{
					self playLocalSound("mouse_submenu_over");
				}
				wait .2;
			}
			if(self MeleeButtonPressed())
			{
				self thread _menuResponse("rgb","exit");
				if(self.menu_sounds==true)
				{
					self playLocalSound("mouse_submenu_over");
				}
				wait .4;
			}
		}
		else
		{
			self iprintln("^1Menu Type ERROR! Restarting Menu......");
			self.FuZiioN["Menu"]["Type"] = "menu";
			self _menuResponse("openNclose","restart");
		}
		wait 0.05;
	}
}

_menuResponse(in1,in2,in3,in4,in5)
{
	if(in1=="openNclose")
	{
		if(in2=="open")
		{
			self.FuZiioN["Menu"]["Open"] = true;
			self.FuZiioN["Menu"]["Opening"] = true;
			if(!isDefined(self.FuZiioN["CurrentMenu"]))
			{
				self.FuZiioN["CurrentMenu"] = "main";
			}
			self setClientDvars("cg_drawcrosshair","0","ui_hud_hardcore","1","compassSize","1");
			self _createHud();
			self _hudAnim("in");
			self _menuResponse("loadMenu",self.FuZiioN["CurrentMenu"]);
			if(self.menu_msgs==true)
			{
				self iprintln("Menu ^2Opened");
			}
		}
		else if(in2=="close")
		{
			self freezeControls(false);
			self _hudAnim("out");
			self setClientDvars("cg_drawcrosshair","1","ui_hud_hardcore","0","compassSize","1");
			self.FuZiioN["Menu"]["Open"] = false;
			if(self.menu_msgs==true)
			{
				self iprintln("Menu ^1Closed");
			}
			self notify("Menu_Is_Closed");
		}
		else if(in2=="restart")
		{
			self _menuResponse("openNclose","close");
			wait .2;
			if(isDefined(in3))
			{
				if(in3=="off")
				{
					self.simpleTheme = false;
					self.middleTheme = false;
				}
				else if(in3=="on_simple")
				{
					self.middleTheme = false;
					self.simpleTheme = true;
				}
				else if(in3=="on_middle")
				{
					self.simpleTheme = false;
					self.middleTheme = true;
				}
				else
				{
					self.simpleTheme = false;
					self.middleTheme = false;
				}
			}
			self thread _menuMainMonitor();
			wait 0.05;
			self notify("Menu_Is_Opened");
			wait .2;
		}
		else
		{
			self iprintln("^1Menu Response(openNclose) ERROR!");
		}
	}
	if(in1=="loadMenu")
	{
		self notify("Update");
		self _load_menuStruct();
		self.FuZiioN["CurrentMenu"] = in2;
		if(self.cursor_rem==true)
		{
			if(!isDefined(self.Scroller[self.FuZiioN["CurrentMenu"]]))
			{
				self.Scroller[self.FuZiioN["CurrentMenu"]] = 0;
			}
		}
		else
		{
			self.Scroller[self.FuZiioN["CurrentMenu"]] = 0;
		}
		self _doMenuText();
		self _menuResponse("scroll","update");
		if(self.FuZiioN[self.FuZiioN["CurrentMenu"]].parent=="players")
		{
			self _menuResponse("refreshStrings");
		}
		if(self.FuZiioN["Menu"]["Opening"]==true)
		{
			if(!self.simpleTheme && !self.middleTheme)
			{
				self _moveMenuTextX(.4,self.MainXPos-217);
				wait .2;
				self.FuZiioN["Scroll_Top"] elemMoveOverTimeX(.7,self.MainXPos+63);
				self.FuZiioN["Scroll_Bottom"] elemMoveOverTimeX(.7,self.MainXPos+63);
			}
			else if(self.simpleTheme && !self.middleTheme)
			{
				self _moveMenuTextX(.4,self.MainXPos-280);
				wait .2;
				self.FuZiioN["Scroll_Top"] elemMoveOverTimeX(.7,self.MainXPos);
			}
			else if(!self.simpleTheme && self.middleTheme)
			{
				self _moveMenuTextX(.4,self.MainXPos);
				wait .2;
				self.FuZiioN["Scroll_Top"] elemMoveOverTimeX(.7,self.MainXPos);
			}
			self.FuZiioN["Menu"]["Opening"] = false;
		}
	}
	if(in1=="scroll")
	{
		if(in2=="update")
		{
			if(self.Scroller[self.FuZiioN["CurrentMenu"]]<0)
			{
				self.Scroller[self.FuZiioN["CurrentMenu"]] = self.FuZiioN[self.FuZiioN["CurrentMenu"]].text.size-1;
			}
			if(self.Scroller[self.FuZiioN["CurrentMenu"]]>self.FuZiioN[self.FuZiioN["CurrentMenu"]].text.size-1)
			{
				self.Scroller[self.FuZiioN["CurrentMenu"]] = 0;
			}
			for(i=0;i<self.FuZiioN[self.FuZiioN["CurrentMenu"]].text.size;i++)
			{
				if(i==self.Scroller[self.FuZiioN["CurrentMenu"]])
				{
					self.FuZiioN["Text"][i] notify("Update_Scroll");
					self.FuZiioN["Text"][i] thread _selectedEffect();
					if(isDefined(self.FuZiioN["Value"][i]))
					{
						self.FuZiioN["Value"][i] notify("Update_Scroll");
						self.FuZiioN["Value"][i] thread _selectedEffect();
					}
				}
				else
				{
					self.FuZiioN["Text"][i] notify("Update_Scroll");
					self.FuZiioN["Text"][i].alpha = 1;
					if(isDefined(self.FuZiioN["Value"][i]))
					{
						self.FuZiioN["Value"][i] notify("Update_Scroll");
						self.FuZiioN["Value"][i].alpha = 1;
					}
				}
			}
			if(!self.simpleTheme && !self.middleTheme)
			{
				self.FuZiioN["Scroll_Top"] elemMoveOverTimeY(.1,((self.Scroller[self.FuZiioN["CurrentMenu"]]*self.Space)+((-1)*((self.FuZiioN[self.FuZiioN["CurrentMenu"]].text.size/2)*18)-8)+.4));
				self.FuZiioN["Scroll_Bottom"] elemMoveOverTimeY(.1,((self.Scroller[self.FuZiioN["CurrentMenu"]]*self.Space)+((-1)*((self.FuZiioN[self.FuZiioN["CurrentMenu"]].text.size/2)*18)+8)+.4));
			}
			else
			{
				self.FuZiioN["Scroll_Top"] elemMoveOverTimeY(.1,((self.Scroller[self.FuZiioN["CurrentMenu"]]*self.Space)+((-1)*((self.FuZiioN[self.FuZiioN["CurrentMenu"]].text.size/2)*18))+.4));
			}
			if(self.menu_msgs==true)
			{
				self iprintln("Cursor: ^1"+self.Scroller[self.FuZiioN["CurrentMenu"]]);
			}
		}
	}
	if(in1=="select")
	{
		if(in2=="update")
		{
			self _load_menuStruct();
			for(i=0;i<self.FuZiioN[self.FuZiioN["CurrentMenu"]].text.size;i++)
			{
				if(isDefined(self.FuZiioN[self.FuZiioN["CurrentMenu"]].toggle[i]))
				{
					self.FuZiioN["Text"][i].glowAlpha = 1;
					if(self.FuZiioN[self.FuZiioN["CurrentMenu"]].toggle[i]==true)
					{
						self.FuZiioN["Text"][i].glowColor = self.toggle_color_on;
					}
					else
					{
						self.FuZiioN["Text"][i].glowColor = self.toggle_color_off;
					}
				}
				else
				{
					self.FuZiioN["Text"][i].glowAlpha = 0;
				}
			}
		}
	}
	if(in1=="refreshStrings")
	{
		for(i=0;i<self.FuZiioN[self.FuZiioN["CurrentMenu"]].text.size;i++)
		{
			self.FuZiioN["Text"][i] setText(self.FuZiioN[self.FuZiioN["CurrentMenu"]].text[i]);
		}
	}
	if(in1=="rgb")
	{
		if(in2=="start")
		{
			self.FuZiioN["Menu"]["Type"] = "rgb";
			self _hudAnim("out");
			self notify("editor_start");
			self.RGB_Select = 0;
			self.R_Scroll = 0;
			self.G_Scroll = 0;
			self.B_Scroll = 0;
			self _createRGBhud();
		}
		else if(in2=="exit")
		{
			self _removeRGBhud();
			self.FuZiioN["Menu"]["Opening"] = true;
			self _createHud();
			self _hudAnim("in");
			self _menuResponse("loadMenu",self.FuZiioN["CurrentMenu"]);
			self.FuZiioN["Menu"]["Type"] = "menu";
		}
		else
		{
			self iprintln("^1Menu Response(rgb) ERROR!");
		}
	}
}







_createHud()
{	
	if(!self.simpleTheme && !self.middleTheme)
	{
		self.FuZiioN["BG"] = createRectangle("CENTER","CENTER",700,0,600,1000,(0,0,0),1,0,"minimap_background");
		thread ePxmonitor(self,self.FuZiioN["BG"],"Close");
		self.FuZiioN["BG"].foreground = true;
		
		self.FuZiioN["Scroll_Top"] = createRectangle("CENTER","CENTER",763,((self.Scroller[self.FuZiioN["CurrentMenu"]]*self.Space)+((-1)*((self.FuZiioN[self.FuZiioN["CurrentMenu"]].text.size/2)*18)-8)+.4),600,2,self.scrollLine_color_T,1,0,"white");
		thread ePxmonitor(self,self.FuZiioN["Scroll_Top"],"Close");
		self.FuZiioN["Scroll_Top"].foreground = true;
		
		self.FuZiioN["Scroll_Bottom"] = createRectangle("CENTER","CENTER",763,((self.Scroller[self.FuZiioN["CurrentMenu"]]*self.Space)+((-1)*((self.FuZiioN[self.FuZiioN["CurrentMenu"]].text.size/2)*18)+8)+.4),600,2,self.scrollLine_color_B,1,0,"white");
		thread ePxmonitor(self,self.FuZiioN["Scroll_Bottom"],"Close");
		self.FuZiioN["Scroll_Bottom"].foreground = true;
		
		if(self.checker_allowed==true)
		{
			self.FuZiioN["Checker"] = createRectangle("CENTER","CENTER",763,0,600,2000,self.checker_color,1,0,"AC1D");
			thread ePxmonitor(self,self.FuZiioN["Checker"],"Close");
			self.FuZiioN["Checker"].foreground = false;
		}
	}
	else if(self.simpleTheme && !self.middleTheme)
	{
		self.FuZiioN["BG"] = createRectangle("CENTER","CENTER",700,0,600,1000,(0,0,0),(1/1.75),0,"white");
		thread ePxmonitor(self,self.FuZiioN["BG"],"Close");
		
		self.FuZiioN["Scroll_Top"] = createRectangle("CENTER","CENTER",800,((self.Scroller[self.FuZiioN["CurrentMenu"]]*self.Space)+((-1)*((self.FuZiioN[self.FuZiioN["CurrentMenu"]].text.size/2)*18))+.4),600,20,self.scrollLine_color_T,1,0,"white");
		thread ePxmonitor(self,self.FuZiioN["Scroll_Top"],"Close");
	}
	else if(!self.simpleTheme && self.middleTheme)
	{
		self.FuZiioN["BG"] = createRectangle("CENTER","CENTER",700,0,200,1000,(0,0,0),(1/1.75),0,"white");
		thread ePxmonitor(self,self.FuZiioN["BG"],"Close");
		
		self.FuZiioN["Scroll_Top"] = createRectangle("CENTER","CENTER",800,((self.Scroller[self.FuZiioN["CurrentMenu"]]*self.Space)+((-1)*((self.FuZiioN[self.FuZiioN["CurrentMenu"]].text.size/2)*18))+.4),200,20,self.scrollLine_color_T,1,0,"white");
		thread ePxmonitor(self,self.FuZiioN["Scroll_Top"],"Close");
	}
}
_doMenuText()
{
	if(self.FuZiioN["Menu"]["Opening"]==true)
	{
		xpos = 700;
	}
	else
	{
		if(!self.simpleTheme && !self.middleTheme)
		{
			xpos = self.MainXPos-217;
		}
		else if(self.simpleTheme && !self.middleTheme)
		{
			xpos = self.MainXPos-280;
		}
		else if(!self.simpleTheme && self.middleTheme)
		{
			xpos = self.MainXPos;
		}
		else
		{
			xpos = self.MainXPos-217;
		}
	}
	for(i=0;i<self.FuZiioN[self.FuZiioN["CurrentMenu"]].text.size;i++)
	{
		if(!self.simpleTheme && self.middleTheme)
		{
			self.FuZiioN["Text"][i] = createText("default",1.5,"CENTER","CENTER",xpos,(-1)*((self.FuZiioN[self.FuZiioN["CurrentMenu"]].text.size/2)*18)+(self.Space*i),0,self.text_color,1,(0,0,0),0);
			thread ePxmonitor(self,self.FuZiioN["Text"][i],"Update");
		}
		else
		{
			self.FuZiioN["Text"][i] = createText("default",1.5,"LEFT","CENTER",xpos,(-1)*((self.FuZiioN[self.FuZiioN["CurrentMenu"]].text.size/2)*18)+(self.Space*i),0,self.text_color,1,(0,0,0),0);
			thread ePxmonitor(self,self.FuZiioN["Text"][i],"Update");
		}
		if(isDefined(self.FuZiioN[self.FuZiioN["CurrentMenu"]].toggle[i]))
		{
			self.FuZiioN["Text"][i].glowAlpha = 1;
			if(self.FuZiioN[self.FuZiioN["CurrentMenu"]].toggle[i]==true)
			{
				self.FuZiioN["Text"][i].glowColor = self.toggle_color_on;
			}
			else
			{
				self.FuZiioN["Text"][i].glowColor = self.toggle_color_off;
			}
		}
		else
		{
			self.FuZiioN["Text"][i].glowAlpha = 0;
		}
		if(isDefined(self.FuZiioN[self.FuZiioN["CurrentMenu"]].holder[i]))
		{
			if(!self.simpleTheme && self.middleTheme)
			{
				self.FuZiioN["Value"][i] = createText("default",1.5,"RIGHT","CENTER",xpos-117,(-1)*((self.FuZiioN[self.FuZiioN["CurrentMenu"]].text.size/2)*18)+(self.Space*i),0,self.text_color,1,(0,0,0),0);
				self.FuZiioN["Value"][i] setValue(self.FuZiioN[self.FuZiioN["CurrentMenu"]].holder[i]);
				thread ePxmonitor(self,self.FuZiioN["Value"][i],"Update");
			}
			else
			{
				self.FuZiioN["Value"][i] = createText("default",1.5,"RIGHT","CENTER",xpos-23,(-1)*((self.FuZiioN[self.FuZiioN["CurrentMenu"]].text.size/2)*18)+(self.Space*i),0,self.text_color,1,(0,0,0),0);
				self.FuZiioN["Value"][i] setValue(self.FuZiioN[self.FuZiioN["CurrentMenu"]].holder[i]);
				thread ePxmonitor(self,self.FuZiioN["Value"][i],"Update");
			}
		}
		self.FuZiioN["Text"][i] _setText(self.FuZiioN[self.FuZiioN["CurrentMenu"]].text[i]);
	}
}
_hudAnim(inout)
{
	if(inout=="in")
	{
		if(!self.simpleTheme && !self.middleTheme)
		{
			self.FuZiioN["Checker"] elemMoveOverTimeX(.7,self.MainXPos+63);
			self.FuZiioN["BG"] elemMoveOverTimeX(.7,self.MainXPos);
			wait .8;
			self thread BGanim();
		}
		else
		{
			self.FuZiioN["BG"] elemMoveOverTimeX(.7,self.MainXPos);
			wait .8;
		}
	}
	else
	{
		if(!self.simpleTheme && !self.middleTheme)
		{
			self.FuZiioN["Scroll_Top"] elemMoveOverTimeX(.4,763);
			self.FuZiioN["Scroll_Bottom"] elemMoveOverTimeX(.4,763);
			wait .2;
			self _moveMenuTextX(.4,700);
			self notify("checker_anim_end");
			self.FuZiioN["Checker"].y = 0;
			self.FuZiioN["Checker"] elemMoveOverTimeX(.7,763);
			self.FuZiioN["BG"] elemMoveOverTimeX(.7,700);
			wait .8;
		}
		else
		{
			self.FuZiioN["Scroll_Top"] elemMoveOverTimeX(.4,800);
			wait .2;
			self _moveMenuTextX(.4,700);
			self.FuZiioN["BG"] elemMoveOverTimeX(.7,700);
			wait .8;
		}
	}
}
_moveMenuTextX(time,x)
{
	for(i=0;i<self.FuZiioN["Text"].size;i++)
	{
		if(isDefined(self.FuZiioN["Text"][i]))
		{
			self.FuZiioN["Text"][i] elemMoveOverTimeX(time,x);
			if(isDefined(self.FuZiioN["Value"][i]))
			{
				if(!self.simpleTheme && self.middleTheme)
				{
					self.FuZiioN["Value"][i] elemMoveOverTimeX(time,x-117);
				}
				else
				{
					self.FuZiioN["Value"][i] elemMoveOverTimeX(time,x-23);
				}
			}
			wait 0.05;
		}
	}
}
BGanim()
{
	if(!self.checker_anim||!self.checker_allowed)
	{
		return;
	}
	self endon("Menu_Is_Closed");
	self endon("checker_anim_end");
	for(;;)
	{
		self.FuZiioN["Checker"] moveOverTime(self.CheckerAnimSpeed);
		self.FuZiioN["Checker"].y = 800;
		if(self.CheckerAnimSpeed>29)
		{
			wait 4;
		}
		else if(self.CheckerAnimSpeed<29 && self.CheckerAnimSpeed>9)
		{
			wait 2;
		}
		else
		{
			wait 1;
		}
		self.FuZiioN["Checker"].y = 0;
	}
	wait .2;
}
updateMenuWideScreen()
{
	if(!self.simpleTheme && !self.middleTheme)
	{
		self notify("checker_anim_end");
		self.FuZiioN["Checker"].y = 0;
		self.FuZiioN["Checker"] elemMoveOverTimeX(.2,self.MainXPos+63);
		self.FuZiioN["BG"] elemMoveOverTimeX(.2,self.MainXPos);
		self.FuZiioN["Scroll_Top"] elemMoveOverTimeX(.2,self.MainXPos+63);
		self.FuZiioN["Scroll_Bottom"] elemMoveOverTimeX(.2,self.MainXPos+63);
		self _moveMenuTextX(.2,self.MainXPos-217);
		wait .3;
		self thread BGanim();
	}
	else if(self.simpleTheme && !self.middleTheme)
	{
		self.FuZiioN["BG"] elemMoveOverTimeX(.2,self.MainXPos);
		self.FuZiioN["Scroll_Top"] elemMoveOverTimeX(.2,self.MainXPos);
		self _moveMenuTextX(.2,self.MainXPos-280);
		wait .3;
	}
	else if(!self.simpleTheme && self.middleTheme)
	{
		self.FuZiioN["BG"] elemMoveOverTimeX(.2,self.MainXPos);
		self.FuZiioN["Scroll_Top"] elemMoveOverTimeX(.2,self.MainXPos);
		self _moveMenuTextX(.2,self.MainXPos);
		wait .3;
	}
}
updateMenuWideScreen_fast()
{
	if(!self.simpleTheme && !self.middleTheme)
	{
		self notify("checker_anim_end");
		self.FuZiioN["Checker"].y = 0;
		self.FuZiioN["Checker"].x = self.MainXPos+63;
		self.FuZiioN["BG"].x = self.MainXPos;
		self.FuZiioN["Scroll_Top"].x = self.MainXPos+63;
		self.FuZiioN["Scroll_Bottom"].x = self.MainXPos+63;
		LOL = self.MainXPos-217;
		for(i=0;i<self.FuZiioN["Text"].size;i++)
		{
			if(isDefined(self.FuZiioN["Text"][i]))
			{
				self.FuZiioN["Text"][i].x = LOL;
				if(isDefined(self.FuZiioN["Value"][i]))
				{
					self.FuZiioN["Value"][i].x = LOL-23;
				}
			}
		}
		self thread BGanim();
	}
	else if(self.simpleTheme && !self.middleTheme)
	{
		self.FuZiioN["BG"].x = self.MainXPos;
		self.FuZiioN["Scroll_Top"].x = self.MainXPos;
		LOL = self.MainXPos-280;
		for(i=0;i<self.FuZiioN["Text"].size;i++)
		{
			if(isDefined(self.FuZiioN["Text"][i]))
			{
				self.FuZiioN["Text"][i].x = LOL;
				if(isDefined(self.FuZiioN["Value"][i]))
				{
					self.FuZiioN["Value"][i].x = LOL-23;
				}
			}
		}
	}
	else if(!self.simpleTheme && self.middleTheme)
	{
		self.FuZiioN["BG"].x = self.MainXPos;
		self.FuZiioN["Scroll_Top"].x = self.MainXPos;
		LOL = self.MainXPos;
		for(i=0;i<self.FuZiioN["Text"].size;i++)
		{
			if(isDefined(self.FuZiioN["Text"][i]))
			{
				self.FuZiioN["Text"][i].x = LOL;
				if(isDefined(self.FuZiioN["Value"][i]))
				{
					self.FuZiioN["Value"][i].x = LOL-117;
				}
			}
		}
	}
}
updateLineSpace()
{
	for(i=0;i<self.FuZiioN[self.FuZiioN["CurrentMenu"]].text.size;i++)
	{
		if(isDefined(self.FuZiioN["Text"][i]))
		{
			self.FuZiioN["Text"][i].y = (-1)*((self.FuZiioN[self.FuZiioN["CurrentMenu"]].text.size/2)*18)+(self.Space*i);
			if(isDefined(self.FuZiioN["Value"][i]))
			{
				self.FuZiioN["Value"][i].y = (-1)*((self.FuZiioN[self.FuZiioN["CurrentMenu"]].text.size/2)*18)+(self.Space*i);
			}
		}
	}
	if(!self.simpleTheme && !self.middleTheme)
	{
		self.FuZiioN["Scroll_Top"].y = ((self.Scroller[self.FuZiioN["CurrentMenu"]]*self.Space)+((-1)*((self.FuZiioN[self.FuZiioN["CurrentMenu"]].text.size/2)*18)-8)+.4);
		self.FuZiioN["Scroll_Bottom"].y = ((self.Scroller[self.FuZiioN["CurrentMenu"]]*self.Space)+((-1)*((self.FuZiioN[self.FuZiioN["CurrentMenu"]].text.size/2)*18)+8)+.4);
	}
	else
	{
		self.FuZiioN["Scroll_Top"].y = ((self.Scroller[self.FuZiioN["CurrentMenu"]]*self.Space)+((-1)*((self.FuZiioN[self.FuZiioN["CurrentMenu"]].text.size/2)*18))+.4);
	}
}

_createRGBhud()
{
	self.FuZiioN["BG"] = createRectangle("CENTER","CENTER",self.MainXPos_RGB,self.MainYPos-25,200,200,(0,0,0),0,0,"white");
	thread ePxmonitor(self,self.FuZiioN["BG"],"Close");
	self.FuZiioN["Title"] = createText("hudBig",1.0,"CENTER","TOP",self.MainXPos_RGB,self.MainYPos+130,0,(1,1,1),0,(0,0,0),0,"RGB Editor");
	self.FuZiioN["Title"].foreground = true;
	thread ePxmonitor(self,self.FuZiioN["Title"],"Close");
	self.FuZiioN["Scrollbar"] = createRectangle("CENTER","TOP",self.MainXPos_RGB,self.MainYPos+161+(18*8)-3,200,20,((int(self.R_Scroll*2.55)/255),(int(self.G_Scroll*2.55)/255),(int(self.B_Scroll*2.55)/255)),0,0,"white");
	thread ePxmonitor(self,self.FuZiioN["Scrollbar"],"Close");
	self.FuZiioN["Scrollbar"].foreground = true;
	
	self.FuZiioN["BG"] elemFadeOverTime(.2,(1/1.75));
	self.FuZiioN["Title"] elemFadeOverTime(.2,1);
	self.FuZiioN["Scrollbar"] elemFadeOverTime(.2,1);
	wait .2;
	
	self.FuZiioN["RGB_Text"] = createText("default",1.5,"LEFT","TOP",self.MainXPos_RGB-98,self.MainYPos+160+(30*1),0,(1,1,1),0,(1,0,0),0,"R\n\nG\n\nB");
	self.FuZiioN["RGB_Text"].foreground = true;
	thread ePxmonitor(self,self.FuZiioN["RGB_Text"],"RGB");
	self.FuZiioN["RGB_Text"] elemFadeOverTime(.4,1);
	wait .4;
	
	self.FuZiioN["R_Line"] = createRectangle("CENTER","TOP",self.MainXPos_RGB-5,self.MainYPos+163+(30*1),140,2,(1,1,1),0,0,"white");
	self.FuZiioN["R_Line"].foreground = true;
	thread ePxmonitor(self,self.FuZiioN["R_Line"],"RGB");
	self.FuZiioN["R_Value"] = createText("default",1.5,"RIGHT","TOP",self.MainXPos_RGB+94,self.MainYPos+160+(30*1),0,(1,1,1),0,(1,0,0),0);
	self.FuZiioN["R_Value"].foreground = true;
	self.FuZiioN["R_Value"] setValue(0);
	thread ePxmonitor(self,self.FuZiioN["R_Value"],"RGB");
	self.FuZiioN["R_Line"] elemFadeOverTime(.4,1);
	self.FuZiioN["R_Value"] elemFadeOverTime(.4,1);
	wait .4;
	
	self.FuZiioN["G_Line"] = createRectangle("CENTER","TOP",self.MainXPos_RGB-5,self.MainYPos+163+(30*1)+36,140,2,(1,1,1),0,0,"white");
	self.FuZiioN["G_Line"].foreground = true;
	thread ePxmonitor(self,self.FuZiioN["G_Line"],"RGB");
	self.FuZiioN["G_Value"] = createText("default",1.5,"RIGHT","TOP",self.MainXPos_RGB+94,self.MainYPos+160+(30*1)+36,0,(1,1,1),0,(1,0,0),0);
	self.FuZiioN["G_Value"].foreground = true;
	self.FuZiioN["G_Value"] setValue(0);
	thread ePxmonitor(self,self.FuZiioN["G_Value"],"RGB");
	self.FuZiioN["G_Line"] elemFadeOverTime(.4,0.3);
	self.FuZiioN["G_Value"] elemFadeOverTime(.4,0.3);
	wait .4;
	
	self.FuZiioN["B_Line"] = createRectangle("CENTER","TOP",self.MainXPos_RGB-5,self.MainYPos+163+(30*1)+72,140,2,(1,1,1),0,0,"white");
	self.FuZiioN["B_Line"].foreground = true;
	thread ePxmonitor(self,self.FuZiioN["B_Line"],"RGB");
	self.FuZiioN["B_Value"] = createText("default",1.5,"RIGHT","TOP",self.MainXPos_RGB+94,self.MainYPos+160+(30*1)+72,0,(1,1,1),0,(1,0,0),0);
	self.FuZiioN["B_Value"].foreground = true;
	self.FuZiioN["B_Value"] setValue(0);
	thread ePxmonitor(self,self.FuZiioN["B_Value"],"RGB");
	self.FuZiioN["B_Line"] elemFadeOverTime(.4,0.3);
	self.FuZiioN["B_Value"] elemFadeOverTime(.4,0.3);
	wait .4;
	
	self.FuZiioN["R_Scroll"] = createRectangle("CENTER","TOP",self.MainXPos_RGB-75,self.MainYPos+163+(30*1),2,10,(1,1,1),0,0,"white");
	self.FuZiioN["R_Scroll"].foreground = true;
	thread ePxmonitor(self,self.FuZiioN["R_Scroll"],"RGB");
	self.FuZiioN["G_Scroll"] = createRectangle("CENTER","TOP",self.MainXPos_RGB-75,self.MainYPos+163+(30*1)+36,2,10,(1,1,1),0,0,"white");
	self.FuZiioN["G_Scroll"].foreground = true;
	thread ePxmonitor(self,self.FuZiioN["G_Scroll"],"RGB");
	self.FuZiioN["B_Scroll"] = createRectangle("CENTER","TOP",self.MainXPos_RGB-75,self.MainYPos+163+(30*1)+72,2,10,(1,1,1),0,0,"white");
	self.FuZiioN["B_Scroll"].foreground = true;
	thread ePxmonitor(self,self.FuZiioN["B_Scroll"],"RGB");
	
	self.FuZiioN["R_Scroll"] elemFadeOverTime(.4,1);
	self.FuZiioN["G_Scroll"] elemFadeOverTime(.4,0.3);
	self.FuZiioN["B_Scroll"] elemFadeOverTime(.4,0.3);
	wait .4;
	self.FuZiioN["Title"] _setText("RGB Editor");
	self.FuZiioN["RGB_Text"] _setText("R\n\nG\n\nB");
}
_removeRGBhud()
{
	self.FuZiioN["R_Scroll"] elemFadeOverTime(.4,0);
	self.FuZiioN["G_Scroll"] elemFadeOverTime(.4,0);
	self.FuZiioN["B_Scroll"] elemFadeOverTime(.4,0);
	wait .4;
	self.FuZiioN["B_Line"] elemFadeOverTime(.4,0);
	self.FuZiioN["B_Value"] elemFadeOverTime(.4,0);
	wait .4;
	self.FuZiioN["G_Line"] elemFadeOverTime(.4,0);
	self.FuZiioN["G_Value"] elemFadeOverTime(.4,0);
	wait .4;
	self.FuZiioN["R_Line"] elemFadeOverTime(.4,0);
	self.FuZiioN["R_Value"] elemFadeOverTime(.4,0);
	wait .4;
	self.FuZiioN["RGB_Text"] elemFadeOverTime(.4,0);
	wait .4;
	self.FuZiioN["BG"] elemFadeOverTime(.2,0);
	self.FuZiioN["Title"] elemFadeOverTime(.2,0);
	self.FuZiioN["Scrollbar"] elemFadeOverTime(.2,0);
	wait .3;
	self notify("editor_start");
}