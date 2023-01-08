Class MayhemBioRifle Extends BioRifle
    HideDropDown;

#exec Texture Import Name=newbio File=Textures\newbio.tga

var Sound ModeCycleSound; // sound to make when cycling modes
var byte CurrentGlobIndex;
var float LastPrimFireTime;

replication
{
    /* the client can call this function on the server*/
    reliable if ( Role < ROLE_Authority )
        ToggleMayhemWeaponMode;
        
    reliable if ( Role == ROLE_Authority )
        UpdateClientSide;

    /*Server replicates this to the client whenever there is a status change*/
    reliable if ( bNetDirty && (Role == ROLE_Authority) )
        CurrentGlobIndex;
}

// AI Interface
function float GetAIRating()
{
	local Bot B;
	local float EnemyDist;
	local vector EnemyDir;

	B = Bot(Instigator.Controller);
	if ( (B == None) || (B.Enemy == None) )
		return AIRating;

	// if retreating, favor this weapon
	EnemyDir = B.Enemy.Location - Instigator.Location;
	EnemyDist = VSize(EnemyDir);
	if ( EnemyDist > 1500 )
		Return 0.36;  //return 0.1;
	if ( B.IsRetreating() )
		return (AIRating + 0.4);
	if ( (B.Enemy.Weapon != None) && B.Enemy.Weapon.bMeleeWeapon )
		return (AIRating + 0.35);
	if ( -1 * EnemyDir.Z > EnemyDist )
		return AIRating + 0.1;
	if ( EnemyDist > 1000 )
		return 0.42;  //0.35
	return AIRating;
}

/* BestMode()
choose between regular or alt-fire
*/
function byte BestMode()
{
    local Bot B;
    local float EnemyDist;
    local vector EnemyDir;
    local byte ModeQuery;

    B = Bot(Instigator.Controller);
    if ( (B == None) || (B.Enemy == None) )
        return 0;
        
    EnemyDir = B.Enemy.Location - Instigator.Location;
    EnemyDist = VSize(EnemyDir);

    if ( -1 * EnemyDir.Z > EnemyDist )
        ModeQuery = 0;
    else if ( EnemyDist > 1600 )
        ModeQuery = 2;
    else if ( EnemyDist > 1000 )
        ModeQuery = 1;

    SwitchToMode(ModeQuery);

    if ( FRand() < 0.8 )
        return 0;
    return 1;
}

Function SwitchToMode(byte Mode)
{
    If ( CurrentGlobIndex != Mode )
    {
        CurrentGlobIndex = Mode;
        ToggleMayhemWeaponMode();
    }
}
// End AI Interface


simulated function BringUp(optional Weapon PrevWeapon)
{
    Super.BringUp(PrevWeapon);
    if ( Instigator.IsHumanControlled() )
        Instigator.ReceiveLocalizedMessage( class'MessageModeSwitchAbstract', CurrentGlobIndex,,, Class );
}

simulated function bool HasAmmo()
{
    return ( Super.HasAmmo() || ( CurrentGlobIndex == 2 && FireMode[0].bIsFiring ) );
}

exec function ToggleMayhemWeaponMode()
{
    local MayhemBioFire PF;
    local MayhemBioChargedFire AF;

    PF = MayhemBioFire(FireMode[0]);
    AF = MayhemBioChargedFire(FireMode[1]);
    
    if ( Instigator.IsHumanControlled() )
    {
        if (PF != None)
        {
            CurrentGlobIndex = (PF.BioMode+1) % PF.EBioMode.EnumCount;
            PF.BioMode = EBioMode(CurrentGlobIndex);
        }
        else
            CurrentGlobIndex = 0;
    }
    else if ( PF != None )
        PF.BioMode = EBioMode(CurrentGlobIndex);

    UpdateClientSide(CurrentGlobIndex);

    if ( PlayerController(Instigator.Controller) != None )
    {
        Instigator.ReceiveLocalizedMessage( class'MessageModeSwitchAbstract', CurrentGlobIndex,,, Class);
        PlayerController(Instigator.Controller).ClientPlaySound(ModeCycleSound);
    }

    GoToState('PendingToggle');
}

function float RefireWaitTime()
{
    // This function returns the amount of time until the Avril can fire again.
    Return FMax( LastPrimFireTime + FireMode[0].FireRate - Level.TimeSeconds,
                 MayhemBioChargedFire(FireMode[1]).LastFireTime + FireMode[1].FireRate - Level.TimeSeconds );
}

function SwitchFireModes(byte Mode)  // This function actually switches the fire modes.
{
    if ( MayhemBioFire(FireMode[0]) != None )
        MayhemBioFire(FireMode[0]).BioMode = EBioMode(Mode);
    MayhemBioChargedFire(FireMode[1]).BioMode = Mode;

    if ( Mode == 2 || Mode == 0 )
    {
        FireMode[0] = None;

        PickPrimFireClass(Mode);
        RebuildThisFireMode(0);
    }
    UpdateClientSide(Mode);
}

simulated Function UpdateClientSide(byte mode)
{
    CurrentGlobIndex = mode;
    if ( Mode == 2 || Mode == 0 )
    {
        FireMode[0] = None;

        PickPrimFireClass(Mode);
        RebuildThisFireMode(0);
    }
}

Simulated Function PickPrimFireClass(byte Mode)
{
    if ( Mode == 2 )
        FireModeClass[0] = Class'MayhemBioChargedFireSpray';
    else
        FireModeClass[0] = Default.FireModeClass[0];
}

Simulated function RebuildThisFireMode(byte i)  // based on postbeginplay function, except uses one given byte for firemode
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
    SwitchFireModes(CurrentGlobIndex);
    GotoState( 'Ready' );
}
// -------------------------------------------

defaultproperties
{
     ModeCycleSound=Sound'WeaponSounds.BaseGunTech.BReload7'
     FireModeClass(0)=Class'mayhemweapons.MayhemBioFire'
     FireModeClass(1)=Class'mayhemweapons.MayhemBioChargedFire'
     AmmoClass(0)=Class'mayhemweapons.MayhemBioAmmo'
     PickupClass=Class'mayhemweapons.MayhemBioRiflePickup'
     AttachmentClass=Class'mayhemweapons.MayhemBioAttachment'
     IconMaterial=Texture'MayhemHudContent.Generic.HUD'
     ItemName="Mayhem Bio-Rifle"
     Skins(0)=Texture'mayhemweapons.newbio'
}
