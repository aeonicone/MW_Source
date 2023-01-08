class MayhemONSGrenadeFire extends ONSGrenadeFire;

var enum EGrenadeType
{
    TYPE_Standard,
    TYPE_Sticky
} GrenadeMode;

var class<ONSGrenadeProjectile> GrenadeClass[3];

var() float mHoldSpeedMin;
var() float mHoldSpeedMax;
var() float mHoldSpeedGainPerSec;
var() float mHoldClampMax;

function PostBeginPlay()
{
     Super.PostBeginPlay();
     mHoldClampMax = (mHoldSpeedMax - mHoldSpeedMin) / mHoldSpeedGainPerSec;
}

function Projectile SpawnProjectile(Vector Start, Rotator Dir)
{
    local ONSGrenadeProjectile G;
    local ONSGrenadeLauncher GL;

    G = Weapon.Spawn(GrenadeClass[GrenadeMode],,, Start, Dir);
    GL = ONSGrenadeLauncher(Weapon);

    if (G != None && GL != None)
    {
        if ( AIController(Instigator.Controller) == None )
        {
            G.Speed = mHoldSpeedMin + HoldTime * mHoldSpeedGainPerSec;
            G.Speed = FClamp(G.Speed, mHoldSpeedMin, mHoldSpeedMax);
            G.Velocity += G.Speed * Vector(Dir);             // pushes in direction fired. 
            //log("**************Velocity measuring logs*******************************");
            //log("Speed Added ="@G.Speed);
            //log("Total Speed ="@G.Speed+1200);
        }

        G.SetOwner(Weapon);
        GL.Grenades[GL.Grenades.length] = G;
        GL.CurrentGrenades++;
    }

    return G;
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
     GrenadeClass(0)=Class'mayhemweapons.MayhemONSGrenadeProjectile'
     GrenadeClass(1)=Class'mayhemweapons.MayhemONSGrenadeProjectileProx'
     mHoldSpeedMin=-180.000000
     mHoldSpeedMax=2400.000000
     mHoldSpeedGainPerSec=2380.000000
     bFireOnRelease=True
     AmmoClass=Class'mayhemweapons.MayhemONSGrenadeAmmo'
     ProjectileClass=Class'mayhemweapons.MayhemONSGrenadeProjectile'
}
