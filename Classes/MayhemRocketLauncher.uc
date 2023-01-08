class MayhemRocketLauncher extends RocketLauncher
     HideDropDown;

#exec Texture Import Name=RocketTex File=Textures\RocketTex.tga

var Sound ModeCycleSound; // sound to make when cycling modes
var byte CurrentRocketIndex;  // Used to set the primary firemode's RocketMode
var enum ETrailColor  // Index used to determine trail color for reflective rockets, client-side unique.
{
    TRAIL_IceBlue,
    TRAIL_NeonViolet,
    TRAIL_NeonGreen,
    TRAIL_NeonRed,
    TRAIL_Violet,
    TRAIL_Red,
    TRAIL_Blue,
    TRAIL_Green,
    TRAIL_Yellow,
    TRAIL_Orange,
    TRAIL_White,
    TRAIL_Random,
    TRAIL_Wild
} TrailColor;
replication
{
    /* the client can call this function on the server*/
    reliable if ( Role < ROLE_Authority )
        ToggleMayhemWeaponMode;

    /*Server replicates this to the client whenever there is a status change*/
    reliable if ( bNetDirty && (Role == ROLE_Authority) )
        CurrentRocketIndex;
}

function Projectile SpawnProjectile(Vector Start, Rotator Dir)
{
    local RocketProjStandardSeeking      StandardSeeker;
    local RocketProjFlamingSeeking       FlameSeeker;
    local RocketProjFragmentationSeeking FragSeeker;
    local RocketProj                     RocketProj;
    local bot B;
    Const CM = Class'ColorManager';

    bBreakLock = true;

	// decide if bot should be locked on
	B = Bot(Instigator.Controller);
	if ( (B != None) && (B.Skill > 2 + 5 * FRand()) && (FRand() < 0.6)
		&& (B.Target == B.Enemy) && (VSize(B.Enemy.Location - B.Pawn.Location) > 2000 + 2000 * FRand())
		&& (Level.TimeSeconds - B.LastSeenTime < 0.4) && (Level.TimeSeconds - B.AcquireTime > 1.5) )
	{
		bLockedOn = true;
		SeekTarget = B.Enemy;
	}

    if (bLockedOn && SeekTarget != None)
    {
        switch(CurrentRocketIndex)
        {
             case 0:  FlameSeeker = Spawn(class'RocketProjFlamingSeeking',,, Start, Dir);
                      FlameSeeker.Seeking = SeekTarget;     Break;
             case 1:  FragSeeker = Spawn(class'RocketProjFragmentationSeeking',,, Start, Dir);
                      FragSeeker.Seeking = SeekTarget;      Break;
             default: StandardSeeker = Spawn(class'RocketProjStandardSeeking',,, Start, Dir);
                      StandardSeeker.Seeking = SeekTarget;  Break;
        }

        if ( B != None )
        {
	    //log("LOCKED");
	    bLockedOn = false;
	    SeekTarget = None;
	}

        switch(CurrentRocketIndex)
        {
            Case 0:   Return FlameSeeker;
            case 1:   Return FragSeeker;
            Default:  Return StandardSeeker;
        }
    }
    else
    {
        RocketProj = Spawn(CM.Default.RocketClass[CurrentRocketIndex],,, Start, Dir);
        Return RocketProj;
    }
}

function Projectile SpawnPlainProjectile(Vector Start, Rotator Dir)
{
    local RocketProjReflectiveSeeking SeekingRocket;
    local bot B;

    bBreakLock = true;

	// decide if bot should be locked on
	B = Bot(Instigator.Controller);
	if ( (B != None) && (B.Skill > 2 + 5 * FRand()) && (FRand() < 0.6)
		&& (B.Target == B.Enemy) && (VSize(B.Enemy.Location - B.Pawn.Location) > 2000 + 2000 * FRand())
		&& (Level.TimeSeconds - B.LastSeenTime < 0.4) && (Level.TimeSeconds - B.AcquireTime > 1.5) )
	{
		bLockedOn = true;
		SeekTarget = B.Enemy;
	}

    if (bLockedOn && SeekTarget != None)
    {
        SeekingRocket = Spawn(class'RocketProjReflectiveSeeking',,, Start, Dir);
        SeekingRocket.Seeking = SeekTarget;
        if ( B != None )
        {
		//log("LOCKED");
		bLockedOn = false;
		SeekTarget = None;
	}
        return SeekingRocket;
    }
    else
    {
        return None;
    }
}

simulated function BringUp(optional Weapon PrevWeapon)
{
    Super.BringUp(PrevWeapon);
    if ( Instigator.IsHumanControlled() )
        Instigator.ReceiveLocalizedMessage( class'MessageModeSwitchAbstract', CurrentRocketIndex,,, Class );
}

exec function ToggleMayhemWeaponMode()
{
    local RocketFireCyclical PF; // This is the rocket's Primary FireModeClass.
        
    // Cycle projectiles of the firemode
    PF = RocketFireCyclical(FireMode[0]);

    // Makes the index go like: 0, 1, 2, 0, 1, 2,..... in a circle
    CurrentRocketIndex = (Int(PF.RocketMode)+1) % PF.ERocketType.EnumCount;

    // Change the primary fire's rocketmode to reflect the weapon's current rocket index
    PF.RocketMode = ERocketType(CurrentRocketIndex);

    // Message - Notify client of mode switch
    Instigator.ReceiveLocalizedMessage( class'MessageModeSwitchAbstract', CurrentRocketIndex,,, Class);

    // sound - play mode cycling sound
    PlayerController(Instigator.Controller).ClientPlaySound(ModeCycleSound);
    
    //log("FireMode is"@CurrentRocketIndex$", RocketMode ="@PF.RocketMode);
}

exec function CycleColors()
{
     if (Level.NetMode == NM_StandAlone)
     {
          Default.TrailColor = ETrailColor((Int(Default.TrailColor)+1) % ETrailColor.EnumCount);
          PlayerController(Instigator.Controller).ClientPlaySound(sound'Menusounds.selectj');
          Instigator.ReceiveLocalizedMessage( class'MessageColorSwitchRocketSmoke', int(Default.TrailColor));
     }
}

defaultproperties
{
     ModeCycleSound=Sound'WeaponSounds.BaseGunTech.BReload2'
     TrailColor=Trail_red
     FireModeClass(0)=Class'mayhemweapons.RocketFireCyclical'
     FireModeClass(1)=Class'mayhemweapons.RocketFireReflective'
     AmmoClass(0)=Class'mayhemweapons.MayhemRocketAmmo'
     PickupClass=Class'mayhemweapons.MayhemRocketLauncherPickup'
     AttachmentClass=Class'mayhemweapons.MayhemRocketAttachment'
     IconMaterial=Texture'MayhemHudContent.Generic.HUD'
     ItemName="Mayhem Rocket Launcher"
     Skins(0)=Texture'mayhemweapons.RocketTex'
}
