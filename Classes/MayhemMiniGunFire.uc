Class MayhemMiniGunFire extends MiniGunFire;

var byte MinigunMode;
var MayhemMiniGun MGun;
var Float CoolRate, CoolRepeatRate;

simulated function bool AllowFire()
{
    Return ( Super.AllowFire() && !MGun.bOverHeated );
}

Function DoFireEffect()
{
    //===============================================================================
    // This Code makes the minigun fire more accurately if the user is crouching

    if ( Bool(Instigator.Controller.bDuck) )
    {
        Spread = Default.Spread * ( 0.6 + ( MinigunMode * 0.15 ) );  // not as much accuracy gain if using super fast fire
    }
    else
        Spread = Default.Spread;

    //===============================================================================

    Super.DoFireEffect();
}

function ShakeView()
{
    local PlayerController P;
    const ShakeAmp = 1.5;

    P = PlayerController(Instigator.Controller);
    if ( P != None )
    {
        // Don't Reset them again if they've already been set.
        if ( /*ShakeRotMag != Default.ShakeRotMag &&*/ MinigunMode == 0 )
        {
            //ShakeRotMag = Default.ShakeRotMag;
            ShakeRotRate = Default.ShakeRotRate;
            //ShakeRotTime = Default.ShakeRotTime;
            //ShakeOffSetMag = Default.ShakeOffSetMag;
            ShakeOffSetRate = Default.ShakeOffSetRate;
            //ShakeOffSetTime = Default.ShakeOffSetTime;
        }
        else if ( /*ShakeRotMag == Default.ShakeRotMag &&*/ MinigunMode == 1 )
        {
            //ShakeRotMag *= ShakeAmp;
            ShakeRotRate = Default.ShakeRotRate * ShakeAmp;
            //ShakeRotTime *= 0.8;
            //ShakeOffSetMag *= ShakeAmp;
            ShakeOffSetRate = Default.ShakeOffSetRate * ShakeAmp;
            //ShakeOffSetTime *= 0.8;
        }

        P.WeaponShakeView(ShakeRotMag, ShakeRotRate, ShakeRotTime, ShakeOffsetMag, ShakeOffsetRate, ShakeOffsetTime);
    }
}

Simulated Function PostBeginPlay()
{
    Super.PostBeginPlay();
    MGun = MayhemMiniGun(Weapon);
    SetTimer(CoolRepeatRate, true);
}

Function ChangeHeatBy(Float Rate)
{
    MGun.CurrentHeatLevel = FClamp( MGun.CurrentHeatLevel + Rate, 0, 1 );
}

Function Timer()
{
    Super.Timer();

    if ( Level.NetMode != NM_DedicatedServer ) // Heat is a ClientSide variable only.
    {
        if ( MGun.bOverHeated || MGun.CurrentHeatLevel > 0 )
        {
            // Determine The Cooling Rate -------------------
            
            If ( !bIsFiring )
                CoolRate = Default.CoolRate;
            else
                CoolRate = Default.CoolRate * 0.50;

            If ( Weapon.PhysicsVolume.bWaterVolume ) // not true only if completely submerged underwater.
                CoolRate *= 4.23;

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

function StartBerserk()
{
    if ( (Level.GRI != None) && (Level.GRI.WeaponBerserk > 1.0) )
	return;
    Super.StartBerserk();
    ModBerserkDamage(1.33);
}

function StopBerserk()
{
    if ( (Level.GRI != None) && (Level.GRI.WeaponBerserk > 1.0) )
	return;
    Super.StopBerserk();
    ModBerserkDamage(1.0);
}

function StartSuperBerserk()
{
    Super.StartSuperBerserk();
    ModBerserkDamage(1.5);
}

function ModBerserkDamage(float DMod)
{
    DamageMin = Default.DamageMin * DMod;
    DamageMax = Default.DamageMax * DMod;
}

defaultproperties
{
     CoolRate=0.004000
     CoolRepeatRate=0.020000
     DamageType=Class'mayhemweapons.DamageTypeMayhemMiniGun'
     AmmoClass=Class'mayhemweapons.MayhemMinigunAmmo'
}
