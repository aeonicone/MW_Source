Class MayhemONSGrenadeProjectileProx extends MayhemONSGrenadeProjectile;

simulated function HitWall( vector HitNormal, actor Wall )
{
    if (Wall != None)
    {
        Stick(Wall, Location);
        return;
    }
    SetPhysics(PHYS_None);
    SetRotation(Rotator(HitNormal));
}

defaultproperties
{
}
