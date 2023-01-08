class MayhemONSAVRiLWolf extends ONSAVRiLRocket;

var byte FlockIndex;
var MayhemONSAVRiLWolf Flock[4];
var() float	FlockRadius;
var() float	FlockStiffness;
var() float FlockMaxForce;
var() float	FlockCurlForce;
var() float FlockMaxCurlForce;
var() float FlockMinCurlForce;
var bool bCurl;
var vector Dir;

/*var enum EWolfName
{
    WOLF_Alpha,
    WOLF_Beta,
    WOLF_Gamma,
    WOLF_Delta,
    WOLF_Epsilon
} WolfName;*/

replication
{
    reliable if ( bNetInitial && (Role == ROLE_Authority) )
        FlockIndex, bCurl;
}

simulated function PostBeginPlay()
{
	Dir = vector(Rotation);

	if ( Level.NetMode != NM_DedicatedServer)
	{
		SmokeTrail = Spawn(class'EffectAvrilTrailSmall',,,Location - 15 * Dir);
		//SmokeTrail = Spawn(Class'EffectRocketTrailStandard',,,Location - 15 * Dir);
                SmokeTrail.Setbase(self);

		Corona = Spawn(class'RocketCorona',self);
	}

	Velocity = speed * Dir;
	Acceleration = Dir;	//really small accel just to give it a direction for use later
	if (PhysicsVolume.bWaterVolume)
		Velocity=0.6*Velocity;
	if ( Level.bDropDetail )
	{
		bDynamicLight = false;
		LightType = LT_None;
	}

	SetTimer(0.1, true);
	//LeadTargetStartTime = Level.TimeSeconds + LeadTargetDelay;

	Super(Projectile).PostBeginPlay();
}

simulated function PostNetBeginPlay()
{
        local MayhemONSAVRiLWolf R;
	local byte i/*, x, e*/;
	local PlayerController PC;
        //local EWolfName tmpWolfName[5];

	Super.PostNetBeginPlay();

        If ( FlockIndex != 0 )
	{

            SetTimer(0.1, true);

            //for ( e = 0; e < Buddies; e++ )    // 'learns' the Wolf name it should look for in its first buddy, second buddy, etc.
            //   tmpWolfName[e] = EWolfName( (Int(WolfName) + (e + 1) ) % Buddies);

            // look for other rockets
	    if ( Flock[3] == None)
	    {
                ForEach DynamicActors(Class'MayhemONSAVRiLWolf',R)
                      if ( R.FlockIndex == FlockIndex )
		      {    /*
                           for ( x = 0; x < Buddies; x++ )
                               if ( R.WolfName == tmpWolfName[x] )
                                   Flock[x] = R;
                           */
			   if ( R.Flock[0] == None )
			       R.Flock[0] = self;
			   else if ( R.Flock[0] != self )
			       R.Flock[1] = self;
			   //-----------
                           i++;
			   if ( i == 4 )
			 	break;
		       }
  	    }
	}
    if ( Level.NetMode == NM_DedicatedServer )
		return;
	if ( Level.bDropDetail || (Level.DetailMode == DM_Low) )
	{
		bDynamicLight = false;
		LightType = LT_None;
	}
	else
	{
		PC = Level.GetLocalPlayerController();
		if ( (Instigator != None) && (PC == Instigator.Controller) )
			return;
		if ( (PC == None) || (PC.ViewTarget == None) || (VSize(PC.ViewTarget.Location - Location) > 3000) )
		{
			bDynamicLight = false;
			LightType = LT_None;
		}
	}
}

