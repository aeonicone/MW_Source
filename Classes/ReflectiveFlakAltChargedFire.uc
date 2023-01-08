class ReflectiveFlakAltChargedFire extends ReflectiveFlakAltFire;

var() float mHoldSpeedMin;
var() float mHoldSpeedMax;
var() float mHoldSpeedGainPerSec;
var() float mHoldClampMax;

function PostBeginPlay()
{
     Super.PostBeginPlay();
     mHoldClampMax = (mHoldSpeedMax - mHoldSpeedMin) / mHoldSpeedGainPerSec;
}

function projectile SpawnProjectile(Vector Start, Rotator Dir)
{
    local Projectile FS; // FS For Flak Shell

    if (ProjectileClass != None)
        FS = Super.SpawnProjectile(Start, Dir);

    if( FS == None )
        return None;

    if ( AIController(Instigator.Controller) == None )
    {
        FS.Speed = mHoldSpeedMin + HoldTime * mHoldSpeedGainPerSec;
        FS.Speed = FClamp(FS.Speed, mHoldSpeedMin, mHoldSpeedMax);
        //FS.Velocity += FS.Speed * Normal(FS.Velocity);   // pushes in direction of toss
        FS.Velocity += FS.Speed * Vector(Dir);             // pushes in direction fired.
    }
    //log("**************Velocity measuring logs*******************************");
    //log("Speed Added ="@FS.Speed);
    //log("Total Speed ="@FS.Speed+FS.Default.Speed);

    return FS;
}

function StartBerserk()
{
    Super.StartBerserk();
    mHoldSpeedGainPerSec = default.mHoldSpeedGainPerSec * 1.5;
    mHoldClampMax = (mHoldSpeedMax - mHoldSpeedMin) / mHoldSpeedGainPerSec;
}

function StopBerserk()
{ 
    Super.StopBerserk();
    mHoldSpeedGainPerSec = default.mHoldSpeedGainPerSec;
    mHoldClampMax = (mHoldSpeedMax - mHoldSpeedMin) / mHoldSpeedGainPerSec;
}

function StartSuperBerserk()
{
    Super.StartSuperBerserk();
    mHoldSpeedGainPerSec = default.mHoldSpeedGainPerSec * Level.GRI.WeaponBerserk;
    mHoldClampMax = (mHoldSpeedMax - mHoldSpeedMin) / mHoldSpeedGainPerSec;
}

defaultproperties
{
     mHoldSpeedMin=-160.000000
     mHoldSpeedMax=1800.000000
     mHoldSpeedGainPerSec=1960.000000
     bFireOnRelease=True
     AmmoClass=Class'mayhemweapons.MayhemFlakAmmo'
}
