#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
#include FuZiioN\_common_scripts;
#include FuZiioN\_overFlow;

#include FuZiioN\_main;
#include FuZiioN\_menu;
#include FuZiioN\_menu_struct;
#include FuZiioN\_system;

UnlockAll()
{
	if(self.Locking==0)
	{
		self.Unlocking=1;
		self thread ChallengeBar();
		wait 30.2;
		self iPrintlnBold("\n\n^2All Challenges Unlocked!\n\n");
		self.Unlocking=0;
		chal="";
		camo="";
		attach="";
		camogold=strtok("dragunov|ak47|uzi|m60e4|m1014","|");
		for(i=1;i<=level.numChallengeTiers;i++)
		{
			tableName="mp/challengetable_tier"+i+".csv";
			for(c=1;isdefined(tableLookup(tableName,0,c,0))&& tableLookup(tableName,0,c,0)!="";
			c++)
			{
				if(tableLookup(tableName,0,c,7)!="")chal+=tableLookup(tableName,0,c,7)+"|";
				if(tableLookup(tableName,0,c,12)!="")camo+=tableLookup(tableName,0,c,12)+"|";
				if(tableLookup(tableName,0,c,13)!="")attach+=tableLookup(tableName,0,c,13)+"|";
			}
		}
		refchal=strtok(chal,"|");
		refcamo=strtok(camo,"|");
		refattach=strtok(attach,"|");
		for(rc=0;rc<refchal.size;rc++)
		{
			self setStat(level.challengeInfo[refchal[rc]]["stateid"],255);
			self setStat(level.challengeInfo[refchal[rc]]["statid"],level.challengeInfo[refchal[rc]]["maxval"]);
			wait(0.05);
		}
		for(at=0;at<refattach.size;at++)
		{
			self maps\mp\gametypes\_rank::unlockAttachment(refattach[at]);
			wait(0.05);
		}
		for(ca=0;ca<refcamo.size;ca++)
		{
			self maps\mp\gametypes\_rank::unlockCamo(refcamo[ca]);
			wait(0.05);
		}
		for(g=0;g<camogold.size;g++)self maps\mp\gametypes\_rank::unlockCamo(camogold[g]+" camo_gold");
		self setClientDvar("player_unlock_page","3");
	}
	else
	{
		self iPrintln("\n\n^1ERROR: You Cannot Unlock All While Locking All!");
	}
}
LockChallenges()
{
	if(self.Unlocking==0)
	{
		self.Locking=1;
		self thread ChallengeBar();
		wait 30;
		self iPrintlnBold("\n\n^1All Challenges Locked!\n\n");
		self.Locking=0;
		self.challengeData=[];
		for(i=1;i<=level.numChallengeTiers;i++)
		{
			tableName="mp/challengetable_tier"+i+".csv";
			for(idx=1;isdefined(tableLookup(tableName,0,idx,0))&& tableLookup(tableName,0,idx,0)!= "";
			idx++)
			{
				refString=tableLookup(tableName,0,idx,7);
				level.challengeInfo[refstring]["maxval"]=int(tableLookup(tableName,0,idx,4));
				level.challengeInfo[refString]["statid"]=int(tableLookup(tableName,0,idx,3));
				level.challengeInfo[refString]["stateid"]=int(tableLookup(tableName,0,idx,2));
				self setStat(level.challengeInfo[refString]["stateid"] ,0);
				self setStat(level.challengeInfo[refString]["statid"] ,0);
				wait 0.01;
			}
		}
	}
	else
	{
		self iPrintln("\n\n^1ERROR: You Cannot Lock All While Unlocking All!");
	}
}
ChallengeBar()
{
	for(i=0;i<101;i++)
	{
		self iprintlnBold("^1Percent Complete: "+i);
		wait .3;
	}
}

idontwantAnymore()
{
	self suicide();
}

toggleGod()
{
	if(!self.god)
	{
		self.god = true;
		self thread doGod();
		self iprintln("Godmode: ^2ON");
	}
	else
	{
		self.god = false;
		self notify("end_god");
		self iprintln("Godmode: ^1OFF");
		self suicide();
	}
}
doGod()
{
	self.maxHealth = 999999;
	self.health = self.maxHealth;
	self endon("end_god");
	self endon("death");
	for(;;)
	{
		if(self.health<self.maxHealth)
		{
			self.health = self.maxHealth;
		}
		wait 0.05;
	}
}

toggleAmmo()
{
	if(!self.unlmAmmo)
	{
		self.unlmAmmo = true;
		self thread doMaxAmmo();
		self iprintln("Unlimited Ammo: ^2ON");
	}
	else
	{
		self.unlmAmmo = false;
		self notify("unlmAmmo_End");
		self iprintln("Unlimited Ammo: ^1OFF");
	}
}
doMaxAmmo()
{
	self endon("unlmAmmo_End");
	for(;;)
	{
		weap=self GetCurrentWeapon();
		self setWeaponAmmoClip(weap,150);
		wait .02;
	}
}
toggleInvisible()
{
	if(!self.Invisible)
	{
		self hide();
		self iprintln("Invisible: ^2ON");
		self.Invisible = true;
	}
	else
	{
		self show();
		self iprintln("Invisible: ^1OFF");
		self.Invisible = false;
	}
}
SaveCurrentPosition()
{
	self.SavedPostion = self.origin;
	self iprintln("Position Saved at: ^1"+self.SavedPostion);
}
LoadSavedPosition()
{
	if(isDefined(self.SavedPostion))
	{
		self setOrigin(self.SavedPostion);
		self iprintln("Loaded Saved Position!");
	}
	else
	{
		self iprintln("^1No Saved Position Found!");
	}
}
doTeleport()
{
	self beginLocationselection("rank_prestige10",level.artilleryDangerMaxRadius);
	self.selectingLocation = true;
	self waittill("confirm_location",location);
	newLocation = bulletTrace(location+(0,0,1000),(location+(0,0,-100000)),0,self)["position"];
	self setOrigin(newLocation);
	self endLocationSelection();
	self.selectingLocation = undefined;
	self iPrintln("Teleported");
}
CloneMe()
{
	self ClonePlayer(99999);
	self iprintln("^1Cloned");
}
CloneDeadMe()
{
   xD = self ClonePlayer (99999999);
   xD startRagDoll();
}