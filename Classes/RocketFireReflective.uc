Class RocketFireReflective extends RocketMultiFire;

function Projectile SpawnProjectile(Vector Start, Rotator Dir)
{
    local Projectile p;

    p = MayhemRocketLauncher(Weapon).SpawnPlainProjectile(Start, Dir);
    //p = MayhemRocketLauncher(Weapon).SpawnProjectile(Start, Dir);

    if ( p == None )
        //p = Spawn(class'RocketFireCyclical'.Default.RocketClass[MayhemRocketLauncher(Instigator.Weapon).CurrentRocketIndex],,, Start, Dir);
        p = Spawn(class'RocketProjReflective',,, Start, Dir);

    return p;
}

defaultproperties
{
     bRecommendSplashDamage=False
     AmmoClass=Class'mayhemweapons.MayhemRocketAmmo'
}
