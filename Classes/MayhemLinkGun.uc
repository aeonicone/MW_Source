class MayhemLinkGun extends LinkGun
    HideDropDown;

#exec Texture Import Name=LinkGunTex File=Textures\LinkGunTex.tga
var Sound ModeCycleSound;
var byte CurrentLinkIndex;
var linkFireExtendable AFire;

replication    // This will possibly fix the non replicated link length problem?
{
    /* the client can call this function on the server*/
    reliable if ( Role < ROLE_Authority )
        ToggleMayhemWeaponMode;

    Reliable if ( Role == ROLE_Authority )
        SendInfoToClient;

    /*Server replicates this to the client whenever there is a status change*/
    reliable if ( bNetDirty && (Role == ROLE_Authority) )
        CurrentLinkIndex;
}

simulated function UpdateLinkColor( LinkAttachment.ELinkColor Color )
{
	if ( FireMode[1] != None )
		LinkFire(FireMode[1]).UpdateLinkColor( Color );

	if ( Mesh == OldMesh )	// no support for old mesh
		return;

	switch ( Color )
	{
		case LC_Green	:	Skins[1] = material'PowerPulseShader'; 		break;
		case LC_Red	: 	Skins[1] = material'PowerPulseShaderRed';	break;
		case LC_Blue	:	Skins[1] = material'PowerPulseShaderBlue'; 	break;
		case LC_Gold	:	Skins[1] = material'PowerPulseShaderYellow';	break;
	}
}

Simulated Function PostBeginPlay()
{
    Super.PostBeginPlay();
    AFire = LinkFireExtendable(FireMode[1]);
}

function byte BestMode()
{
    local Bot B;
    local Float TargetDist, EnemyDist;
    local byte i;
    local Vehicle V;

    B = Bot(Instigator.Controller);
    if ( B == None )
        Return 0;

    // Determine Which Beam length to use ---------------------
    TargetDist = VSize(B.Target.Location - Instigator.Location);

    i = AFire.EBeamMode.Enumcount;

    // 0 is longest, 1 is medium, 2 is shortest.
    Do  {  i--;  }  Until  ( i == 0 || TargetDist <= AFire.LengthTrace[i] );

    // Low skilled bots don't use this stuff, and Mid level bots don't use short range.
    if ( (B.Skill < 2) || ( B.Skill < 4 && i == 2 ) )
        i = 1;

    AFire.BeamMode = EBeamMode(i);
    // ---------------------------------------------------------
    
        // original portion of super function following.
	if ( ( (DestroyableObjective(B.Squad.SquadObjective) != None && B.Squad.SquadObjective.TeamLink(B.GetTeamNum()))
             || (B.Squad.SquadObjective == None && DestroyableObjective(B.Target) != None && B.Target.TeamLink(B.GetTeamNum())) )
	     && VSize(B.Squad.SquadObjective.Location - B.Pawn.Location) < FireMode[1].MaxRange()
             && (B.Enemy == None || !B.EnemyVisible()) )
                return 1;
	if ( FocusOnLeader(B.Focus == B.Squad.SquadLeader.Pawn) )
		return 1;

	V = B.Squad.GetLinkVehicle(B);
	if ( V == None )
		V = Vehicle(B.MoveTarget);
	if ( V == B.Target )
		return 1;
	if ( (V != None) && (VSize(Instigator.Location - V.Location) < LinkFire(FireMode[1]).TraceRange)
		&& (V.Health < V.HealthMax) 
                && (V.LinkHealMult > 0) && B.LineOfSightTo(V) )
		return 1;
	if ( B.Enemy == None )
		return 0;
	EnemyDist = VSize(B.Enemy.Location - Instigator.Location);
	if ( EnemyDist > AFire.TraceRange )
		return 0;
	return 1;
	// end of portion
}

simulated function BringUp(optional Weapon PrevWeapon)
{
    Super.BringUp(PrevWeapon);
    if ( Instigator.IsHumanControlled() )
        Instigator.ReceiveLocalizedMessage( class'MessageModeSwitchAbstract', CurrentLinkIndex,,, Class );
}

exec function ToggleMayhemWeaponMode()
{
    // Cycle BeamModes of the firemode
    CurrentLinkIndex = (Int(AFire.BeamMode)+1) % AFire.EBeamMode.EnumCount;

    AFire.BeamMode = EBeamMode(CurrentLinkIndex);

    SendInfoToClient(CurrentLinkIndex);

    //log("Link beam length ="@CurrentLinkIndex);

    Instigator.ReceiveLocalizedMessage( class'MessageModeSwitchAbstract', CurrentLinkIndex,,, Class);
    PlayerController(Instigator.Controller).ClientPlaySound(ModeCycleSound);
}

Simulated Function SendInfoToClient(int Mode)
{
    AFire.BeamMode = EBeamMode(Mode);
    //AF.FiringSound = AF.M_Sound[Mode];
}

defaultproperties
{
     ModeCycleSound=Sound'WeaponSounds.BaseGunTech.BReload5'
     CurrentLinkIndex=1
     FireModeClass(0)=Class'mayhemweapons.ReflectiveLinkAltFire'
     FireModeClass(1)=Class'mayhemweapons.LinkFireExtendable'
     AmmoClass(0)=Class'mayhemweapons.MayhemLinkAmmo'
     PickupClass=Class'mayhemweapons.MayhemLinkGunPickup'
     AttachmentClass=Class'mayhemweapons.ReflectiveLinkAttachment'
     IconMaterial=Texture'MayhemHudContent.Generic.HUD'
     ItemName="Mayhem Link Gun"
     Skins(0)=Texture'mayhemweapons.LinkGunTex'
}
