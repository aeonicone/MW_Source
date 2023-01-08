class MayhemONSMineLayerAltFire extends ONSMineLayerAltFire;

var MayhemONSMineLayer MayhemGun;
var MayhemONSMineLayerBeamEffectEMP EMPBeam;

function PostBeginPlay()
{
	Super(WeaponFire).PostBeginPlay();
	MayhemGun = MayhemONSMineLayer(Weapon);
}

function DestroyEffects()
{
    if (EMPBeam != None)
        EMPBeam.Destroy();

    Super.DestroyEffects();
}

function StopFiring()
{
	if (Weapon.Role == ROLE_Authority)
	{
		if (Beam != None)
			Beam.Cancel();
                if (EMPBeam != None)
                        EMPBeam.Cancel();
		SetTimer(0, false);
	}
}


simulated function ModeTick(float deltaTime)
{
    local vector HitLocation, HitNormal, StartTrace, EndTrace, X, Y, Z;
    local rotator Aim;
    local Actor Other;
    local byte i;

    if (!bIsFiring)
        return;

        Weapon.GetViewAxes(X,Y,Z);

    // the to-hit trace always starts right in front of the eye
    StartTrace = Instigator.Location + Instigator.EyePosition() + X*Instigator.CollisionRadius;
    Aim = AdjustAim(StartTrace, AimError);
    X = Vector(Aim);
    EndTrace = StartTrace + TraceRange * X;

    Other = Weapon.Trace(HitLocation, HitNormal, EndTrace, StartTrace, false);
    if (Other == None || Other == Instigator)
        HitLocation = EndTrace;


        if ( Weapon.Role == ROLE_Authority )
	{
            If ( Beam == None && MayhemGun.CurrentMineIndex == 0)
                Beam = Weapon.spawn(class'ONSMineLayerTargetBeamEffect',,, Instigator.Location);
            else if ( EMPBeam == None && MayhemGun.CurrentMineIndex == 1 )
                EMPBeam = Weapon.spawn(class'MayhemONSMineLayerBeamEffectEMP',,, Instigator.Location);
        }
        else
	{
            if ( MayhemGun.CurrentMineIndex == 0 )
                foreach Weapon.DynamicActors(class'ONSMineLayerTargetBeamEffect', Beam)
    	            break;
    	    else if ( MayhemGun.CurrentMineIndex == 1 )
                foreach Weapon.DynamicActors(class'MayhemONSMineLayerBeamEffectEMP', EMPBeam)
      		    break;
        }


    if ( Beam != None )
	Beam.EndEffect = HitLocation;
    if ( EMPBeam != None )
        EMPBeam.EndEffect = Hitlocation;

    // Main Modified Section ----------------------------
    if (bDoHit)
	for (i = 0; i < MayhemGun.Mines.Length; i++)
	{
	    if (MayhemGun.Mines[i] == None)
  	    {
		MayhemGun.Mines.Remove(i, 1);
		i--;
	    }
	    else if (/*( AIController(Instigator.Controller) != None && ONSMineProjectile(MayhemGun.Mines[i]) != None ) || */
                       ( MayhemGun.CurrentMineIndex == 1 && MayhemONSMineProjectileEMP(MayhemGun.Mines[i]) != None )    ||
                       ( MayhemGun.CurrentMineIndex == 0 && MayhemONSMineProjectile(MayhemGun.Mines[i]) != None    )    )
            {
                ONSMineProjectile(MayhemGun.Mines[i]).SetScurryTarget(HitLocation);
            }
        }
}

defaultproperties
{
}
