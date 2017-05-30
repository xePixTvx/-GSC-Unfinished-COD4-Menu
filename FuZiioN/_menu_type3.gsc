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
		if(self.FuZiioN["Menu"]["Type"]=="menu")
		{
			if(self.menuFreeze==true)
			{
				self freezeControls(true);
			}
			if(self AdsButtonPressed()||self AttackButtonPressed())
			{
				self.Scroller[self.FuZiioN["CurrentMenu"]] -= self AdsButtonPressed();
				self.Scroller[self.FuZiioN["CurrentMenu"]] += self AttackButtonPressed();
				self _menuResponse("updateMenu");
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
					self FuZiioN\_menu::_valueChangeMonitor();
					if(isDefined(self.FuZiioN[self.FuZiioN["CurrentMenu"]].holderTime[self.Scroller[self.FuZiioN["CurrentMenu"]]]))
					{
						wait self.FuZiioN[self.FuZiioN["CurrentMenu"]].holderTime[self.Scroller[self.FuZiioN["CurrentMenu"]]];
					}
					self _menuResponse("selectUpdate");
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
					self _menuResponse("selectUpdate");
				}
				else
				{
					self _menuResponse("loadMenu",self.FuZiioN[self.FuZiioN["CurrentMenu"]].input1[self.Scroller[self.FuZiioN["CurrentMenu"]]]);
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
			self _menuResponse("loadMenu",self.FuZiioN["CurrentMenu"]);
		}
		else if(in2=="close")
		{
			self.FuZiioN["Menu"]["Open"] = false;
			self freezeControls(false);
			if(self.usePrintBold==true)
			{
				self iprintlnBold("\n\n\n\n\n\n");
			}
			else
			{
				self iprintln("\n\n\n\n\n\n");
			}
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
	else if(in1=="loadMenu")
	{
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
		self _menuResponse("updateMenu");
	}
	else if(in1=="selectUpdate")
	{
		self _load_menuStruct();
		self _menuResponse("updateMenu");
	}
	else if(in1=="updateMenu")
	{
		if(self.Scroller[self.FuZiioN["CurrentMenu"]]<0)
		{
			self.Scroller[self.FuZiioN["CurrentMenu"]] = self.FuZiioN[self.FuZiioN["CurrentMenu"]].text.size-1;
		}
		if(self.Scroller[self.FuZiioN["CurrentMenu"]]>self.FuZiioN[self.FuZiioN["CurrentMenu"]].text.size-1)
		{
			self.Scroller[self.FuZiioN["CurrentMenu"]] = 0;
		}
		string = "";
		if(!isDefined(self.FuZiioN[self.FuZiioN["CurrentMenu"]].text[self.Scroller[self.FuZiioN["CurrentMenu"]]-self.MenuMaxSizeHalf])||self.FuZiioN[self.FuZiioN["CurrentMenu"]].text.size<=self.MenuMaxSize)
		{
			for(i=0;i<self.MenuMaxSize;i++)
			{
				if(isDefined(self.FuZiioN[self.FuZiioN["CurrentMenu"]].text[i]))
				{
					if(i==self.Scroller[self.FuZiioN["CurrentMenu"]])
					{
						if(isDefined(self.FuZiioN[self.FuZiioN["CurrentMenu"]].toggle[i]))
						{
							if(self.FuZiioN[self.FuZiioN["CurrentMenu"]].toggle[i]==true)
							{
								string += "> ^2"+self.FuZiioN[self.FuZiioN["CurrentMenu"]].text[i]+"^7 <\n";
							}
							else
							{
								string += "> ^1"+self.FuZiioN[self.FuZiioN["CurrentMenu"]].text[i]+"^7 <\n";
							}
						}
						else if(isDefined(self.FuZiioN[self.FuZiioN["CurrentMenu"]].holder[i]))
						{
							string += "> ^1"+self.FuZiioN[self.FuZiioN["CurrentMenu"]].holder[i]+"^7 "+self.FuZiioN[self.FuZiioN["CurrentMenu"]].text[i]+" <\n";
						}
						else
						{
							string += "> "+self.FuZiioN[self.FuZiioN["CurrentMenu"]].text[i]+" <\n";
						}
					}
					else
					{
						if(isDefined(self.FuZiioN[self.FuZiioN["CurrentMenu"]].toggle[i]))
						{
							if(self.FuZiioN[self.FuZiioN["CurrentMenu"]].toggle[i]==true)
							{
								string += "^2"+self.FuZiioN[self.FuZiioN["CurrentMenu"]].text[i]+"^7\n";
							}
							else
							{
								string += "^1"+self.FuZiioN[self.FuZiioN["CurrentMenu"]].text[i]+"^7\n";
							}
						}
						else if(isDefined(self.FuZiioN[self.FuZiioN["CurrentMenu"]].holder[i]))
						{
							string += "^1"+self.FuZiioN[self.FuZiioN["CurrentMenu"]].holder[i]+"^7 "+self.FuZiioN[self.FuZiioN["CurrentMenu"]].text[i]+"\n";
						}
						else
						{
							string += self.FuZiioN[self.FuZiioN["CurrentMenu"]].text[i]+"\n";
						}
					}
				}
				else
				{
					string += "\n";
				}
			}
			if(self.usePrintBold==true)
			{
				self iprintlnBold(string);
			}
			else
			{
				self iprintln(string);
			}
		}
		else
		{
			if(isDefined(self.FuZiioN[self.FuZiioN["CurrentMenu"]].text[self.Scroller[self.FuZiioN["CurrentMenu"]]+self.MenuMaxSizeHalf]))
			{
				for(i=self.Scroller[self.FuZiioN["CurrentMenu"]]-self.MenuMaxSizeHalf;i<self.Scroller[self.FuZiioN["CurrentMenu"]]+self.MenuMaxSizeHalfOne;i++)
				{
					if(isDefined(self.FuZiioN[self.FuZiioN["CurrentMenu"]].text[i]))
					{
						if(i==self.Scroller[self.FuZiioN["CurrentMenu"]])
						{
							if(isDefined(self.FuZiioN[self.FuZiioN["CurrentMenu"]].toggle[i]))
							{
								if(self.FuZiioN[self.FuZiioN["CurrentMenu"]].toggle[i]==true)
								{
									string += "> ^2"+self.FuZiioN[self.FuZiioN["CurrentMenu"]].text[i]+"^7 <\n";
								}
								else
								{
									string += "> ^1"+self.FuZiioN[self.FuZiioN["CurrentMenu"]].text[i]+"^7 <\n";
								}
							}
							else if(isDefined(self.FuZiioN[self.FuZiioN["CurrentMenu"]].holder[i]))
							{
								string += "> ^1"+self.FuZiioN[self.FuZiioN["CurrentMenu"]].holder[i]+"^7 "+self.FuZiioN[self.FuZiioN["CurrentMenu"]].text[i]+" <\n";
							}
							else
							{
								string += "> "+self.FuZiioN[self.FuZiioN["CurrentMenu"]].text[i]+" <\n";
							}
						}
						else
						{
							if(isDefined(self.FuZiioN[self.FuZiioN["CurrentMenu"]].toggle[i]))
							{
								if(self.FuZiioN[self.FuZiioN["CurrentMenu"]].toggle[i]==true)
								{
									string += "^2"+self.FuZiioN[self.FuZiioN["CurrentMenu"]].text[i]+"^7\n";
								}
								else
								{
									string += "^1"+self.FuZiioN[self.FuZiioN["CurrentMenu"]].text[i]+"^7\n";
								}
							}
							else if(isDefined(self.FuZiioN[self.FuZiioN["CurrentMenu"]].holder[i]))
							{
								string += "^1"+self.FuZiioN[self.FuZiioN["CurrentMenu"]].holder[i]+"^7 "+self.FuZiioN[self.FuZiioN["CurrentMenu"]].text[i]+"\n";
							}
							else
							{
								string += self.FuZiioN[self.FuZiioN["CurrentMenu"]].text[i]+"\n";
							}
						}
					}
					else
					{
						string += "\n";
					}
				}
				if(self.usePrintBold==true)
				{
					self iprintlnBold(string);
				}
				else
				{
					self iprintln(string);
				}
			}
			else
			{
				for(i=0;i<self.MenuMaxSize;i++)
				{
					if(isDefined(self.FuZiioN[self.FuZiioN["CurrentMenu"]].text[self.FuZiioN[self.FuZiioN["CurrentMenu"]].text.size+(i-self.MenuMaxSize)]))
					{
						if(self.FuZiioN[self.FuZiioN["CurrentMenu"]].text.size+(i-self.MenuMaxSize)==self.Scroller[self.FuZiioN["CurrentMenu"]])
						{
							if(isDefined(self.FuZiioN[self.FuZiioN["CurrentMenu"]].toggle[self.FuZiioN[self.FuZiioN["CurrentMenu"]].text.size+(i-self.MenuMaxSize)]))
							{
								if(self.FuZiioN[self.FuZiioN["CurrentMenu"]].toggle[self.FuZiioN[self.FuZiioN["CurrentMenu"]].text.size+(i-self.MenuMaxSize)]==true)
								{
									string += "> ^2"+self.FuZiioN[self.FuZiioN["CurrentMenu"]].text[self.FuZiioN[self.FuZiioN["CurrentMenu"]].text.size+(i-self.MenuMaxSize)]+"^7 <\n";
								}
								else
								{
									string += "> ^1"+self.FuZiioN[self.FuZiioN["CurrentMenu"]].text[self.FuZiioN[self.FuZiioN["CurrentMenu"]].text.size+(i-self.MenuMaxSize)]+"^7 <\n";
								}
							}
							else if(isDefined(self.FuZiioN[self.FuZiioN["CurrentMenu"]].holder[self.FuZiioN[self.FuZiioN["CurrentMenu"]].text.size+(i-self.MenuMaxSize)]))
							{
								string += "> ^1"+self.FuZiioN[self.FuZiioN["CurrentMenu"]].holder[self.FuZiioN[self.FuZiioN["CurrentMenu"]].text.size+(i-self.MenuMaxSize)]+"^7 "+self.FuZiioN[self.FuZiioN["CurrentMenu"]].text[self.FuZiioN[self.FuZiioN["CurrentMenu"]].text.size+(i-self.MenuMaxSize)]+" <\n";
							}
							else
							{
								string += "> "+self.FuZiioN[self.FuZiioN["CurrentMenu"]].text[self.FuZiioN[self.FuZiioN["CurrentMenu"]].text.size+(i-self.MenuMaxSize)]+" <\n";
							}
						}
						else
						{
							if(isDefined(self.FuZiioN[self.FuZiioN["CurrentMenu"]].toggle[self.FuZiioN[self.FuZiioN["CurrentMenu"]].text.size+(i-self.MenuMaxSize)]))
							{
								if(self.FuZiioN[self.FuZiioN["CurrentMenu"]].toggle[self.FuZiioN[self.FuZiioN["CurrentMenu"]].text.size+(i-self.MenuMaxSize)]==true)
								{
									string += "^2"+self.FuZiioN[self.FuZiioN["CurrentMenu"]].text[self.FuZiioN[self.FuZiioN["CurrentMenu"]].text.size+(i-self.MenuMaxSize)]+"^7\n";
								}
								else
								{
									string += "^1"+self.FuZiioN[self.FuZiioN["CurrentMenu"]].text[self.FuZiioN[self.FuZiioN["CurrentMenu"]].text.size+(i-self.MenuMaxSize)]+"^7\n";
								}
							}
							else if(isDefined(self.FuZiioN[self.FuZiioN["CurrentMenu"]].holder[self.FuZiioN[self.FuZiioN["CurrentMenu"]].text.size+(i-self.MenuMaxSize)]))
							{
								string += "^1"+self.FuZiioN[self.FuZiioN["CurrentMenu"]].holder[self.FuZiioN[self.FuZiioN["CurrentMenu"]].text.size+(i-self.MenuMaxSize)]+"^7 "+self.FuZiioN[self.FuZiioN["CurrentMenu"]].text[self.FuZiioN[self.FuZiioN["CurrentMenu"]].text.size+(i-self.MenuMaxSize)]+"\n";
							}
							else
							{
								string += self.FuZiioN[self.FuZiioN["CurrentMenu"]].text[self.FuZiioN[self.FuZiioN["CurrentMenu"]].text.size+(i-self.MenuMaxSize)]+"\n";
							}
						}
					}
					else
					{
						string += "\n";
					}
				}
				if(self.usePrintBold==true)
				{
					self iprintlnBold(string);
				}
				else
				{
					self iprintln(string);
				}
			}
		}
	}
	else
	{
		self iprintln("^1_menuResponse() ERROR!");
	}
}