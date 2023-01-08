class RocketProjFragmentationSeeking extends RocketProjFragmentation;

var Actor Seeking;
var vector InitialDir;

replication
{
    reliable if( bNetInitial && (Role==ROLE_Authority) )
        Seeking, InitialDir;
}

simulated function Timer()
{
    local vector ForceDir;
    local float VelMag;
    local rotator rVelocity;

    if ( InitialDir == vect(0,0,0) )
        InitialDir = Normal(Velocity);
         
	Acceleration = vect(0,0,0);
    Super.Timer();
    if ( (Seeking != None) && (Seeking != Instigator) )
    {
		// Do normal guidance to target.
		ForceDir = Normal(Seeking.Location - Location);
		
		if( (ForceDir Dot InitialDir) > 0 )
		{
			VelMag = VSize(Velocity);
		
			// track vehicles better
			if ( Seeking.Physics == PHYS_Karma )
				ForceDir = Normal(ForceDir * 0.8 * VelMag + Velocity);
			else
				ForceDir = Normal(ForceDir * 0.5 * VelMag + Velocity);
			Velocity =  VelMag * ForceDir;  
			Acceleration += 5 * ForceDir; 
		}
		// Update rocket so it faces in the direction its going.
	rVelocity = Rotator(Velocity);
        SetRotation(rVelocity);
	if ( AirTrailEmitter != None )
             AirTrailEmitter.SetRotation(rVelocity);
        else if ( WaterTrailEmitter != None )
             WaterTrailEmitter.SetRotation(rVelocity);

    }
}

simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
    SetTimer(0.1, true);
}

defaultproperties
{
     MyDamageType=Class'mayhemweapons.DamageTypeRocketFragmentation'
     LifeSpan=10.000000
}
