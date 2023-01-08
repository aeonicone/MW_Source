class MayhemBioFire extends BioFire;

const CM = Class'ColorManager';

var config enum EBioMode
{
    MODE_Standard,
    MODE_Flubber,
    MODE_Splitter
} BioMode;

event modeDoFire()
{
    MayhemBioRifle(Weapon).LastPrimFireTime = Level.TimeSeconds;
    Super.ModeDoFire();
}

function projectile SpawnProjectile(Vector Start, Rotator Dir)
{
    local Projectile p;

    if( ProjectileClass != None )
        p = Weapon.Spawn(CM.Default.GlobClass[BioMode],,, Start, Dir);

    if( p == None )
        return None;

    p.Damage *= DamageAtten;
    return p;
}

defaultproperties
{
     AmmoClass=Class'mayhemweapons.MayhemBioAmmo'
}
