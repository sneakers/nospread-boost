#include <sdkhooks>

new VelocityOffset_0,VelocityOffset_1,BaseVelocityOffset;
public Plugin:myinfo={name="BHOP",author="Danyas"};
ConVar g_speedMultiplier;

public OnPluginStart()
{ 
	g_speedMultiplier = CreateConVar("speed_multiplier",
			"0.135",
			"Sets the speed multiplier",
			FCVAR_NOTIFY,
			false,
			0,
			true,
			500.0);

	HookEvent("player_jump",PlayerJumpEvent);
 	VelocityOffset_0=FindSendPropOffs("CBasePlayer","m_vecVelocity[0]");VelocityOffset_1=FindSendPropOffs("CBasePlayer","m_vecVelocity[1]");
 	BaseVelocityOffset=FindSendPropOffs("CBasePlayer","m_vecBaseVelocity");
}

public PlayerJumpEvent(Handle:event,const String:name[],bool:dontBroadcast)
{
	new index=GetClientOfUserId(GetEventInt(event,"userid")), Float:finalvec[3];
	// jumpboost part
	finalvec[0]=GetEntDataFloat(index,VelocityOffset_0)*g_speedMultiplier.FloatValue; // x
	finalvec[1]=GetEntDataFloat(index,VelocityOffset_1)*g_speedMultiplier.FloatValue; // y
	finalvec[2]=15.0; // z 

	SetEntDataVector(index,BaseVelocityOffset,finalvec,true);
}
 
//bunnyhop part
public Action:OnPlayerRunCmd(client, &buttons, &impulse, Float:vel[3], Float:angles[3], &weapon) 
    if (IsPlayerAlive(client) && (buttons & IN_JUMP) && !(GetEntityFlags(client) & FL_ONGROUND) && !(GetEntityMoveType(client) & MOVETYPE_LADDER) && (GetEntProp(client, Prop_Data, "m_nWaterLevel") <= 1)) 
        buttons &= ~IN_JUMP;
