Class MayhemBioGlobSplitter extends MayhemBioGlob;

const SPLIT_COUNT = 2;
const SPLIT_SPREAD = 2000.0;

Simulated singular Function BioGlob GlobSplit(Vector HitNormal) // assumes gooplevel is 2 or greater.
{
    local BioGlob Glob;
    local Rotator SplitDir;
    local vector X;
    Local Float Theta;
    local byte p;

    SplitDir = Rotator(GetBounceVector(HitNormal));
    if (Role == ROLE_Authority)
        for (p = 0; p < SPLIT_COUNT; p++)
        {
            theta = SPLIT_SPREAD*PI/32768*(p - float(SPLIT_COUNT-1)/2.0);
            X.X = Cos(theta);
            X.Y = Sin(theta);
            X.Z = 0.0;
            Glob = Spawn(Class,Self,, Location+GoopVolume*(CollisionHeight+4.0)*HitNormal, Rotator(X >> SplitDir));
            if( Glob != None )
                Glob.SetGoopLevel( Ceil( Float(GoopLevel) / Float(SPLIT_COUNT) ) );
        }
    return Glob;
}

simulated function Landed( Vector HitNormal )
{
    Local BioGlob Glob;

    if ( Level.NetMode != NM_DedicatedServer )
    {
        PlaySound(ImpactSound, SLOT_Misc);
        // explosion effects
    }

    spawn(class'BioDecal',,,, rotator(-HitNormal));

    if ( GoopLevel >= SPLIT_COUNT )
        Glob = GlobSplit(HitNormal);

    if ( Glob != None )
        Destroy();
    else
        Velocity = GetBounceVector(HitNormal);
}

event TakeDamage( int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DType)
{   
    if (class<DamageTypeMayhemFlubber>(DType) == None)    // immune to explosion damage from Spider Mines.
        Super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DType);
}

defaultproperties
{
     LifeSpan=6.000000
}
