class MayhemONSGrenadeLauncher extends ONSGrenadeLauncher
    HideDropDown;
    
#exec Texture Import Name=newgrenadelauncher File=Textures\newgrenadelauncher.tga

var Sound ModeCycleSound; // sound to make when cycling modes
var byte CurrentGrenadeIndex;  // Used to set the primary firemode's GrenadeMode
var bool bDisplayMode;
replication
{
    /* the client can call this function on the server*/
    reliable if ( Role < ROLE_Authority )
        ToggleMayhemWeaponMode;

    /*Server replicates this to the client whenever there is a status change*/
    reliable if ( bNetDirty && (Role == ROLE_Authority) )
        CurrentGrenadeIndex;
}

simulated function float ChargeBar()
{
    return FMin(1,FireMode[0].HoldTime/MayhemONSGrenadeFire(FireMode[0]).mHoldClampMax);
}

/* BestMode()
choose between regular or alt-fire
*/
function byte BestMode()
{
    local int x;
    local Bot B;

    B = Bot(Instigator.Controller);

    FireMode[0].bFireOnRelease = (B == None); // to disable charged fire, if is a Bot.

    if (CurrentGrenades >= MaxGrenades || (AmmoAmount(0) <= 0 && FireMode[0].NextFireTime <= Level.TimeSeconds))
        return 1;

    for (x = 0; x < Grenades.length; x++)
        if (Grenades[x] != None)
            if ( (Pawn(Grenades[x].Base) != None) || (VSize(Grenades[x].Location - B.Enemy.Location) < Grenades[x].DamageRadius - 20.0) )
                return 1;
    return 0;
}

simulated function BringUp(optional Weapon PrevWeapon)
{
    Super.BringUp(PrevWeapon);
    if ( Instigator.IsHumanControlled() )
        Instigator.ReceiveLocalizedMessage( class'MessageModeSwitchAbstract', CurrentGrenadeIndex,,, Class );
}

exec function ToggleMayhemWeaponMode()
{
    local MayhemONSGrenadeFire PrimaryFire;

    PrimaryFire = MayhemONSGrenadeFire(FireMode[0]);

    CurrentGrenadeIndex = (Int(PrimaryFire.GrenadeMode)+1) % PrimaryFire.EGrenadeType.EnumCount;
    PrimaryFire.GrenadeMode = EGrenadeType(CurrentGrenadeIndex);
    Instigator.ReceiveLocalizedMessage( class'MessageModeSwitchAbstract', CurrentGrenadeIndex,,, Class);
    PlayerController(Instigator.Controller).ClientPlaySound(ModeCycleSound);
}

defaultproperties
{
     ModeCycleSound=Sound'WeaponSounds.BaseGunTech.BReload6'
     MaxGrenades=12
     FireModeClass(0)=Class'mayhemweapons.MayhemONSGrenadeFire'
     bShowChargingBar=True
     AmmoClass(0)=Class'mayhemweapons.MayhemONSGrenadeAmmo'
     PickupClass=Class'mayhemweapons.MayhemONSGrenadePickup'
     AttachmentClass=Class'mayhemweapons.MayhemONSGrenadeAttachment'
     IconMaterial=Texture'MayhemHudContent.Generic.HUD'
     ItemName="Mayhem Grenade Launcher"
     Skins(0)=Texture'mayhemweapons.newgrenadelauncher'
}
