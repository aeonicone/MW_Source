class MayhemONSAVRiLAltFire extends MayhemONSAVRiLFire;

function ShakeView()
{
    Super(ProjectileFire).ShakeView();

    if (Instigator != None)
        Instigator.AddVelocity(KickMomentum >> Instigator.Rotation);
}

event ModeDoFire()
{
    if (!AllowFire())
        return;
    //---------------------------------------------------------------
    MayhemONSAVRiL(Weapon).LastAltFireTime = Level.TimeSeconds;
    //---------------------------------------------------------------

    if (MaxHoldTime > 0.0)
        HoldTime = FMin(HoldTime, MaxHoldTime);

    // server
    if (Weapon.Role == ROLE_Authority)
    {
        //----------------------------------------------------
        MayhemONSAVRiL(Weapon).MisslesLeft--;
        //Log("Subtracting a missle,"@MayhemONSAVRiL(Weapon).MisslesLeft$" Missles left");
        if (MayhemONSAVRiL(Weapon).MisslesLeft == 0)
        {
            //Log("MisslesLeft is"@MayhemONSAVRiL(Weapon).MisslesLeft$", Consuming a round.");
            Weapon.ConsumeAmmo(ThisModeNum, Load);
            MayhemONSAVRiL(Weapon).ResetMissleCounter();
            //MayhemONSAVRiL(Weapon).MisslesLeft = MayhemONSAVRiL(Weapon).MAX_MISSLE_LOAD;
        }
        //----------------------------------------------------
        DoFireEffect();
		HoldTime = 0;	// if bot decides to stop firing, HoldTime must be reset first
        if ( (Instigator == None) || (Instigator.Controller == None) )
			return;

        if ( AIController(Instigator.Controller) != None )
            AIController(Instigator.Controller).WeaponFireAgain(BotRefireRate, true);

        Instigator.DeactivateSpawnProtection();
    }

    // client
    if (Instigator.IsLocallyControlled())
    {
        ShakeView();
        PlayFiring();
        FlashMuzzleFlash();
        StartMuzzleSmoke();
    }
    else // server
    {
        ServerPlayFiring();
    }

    Weapon.IncrementFlashCount(ThisModeNum);

    // set the next firing time. must be careful here so client and server do not get out of sync
    if (bFireOnRelease)
    {
        if (bIsFiring)
            NextFireTime += MaxHoldTime + FireRate;
        else
            NextFireTime = Level.TimeSeconds + FireRate;
    }
    else
    {
        NextFireTime += FireRate;
        NextFireTime = FMax(NextFireTime, Level.TimeSeconds);
    }

    Load = AmmoPerFire;
    HoldTime = 0;

    if (Instigator.PendingWeapon != Weapon && Instigator.PendingWeapon != None)
    {
        bIsFiring = false;
        Weapon.PutDown();
    }
}

function DoFireEffect()
{
    Super(ProjectileFire).DoFireEffect();
}

function PlayFiring()
{
    Super(WeaponFire).PlayFiring();
}

defaultproperties
{
     AVRiLMode=MODE_WolfPack
     KickMomentum=(X=-98.000000,Z=49.000000)
     bRecommendSplashDamage=True
     bModeExclusive=True
     FireAnimRate=1.200000
     FireSound=Sound'MayhemWeaponSounds.AVRiL.avrilindiv'
     FireRate=0.800000
     ProjectileClass=Class'mayhemweapons.MayhemONSAVRiLWolf'
}
