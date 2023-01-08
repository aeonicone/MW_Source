class MayhemSniperFire extends SniperFire;

var enum ELightningMode
{
    MODE_Standard,
    MODE_Branch
} LightningMode;

var() class<xEmitter> ReflectEmitterClass, BranchEmitterClass, SpreadEmitterClass;
var float DampeningFactor, NewDamage;
var byte BounceNum, BounceMaxNum;
var sound BranchFireSound;

const CM = Class'ColorManager';

function DoTrace(Vector Start, Rotator Dir)
{
    local Vector X,Y,Z, End, HitLocation, HitNormal, RefNormal;
    local Actor Other, mainArcHitTarget;
    local int ReflectNum, arcsRemaining;
    local bool bDoReflect;
    local xEmitter hitEmitter;
    local class<Actor> tmpHitEmitClass;
    local float tmpTraceRange;
    local vector arcEnd, mainArcHit;
    local vector EffectOffset;

    local Rotator MainArcDir;
    local Vector MainArcHitNormal, MainArcHitLocation;

    local Vector StemStart;
    local bool bDoArcs;
    local Float RemainingLength, StemSpreadRange, StemMinSpread, StemAddition, CurrentTrace;
    const MaxTrace = 45000;

    if ( class'PlayerController'.Default.bSmallWeapons )
        EffectOffset = Weapon.SmallEffectOffset;
    else
        EffectOffset = Weapon.EffectOffset;

    Weapon.GetViewAxes(X, Y, Z);
    if ( Weapon.WeaponCentered() )
        arcEnd = (Instigator.Location +
            EffectOffset.X * X +
            1.5 * EffectOffset.Z * Z);
    else if ( Weapon.Hand == 0 )
    {
        if ( class'PlayerController'.Default.bSmallWeapons )
            arcEnd = (Instigator.Location +
                EffectOffset.X * X);
        else
            arcEnd = (Instigator.Location +
                EffectOffset.X * X
                - 0.5 * EffectOffset.Z * Z);
    }
    else
        arcEnd = (Instigator.Location +
            Instigator.CalcDrawOffset(Weapon) +
            EffectOffset.X * X +
            Weapon.Hand * EffectOffset.Y * Y +
            EffectOffset.Z * Z);

    if ( LightningMode == MODE_Standard )
    {
        if ( DamageMin != Default.DamageMin )
        {
            DamageMin = Default.DamageMin;
            DamageMax = Default.DamageMax;
        }
        StemSpreadRange = 200.0;
        StemMinSpread   = 120.0;
    }
    else
    {
        if ( DamageMin != 17 )
        {
            DamageMin = 17;
            DamageMax = 19;
        }
        DoBranchTrace(Start, Dir, arcEnd);
        Return;
    }
    // if LightningMode == MODE_Branch, something is wrong here.

    CurrentTrace = MaxTrace;

    //Log("Start Trace-----------------------------------------------------------------------------------------------------------");
    For (BounceNum = 0; BounceNum <= BounceMaxNum; BounceNum++)   // Repeat for beam bouncing.
    {
        // A new Main arc needs to be created now.

        MainArcDir = Dir;         // MainArcDir Saves what's in Dir for bolt-bending later.
        arcsRemaining = NumArcs;  // Resetting Arcs

        If (BounceNum > 0)
        {              // If bolt already bounced, then use the non-repositioning bolt effect class
            tmpHitEmitClass = ReflectEmitterClass;
            ArcEnd = Start;
        }
        else                            // else, use the one drawn from the muzzle
            tmpHitEmitClass = HitEmitterClass;
        tmpTraceRange = fMin(CurrentTrace, Default.TraceRange); // set long range bolt use, using either the default trace range or the remaining.

        //Log("tmpTraceRange ="@tmpTraceRange);
        if ( tmpTraceRange < 15000 )  // Prematurely aborting
        {
            //Log("Short Segment detected, aborting beam draw.}}}}}}}}}}}}");
            Break;
        }
        // ============================================================================

        StemStart = arcEnd;
        bDoArcs = True;

        ReflectNum = 0;
        while (true)
        {
            bDoReflect = false;
            X = Vector(Dir);
            End = Start + tmpTraceRange * X;
            Other = Weapon.Trace(HitLocation, HitNormal, End, Start, true);

            if ( Other != None )
            {
                if ( Other != Instigator || ReflectNum > 0 )
                {
                    if (bReflective && Other.IsA('xPawn') && xPawn(Other).CheckReflect(HitLocation, RefNormal, DamageMin*0.25))
                    {
                        bDoReflect = true;
                    }
                    else if ( Other != mainArcHitTarget )
                    {
                        if ( !Other.bWorldGeometry )
                        {
                            DealDamage(X, HitLocation, ArcsRemaining, Other, 1.0);
                            If ( ArcsRemaining == NumArcs )
                                BounceNum = BounceMaxNum + 1;  // Set it up to escape the BounceNum For Loop
                        }
                        else
                            HitLocation = HitLocation + 2.0 * HitNormal;
                    }
                }
            }
            else
            {
                If ( ArcsRemaining == NumArcs )
                    BounceNum = BounceMaxNum + 1;  // Can't bounce anymore, The bolt has hit air.
                HitLocation = End;               // setting Hitlocation to where arc "didn't hit"
                HitNormal = Normal(Start - End);
            }

            if (ArcsRemaining == NumArcs)   // Save this HitNormal for arc bending info later.
            {
                CurrentTrace -= VSize(Start - HitLocation);   // Reduce Current trace, There is a maximum distance for main bolt.
                //log("Remaining Trace ="@CurrentTrace);
                MainArcHitNormal = HitNormal;
                MainArcHitLocation = HitLocation;
                //log ("MainArcHitNormal ="@MainArcHitNormal);
            }

            if ( Weapon == None )
                return;

            // Effects spawned here--------------------------------------------------------------
            hitEmitter = xEmitter(Weapon.Spawn(tmpHitEmitClass,,, arcEnd, Rotator(HitNormal)));

            if ( hitEmitter != None )   // bolt end assigned here
            {
                if (ArcsRemaining < NumArcs)      hitEmitter.mSpawnVecA = HitLocation;
                else                              hitEmitter.mSpawnVecA = MainArcHitLocation;
            }
            // ----------------------------------------------------------------------------------

            if ( HitScanBlockingVolume(Other) != None )
                return;

            if( arcsRemaining == NumArcs )
            {
                mainArcHit = HitLocation + (HitNormal * 2.0);
                if ( Other != None && !Other.bWorldGeometry )
                    mainArcHitTarget = Other;
            }

            //------------------------------------------------------------------------------------
            If (bDoArcs) // Arch branches here
            {
                bDoArcs = False;
                // Initializing Amount of distance left to spawn forks off main bolt
                RemainingLength = VSize(StemStart - MainArcHitLocation);
                StemAddition = FRand() * StemSpreadRange + StemMinSpread; // Amount of space to move forward for first fork
                While ( RemainingLength > StemAddition )
                {
                    //Log("RemainingLength ="@RemainingLength);
                    //Log("StemAddition ="@StemAddition);
                    StemStart += Normal(StemStart - MainArcHitLocation) * -1 * StemAddition;  // get new starting fork position.

                    DoBranchTrace( StemStart, MainArcDir, ArcEnd, (200 - StemSpreadRange) / 20.0 ); // make the fork

                    RemainingLength -= StemAddition;

                    StemMinSpread = FMin(StemMinSpread + 20, 400);
                    StemSpreadRange = FMin(StemSpreadRange + 20, 600);
                    StemAddition = FRand() * StemSpreadRange + StemMinSpread;
                }
            }
            //------------------------------------------------------------------------------------

            if (bDoReflect && ++ReflectNum < 4)
            {
                //Log("reflecting off"@Other@Start@HitLocation);
                Start = HitLocation;
                Dir = Rotator( X - 2.0*RefNormal*(X dot RefNormal) );
            }
            else if ( arcsRemaining > 0 )
            {
                arcsRemaining--;

                // done parent arc, now move trace point to arc trace hit location and try child arcs from there
                Start = mainArcHit;
                Dir = Rotator(VRand());
                tmpHitEmitClass = SecHitEmitterClass;
                tmpTraceRange = SecTraceDist;
                arcEnd = mainArcHit;
            }
            else
                break;
        }

        //Bend the beam now
        if (BounceNum <= BounceMaxNum)
        {
            //Log("New Bounce~~~~~~~~~~~~~~~~");
            Start = MainArcHitLocation;
            Dir = Rotator(MirrorVectorByNormal(Vector(MainArcDir), MainArcHitNormal));
        }


    }
    //Log("End Trace-------------------------------------------------------------------------------------------------------------");
}

