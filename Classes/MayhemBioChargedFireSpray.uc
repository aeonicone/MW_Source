class MayhemBioChargedFireSpray extends BioChargedFire;
const CM = Class'ColorManager';

Function ModeDoFire()
{
    MayhemBioRifle(Weapon).LastPrimFireTime = Level.TimeSeconds;
    Super.ModeDoFire();
}

function DoFireEffect()
{
    local Vector StartProj, StartTrace, X,Y,Z;
    local Rotator R, Aim;
    local Vector HitLocation, HitNormal;
    local Actor Other;
    local int p;
    local int SpawnCount;

    Instigator.MakeNoise(1.0);
    Weapon.GetViewAxes(X,Y,Z);

    StartTrace = Instigator.Location + Instigator.EyePosition();// + X*Instigator.CollisionRadius;
    StartProj = StartTrace + X*ProjSpawnOffset.X;
    if ( !Weapon.WeaponCentered() )
	    StartProj = StartProj + Weapon.Hand * Y*ProjSpawnOffset.Y + Z*ProjSpawnOffset.Z;

    // check if projectile would spawn through a wall and adjust start location accordingly
    Other = Weapon.Trace(HitLocation, HitNormal, StartProj, StartTrace, false);
    if (Other != None)
    {
        StartProj = HitLocation;
    }

    Aim = AdjustAim(StartProj, AimError);

    // Set the Spread here =======================================
    Spread = Default.Spread * FMin( 0.2 + GoopLoad * 0.1, 1.0 );
    // ===========================================================

    //Log("Spread ="@Spread);
    SpawnCount = Max(1, GoopLoad);
    //Log("SpawnCount ="@SpawnCount);

    /* Automatically using Random spreadstyle, for some reason, even though
       i told it to use Random, it went ahead and did no spreadstyle */
    X = Vector(Aim);
    for (p = 0; p < SpawnCount; p++)
    {
        R.Yaw = Spread * (FRand()-0.5);
        R.Pitch = Spread * (FRand()-0.5);
        R.Roll = Spread * (FRand()-0.5);
        SpawnProjectile(StartProj, Rotator(X >> R));
    }
    GoopLoad = 0;
}

function projectile SpawnProjectile(Vector Start, Rotator Dir)
{
    local Projectile Proj;

    GoToState('');

    if ( GoopLoad == 0 )
       Return None;

    Proj = Weapon.Spawn(CM.Default.GlobClass[1],,, Start, Dir);

    if ( Proj != None )
    {
	Proj.Damage *= DamageAtten;
        if ( MayhemBioGlob(Proj) != None )
            MayhemBioGlob(Proj).AdjustSpreadSpeed(GoopLoad);
        Else
            Log("MayhemBioGlob(Glob) == None, unable to adjust spread speed");
    }
    if ( Weapon.AmmoAmount(ThisModeNum) <= 0 )
        Weapon.OutOfAmmo();
    return Proj;
}

defaultproperties
{
     AmmoClass=Class'mayhemweapons.MayhemBioAmmo'
     load=1.000000
     ProjectileClass=Class'mayhemweapons.MayhemBioGlob'
     Spread=2000.000000
}
