class MayhemFlakCannon extends FlakCannon
    HideDropDown;

#exec Texture Import Name=FlakTex File=Textures\FlakTex.tga

var Sound ModeCycleSound;
var byte CurrentFlakIndex;
var ReflectiveFlakFire PrimFire;

var enum EFlakTrailColor  // Index used to determine trail color for reflective rockets, Standalone only.
{
    FTC_IceBlue,
    FTC_NeonViolet,
    FTC_NeonGreen,
    FTC_NeonRed,
    FTC_Violet,
    FTC_Red,
    FTC_Blue,
    FTC_Green,
    FTC_Yellow,
    FTC_Orange,
    FTC_White,
    FTC_Random,
    FTC_Wild,
    FTC_Group
} FlakTrailColor;

replication
{
    /* the client can call this function on the server*/
    reliable if ( Role < ROLE_Authority )
        ToggleMayhemWeaponMode;

    Reliable if ( Role == ROLE_Authority )
        SendInfoToClient;

    /*Server replicates this to the client whenever there is a status change*/
    reliable if ( bNetDirty && (Role == ROLE_Authority) )
        CurrentFlakIndex;
}

simulated function float ChargeBar()
{
    return FMin( 1, FireMode[1].HoldTime / ReflectiveFlakAltChargedFire(FireMode[1]).mHoldClampMax);
}

simulated Function PostBeginPlay()
{
    Super.PostBeginPlay();
    PrimFire = ReflectiveFlakFire(FireMode[0]);
}
/* BestMode()
choose between regular or alt-fire
*/
function byte BestMode()
{
    local vector EnemyDir;
    local float EnemyDist;
    local bot B;
    local byte ModePick;

    B = Bot(Instigator.Controller);
    if ( (B == None) || (B.Enemy == None) )
        return 0;

    FireMode[1].bFireOnRelease = (B == None); // to disable charged fire.

    EnemyDir = B.Enemy.Location - Instigator.Location;
    EnemyDist = VSize(EnemyDir);
    if ( EnemyDist > 750 )
    {
	if ( EnemyDir.Z < -0.5 * EnemyDist ) // If less than a 30 degree angle down?
	    ModePick = 1;
	else
	    ModePick = 0;
    }
    else if ( (B.Enemy.Weapon != None) && B.Enemy.Weapon.bMeleeWeapon )
        ModePick = 0;
    else if ( (EnemyDist < 400) || (EnemyDir.Z > 30) )
        ModePick = 0;
    else if ( FRand() < 0.65 )
        ModePick = 1;
    else
        ModePick = 0;
        
    If (ModePick == 0)
    {
        CurrentFlakIndex = PickPattern(B.Skill, EnemyDist, EnemyDir.Z);
        ToggleMayhemWeaponMode();
    }

    Return ModePick;
}

function byte PickPattern(float BotSkill, float EnemyDist, float EnemyDirZ)
{
    BotSkill = 0.3 + (BotSkill / 10.f); // percent chance that the bot will pick the optimal shot.
    //Log("EnemyDist ="@EnemyDist);

    // 0 is tight pattern, 1 is regular, 2 is wide.
    if ( EnemyDist > 2500 )
    {
        if ( BotSkill > FRand() + 0.2 ) // lower level bots have easier time figuring out to use tight mode for long shots
            Return 0;
        Return 1;
    }
    else if ( EnemyDist > 1400 )
    {
        if ( BotSkill > FRand() )
            Return 0;
        Return 1;
    }
    else if ( EnemyDist > 450 )
    {
        if ( BotSkill > FRand() )
            Return 1;
        Return 2;         // give further consideration later on...
    }
    else
    {
        if ( BotSkill > FRand() )
            Return 2;
        Return 1;
    }
}

simulated function BringUp(optional Weapon PrevWeapon)
{
    Super.BringUp(PrevWeapon);
    if ( Instigator.IsHumanControlled() )
        Instigator.ReceiveLocalizedMessage( class'MessageModeSwitchAbstract', CurrentFlakIndex,,, Class );
}

exec function ToggleMayhemWeaponMode()
{
    Local bool bIsHuman;
    bIsHuman = Instigator.IsHumanControlled();

    // Cycle Shot patterns of the firemode
    if ( bIsHuman )
        CurrentFlakIndex = (Int(PrimFire.PatternSize)+1) % PrimFire.EPatternSize.EnumCount;

    //log("Changed Index to"@CurrentFlakIndex);

    PrimFire.PatternSize = EPatternSize(CurrentFlakIndex);                            // Adjust Pattern
    PrimFire.FireSound = PrimFire.PatternSound[CurrentFlakIndex];
    PrimFire.TransientSoundVolume = PrimFire.PatternVolume[CurrentFlakIndex];

    SendInfoToClient(CurrentFlakIndex);

    if ( bIsHuman )
    {
        Instigator.ReceiveLocalizedMessage( class'MessageModeSwitchAbstract', CurrentFlakIndex,,, Class); // Message
        PlayerController(Instigator.Controller).ClientPlaySound(ModeCycleSound);             // sound
    }
}

Simulated Function SendInfoToClient(byte Mode)
{
    PrimFire.FireSound = PrimFire.PatternSound[Mode];
    PrimFire.TransientSoundVolume = PrimFire.PatternVolume[Mode];
}

exec function CycleColors()
{
     if (Level.NetMode == NM_StandAlone)
     {
          Default.FlakTrailColor = EFlakTrailColor((Default.FlakTrailColor+1) % EFlakTrailColor.EnumCount);
          PlayerController(Instigator.Controller).ClientPlaySound(sound'Menusounds.selectj');
          Instigator.ReceiveLocalizedMessage( class'MessageColorSwitchFlakTrail', int(Default.FlakTrailColor));
     }
}

defaultproperties
{
     ModeCycleSound=Sound'WeaponSounds.BaseGunTech.BReload3'
     CurrentFlakIndex=1
     FlakTrailColor=FTC_Red
     FireModeClass(0)=Class'mayhemweapons.ReflectiveFlakFire'
     FireModeClass(1)=Class'mayhemweapons.ReflectiveFlakAltChargedFire'
     bShowChargingBar=True
     AmmoClass(0)=Class'mayhemweapons.MayhemFlakAmmo'
     Description="The Trident Defensive Technologies Series 7 Flechette Cannon has been improved with modified firepower. The ionized flechettes of this remake glow with phosphorous chemicals, and are known to burn in random colors.||Payload delivery is achieved through 2 methods.  Spread patterns of ionized flechetes launched directly from the barrel, featuring 3 pattern modes; configureable.  Or via fragmentation grenades that explode on impact, radiating flechettes in all directions.  "
     PickupClass=Class'mayhemweapons.MayhemFlakCannonPickup'
     AttachmentClass=Class'mayhemweapons.MayhemFlakAttachment'
     IconMaterial=Texture'MayhemHudContent.Generic.HUD'
     ItemName="Mayhem Flak Cannon"
     Skins(0)=Texture'mayhemweapons.FlakTex'
}
