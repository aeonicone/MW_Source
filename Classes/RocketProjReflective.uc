class RocketProjReflective extends RocketProjAbstract;

#exec OBJ LOAD FILE=..\Sounds\MayhemWeaponSounds.uax

var float DampeningFactor, NewDamage;
var byte ReflectNum, ReflectMaxNum;
var float AccelerationForce;

replication
{
    reliable if ( bNetInitial && (Role == ROLE_Authority) )
        ReflectNum;
}

//------------------------------------------------------------
// Note: Does not explode when it hits the wall until last bounce
//------------------------------------------------------------
simulated function HitWall( vector HitNormal, actor Wall )
{
    if ( !Wall.bStatic && !Wall.bWorldGeometry
		&& ((Mover(Wall) == None) || Mover(Wall).bDamageTriggered) )
    {
        if ( Level.NetMode != NM_Client )
	{
	     if ( Instigator == None || Instigator.Controller == None )
		    Wall.SetDelayedDamageInstigatorController( InstigatorController );
             SetNewDamage();
             Wall.TakeDamage( NewDamage, instigator, Location, MomentumTransfer * Normal(Velocity), MyDamageType);
	}
        Explode(Location,HitNormal);
        return;
    }

    if (ReflectNum < ReflectMaxNum)
    {
        BounceProjectile(HitNormal);
        Playsound(Sound'MayhemWeaponSounds.Rocket.newreflect');
        //log("Reflection"@ReflectNum$"/"$ReflectMaxNum);
        ReflectNum++;
        return;
    }
    Explode(Location,HitNormal); // will not be reached until the last bounce, because of the if statement above
}

simulated function PostBeginPlay()
{
    const CM = Class'ColorManager';
    Const RL = Class'MayhemRocketLauncher';
    local Color CTS;

    Dir = vector(Rotation);
    Velocity = speed * Dir;
    if (PhysicsVolume.bWaterVolume)
    {
	bHitWater = True;
	Velocity=0.6*Velocity;
    }
    if ( Level.NetMode != NM_DedicatedServer)
    {
        if (RL.default.TrailColor == TRAIL_Random)
        {
            CTS = CM.static.AssignRandomColor();
        }
        else
        {
            CTS = CM.Default.ColorBank[
                  CM.static.AssignColorIndex(
                  CM.Default.ColorName[ Min(RL.default.TrailColor, 10) ] // Colorbank has up to 10 index.
                                            )
                                      ];
        }

        ColorAssign(CTS);
        SmokeTrail = Spawn(class'ColorRocketSmokeInner',self);
	SmokeTrail = Spawn(class'ColorRocketSmokeOuter',self);
        Corona = Spawn(class'RocketCorona',self);
    }
    Super(Projectile).PostBeginPlay();
}

simulated static function ColorAssign(Color CTS)
{
    local byte i;

    for (i = 0; i < 2; i++)
    {
        class'ColorRocketSmokeInner'.default.mColorRange[i] = CTS;
        class'ColorRocketSmokeOuter'.default.mColorRange[i] = CTS;
    }
}

simulated function ProcessTouch(Actor Other, Vector HitLocation)
{
	if ( ReflectNum != 0 && Other == Instigator)
		Explode(HitLocation, vector(rotation)*-1);
	else
		Super.ProcessTouch(Other, HitLocation);
}

function BlowUp(vector HitLocation)
{
    SetNewDamage();
    HurtRadius(NewDamage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation );
    MakeNoise(1.0);
}

simulated function BounceProjectile(vector HitNormal) // makes projectile bounce off wall
{
    Const V_Absorbed = 0.95;  // Percentage of force vector facing perpendicular to wall absorbed
    local float V_Returned;   // Percentage of force returned by wall
    
    V_Returned = 1 - V_Absorbed; // always equal to the percentage that wasn't absorbed.

    /* Dir Needs to be mirrored as well as velocity because it is used to calculate the directional accelaration
       in the timer function that governs the way the rockets act when they are launched in a spiral */

    // Velocity absorbed depending on angle of impact and surface angle, then reflected in the mirrored direction.
    Velocity = Normal( MirrorVectorByNormal(Velocity,HitNormal) ) * (VSize(Velocity) * V_Returned + V_Absorbed * VSize(Velocity) * (0.5 + 0.5 * (normal(velocity) dot hitnormal)));

    Dir = Velocity;
    SetRotation(Rotator(Velocity));               // Rotates the actual rocket itself
    Acceleration = Normal(Velocity) * AccelerationForce;     // Resets the direction of the accelaration.
}

function SetNewDamage()
{
     NewDamage = Default.Damage * ((1-DampeningFactor) ** float(ReflectNum));
     //Log("Damage Applied over"@ReflectNum$"/"$ReflectMaxNum@"reflections ="@NewDamage);
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
    Super.Explode(Hitlocation, HitNormal);
    Destroy();
}

simulated function Timer()
{
    local vector ForceDir, CurlDir;
    local float ForceMag;
    local int i;

    if (LifeSpan < 0.11)
    {
        Explode(Location, Dir);
    }

        SetRotation(Rotator(Dir));

        if (VSize(Velocity) >= Default.Speed)
            Velocity = Default.Speed * Normal(Dir * 0.5 * Default.Speed + Velocity);
        else
            Velocity += (AccelerationForce / 10) * Normal(Dir * 0.5 * Default.Speed + Velocity);

        // Work out force between flock to add madness
	for(i=0; i<2; i++)
	{
		if(Flock[i] == None)
			continue;

		// Attract if distance between rockets is over 2*FlockRadius, repulse if below.
		ForceDir = Flock[i].Location - Location;
		ForceMag = FlockStiffness * ( (2 * FlockRadius) - VSize(ForceDir) );
                Acceleration = Normal(ForceDir) * Min(ForceMag, FlockMaxForce);

		// Vector 'curl'
		CurlDir = Flock[i].Velocity Cross ForceDir;
		if ( bCurl == Flock[i].bCurl )
			Acceleration += Normal(CurlDir) * FlockCurlForce;
		else
                        Acceleration -= Normal(CurlDir) * FlockCurlForce;
	}

}

defaultproperties
{
     DampeningFactor=0.070000
     ReflectMaxNum=5
     AccelerationForce=2000.000000
     MyDamageType=Class'mayhemweapons.DamageTypeRocketReflective'
     bBounce=True
}
