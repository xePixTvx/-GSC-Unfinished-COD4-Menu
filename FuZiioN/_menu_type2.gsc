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
				self thread _menuMain();
				wait 0.05;
				self notify("Menu_Is_Opened");
				wait .2;
			}
			if(self SecondaryOffHandButtonPressed() && self MeleeButtonPressed())
			{
				self.FuZiioN["Menu"]["Locked"] = true;
				self iprintlnBold("Menu ^1Locked");
				wait .2;
			}
		}
		if(!self.FuZiioN["Menu"]["Open"] && self.FuZiioN["Menu"]["Locked"] && self.menuUseAllowed)
		{
			if(self SecondaryOffHandButtonPressed() && self MeleeButtonPressed())
			{
				self.FuZiioN["Menu"]["Locked"] = false;
				self iprintlnBold("Menu ^2UnLocked");
				wait .2;
			}
		}
		wait 0.05;
	}
}

_menuMain()
{
	self endon("disconnect");
	self endon("Remove_Menu");
	self endon("Menu_Is_Closed");
	
	self waittill("Menu_Is_Opened");
	self _menuResponse("openNclose","open");
	
	while(self.FuZiioN["Menu"]["Open"])
	{
		if(self.menuFreeze==true)
		{
			self freezeControls(true);
		}
		if(self.FuZiioN["Menu"]["Type"]=="menu")
		{
			if(self AdsButtonPressed())
			{
				if(self.Scroller[self.FuZiioN["CurrentMenu"]]>=1)
				{
					self.Scroller[self.FuZiioN["CurrentMenu"]] --;
					for(i=0;i<self.FuZiioN["Text"].size;i++)
					{
						self.FuZiioN["Text"][i] elemMoveOverTimeY(.120,self.FuZiioN["Text"][i].y+self.Space);
						if(isDefined(self.FuZiioN["Toggle"][i]))
						{
							self.FuZiioN["Toggle"][i] elemMoveOverTimeY(.120,self.FuZiioN["Toggle"][i].y+self.Space);
						}
						if(isDefined(self.FuZiioN["Value"][i]))
						{
							self.FuZiioN["Value"][i] elemMoveOverTimeY(.120,self.FuZiioN["Value"][i].y+self.Space);
						}
					}
					self _menuResponse("scroll","update");
				}
				if(self.menuSounds==true)
				{
					self playLocalSound("mouse_submenu_over");
				}
				wait .124;
			}
			if(self AttackButtonPressed())
			{
				if(self.Scroller[self.FuZiioN["CurrentMenu"]]<self.FuZiioN[self.FuZiioN["CurrentMenu"]].text.size-1)
				{
					self.Scroller[self.FuZiioN["CurrentMenu"]] ++;
					for(i=0;i<self.FuZiioN["Text"].size;i++)
					{
						self.FuZiioN["Text"][i] elemMoveOverTimeY(.120,self.FuZiioN["Text"][i].y+self.Space*-1);
						if(isDefined(self.FuZiioN["Toggle"][i]))
						{
							self.FuZiioN["Toggle"][i] elemMoveOverTimeY(.120,self.FuZiioN["Toggle"][i].y+self.Space*-1);
						}
						if(isDefined(self.FuZiioN["Value"][i]))
						{
							self.FuZiioN["Value"][i] elemMoveOverTimeY(.120,self.FuZiioN["Value"][i].y+self.Space*-1);
						}
					}
					self _menuResponse("scroll","update");
				}
				if(self.menuSounds==true)
				{
					self playLocalSound("mouse_submenu_over");
				}
				wait .124;
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
					if(self.menuSounds==true)
					{
						self playLocalSound("mouse_submenu_over");
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
					wait 0.05;
					self _menuResponse("select","update");
				}
				else
				{
					self _menuResponse("loadMenu",self.FuZiioN[self.FuZiioN["CurrentMenu"]].input1[self.Scroller[self.FuZiioN["CurrentMenu"]]]);
				}
				if(self.menuSounds==true)
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
				if(self.menuSounds==true)
				{
					self playLocalSound("mouse_submenu_over");
				}
				wait .4;
			}
		}
		else
		{
			self iprintln("^1Menu Type ERROR! Restarting Now....");
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
			if(!isDefined(self.FuZiioN["CurrentMenu"]))
			{
				self.FuZiioN["CurrentMenu"] = "main";
			}
			self _menuResponse("hud","create");
			self _menuResponse("loadMenu",self.FuZiioN["CurrentMenu"]);
		}
		else if(in2=="close")
		{
			self.FuZiioN["Menu"]["Open"] = false;
			self freezeControls(false);
			self notify("Menu_Is_Closed");
		}
		else if(in2=="restart")
		{
			self _menuResponse("openNclose","close");
			wait .2;
			self thread _menuMain();
			wait 0.05;
			self notify("Menu_Is_Opened");
			wait .2;
		}
		else
		{
			self iprintln("^1_menuResponse()= openNclose ERROR!");
		}
	}
	else if(in1=="hud")
	{
		if(in2=="create")
		{
			self.FuZiioN["BG"] = createRectangle("CENTER","CENTER",self.MainXPos,self.MainYPos,200,230,(0,0,0),(1/1.75),0,"white");
			thread ePxmonitor(self,self.FuZiioN["BG"],"Close");
			
			self.FuZiioN["Arrow"] = createRectangle("CENTER","CENTER",self.MainXPos-90,self.MainYPos,10,10,(1,0,0),1,0,"ui_scrollbar_arrow_right");
			self.FuZiioN["Arrow"].foreground = true;
			thread ePxmonitor(self,self.FuZiioN["Arrow"],"Close");
		}
		else if(in2=="createText")
		{
			self.FuZiioN["Text"] = [];
			for(i=0;i<self.FuZiioN[self.FuZiioN["CurrentMenu"]].text.size;i++)
			{
				self.FuZiioN["Text"][i] = createText("default",1.5,"LEFT","CENTER",self.MainXPos-80,self.MainYPos+(self.Space*i),0,(1,1,1),1,(0,0,0),0,self.FuZiioN[self.FuZiioN["CurrentMenu"]].text[i]);
				self.FuZiioN["Text"][i].foreground = true;
				thread ePxmonitor(self,self.FuZiioN["Text"][i],"Update");
				
				if(isDefined(self.FuZiioN[self.FuZiioN["CurrentMenu"]].toggle[i]))
				{
					self.FuZiioN["Toggle"][i] = createText("default",1.5,"RIGHT","CENTER",self.MainXPos+80,self.MainYPos+(self.Space*i),0,(1,1,1),1,(0,0,0),0);
					self.FuZiioN["Toggle"][i].foreground = true;
					thread ePxmonitor(self,self.FuZiioN["Toggle"][i],"Update");
					if(self.FuZiioN[self.FuZiioN["CurrentMenu"]].toggle[i]==true)
					{
						self.FuZiioN["Toggle"][i] setText("ON");
					}
					else
					{
						self.FuZiioN["Toggle"][i] setText("OFF");
					}
				}
				if(isDefined(self.FuZiioN[self.FuZiioN["CurrentMenu"]].holder[i]))
				{
					self.FuZiioN["Value"][i] = createText("default",1.5,"RIGHT","CENTER",self.MainXPos+80,self.MainYPos+(self.Space*i),0,(1,1,1),1,(0,0,0),0);
					self.FuZiioN["Value"][i] setValue(self.FuZiioN[self.FuZiioN["CurrentMenu"]].holder[i]);
					thread ePxmonitor(self,self.FuZiioN["Value"][i],"Update");
				}
			}
		}
		else
		{
			self iprintln("^1_menuResponse()= hud ERROR!");
		}
	}
	else if(in1=="loadMenu")
	{
		self notify("Update");
		self _load_menuStruct();
		self.FuZiioN["CurrentMenu"] = in2;
		if(self.CursorRem==true)
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
		self _menuResponse("hud","createText");
		self _menuResponse("scroll","update");
		self _menuResponse("scroll","cursorRemember");
		if(self.FuZiioN[self.FuZiioN["CurrentMenu"]].parent=="players")
		{
			self _menuResponse("refreshStrings");
		}
	}
	else if(in1=="scroll")
	{
		if(in2=="update")
		{
			for(i=0;i<self.FuZiioN["Text"].size;i++)
			{
				if(i<self.Scroller[self.FuZiioN["CurrentMenu"]]-5)
				{
					self.FuZiioN["Text"][i] notify("Update_Scroll");
					self.FuZiioN["Text"][i].alpha = 0;
					if(isDefined(self.FuZiioN["Toggle"][i]))
					{
						self.FuZiioN["Toggle"][i] notify("Update_Scroll");
						self.FuZiioN["Toggle"][i].alpha = 0;
					}
					if(isDefined(self.FuZiioN["Value"][i]))
					{
						self.FuZiioN["Value"][i] notify("Update_Scroll");
						self.FuZiioN["Value"][i].alpha = 0;
					}
				}
				else if(i==self.Scroller[self.FuZiioN["CurrentMenu"]])
				{
					self.FuZiioN["Text"][i].alpha = 1;
					self.FuZiioN["Text"][i] thread _selectedEffect();
					if(isDefined(self.FuZiioN["Toggle"][i]))
					{
						self.FuZiioN["Toggle"][i].alpha = 1;
						self.FuZiioN["Toggle"][i] thread _selectedEffect();
					}
					if(isDefined(self.FuZiioN["Value"][i]))
					{
						self.FuZiioN["Value"][i].alpha = 1;
						self.FuZiioN["Value"][i] thread _selectedEffect();
					}
				}
				else if(i>self.Scroller[self.FuZiioN["CurrentMenu"]]+5)
				{
					self.FuZiioN["Text"][i] notify("Update_Scroll");
					self.FuZiioN["Text"][i].alpha = 0;
					if(isDefined(self.FuZiioN["Toggle"][i]))
					{
						self.FuZiioN["Toggle"][i] notify("Update_Scroll");
						self.FuZiioN["Toggle"][i].alpha = 0;
					}
					if(isDefined(self.FuZiioN["Value"][i]))
					{
						self.FuZiioN["Value"][i] notify("Update_Scroll");
						self.FuZiioN["Value"][i].alpha = 0;
					}
				}
				else
				{
					self.FuZiioN["Text"][i] notify("Update_Scroll");
					self.FuZiioN["Text"][i].alpha = 1;
					if(isDefined(self.FuZiioN["Toggle"][i]))
					{
						self.FuZiioN["Toggle"][i] notify("Update_Scroll");
						self.FuZiioN["Toggle"][i].alpha = 1;
					}
					if(isDefined(self.FuZiioN["Value"][i]))
					{
						self.FuZiioN["Value"][i] notify("Update_Scroll");
						self.FuZiioN["Value"][i].alpha = 1;
					}
				}
			}
		}
		else if(in2=="cursorRemember")
		{
			for(i=0;i<self.FuZiioN["Text"].size;i++)
			{
				self.FuZiioN["Text"][i] setPoint("LEFT","CENTER",self.MainXPos-80,(self.MainYPos+(self.Space*(self.Scroller[self.FuZiioN["CurrentMenu"]]*-1)))+(self.Space*i));
				if(isDefined(self.FuZiioN["Toggle"][i]))
				{
					self.FuZiioN["Toggle"][i] setPoint("RIGHT","CENTER",self.MainXPos+80,(self.MainYPos+(self.Space*(self.Scroller[self.FuZiioN["CurrentMenu"]]*-1)))+(self.Space*i));
				}
				if(isDefined(self.FuZiioN["Value"][i]))
				{
					self.FuZiioN["Value"][i] setPoint("RIGHT","CENTER",self.MainXPos+80,(self.MainYPos+(self.Space*(self.Scroller[self.FuZiioN["CurrentMenu"]]*-1)))+(self.Space*i));
				}
			}
		}
		else
		{
			self iprintln("^1_menuResponse()= scroll ERROR!");
		}
	}
	else if(in1=="select")
	{
		if(in2=="update")
		{
			self _load_menuStruct();
			for(i=0;i<self.FuZiioN[self.FuZiioN["CurrentMenu"]].text.size;i++)
			{
				if(isDefined(self.FuZiioN[self.FuZiioN["CurrentMenu"]].toggle[i]))
				{
					if(self.FuZiioN[self.FuZiioN["CurrentMenu"]].toggle[i]==true)
					{
						self.FuZiioN["Toggle"][i] setText("ON");
					}
					else
					{
						self.FuZiioN["Toggle"][i] setText("OFF");
					}
				}
			}
		}
		else
		{
			self iprintln("^1_menuResponse()= select ERROR!");
		}
	}
	else if(in1=="refreshStrings")
	{
		for(i=0;i<self.FuZiioN[self.FuZiioN["CurrentMenu"]].text.size;i++)
		{
			self.FuZiioN["Text"][i] setText(self.FuZiioN[self.FuZiioN["CurrentMenu"]].text[i]);
			if(isDefined(self.FuZiioN[self.FuZiioN["CurrentMenu"]].toggle[i]))
			{
				if(self.FuZiioN[self.FuZiioN["CurrentMenu"]].toggle[i]==true)
				{
					self.FuZiioN["Toggle"][i] setText("ON");
				}
				else
				{
					self.FuZiioN["Toggle"][i] setText("OFF");
				}
			}
		}
	}
	else if(in1=="updateMenuPos")
	{
		self.FuZiioN["BG"].x = self.MainXPos;
		self.FuZiioN["BG"].y = self.MainYPos;
		self.FuZiioN["Arrow"].x = self.MainXPos-90;
		self.FuZiioN["Arrow"].y = self.MainYPos;
		self _menuResponse("scroll","cursorRemember");
	}
	else
	{
		self iprintln("^1_menuResponse() ERROR!");
	}
}