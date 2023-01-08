class LightningArcSmall extends ChildLightningBolt;

simulated function PostBeginPlay()
{
    Super(xEmitter).PostBeginPlay();
}

defaultproperties
{
     bSuspendWhenNotVisible=False
     mSpawnVecB=(X=0.000000,Z=0.000000)
     mSizeRange(0)=22.500000
     mSizeRange(1)=22.500000
}
