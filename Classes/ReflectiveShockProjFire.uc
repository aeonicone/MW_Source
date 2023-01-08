Class ReflectiveShockProjFire extends ShockProjFire;

const CM = Class'ColorManager';

function projectile SpawnProjectile(Vector Start, Rotator Dir)
{
    local Projectile p;

    p = MayhemShockRifle(Weapon).SpawnProjectile(Start, Dir);

    if ( (ShockRifle(Instigator.Weapon) != None) && (p != None) )
	ShockRifle(Instigator.Weapon).SetComboTarget(ShockProjectile(P));
    return p;
}

simulated function InitEffects()
{
    FlashEmitterClass = CM.Default.ShockProjFlashEmitter_Class[MayhemShockRifle(Weapon).ShockColor];
    Super.InitEffects();
}

defaultproperties
{
     AmmoClass=Class'mayhemweapons.MayhemShockAmmo'
     ProjectileClass=Class'mayhemweapons.ReflectiveShockProjectile'
     FlashEmitterClass=Class'mayhemweapons.ReflectiveShockProjMuzFlash'
}
