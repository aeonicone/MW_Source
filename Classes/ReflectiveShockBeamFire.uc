//==========================================================================
// MayhemShockRifleFire
// This is the fire class
//==========================================================================
class ReflectiveShockBeamFire extends ShockBeamFire;
const CM = Class'ColorManager';
var() class<ShockBeamEffect> ReflectedBeamEffectClass;
var float DampeningFactor, NewDamage;
var byte BounceMaxNum, BounceNum, BeamColorIndex;
var bool bHitWithoutBounce;

event ModeDoFire()
{
    BeamColorIndex = MayhemShockRifle(Weapon).ShockColor;
    Super.ModeDoFire();
}

function DoTrace(Vector Start, Rotator Dir)
{
    local Vector X, End, HitLocation, HitNormal, RefNormal;
    local Actor Other;
    local bool bDoReflect;
    local int ReflectNum;
    const MaxTrace = 45000;
    local float RemainingTrace;
    
    RemainingTrace = MaxTrace;

    bHitWithoutBounce = False;

    //Log("Start Trace-----------------------------------------------------------------------------------------------------------");
    For (BounceNum = 0; BounceNum <= BounceMaxNum; BounceNum++)
    {
        MaxRange();
        ReflectNum = 0;

        TraceRange = fMin(RemainingTrace, TraceRange);

        if ( RemainingTrace < 15000 )
        {
            //Log("Short Segment detected, aborting beam draw.");
            Break;
        }

        while (True)
        {
            bDoReflect = false;
            X = Vector(Dir);
            End = Start + TraceRange * X;

            Other = Weapon.Trace(HitLocation, HitNormal, End, Start, true);
            //Log(VSize(Start - HitLocation));  // Tracer log
            if ( Other != None && (Other != Instigator || ReflectNum > 0) )
            {
                if (bReflective && Other.IsA('xPawn') && xPawn(Other).CheckReflect(HitLocation, RefNormal, DamageMin*0.25))
                {
                     bDoReflect = true;
                     HitNormal = Vect(0,0,0);
                }
                else if ( !Other.bWorldGeometry )
                {
                     SetNewDamage(BounceNum);
                     NewDamage *= DamageAtten;

    		     // Update hit effect except for pawns (blood) other than vehicles.
                     if ( Other.IsA('Vehicle') || (!Other.IsA('Pawn') && !Other.IsA('HitScanBlockingVolume')) )
    			  WeaponAttachment(Weapon.ThirdPersonActor).UpdateHit(Other, HitLocation, HitNormal);

                     Other.TakeDamage(NewDamage, Instigator, HitLocation, Momentum*X, CM.Default.DamageTypeBeam_Class[BeamColorIndex]);
                     bHitWithoutBounce = (BounceNum == 0);  
                     BounceNum = BounceMaxNum + 1;  // Stop Bouncing The beam, it has hit a target.
                     HitNormal = Vect(0,0,0);
                }
                else if ( WeaponAttachment(Weapon.ThirdPersonActor) != None )
    		     WeaponAttachment(Weapon.ThirdPersonActor).UpdateHit(Other,HitLocation,HitNormal);
            }
            else
            {
                HitLocation = End;
                HitNormal = Vect(0,0,0);
    	        WeaponAttachment(Weapon.ThirdPersonActor).UpdateHit(Other,HitLocation,HitNormal);
            }

            RemainingTrace -= VSize(Start - HitLocation);

            SpawnBeamEffect(Start, Dir, HitLocation, HitNormal, ReflectNum);

            if (bDoReflect && ++ReflectNum < 4)
            {
                //Log("reflecting off"@Other@Start@HitLocation);
                Start = HitLocation;
                Dir = Rotator(RefNormal); //Rotator( X - 2.0*RefNormal*(X dot RefNormal) );
            }
            else
            {
                break;
            }
        }
        //Bend the beam now
        //Log("New Bounce~~~~~~~~~~~~~~~~");
        if (BounceNum <= BounceMaxNum && HitNormal != Vect(0,0,0))
        {
            Start = HitLocation;
            Dir = Rotator(MirrorVectorByNormal(Vector(Dir), HitNormal));
        }
        else
            Break;
    }
    //Log("End Trace-------------------------------------------------------------------------------------------------------------");
}

function SpawnBeamEffect(Vector Start, Rotator Dir, Vector HitLocation, Vector HitNormal, int ReflectNum)
{
    local ShockBeamEffect Beam;

    if (Weapon != None)
    {
        //Choose Which beam effect class to spawn, the reflected one, which blocks out something of postnetbeginplay or the original.

        if (BounceNum > 0 && bHitWithoutBounce == False)   // is using this when beam has hit something.
            Beam = Weapon.Spawn(CM.Default.Rd_ShockBeam_Class[BeamColorIndex],,, Start, Dir);//ReflectedBeamEffectClass
        else
            Beam = Weapon.Spawn(CM.Default.ShockBeam_Class[BeamColorIndex],,, Start, Dir);   //BeamEffectClass

        if (ReflectNum != 0) Beam.Instigator = None; // prevents client side repositioning of beam start

        Beam.AimAt(HitLocation, HitNormal);
    }
}

simulated function InitEffects()
{
    FlashEmitterClass = CM.Default.ShockBeamFlashEmitter_Class[MayhemShockRifle(Weapon).ShockColor];
    Super.InitEffects();
}

Function SetNewDamage(byte BounceNum)
{
    NewDamage = Default.DamageMin * ((1-DampeningFactor) ** float(BounceNum));
}

defaultproperties
{
     ReflectedBeamEffectClass=Class'mayhemweapons.ReflectedShockBeamEffect'
     DampeningFactor=0.150000
     BounceMaxNum=5
     BeamEffectClass=Class'mayhemweapons.ReflectiveShockBeamEffect'
     DamageType=Class'mayhemweapons.DamageTypeBeamAbstract'
     AmmoClass=Class'mayhemweapons.MayhemShockAmmo'
     FlashEmitterClass=Class'mayhemweapons.ReflectiveShockBeamMuzFlash'
}
