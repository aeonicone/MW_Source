class RocketProjStandard extends RocketProjAbstract;

simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
    if ( Level.NetMode != NM_DedicatedServer)
	Corona = Spawn(class'RocketCorona',self);
}

Simulated Function MakeAirTrail()
{
    Super.MakeAirTrail();
    if ( Level.NetMode != NM_DedicatedServer )
    {
        if (Corona != None)
            Corona = Spawn(class'RocketCorona',self);
    }
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
    Super.Explode(Hitlocation,HitNormal);
    Destroy();
}

defaultproperties
{
     ExplodeOffSet=20.000000
     MyDamageType=Class'mayhemweapons.DamageTypeRocketAbstract'
}
