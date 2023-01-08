class MayhemMinigun extends Minigun
    HideDropDown;

#exec Texture Import Name=newminigun File=Textures\newminigun.tga

var Sound ModeCycleSound;
var byte CurrentMiniGunIndex;
var float CurrentHeatLevel,
          LastPutDown;
var bool bOverHeated,
         bHeatWarning;   // AI Variable

replication
{
    /* the client can call this function on the server*/
    reliable if ( Role < ROLE_Authority )
        ToggleMayhemWeaponMode;
        
    Reliable if ( bNetDirty && ( Role < ROLE_Authority ) )
        bOverHeated;

    Reliable if ( Role == ROLE_Authority )
        UpdateClientSide;

    /*Server replicates this to the client whenever there is a status change*/
    reliable if ( bNetDirty  && (Role == ROLE_Authority) )
        CurrentMinigunIndex;
}

simulated function float ChargeBar()
{
    return FMin( 1 , CurrentHeatLevel );
}

/* BestMode()
choose between regular or alt-fire
*/
function byte BestMode()
{
    local float EnemyDist;
    local bot B;

    B = Bot(Instigator.Controller);
    if ( (B == None) || (B.Enemy == None) )
        return 0;

    if ( FireMode[0].bIsFiring )
    {
	if (bHeatWarning)
	    SwitchToMode(0);
        return 0;
    }
    else if ( FireMode[1].bIsFiring )
	return 1;

    EnemyDist = VSize(B.Enemy.Location - Instigator.Location);
    if ( EnemyDist < 700 && B.Skill + FRand() * 3 > 3 )
    {
        if (!bHeatWarning)
            SwitchToMode(1);
        else
            SwitchToMode(0);
        Return 0;
    }
    if ( EnemyDist < 2000 )
    {
        SwitchToMode(0);
        return 0;
    }
    else if ( EnemyDist < 3000 )
        SwitchToMode(0);
    else if ( EnemyDist < 6000 && B.Skill + FRand() * 3 > 3)
    {
        if (Vehicle(B.MoveTarget) == None)
            SwitchToMode(1);
        Else
            SwitchToMode(0); // Better for vehicles at this distance.
    }
    else
        SwitchToMode(1);
    Return 1;
}

Function SwitchToMode(byte Mode)
{
    If ( CurrentMiniGunIndex != Mode )
    {
        CurrentMiniGunIndex = Mode;
        ToggleMayhemWeaponMode();
    }
}
// end AI Interface

simulated function BringUp(optional Weapon PrevWeapon)
{
    local MayhemMiniGunFire PF;
    local Float CoolAmtPerSecond, TotalCoolAmount, SecondsForCompleteCool;

    Super.BringUp(PrevWeapon);
    if ( Instigator.IsHumanControlled() )
        Instigator.ReceiveLocalizedMessage( class'MessageModeSwitchAbstract', CurrentMinigunIndex,,, Class );

    PF = MayhemMiniGunFire(FireMode[0]);

    if ( CurrentHeatLevel > 0 )
    {
        CoolAmtPerSecond = PF.CoolRate * ( PF.CoolRepeatRate / PF.CoolRepeatRate ** 2.f );
        //Log("CoolAmtPerSecond ="@CoolAmtPerSecond);
        SecondsForCompleteCool = 1.0 / CoolAmtPerSecond;
        //Log("SecondsForCompleteCool ="@SecondsForCompleteCool);
        TotalCoolAmount = ( ( Level.TimeSeconds - LastPutDown ) * CoolAmtPerSecond ) / SecondsForCompleteCool;
        //Log("TotalCoolAmount ="@TotalCoolAmount);
        CurrentHeatLevel = FMax( CurrentHeatLevel - TotalCoolAmount, 0 );
    }
}

Simulated Function Bool PutDown()
{
    LastPutDown = Level.TimeSeconds;
    Return Super.PutDown();
}

