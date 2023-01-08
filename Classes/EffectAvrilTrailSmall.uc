class EffectAvrilTrailSmall extends Emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         UseColorScale=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         ColorScale(0)=(Color=(B=210,G=157,R=85))
         ColorScale(1)=(RelativeTime=0.200000,Color=(B=130,G=226,R=255))
         ColorScale(2)=(RelativeTime=0.475000,Color=(G=135,R=225))
         ColorScale(3)=(RelativeTime=1.000000)
         MaxParticles=20
         UseRotationFrom=PTRS_Actor
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=3.000000)
         StartSizeRange=(X=(Min=5.000000,Max=5.000000))
         ParticlesPerSecond=120.000000
         InitialParticlesPerSecond=200.000000
         Texture=Texture'AW-2004Particles.Weapons.SmokePanels1'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         LifetimeRange=(Min=0.050000,Max=0.100000)
     End Object
     Emitters(0)=SpriteEmitter'mayhemweapons.EffectAvrilTrailSmall.SpriteEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         UseColorScale=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         UseRandomSubdivision=True
         Acceleration=(Z=20.000000)
         ColorScale(0)=(Color=(B=160,G=160,R=160,A=255))
         ColorScale(1)=(RelativeTime=0.500000,Color=(B=120,G=120,R=120,A=255))
         ColorScale(2)=(RelativeTime=1.000000,Color=(B=100,G=100,R=100))
         Opacity=0.700000
         MaxParticles=1000
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Max=8.000000)
         SpinsPerSecondRange=(X=(Min=-0.050000,Max=0.050000))
         StartSpinRange=(X=(Min=0.550000,Max=0.450000))
         SizeScale(0)=(RelativeSize=0.500000)
         SizeScale(1)=(RelativeTime=0.140000,RelativeSize=2.000000)
         SizeScale(2)=(RelativeTime=1.000000,RelativeSize=3.000000)
         StartSizeRange=(X=(Min=4.000000,Max=6.000000))
         ParticlesPerSecond=150.000000
         InitialParticlesPerSecond=150.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'AW-2004Particles.Fire.MuchSmoke1'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         LifetimeRange=(Min=1.000000,Max=1.500000)
         StartVelocityRange=(X=(Min=-5.000000,Max=5.000000),Y=(Min=-5.000000,Max=5.000000),Z=(Min=-5.000000,Max=5.000000))
     End Object
     Emitters(1)=SpriteEmitter'mayhemweapons.EffectAvrilTrailSmall.SpriteEmitter1'

     AutoDestroy=True
     bNoDelete=False
     AmbientSound=Sound'WeaponSounds.RocketLauncher.RocketLauncherProjectile'
     bHardAttach=True
     SoundVolume=255
     SoundRadius=100.000000
}
