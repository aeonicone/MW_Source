class ReflectiveShockProjectile extends ShockProjectile;

var byte ReflectMaxNum, ReflectNum;
var float DampeningFactor, NewDamage;
var class<ColorShockCombo> ComboClass;
var Class<ReflectiveShockBall> ShockBallClass;
var Class<ColorShockExplosionCore> ExplosionCoreClass;
var class<ColorShockExplosion> ExplosionClass;

replication
{
    reliable if (bNetInitial && Role == ROLE_Authority)
        ReflectNum;
}

simulated function PostBeginPlay()
{
    Super(Projectile).PostBeginPlay();

    if ( Level.NetMode != NM_DedicatedServer )
    {
        ShockBallEffect = Spawn(ShockBallClass, self);  // might need to cancel this out.
        ShockBallEffect.SetBase(self);
    }

    Velocity = Speed * Vector(Rotation); // starts off slower so combo can be done closer

    SetTimer(0.4, false);
    tempStartLoc = Location;
}

simulated function HitWall( vector HitNormal, actor Wall )
{
    if ( !Wall.bStatic && !Wall.bWorldGeometry
		&& ((Mover(Wall) == None) || Mover(Wall).bDamageTriggered) )
    {
        if ( Level.NetMode != NM_Client )
	{
	     SetNewDamage();
             if ( Instigator == None || Instigator.Controller == None )
		  Wall.SetDelayedDamageInstigatorController( InstigatorController );
             Wall.TakeDamage( NewDamage, instigator, Location, MomentumTransfer * Normal(Velocity), MyDamageType);
	}
        DestroyProjectile();
        return;
    }

    DoImpactEffects(); // Blasts out a wave of energy, but not destroying the projectile

    if (ReflectNum < ReflectMaxNum)
    {
        BounceProjectile(HitNormal);
        return;
    }
    DestroyProjectile();
}

Simulated Function BounceProjectile(vector HitNormal)
{
    Const V_Absorbed = 0.80;  // Percentage of force vector facing perpendicular to wall absorbed
    local float V_Returned;   // Percentage of force returned by wall

    V_Returned = 1 - V_Absorbed; // always equal to the percentage that wasn't absorbed.

    Velocity = Normal( MirrorVectorByNormal(Velocity,HitNormal) ) * (VSize(Velocity) * V_Returned + V_Absorbed * VSize(Velocity) * (0.5 + 0.5 * (normal(velocity) dot hitnormal)));
    Acceleration = Normal(Velocity) * 1500.0;     // Resets the direction of the accelaration.
    ReflectNum++;
}

Simulated Function DoImpactEffects()
{
    SetNewDamage();
    // Explosion
    if ( Role == ROLE_Authority )
	HurtRadius(NewDamage, DamageRadius, MyDamageType, MomentumTransfer, Location );
    // Visual and audio effects
    PlaySound(ImpactSound, SLOT_Misc);
    if ( EffectIsRelevant(Location,false) )
    {
        Spawn(ExplosionCoreClass,,, Location);
	if ( !Level.bDropDetail && (Level.DetailMode != DM_Low) )
	     Spawn(ExplosionClass,,, Location);
    }
}

simulated function Explode(vector HitLocation,vector HitNormal)
{
    SetNewDamage();
    DoImpactEffects();
    DestroyProjectile();
}

SIMULATED function SetNewDamage()
{
    NewDamage = Default.Damage * ( (1-DampeningFactor) ** float(ReflectNum) );
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Enables the Instigator to Shoot himself
simulated function ProcessTouch (Actor Other, vector HitLocation)
{
    if ( ReflectNum != 0 && Other == Instigator )
	Explode(HitLocation, Normal(HitLocation-Other.Location));
    else
	Super.ProcessTouch(Other, HitLocation);
}

event TakeDamage( int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DType)
{
    if (class<DamageTypeBeamAbstract>(DType) != None)  //(DamageType == ComboDamageType)
    {
        Instigator = EventInstigator;
        SuperExplosion();
        if( EventInstigator.Weapon != None )
        {
			EventInstigator.Weapon.ConsumeAmmo(0, ComboAmmoCost, true);
            Instigator = EventInstigator;
        }
    }
}

function SuperExplosion()
{
	local actor HitActor;
	local vector HitLocation, HitNormal;

	HurtRadius(ComboDamage, ComboRadius, ComboDamageType, ComboMomentumTransfer, Location );

	Spawn(ComboClass);
	if ( (Level.NetMode != NM_DedicatedServer) && EffectIsRelevant(Location,false) )
	{
		HitActor = Trace(HitLocation, HitNormal,Location - Vect(0,0,120), Location,false);
		if ( HitActor != None )
			Spawn(class'ComboDecal',self,,HitLocation, rotator(vect(0,0,-1)));
	}
	PlaySound(ComboSound, SLOT_None,1.0,,800);
    DestroyTrails();
    Destroy();
}

Simulated Function DestroyProjectile()
{
    SetCollisionSize(0.0, 0.0);
    Destroy();
}

defaultproperties
{
     ReflectMaxNum=5
     DampeningFactor=0.150000
     ComboClass=Class'mayhemweapons.ColorShockCombo'
     ShockBallClass=Class'mayhemweapons.ReflectiveShockBall'
     ExplosionCoreClass=Class'mayhemweapons.ColorShockExplosionCore'
     ExplosionClass=Class'mayhemweapons.ColorShockExplosion'
     ComboDamageType=Class'mayhemweapons.DamageTypeMayhemShockCombo'
     MyDamageType=Class'mayhemweapons.DamageTypeMayhemShockProj'
     LightHue=0
     LightSaturation=255
     Texture=Texture'MayhemWeaponEffects.Shock.shock_core_low_desat'
     Skins(0)=Texture'MayhemWeaponEffects.Shock.shock_core_low_desat'
}
