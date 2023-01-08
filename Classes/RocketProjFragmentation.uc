Class RocketProjFragmentation extends RocketProjAbstract;

simulated function Explode(vector HitLocation, vector HitNormal)
{
    local vector start;
    local rotator rot;
    local byte i, TotalShrapnelToSpawn;
    local RocketProjFragmentShrapnel Shrapnel;

    Super.Explode(HitLocation, HitNormal);

    start = Location + 10 * HitNormal;
    TotalShrapnelToSpawn = 8; // Set number of shrapnel pieces here.


    if ( Role == ROLE_Authority )
    {
        for (i=0; i < TotalShrapnelToSpawn + 1; i++)
	{
	    rot = Rotation;
	    rot.yaw   += FRand()*32000-16000;
	    rot.pitch += FRand()*32000-16000;
	    rot.roll  += FRand()*32000-16000;
	    Shrapnel = Spawn( class'RocketProjFragmentShrapnel',, '', Start, rot);
	}
    }
    Destroy();
}

/*simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
    if ( Level.NetMode != NM_DedicatedServer)
	Corona = Spawn(class'RocketCorona',self);
}*/

defaultproperties
{
     AirTrailClass=Class'mayhemweapons.EffectRocketFragTrail'
     AirExplosionClass=Class'mayhemweapons.EffectRocketFragExplosion'
     AirExplosionSound=Sound'MayhemWeaponSounds.Rocket.fragmentation'
     AirVolumeMult=4.000000
     WaterVolumeMult=3.500000
     Damage=50.000000
     DamageRadius=340.000000
}
