class MayhemONSAVRiL extends ONSAVRiL config(User)
    HideDropDown;

#exec Texture Import Name=newavril File=Textures\newavril.tga

var byte CurrentAVRiLIndex;
var Sound ModeCycleSound;
var Float LastAltFireTime;
var Bool bBarIsZero;   // When out of ammo, out of missles left too.
var bool bUseWolfPack; // AI Variable
var byte MisslesLeft;  // missles left before consuming a round of ammo
const MAX_MISSLE_LOAD = 5;

replication
{
    /* the client can call this function on the server*/
    reliable if ( Role < ROLE_Authority )
        ToggleMayhemWeaponMode;

    Reliable if ( Role == ROLE_Authority )
        UpdateClientSide, SetBarZero;

    /*Server replicates this to the client whenever there is a status change*/
    reliable if ( bNetDirty && (Role == ROLE_Authority) )
        MisslesLeft, bBarIsZero, CurrentAVRiLIndex;
}

simulated function float ChargeBar() // Will need a different variable to use as 0 until reloaded, put in the playfiring function
{
    if ( CurrentAVRiLIndex == 1 && !bBarIsZero)
        return FMin(MisslesLeft / Float(MAX_MISSLE_LOAD), 0.999999); // Second argument is .999999 so that it doesn't flash and blink rapidly when full
    Return 0;
}

// Missle bar ammo corrections -------------------------------------------------------------------
/*  Whenever a round of ammo is used up in the alt fire, the charge bar that shows the amount of
    missles left is reset to a full bar.  These functions are modified from Weapon.uc to
    Tell when the bar should be zero (out of ammo completely), or reset the ammo bar to full when
    ammo is picked up or increased. */

simulated function OutOfAmmo()
{
    bBarIsZero = True;
}

simulated function FillToInitialAmmo()
{
    bBarIsZero = False;
    SetBarZero(False);
    Super.FillToInitialAmmo();
}

function bool AddAmmo(int AmmoToAdd, int Mode)
{
    bBarIsZero = False;
    SetBarZero(False);
    Return Super.AddAmmo(AmmoToAdd, Mode);
}

Simulated Function SetBarZero(bool bSet)
{
    bBarIsZero = bSet;
}

simulated function MaxOutAmmo()
{
    Super.MaxOutAmmo();
    bBarIsZero = False;
}

simulated function SuperMaxOutAmmo()
{
    Super.SuperMaxOutAmmo();
    bBarIsZero = False;
}

Function ResetMissleCounter()
{
    MisslesLeft = MAX_MISSLE_LOAD;
}

// ----------------------------------------------------------------------------------------------

Simulated Function PostBeginPlay()
{
    Super.PostBeginPlay();
    MisslesLeft = MAX_MISSLE_LOAD;
}


// AI InterFace -----------------------------------
function byte BestMode()
{
    local Bot B;

    if ( bUseWolfPack )
    {
        B = Bot(Instigator.Controller);

        if ( B == None || B.Enemy == None )
            Return 0;

        If ( ( B.Target != None ) && DestroyableObjective(B.Target) == None )
        {
            if ( ( VSize( B.Enemy.Location - Instigator.Location ) < 600 )
              && ( Instigator.Location.Z - B.Enemy.Location.Z < -50 ) )
                Return int( FRand() > 0.75 );
        }
        Return 1;
    }
    return 0;
}

function SwitchToMode(byte Mode)
{
   If ( CurrentAVRiLIndex != Mode )
   {
       CurrentAVRiLIndex = Mode;
       ToggleMayhemWeaponMode();
   }
}