simulated function Timer()
{
    local vector ForceDir, CurlDir;
    local float ForceMag;
    local byte /*i,*/ J, X;

        if ( FlockIndex == 0 )
            Return;

        SetRotation(Rotator(Dir));

        if (VSize(Velocity) >= Default.Speed)
            Velocity = Default.Speed * Normal(Dir * 0.5 * Default.Speed + Velocity);
        else
            Velocity += (1000 / 10) * Normal(Dir * 0.5 * Default.Speed + Velocity);

        // FlockCurlForce = FClamp(FlockCurlForce + 100, FlockMinCurlForce, FlockMaxCurlForce);

        // Work out force between flock to add madness
	//for(i = 0; i < 4; i++)
	//{
	    //J = (int(WolfName) + i) % Max(0, Buddies-2);
            //J = 1 + (i % 2);
            //J = i % 2;
            J = 1;

            If ( Flock[J] != None )
            {
                ForceDir = Flock[J].Location - Location;
        	ForceMag = FlockStiffness * ( (2 * FlockRadius) - VSize(ForceDir) );
                Acceleration = Normal(ForceDir) * Min(ForceMag, FlockMaxForce);
            }
            For ( x = 0; x < 4; x++ )
            {
                J = (J + 1) % 5;

                if( J > 3 || Flock[J] == None)
		     continue;

                // Attract if distance between rockets is over 2*FlockRadius, repulse if below.
		ForceDir += Flock[J].Location - Location;
		ForceMag = FlockStiffness * ( (2 * FlockRadius) - VSize(ForceDir) );
                Acceleration += Normal(ForceDir) * Min(ForceMag, FlockMaxForce);

            }
	    // Vector 'curl'

	    if ( J > 3 || Flock[J] == None )
                Return; 

	    CurlDir = Flock[J].Velocity Cross ForceDir;
	    if ( bCurl == Flock[J].bCurl)
	        Acceleration += Normal(CurlDir) * FlockCurlForce;
	    else
                Acceleration -= Normal(CurlDir) * FlockCurlForce;
        //}
}

simulated function Tick(float deltaTime)
{
	Super(projectile).Tick(deltaTime);
}

event TakeDamage( int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DType)
{
    if (class<DamageTypeMayhemONSAVRiLWolf>(DType) == None) // immune to damage from its own buddies' explosions.
        Super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DType);
}

simulated function ProcessTouch(Actor Other, Vector HitLocation)
{
	if ( Other != Instigator && MayhemONSAVRiLWolf(Other) == None)
		Explode(HitLocation,Normal(HitLocation-Other.Location));
}

simulated function Destroyed()
{
	SetTimer(0.0, False);

        // Turn of smoke emitters. Emitter should then destroy itself when all particles fade out.
	if ( SmokeTrail != None )
		SmokeTrail.Kill();

	if ( Corona != None )
		Corona.Destroy();

	PlaySound(sound'WeaponSounds.BExplosion3',,2.5*TransientSoundVolume);
	if (!bNoFX && EffectIsRelevant(Location, false))
		spawn(class'ONSAVRiLRocketExplosion',,, Location, rotator(vect(0,0,1)));
	if (Instigator != None && Instigator.IsLocallyControlled() && Instigator.Weapon != None && !Instigator.Weapon.HasAmmo())
		Instigator.Weapon.DoAutoSwitch();

        /* This undoes the "Turning off" that the avril does to the firing 
           sound, by playing it from the rocket, instead of the owner.- gb   */
	/*if (ONSAVRiL(Owner) != None)
		ONSAVRiL(Owner).*/PlaySound(sound'WeaponSounds.BExplosion3', SLOT_Interact, 0.01,, TransientSoundRadius);

	Super(Projectile).Destroyed();
}

defaultproperties
{
     FlockRadius=12.000000
     FlockStiffness=-40.000000
     FlockMaxForce=140.000000
     FlockCurlForce=600.000000
     Speed=1500.000000
     Damage=50.000000
     DamageRadius=240.000000
     MomentumTransfer=30000.000000
     MyDamageType=Class'mayhemweapons.DamageTypeMayhemONSAVRiLWolf'
     CullDistance=7500.000000
     LifeSpan=8.000000
     DrawScale=0.075000
}
