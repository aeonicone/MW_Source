class MayhemBioChargedFire extends BioChargedFire;

const CM = Class'ColorManager';
var int BioMode; // can't make enum biomode like other firemode because weapon class has two enum types confused.
var float LastFireTime;

Event ModeDoFire()
{
    LastFireTime = Level.TimeSeconds;
    Super.ModeDoFire();
}

function projectile SpawnProjectile(Vector Start, Rotator Dir)
{
    local BioGlob Glob;

    GotoState('');

    if (GoopLoad == 0) return None;

    Glob = Weapon.Spawn(CM.Default.GlobClass[BioMode],,, Start, Dir);
    if ( Glob != None )
    {
	Glob.Damage *= DamageAtten;
	Glob.SetGoopLevel(GoopLoad);
	Glob.AdjustSpeed();
	if ( MayhemBioGlob(Glob) != None && GoopLoad > 1 )
	    MayhemBioGlob(Glob).IncreaseLifeSpan(GoopLoad / 2.0);
    }
    GoopLoad = 0;
    if ( Weapon.AmmoAmount(ThisModeNum) <= 0 )
        Weapon.OutOfAmmo();
    return Glob;
}

defaultproperties
{
     AmmoClass=Class'mayhemweapons.MayhemBioAmmo'
}