function float GetAIRating()
{
    local Bot B;
    local float EnemyDist, Rating, ZDiff;

    B = Bot(Instigator.Controller);
    if ( (B == None) || (B.Enemy == None) )
	return AIRating;

    if (Vehicle(B.Enemy) == None)  //AI code from rocket launcher inserted here
    {
        bUseWolfPack = true;
        SwitchToMode(1);
        // if standing on a lift, make sure not about to go around a corner and lose sight of target
        // (don't want to blow up a rocket in bot's face)
        if ( (Instigator.Base != None) && (Instigator.Base.Velocity != vect(0,0,0))
             && !B.CheckFutureSight(0.1) )
               return 0.1;

	EnemyDist = VSize(B.Enemy.Location - Instigator.Location);
	Rating = AIRating;

	// don't pick rocket launcher if enemy is too close
	if ( EnemyDist < 360 )
	{
	    if ( Instigator.Weapon == self )
	    {
		// don't switch away from rocket launcher unless really bad tactical situation
		if ( (EnemyDist > 250) || ((Instigator.Health < 50) && (Instigator.Health < B.Enemy.Health - 30)) )
		     return Rating;
	    }
	    return 0.05 + EnemyDist * 0.001;
	}

	// rockets are good if higher than target, bad if lower than target
	ZDiff = Instigator.Location.Z - B.Enemy.Location.Z;
	if ( ZDiff > 120 )
		Rating += 0.125;
	else if ( ZDiff < -160 )
		Rating -= 0.35;
	else if ( ZDiff < -80 )
		Rating -= 0.05;
	if ( (B.Enemy.Weapon != None) && B.Enemy.Weapon.bMeleeWeapon && (EnemyDist < 2500) )
		Rating += 0.125;

	return Rating;
    }

    SwitchToMode(0);
    Rating = AIRating;
    ZDiff = Instigator.Location.Z - B.Enemy.Location.Z;
    if ( ZDiff < -200 )
        Rating += 0.1;
    EnemyDist = VSize(B.Enemy.Location - Instigator.Location);
    if ( EnemyDist > 2000 )
        return ( FMin(2.0,Rating + (EnemyDist - 2000) * 0.0002) );

    return Rating;
}

function float SuggestAttackStyle()
{
    local float EnemyDist;
    
    if ( CurrentAVRiLIndex == 0 )   // be more defensive if weapon armed with anti vehicle rocket.
        return Super.SuggestAttackStyle(); // -0.4;
    
    // else, use rocket launcher's Attack style:
    // recommend backing off if target is too close
    EnemyDist = VSize(Instigator.Controller.Enemy.Location - Owner.Location);
    if ( EnemyDist < 750 )
    {
        if ( EnemyDist < 500 )
	    return -1.5;
        else
	    return -0.7;
    }
    else if ( EnemyDist > 1600 )
	return 0.5;
    else
        return -0.1;
}

function float SuggestDefenseStyle()
{
    if ( CurrentAVRiLIndex == 0 )   // use regular suggested defense style if weapon is armed with anti vehicle rocket.
        return Super.SuggestDefenseStyle(); // 0.5;
    return 0.0;                // else, just act like if they had a rocket launcher.
}
// End AI Interface --------------------------------

simulated function WeaponTick(float deltaTime) 
{
    If ( CurrentAVRiLIndex != 1 )     // Disable lock ons when AVRiL is using wolfpack
        Super.WeaponTick(DeltaTime);
}

simulated function BringUp(optional Weapon PrevWeapon)
{
    Super.BringUp(PrevWeapon);
    if ( Instigator.IsHumanControlled() )
        Instigator.ReceiveLocalizedMessage( class'MessageModeSwitchAbstract', CurrentAVRiLIndex,,, Class );
}

// Mode Toggling ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
exec function ToggleMayhemWeaponMode()
{
    local MayhemONSAVRiLFire PF;

    //if ( FireMode[1].bIsFiring ) // prevents an exploit
    //    return;

    if ( PlayerController(Instigator.Controller) != None )
    {
        PF = MayhemONSAVRiLFire(FireMode[0]);

        CurrentAVRiLIndex = (PF.AVRiLMode+1) % PF.EAVRiLMode.EnumCount;

        Instigator.ReceiveLocalizedMessage( class'MessageModeSwitchAbstract', CurrentAVRiLIndex,,, Class);
        PlayerController(Instigator.Controller).ClientPlaySound(ModeCycleSound);
    }

    GotoState('PendingToggle');
}