function DoBranchTrace(Vector start, Rotator Dir, vector arcEnd, optional float SpreadIncrement)
{
    local Vector X, End, HitLocation, HitNormal, tmpStart, RandCone;
    local Actor Other;
    local xEmitter hitEmitter;
    local float MinimumLength, LengthRange, DamageMult;
    local float BoltSpread, BoltSpreadBounds, MinimumHollowness;
    local byte Alpha, Omega;
    local class<xEmitter> tmpEmitterClass;
    local bool bLeaveOnlyFirstFlash, bHitNothing;

    if (LightningMode == MODE_Standard)
    {
        BoltSpreadBounds = 0.30;    // Highest percentage that bolt can spread, 1.00 = Semi-sphere i think...
        BoltSpread = 0.20;          // Subtract from BoltSpreadBounds and you get the minimum range the bolt can spread.
        LengthRange = FMin(250 + (SpreadIncrement * -25), 500 );    // add between 1 and this number to the trace length.
        MinimumLength = FMin(250 + (SpreadIncrement * -75), 500 ); // Minimum Length of bolts
        DamageMult = 0.5;          // fork bolts don't do as much damage as the Main bolt
        Omega = 1;               // Number of bolts spawned
        tmpEmitterClass = BranchEmitterClass; 
        tmpStart = start;              // my starting point is where the calling function tells me to start
        Momentum = Default.Momentum;
    }
    else
    {
        BoltSpreadBounds = 0.225;
        BoltSpread = BoltSpreadBounds;
        LengthRange = 500;
        MinimumLength = 1200;
        DamageMult = 1;
        Omega = 10;
        tmpEmitterClass = SpreadEmitterClass;
        tmpStart = ArcEnd;
        BounceNum = 0;
        bLeaveOnlyFirstFlash = True;
        Momentum = Default.Momentum * 0.5;
    }

    //Log("TmpStart ="@TmpStart);
    //Log("Start ="@Start);

    MinimumHollowness = (1 - BoltSpread) - (1 - BoltSpreadBounds);

    //Log("Fired Weapon----------------------------");
    For (Alpha = 0; Alpha < Omega; Alpha++)
    {
        bHitNothing = False;
        /*
            Creates a cone of random directions that points in a random direction.
            Allows code to have a 'hollow range' in the center of the cone, used
            with the standard bolt mode.
        */
        X = Vector(Dir);
        RandCone = VRand();
        RandCone.X = 0;
        RandCone = Normal(RandCone);
        RandCone = RandCone >> Dir;
        RandCone *=( MinimumHollowness + ( fRand() * BoltSpread ) );

        X += RandCone;

        End = Start + (Rand(LengthRange) + MinimumLength) * X;
        Other = Weapon.Trace(HitLocation, HitNormal, End, Start, true);

        if ( Other != None && Other != Instigator )
        {
            if ( !Other.bWorldGeometry )
            {
                //Log("DamageMult ="@DamageMult$", BounceNum ="@BounceNum$", DampeningFactor ="@(1-DampeningFactor));
                DealDamage(X, HitLocation, NumArcs, Other, DamageMult);
            }
            else
                HitLocation = HitLocation + 2.0 * HitNormal;
        }
        else
        {
            bHitNothing = True;
            HitLocation = End;               // setting Hitlocation to where arc "didn't hit"
            HitNormal = Normal(Start - End); // trouble with resetting hitnormal?
        }
        if ( Weapon == None )
            return;

        // Effects spawned here--------------------------------------------------------------
        hitEmitter = Weapon.Spawn(tmpEmitterClass,,, tmpStart, Rotator(HitNormal));

        if ( hitEmitter != None )      // Applying hitlocation to where bolt did or didn't hit.
        {
            hitEmitter.mSpawnVecA = HitLocation;
            if ( bLeaveOnlyFirstFlash && Alpha > 0 )
                hitEmitter.mSpawnVecB.X = 0;

            if ( bHitNothing )
                hitEmitter.mSpawnVecB.Y = 0;
        }
     }
}

