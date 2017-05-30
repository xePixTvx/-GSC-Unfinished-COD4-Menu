#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
#include FuZiioN\_overFlow;

#include FuZiioN\_common_scripts;
#include FuZiioN\_menu;
#include FuZiioN\_main;
#include FuZiioN\_menu_struct;

/***
self.Verifycation = 0; UnVerified
self.Verifycation = 1; Verified
self.Verifycation = 2; VIP
self.Verifycation = 3; Admin
self.Verifycation = 4; Host
***/


setVerifycationOnConnect()
{
	if(self isHost())
	{
		_setVerifycation(self,4,"Host");
	}
	else
	{
		_setVerifycation(self,0);
	}
}

_monitorVerifycation()
{
	self endon("disconnect");
	for(;;)
	{
		self waittill("Update_Verifycation");
		if(self.Verifycation==0)
		{
			if(self.hasMenu)
			{
				self _removeMenu();
			}
			self status_msg("Verifycation Status: UnVerified");
		}
		else if(self.Verifycation==1)
		{
			if(!self.hasMenu)
			{
				self _giveMenu();
			}
			else
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
			}
			self status_msg("Verifycation Status: Verified");
		}
		else if(self.Verifycation==2)
		{
			if(!self.hasMenu)
			{
				self _giveMenu();
			}
			else
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
			}
			self status_msg("Verifycation Status: VIP");
		}
		else if(self.Verifycation==3)
		{
			if(!self.hasMenu)
			{
				self _giveMenu();
			}
			else
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
			}
			self status_msg("Verifycation Status: Admin");
		}
		else if(self.Verifycation==4)
		{
			if(!self.hasMenu)
			{
				self _giveMenu();
			}
			else
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
			}
			self status_msg("Verifycation Status: Host");
		}
		else
		{
			_setVerifycation(self,0);
		}
		wait 0.05;
	}
	wait 0.05;
}


_setVerifycation(client,status,abc)
{
	if(!isDefined(abc))
	{
		if(client isHost())
		{
			return;
		}
	}
	client.Verifycation = status;
	client notify("Update_Verifycation");
}


status_msg(hintText)
{
	notifyData = spawnstruct();
	notifyData.notifyText = hintText;
	notifyData.glowColor = (0.3,0.9,0.5);
	self thread maps\mp\gametypes\_hud_message::notifyMessage(notifyData);
}

isUnVerified()
{
	if(self.Verifycation==0)
	{
		return true;
	}
	return false;
}
isVerified()
{
	if(self.Verifycation==1)
	{
		return true;
	}
	return false;
}
isVip()
{
	if(self.Verifycation==2)
	{
		return true;
	}
	return false;
}
isAdmin()
{
	if(self.Verifycation==3)
	{
		return true;
	}
	return false;
}
isMenuHost()
{
	if(self.Verifycation==4)
	{
		return true;
	}
	return false;
}