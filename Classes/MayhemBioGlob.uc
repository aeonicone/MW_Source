class MayhemBioGlob Extends BioGlob;
var float InitialSpeed;
var float GainedLifeSpan;

simulated function PostBeginPlay()
{
    Super(Projectile).PostBeginPlay();

    LoopAnim('flying', 1.0);

    if (Role == ROLE_Authority)
    {
        Velocity = Vector(Rotation) * Speed;
        Velocity.Z += TossZ;
        InitialSpeed = VSize(Velocity);
    }

    if (Role == ROLE_Authority)
    if ( (Level.NetMode != NM_DedicatedServer) && ((Level.DetailMode == DM_Low) || Level.bDropDetail) )
    {
        bDynamicLight = false;
        LightType = LT_None;
    }
}

auto state Ready{}

simulated function Landed( Vector HitNormal )
{
    if ( Level.NetMode != NM_DedicatedServer )
    {
        PlaySound(ImpactSound, SLOT_Misc);
        // explosion effects
    }

    spawn(class'BioDecal',,,, rotator(-HitNormal));

    Velocity = GetBounceVector(HitNormal);
}

simulated function HitWall( Vector HitNormal, Actor Wall )
{
    Landed(HitNormal);

    if ( Vehicle(Wall) != None )
         Velocity = Normal(Velocity) * 0.5 * VSize(Velocity);  // slightly better physics.

    if ( !Wall.bStatic && !Wall.bWorldGeometry && ((Mover(Wall) == None) || Mover(Wall).bDamageTriggered) )
    {
         SetAmplifiedDamage();
         if ( Level.NetMode != NM_Client )
         {
             if ( Instigator == None || Instigator.Controller == None )
                 Wall.SetDelayedDamageInstigatorController( InstigatorController );
             Wall.TakeDamage( Damage, instigator, Location, MomentumTransfer * Normal(Velocity), MyDamageType);
         }
    }
}

simulated function ProcessTouch(Actor Other, Vector HitLocation)
{
    if (VSize(Velocity) >= 200)
    {
        If ( MayhemBioGlob(Other) != None )
             Return;

        SetAmplifiedDamage();
        if (Other != Instigator)
        {
             If (Other.Isa('Pawn') || Other.IsA('DestroyableObjective') || Other.bProjTarget)
             {
                   Other.TakeDamage(Damage, Instigator, HitLocation, MomentumTransfer * Normal(velocity), MyDamageType);
                   Destroy();
             }
             else if ( Other.bBlockActors )
                   HitWall( Normal(HitLocation-Location), Other );
        }
        else if (LifeSpan < Default.LifeSpan + GainedLifeSpan - 0.1) // make sure that glob isn't detected within the instigator
        {
             Other.TakeDamage(Damage, Instigator, HitLocation, MomentumTransfer * Normal(velocity), MyDamageType);
             Destroy();
        }
    }
}

function IncreaseLifeSpan(byte Amount)
{
    LifeSpan += Amount;
    GainedLifeSpan = Amount;
}

Simulated function SetAmplifiedDamage()
{
    Const GoopDamageScalar = 10;       // Damage gained per GoopLevel above 1.
    Const GoopMomentumScalar = 10000;  // Momentum transfer gained per goop level above 1.
    local float VelocityPercent;
    local float GoopBonusFactor;

    VelocityPercent = Vsize(Velocity) / InitialSpeed;
    GoopBonusFactor = GoopLevel-1;

    Damage += GoopBonusFactor * GoopDamageScalar;
    Damage *= VelocityPercent;
    MomentumTransfer += GoopBonusFactor * GoopMomentumScalar;
    MomentumTransfer *= VelocityPercent;
    //Log("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
    //Log("InitialSpeed ="@InitialSpeed);
    //Log("Velocity = %"$VelocityPercent*100$", GoopBonusFactor ="@GoopBonusFactor);
    //log("Damage Dealt ="@Damage$", Momenutum ="@MomentumTransfer);
    //Log("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
}

//***********************************************************************

simulated function Vector GetBounceVector(vector HitNormal) // makes projectile bounce off wall
{
    local float V_Absorbed;   // Percentage of force vector facing perpendicular to wall absorbed
    local float V_Returned;   // Percentage of force returned by wall

    V_Absorbed = 0.125;
    V_Returned = 1 - V_Absorbed; // always equal to the percentage that wasn't absorbed.

    if (VSize(Velocity) < 15) // sometimes in water they will stand around with all velocity lost.
        Destroy();

    // Velocity absorbed depending on angle of impact and surface angle, then reflected in the mirrored direction.
    Return Normal( MirrorVectorByNormal(Velocity,HitNormal) ) * (VSize(Velocity) * V_Returned + V_Absorbed * VSize(Velocity) * (0.5 + 0.5 * (normal(velocity) dot hitnormal)));

    //Velocity = Normal( MirrorVectorByNormal(Velocity,HitNormal) ) * (VSize(Velocity) * V_Returned + V_Absorbed * VSize(Velocity) * (0.5 + 0.5 * (normal(velocity) dot hitnormal)));
}

function AdjustSpeed()
{
    super.AdjustSpeed();
    //Log("Speed Adjusted");
    InitialSpeed = VSize(Velocity);
}

Function AdjustSpreadSpeed(int SpreadLoad)
{
    local vector Dir;

    Dir = Vector(Rotation);

    if ( SpreadLoad < 1 )
        Velocity = Dir * Speed;
    else
        Velocity = Dir * Speed * (0.4 + SpreadLoad)/(1.4*SpreadLoad);
    Velocity.Z += TossZ;

    Velocity += Dir * ( fRand() - 0.5 ) * ( SpreadLoad * 10 );
    
    InitialSpeed = VSize(Velocity);
}

defaultproperties
{
     Speed=1500.000000
     Damage=15.000000
     MomentumTransfer=30000.000000
     MyDamageType=Class'mayhemweapons.DamageTypeMayhemFlubber'
     LifeSpan=5.000000
     bProjTarget=True
     bBounce=True
}