// Mode Toggling ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
exec function ToggleMayhemWeaponMode()
{
    if ( Instigator.IsHumanControlled() )
    {
        if ( Firemode[0].bIsFiring || FireMode[1].bIsFiring )
            Return;

        CurrentMiniGunIndex = ( CurrentMiniGunIndex + 1 ) % 2;

        Instigator.ReceiveLocalizedMessage( class'MessageModeSwitchAbstract', CurrentMiniGunIndex,,, Class);
        PlayerController(Instigator.Controller).ClientPlaySound(ModeCycleSound);
    }

    SwitchFireModes(CurrentMiniGunIndex);
}

function SwitchFireModes(byte Mode)  // This function actually switches the fire modes.
{
    FireMode[0] = None;
    FireMode[1] = None;

    PickFireClasses(Mode);

    RebuildFireMode();

    UpdateClientSide(Mode);
}

simulated Function UpdateClientSide(byte mode)
{
    CurrentMinigunIndex = mode;

    FireMode[0] = None;
    FireMode[1] = None;

    PickFireClasses(Mode);

    RebuildFireMode();
}

Simulated Function PickFireClasses(byte Mode)
{
    if ( Mode == 1 )
    {
        FireModeClass[0] = class'MayhemMiniGunSuperFire';
        FireModeClass[1] = Class'MayhemMiniGunAltPrecisionFire';
    }
    else
    {
        FireModeClass[0] = class'MayhemMiniGunFire';
        FireModeClass[1] = Class'MayhemMiniGunAltFire';
    }
}

Simulated function RebuildFireMode()  // based on postbeginplay function.
{
    local int m;
    Super.PostBeginPlay();
    for (m = 0; m < NUM_FIRE_MODES; m++)
    {
        if (FireModeClass[m] != None)
        {
            FireMode[m] = new(self) FireModeClass[m];
            if ( FireMode[m] != None )
				AmmoClass[m] = FireMode[m].AmmoClass;
        }
     }
     InitWeaponFires();

     for (m = 0; m < NUM_FIRE_MODES; m++)
    {
        if (FireMode[m] != None)
        {
            FireMode[m].ThisModeNum = m;
            FireMode[m].Weapon = self;
            FireMode[m].Instigator = Instigator;
            FireMode[m].Level = Level;
            FireMode[m].Owner = self;
			FireMode[m].PreBeginPlay();
			FireMode[m].BeginPlay();
			FireMode[m].PostBeginPlay();
			FireMode[m].SetInitialState();
			FireMode[m].PostNetBeginPlay();
			// Added
			FireMode[m].InitEffects();
		}
    }

	if ( Level.bDropDetail || (Level.DetailMode == DM_Low) )
		MaxLights = Min(4,MaxLights);

	if ( SmallViewOffset == vect(0,0,0) )
		SmallViewOffset = Default.PlayerviewOffset;

	if ( SmallEffectOffset == vect(0,0,0) )
		SmallEffectOffset = EffectOffset + Default.PlayerViewOffset - SmallViewOffset;

	if ( bUseOldWeaponMesh && (OldMesh != None) )
	{
		bInitOldMesh = true;
		LinkMesh(OldMesh);
	}
	if ( Level.GRI != None )
		CheckSuperBerserk();
}
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

defaultproperties
{
     ModeCycleSound=Sound'WeaponSounds.BaseGunTech.BReload3'
     FireModeClass(0)=Class'mayhemweapons.MayhemMiniGunFire'
     FireModeClass(1)=Class'mayhemweapons.MayhemMiniGunAltFire'
     bShowChargingBar=True
     AmmoClass(0)=Class'mayhemweapons.MayhemMinigunAmmo'
     PickupClass=Class'mayhemweapons.MayhemMiniGunPickup'
     AttachmentClass=Class'mayhemweapons.MayhemMiniGunAttachment'
     IconMaterial=Texture'MayhemHudContent.Generic.HUD'
     ItemName="Mayhem Minigun"
     Skins(0)=Texture'mayhemweapons.newminigun'
}
