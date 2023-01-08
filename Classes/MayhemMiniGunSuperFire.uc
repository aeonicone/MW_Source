Class MayhemMiniGunSuperFire extends MayhemMiniGunFire;

var Float HeatUpRate;
var Sound OverHeatSound;

Function ModeDoFire()
{
    If ( !AllowFire() )
        Return;

    if ( Level.NetMode != NM_DedicatedServer )
        IncreaseHeat();

    Super.ModeDoFire();
}

Function IncreaseHeat()  // never done by dedicated server.
{
    If ( !Weapon.PhysicsVolume.bWaterVolume )
    {
        HeatUpRate = Default.HeatUpRate;
    }
    else
        HeatUpRate = Default.HeatUpRate * 0.3333;

    ChangeHeatBy(HeatUpRate);

    if ( MGun.CurrentHeatLevel >= 0.90 )
        MGun.bHeatWarning = True;

    If ( MGun.CurrentHeatLevel >= 1 )
    {
        MGun.bOverHeated = True;
        if ( PlayerController(Instigator.Controller) != None )
        {
             PlayerController(Instigator.Controller).bFire = 0;
             PlayerController(Instigator.Controller).ClientPlaySound(OverHeatSound);
        }
        StopFiring();
    }
}

Function Timer()
{
    Super(MinigunFire).Timer();

    if ( Level.NetMode != NM_DedicatedServer ) // Heat is a ClientSide variable only.
    {
        if ( ( !bIsFiring || MGun.bOverHeated ) && MGun.CurrentHeatLevel > 0 )
        {
            // Determine The Cooling Rate -------------------
            If ( !Weapon.PhysicsVolume.bWaterVolume ) // not true only if completely submerged underwater.
                CoolRate = Default.CoolRate;
            else
                CoolRate = Default.CoolRate * 4.23;

            // Cool The Barrels down ------------------------------------------------
            ChangeHeatBy(-1 * CoolRate);
        }

        // Nullify overheated Status if it was overheated ---------------
        if ( MGun.CurrentHeatLevel < 0.36 )
        {
            MGun.bOverHeated = False;
            MGun.bHeatWarning = False;
        }
    }
}

defaultproperties
{
     HeatUpRate=0.013000
     OverHeatSound=Sound'IndoorAmbience.door14'
     MinigunMode=1
     BarrelRotationsPerSec=5.000000
     FiringSound=Sound'MayhemWeaponSounds.Minigun.newmini'
     MinigunSoundVolume=250
     WindUpTime=0.500000
     DamageMin=5
     DamageMax=6
     PreFireTime=0.500000
     FireLoopAnimRate=15.000000
     Spread=0.100000
}
