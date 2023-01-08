class ReflectiveFlakChunk extends FlakChunk;

var byte ReflectNum, ReflectMaxNum;
var bool bIgnoreGravity, bCanDamageUser;
var float DampeningFactor;
var float NewDamage;
var Class<FlakTrail> TrailClass;

replication
{
    reliable if (bNetInitial && Role == ROLE_Authority)
        ReflectNum, bIgnoreGravity;
}

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
        Destroy();
        return;
    }

    if (ReflectNum < ReflectMaxNum)
    {
        if ( !Level.bDropDetail && (FRand() < 0.4) )
  	     Playsound(ImpactSounds[Rand(6)]);
        BounceProjectile(HitNormal);

        ReflectNum++;
        return;
    }
    Destroy();   // if this is reached, the reflectnum = reflectmaxnum and it has bounced max times.
}

Simulated function BounceProjectile(Vector HitNormal)
{
    local float V_Absorbed;  // Percentage of force vector facing perpendicular to wall absorbed
    local float V_Returned;  // Percentage of force returned by wall

    V_Absorbed = 0.175;
    V_Returned = 1 - V_Absorbed; // always equal to the percentage that wasn't absorbed.

    if ( ReflectNum == 0 )
        SetPhysics(PHYS_Falling);
        
    If (VSize(Velocity) < 30)
        Destroy();

    //if (bIgnoreGravity) // bounce this projectile without gravity
    //    Velocity = MirrorVectorByNormal(Velocity, HitNormal);
    //else // Absorb some velocity, and reflect based on angle hit.
    Velocity = Normal( MirrorVectorByNormal(Velocity,HitNormal) ) * (VSize(Velocity) * V_Returned + V_Absorbed * VSize(Velocity) * (0.5 + 0.5 * (normal(velocity) dot hitnormal)));
}

SIMULATED function SetNewDamage() // Damage Dealt is based on the speed of the projectile
{
    NewDamage = ( Vsize(Velocity) / Default.Speed ) * Default.Damage;
}

Simulated function PostBeginPlay()
{
    LifeSpan += FRand() - 0.5;

    if ( Level.NetMode != NM_DedicatedServer )
    {
        if ( !PhysicsVolume.bWaterVolume )
        {
            Trail = Spawn(TrailClass,self);
            Trail.Lifespan = Lifespan; // Trail lifespan needs to be same as chunk lifespan
        }
    }

    Velocity = Vector(Rotation) * (Speed);
    if (PhysicsVolume.bWaterVolume)
        Velocity *= 0.65;

    SetRotation(RotRand());

    Super(Projectile).PostBeginPlay();
}

simulated function ProcessTouch (Actor Other, vector HitLocation)
{
    bCanDamageUser = ( bCanDamageUser && (LifeSpan < (Default.Lifespan - 0.1)) );

    if ( (FlakChunk(Other) == None) && (bCanDamageUser || (Other != Instigator)) ) //With reflectnum < 0, flak chunks will not hurt instigator.
    {
        speed = VSize(Velocity);
        if ( speed > 200 ) // Damage dealt if speed is Greater than 200
        {
            if ( Role == ROLE_Authority )
	    {
                if ( Instigator == None || Instigator.Controller == None )
		    Other.SetDelayedDamageInstigatorController( InstigatorController );

                SetNewDamage();
                Other.TakeDamage( Max(5, NewDamage - DamageAtten*FMax(0,(default.LifeSpan - LifeSpan - 1))), Instigator, HitLocation,
                      (MomentumTransfer * Velocity/speed), MyDamageType );
	    }
        }
        if ( (Other != Instigator) || (bCanDamageUser && Other == Instigator) )
            Destroy();
    }
}

defaultproperties
{
     ReflectMaxNum=5
     bIgnoreGravity=True
     bCanDamageUser=True
     TrailClass=Class'mayhemweapons.ReflectiveFlakTrail'
     Bounces=5
     Speed=3000.000000
     MaxSpeed=3000.000000
     Damage=12.500000
     MyDamageType=Class'mayhemweapons.DamageTypeMayhemFlakChunk'
     LifeSpan=4.800000
}
