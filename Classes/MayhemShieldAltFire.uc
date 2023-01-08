Class MayhemShieldAltFire extends ShieldAltFire;
const FireModeNum = 1;
Var Float AmmoConsumeTime;

function Timer()
{
    if (!bIsFiring)
    {
        SetTimer(AmmoRegenTime, true);
        	RampTime = 0;
        if ( !Weapon.AmmoMaxed(1) )
            Weapon.AddAmmo(1,FireModeNum);
        else
            SetTimer(0, false); // ammo maxed.
    }
    else
    {
        SetTimer(AmmoConsumeTime, True);
        if ( !Weapon.ConsumeAmmo(FireModeNum,1) )
        {
            if (Weapon.ClientState == WS_ReadyToFire)
                Weapon.PlayIdle();
            StopFiring();  // Ran out of ammo
        }
        else
		RampTime += AmmoRegenTime;
    }

	SetBrightness(false);
}

function StartBerserk()
{
    Super.StartBerserk();
    MayhemShieldGun(Weapon).SetShielding(1.33);
}

function StopBerserk()
{
    Super.StopBerserk();
    MayhemShieldGun(Weapon).SetShielding(1.0);
}

function StartSuperBerserk()
{
    Super.StartSuperBerserk();
    MayhemShieldGun(Weapon).SetShielding(1.5);
}

defaultproperties
{
     AmmoConsumeTime=0.230000
     AmmoRegenTime=0.060000
     FireRate=0.400000
     AmmoPerFire=5
}