Function DealDamage(Vector X, Vector HitLocation, byte arcsRemaining, Actor Other, Float DamageMult)
{
     local Pawn HeadShotPawn;

     SetNewDamage(DamageMult);  // calculate Damage Based on Number of bounces.

     //Log("DamageMult ="@DamageMult$", BounceNum ="@BounceNum$", DampeningFactor ="@(1-DampeningFactor));

     if (Vehicle(Other) != None)
     {
         HeadShotPawn = Vehicle(Other).CheckForHeadShot(HitLocation, X, 1.0);
     }
     if (HeadShotPawn != None)
     {
         HeadShotPawn.TakeDamage(NewDamage * HeadShotDamageMult, Instigator, HitLocation, Momentum*X, DamageTypeHeadShot);
         //Log("Total Damage:"@(NewDamage * HeadShotDamageMult)$", With Headshot!");
     }
     else if ( (Pawn(Other) != None) && (arcsRemaining == NumArcs) && Pawn(Other).IsHeadShot(HitLocation, X, 1.0) )
     {
         Other.TakeDamage(NewDamage * HeadShotDamageMult, Instigator, HitLocation, Momentum*X, DamageTypeHeadShot);
         //Log("Total Damage:"@(NewDamage * HeadShotDamageMult)$", With Headshot!");
     }
     else
     {
         if ( arcsRemaining < NumArcs )
         {
             NewDamage *= SecDamageMult;  // Reduced damage if it is a Secondary arc.
             //Log("Arc hit opponent, Damage:"@NewDamage);
         }
         Other.TakeDamage(NewDamage, Instigator, HitLocation, Momentum*X, CM.Default.DamageTypeLightning_Class[LightningMode]);
         //if ( arcsRemaining == NumArcs )
             //log("Damage:"@NewDamage);
     }
}

function SetNewDamage(Float DamageMult)
{
    NewDamage =  (DamageMin + Rand(DamageMax - DamageMin)) * DamageMult;
    NewDamage *= ((1-DampeningFactor) ** float(BounceNum));
    NewDamage *= DamageAtten;
}

defaultproperties
{
     ReflectEmitterClass=Class'mayhemweapons.ReflectedLightningBolt'
     BranchEmitterClass=Class'mayhemweapons.LightningArcSmall'
     SpreadEmitterClass=Class'mayhemweapons.LightningArcSpread'
     DampeningFactor=0.120000
     BounceMaxNum=5
     BranchFireSound=Sound'MayhemWeaponSounds.Lightning.ltg'
     HitEmitterClass=Class'mayhemweapons.ReflectiveLightningBolt'
     SecHitEmitterClass=Class'mayhemweapons.LightningArcChild'
     AmmoClass=Class'mayhemweapons.MayhemSniperAmmo'
}
