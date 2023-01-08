Class ReflectiveLinkProjectile extends LinkProjectile;

var float DampeningFactor, NewDamage;
var byte ReflectNum, ReflectMaxNum;
//var bool bRandColor;
var class<ReflectiveLinkProjSparks> LinkSparksClass;
var class<ReflectiveNewLinkTrail> LinkTrailClass;
const CM = class'ColorManager';

replication
{
    reliable if (bNetInitial && Role == ROLE_Authority)
        ReflectNum;
}

simulated function PostNetBeginPlay()
{
    local float dist;
    local PlayerController PC;

    Acceleration = Normal(Velocity) * 3000.0;

	if ( (Level.NetMode != NM_DedicatedServer) && (Level.DetailMode != DM_Low) )
		Trail = Spawn(LinkTrailClass,self);   // only change in this function
	if ( (Trail != None) && (Instigator != None) && Instigator.IsLocallyControlled() )
	{
		if ( Role == ROLE_Authority )
			Trail.Delay(0.1);
		else
		{
			dist = VSize(Location - Instigator.Location);
			if ( dist < 100 )
				Trail.Delay(0.1 - dist/1000);
		}
	}

    if (Role < ROLE_Authority)
        LinkAdjust();
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
		if ( (PC == None) || (Instigator == None) || (PC != Instigator.Controller) )
		{
			bDynamicLight = false;
			LightType = LT_None;
		}
	}
}

simulated function LinkAdjust()
{
    if (Links > 0)
        MaxSpeed = default.MaxSpeed + 350*Links;
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
    if ( EffectIsRelevant(Location,false) )
    {
        if (Links == 0)
            Spawn(LinkSparksClass,,, HitLocation, rotator(HitNormal));
    }

    PlaySound(Sound'WeaponSounds.BioRifle.BioRifleGoo2');
    Destroy();
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
             NewDamage = CalculateDamage();
             //Log("Damage Applied over"@ReflectNum$"/"$ReflectMaxNum@"reflections ="@D);
             Wall.TakeDamage( NewDamage, instigator, Location, MomentumTransfer * Normal(Velocity), MyDamageType);
	}
        Explode(Location,HitNormal);
        return;
    }

    if (ReflectNum < ReflectMaxNum)
    {
        BounceProjectile(HitNormal);
        PlaySound(Sound'WeaponSounds.BioRifle.BioRifleGoo2');
        ReflectNum++;
        return;
    }
    Explode(Location,HitNormal);
}

function float CalculateDamage() // Not an Overridden Function.
{
    Return ( Default.Damage * ( (1-DampeningFactor) ** float(ReflectNum) ) );
}

simulated function BounceProjectile(vector HitNormal) // makes projectile bounce off wall
{
    Const V_Absorbed = 0.95;  // Percentage of force vector facing perpendicular to wall absorbed
    local float V_Returned;   // Percentage of force returned by wall

    V_Returned = 1 - V_Absorbed; // always equal to the percentage that wasn't absorbed.

    Velocity = Normal( MirrorVectorByNormal(Velocity,HitNormal) ) * (VSize(Velocity) * V_Returned + V_Absorbed * VSize(Velocity) * (0.5 + 0.5 * (normal(velocity) dot hitnormal)));

    SetRotation(Rotator(Velocity));
    Acceleration = Normal(Velocity) * 3000.0;
}

simulated function ProcessTouch(Actor Other, Vector HitLocation)
{
    local Vector X, RefNormal, RefDir;
    local LinkProjectile LiPr;

    if ( (LifeSpan < (Default.Lifespan - 0.2) ) && Other == Instigator)
    {
        NewDamage = CalculateDamage();
	Other.TakeDamage(NewDamage * (1.0 + float(Links)),Instigator,HitLocation,MomentumTransfer * Normal(Velocity),MyDamageType);
	Explode(HitLocation, vector(rotation)*-1);
    }
    else
    {
        if (Other == Owner) return;

        if (Other.IsA('xPawn') && xPawn(Other).CheckReflect(HitLocation, RefNormal, NewDamage*0.25))
        {
            if (Role == ROLE_Authority)
            {
                X = Normal(Velocity);
                RefDir = X - 2.0*RefNormal*(X dot RefNormal);
                //Log("reflecting off"@Other@X@RefDir);
                //Spawn(Class, Other,, HitLocation+RefDir*20, Rotator(RefDir));
                LiPr = Spawn(Class, Other,, HitLocation+RefDir*20, Rotator(RefDir));
                LiPr.Links=Links;
                LiPr.LinkAdjust();
            }
            Destroy();
        }
        else if ( (!Other.IsA('Projectile') || Other.bProjTarget) && (Other != Instigator))
        {
      	    if ( Role == ROLE_Authority )
            {
                NewDamage = CalculateDamage();
                if ( Instigator == None || Instigator.Controller == None )
      			Other.SetDelayedDamageInstigatorController( InstigatorController );
                Other.TakeDamage(NewDamage * (1.0 + float(Links)),Instigator,HitLocation,MomentumTransfer * Normal(Velocity),MyDamageType);
      	    }
      	    Explode(HitLocation, vect(0,0,1));
        }
    }
}

defaultproperties
{
     DampeningFactor=0.150000
     ReflectMaxNum=5
     LinkSparksClass=Class'mayhemweapons.ReflectiveLinkProjSparks'
     LinkTrailClass=Class'mayhemweapons.ReflectiveNewLinkTrail'
     MyDamageType=Class'mayhemweapons.DamageTypeMayhemLinkPlasma'
     LightHue=0
     LightSaturation=255
     LifeSpan=5.000000
     Skins(0)=FinalBlend'MayhemWeaponEffects.Link.LinkProjGreenFB'
}
