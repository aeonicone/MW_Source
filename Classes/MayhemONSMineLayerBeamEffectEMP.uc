class MayhemONSMineLayerBeamEffectEMP extends ONSMineLayerTargetBeamEffect;

defaultproperties
{
     Begin Object Class=BeamEmitter Name=BeamEmitter0
         BeamDistanceRange=(Min=10000.000000,Max=10000.000000)
         DetermineEndPointBy=PTEP_Distance
         BeamTextureUScale=16.000000
         RotatingSheets=3
         LowFrequencyPoints=2
         HighFrequencyPoints=2
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=192))
         ColorScale(1)=(RelativeTime=0.500000,Color=(B=255,G=64,R=64))
         ColorScale(2)=(RelativeTime=1.000000,Color=(B=192))
         ColorMultiplierRange=(X=(Min=0.000000,Max=0.000000),Y=(Min=0.000000,Max=0.000000),Z=(Min=0.500000,Max=0.500000))
         MaxParticles=1
         UseRotationFrom=PTRS_Actor
         StartSizeRange=(X=(Min=10.000000,Max=10.000000),Y=(Min=10.000000,Max=10.000000))
         InitialParticlesPerSecond=5000.000000
         Texture=Texture'AW-2004Particles.Weapons.BeamFragment'
         LifetimeRange=(Min=0.020000,Max=0.020000)
         StartVelocityRange=(X=(Min=1.000000,Max=1.000000))
     End Object
     Emitters(0)=BeamEmitter'mayhemweapons.MayhemONSMineLayerBeamEffectEMP.BeamEmitter0'

}
