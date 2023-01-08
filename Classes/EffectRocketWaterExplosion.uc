class EffectRocketWaterExplosion extends Emitter;

//total effect time is much shorter than the incendiary effect.
//make the explosion do initial damage but the Per Second damage should not exist (when underwater)

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         BlendBetweenSubdivisions=True
         ColorMultiplierRange=(X=(Min=0.250000,Max=0.250000),Y=(Min=0.500000,Max=0.500000))
         Opacity=0.500000
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=32.000000,Max=64.000000)
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=0.750000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.500000)
         StartSizeRange=(X=(Min=50.000000,Max=50.000000))
         InitialParticlesPerSecond=3000.000000
         Texture=Texture'ExplosionTex.Framed.exp1_frames'
         TextureUSubdivisions=2
         TextureVSubdivisions=4
         LifetimeRange=(Min=0.400000,Max=0.400000)
     End Object
     Emitters(0)=SpriteEmitter'mayhemweapons.EffectRocketWaterExplosion.SpriteEmitter1'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter2
         UseColorScale=True
         RespawnDeadParticles=False
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=155,G=155,R=155))
         ColorScale(1)=(RelativeTime=1.000000)
         Opacity=0.250000
         MaxParticles=5
         SpinsPerSecondRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=4.000000)
         StartSizeRange=(X=(Min=50.000000,Max=50.000000))
         InitialParticlesPerSecond=100.000000
         Texture=Texture'AW-2004Particles.Energy.JumpDuck'
         LifetimeRange=(Min=0.300000,Max=0.300000)
     End Object
     Emitters(1)=SpriteEmitter'mayhemweapons.EffectRocketWaterExplosion.SpriteEmitter2'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter4
         FadeOut=True
         FadeIn=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         BlendBetweenSubdivisions=True
         UseRandomSubdivision=True
         Acceleration=(Z=50.000000)
         Opacity=0.500000
         FadeOutStartTime=0.250000
         FadeInEndTime=0.250000
         MaxParticles=20
         StartLocationRange=(X=(Min=-20.000000,Max=20.000000),Y=(Min=-20.000000,Max=20.000000),Z=(Min=-10.000000,Max=10.000000))
         StartLocationPolarRange=(X=(Min=65536.000000,Max=65536.000000),Y=(Min=65536.000000,Max=65536.000000),Z=(Min=65536.000000,Max=65536.000000))
         SpinsPerSecondRange=(X=(Min=0.050000,Max=0.100000))
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=8.000000)
         StartSizeRange=(X=(Min=7.000000,Max=10.000000))
         InitialParticlesPerSecond=50.000000
         Texture=Texture'AW-2004Particles.Fire.MuchSmoke2t'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         LifetimeRange=(Min=1.000000,Max=1.000000)
         StartVelocityRange=(Z=(Min=10.000000,Max=30.000000))
         StartVelocityRadialRange=(Max=-50.000000)
         GetVelocityDirectionFrom=PTVD_AddRadial
     End Object
     Emitters(2)=SpriteEmitter'mayhemweapons.EffectRocketWaterExplosion.SpriteEmitter4'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter5
         FadeOut=True
         FadeIn=True
         RespawnDeadParticles=False
         SpinParticles=True
         UniformSize=True
         AutomaticInitialSpawning=False
         Acceleration=(Z=700.000000)
         Opacity=0.500000
         FadeOutStartTime=0.250000
         FadeInEndTime=0.100000
         MaxParticles=30
         StartLocationRange=(X=(Min=-50.000000,Max=50.000000),Y=(Min=-50.000000,Max=50.000000))
         RevolutionsPerSecondRange=(Z=(Min=-0.500000,Max=0.500000))
         SpinsPerSecondRange=(X=(Min=-10.000000,Max=10.000000))
         StartSizeRange=(X=(Min=4.000000,Max=6.000000))
         InitialParticlesPerSecond=40.000000
         Texture=Texture'EmitterTextures.SingleFrame.Bubble'
         LifetimeRange=(Min=0.500000,Max=0.500000)
         StartVelocityRange=(Z=(Min=50.000000,Max=100.000000))
     End Object
     Emitters(3)=SpriteEmitter'mayhemweapons.EffectRocketWaterExplosion.SpriteEmitter5'

     AutoDestroy=True
     LightType=LT_FadeOut
     LightEffect=LE_QuadraticNonIncidence
     LightSaturation=255
     LightBrightness=255.000000
     LightRadius=6.000000
     LightPeriod=32
     LightCone=128
     bNoDelete=False
     bDynamicLight=True
     LifeSpan=2.000000
}