function float RefireWaitTime()
{
    // This function returns the amount of time until the Avril can fire again.
    Return FMax( LastAltFireTime + FireMode[1].FireRate - Level.TimeSeconds,
                 MayhemONSAVRiLFire(FireMode[0]).LastFireTime + FireMode[0].FireRate - Level.TimeSeconds );
}

function SwitchFireModes(byte Mode)  // This function actually switches the fire modes.
{
    MayhemONSAVRiLFire(FireMode[0]).AVRiLMode = EAVRiLMode(Mode);

    FireMode[1] = None;

    PickAltFireClass(Mode);
    RebuildFireMode(1);

    FireMode[0].bModeExclusive = ( Mode == 1 );
    FireMode[0].bRecommendSplashDamage = FireMode[0].bModeExclusive;
    bShowChargingBar = FireMode[0].bModeExclusive;

    FireMode[0].FireSound = GetNewFireSound(Mode);

    UpdateClientSide(Mode);
}

Function Sound GetNewFireSound(byte mode)
{
    if ( Mode == 0 )
        Return FireMode[0].Default.FireSound;
    Return MayhemONSAVRiLFire(FireMode[0]).WolfFireSound;
}

simulated Function UpdateClientSide(byte mode)
{
    CurrentAVRiLIndex = mode;
    FireMode[1] = None;

    PickAltFireClass(Mode);
    RebuildFireMode(1);

    FireMode[0].FireSound = GetNewFireSound(Mode);
    FireMode[0].bModeExclusive = ( Mode == 1 );
    bShowChargingBar = FireMode[0].bModeExclusive;
}

Simulated Function PickAltFireClass(byte Mode)
{
    if ( Mode == 1 )
        FireModeClass[1] = Class'MayhemONSAVRiLAltFire';
    else
    {
        if( Instigator.Controller.IsA( 'PlayerController' ) )
            PlayerController(Instigator.Controller).EndZoom();
        FireModeClass[1] = Class'Onslaught.ONSAVRiLAltFire';
    }
}

Simulated function RebuildFireMode(byte i)  // based on postbeginplay function, except only handles a chosen firemode.
{
    if (FireModeClass[i] != None)
    {
        FireMode[i] = new(self) FireModeClass[i];
        if ( FireMode[i] != None )
		AmmoClass[i] = FireMode[i].AmmoClass;
    }

    InitWeaponFires();

    if (FireMode[i] != None)
    {
            FireMode[i].ThisModeNum = i;
            FireMode[i].Weapon = self;
            FireMode[i].Instigator = Instigator;
            FireMode[i].Level = Level;
            FireMode[i].Owner = self;
			FireMode[i].PreBeginPlay();
			FireMode[i].BeginPlay();
			FireMode[i].PostBeginPlay();
			FireMode[i].SetInitialState();
			FireMode[i].PostNetBeginPlay();
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

// States -----------------------------------
auto state Ready
{
}

state PendingToggle
{
  Begin:
    Sleep( RefireWaitTime() );
    SwitchFireModes(CurrentAVRiLIndex);
    GotoState( 'Ready' );
}
// -------------------------------------------

defaultproperties
{
     ModeCycleSound=Sound'WeaponSounds.BaseGunTech.BReload2'
     BaseMaterial=Texture'mayhemweapons.newavril'
     FireModeClass(0)=Class'mayhemweapons.MayhemONSAVRiLFire'
     PickupClass=Class'mayhemweapons.MayhemONSAVRiLPickup'
     AttachmentClass=Class'mayhemweapons.MayhemONSAVRiLAttachment'
     IconMaterial=Texture'MayhemHudContent.Generic.HUD'
     ItemName="Mayhem AVRiL"
     Skins(0)=Texture'mayhemweapons.newavril'
}
