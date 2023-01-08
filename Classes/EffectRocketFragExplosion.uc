class EffectRocketFragExplosion extends Emitter;

#exec OBJ LOAD File=AW-2004Particles.utx

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         UseColorScale=True
         FadeIn=True
         RespawnDeadParticles=False
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         UseRandomSubdivision=True
         Acceleration=(Z=100.000000)
         ColorScale(0)=(Color=(B=64,G=64,R=64,A=255))
         ColorScale(1)=(RelativeTime=0.600000,Color=(B=128,G=128,R=128,A=255))
         ColorScale(2)=(RelativeTime=1.000000)
         FadeOutStartTime=0.750000
         FadeInEndTime=0.100000
         MaxParticles=3
         StartLocationRange=(X=(Min=-100.000000,Max=100.000000),Y=(Min=-100.000000,Max=100.000000),Z=(Min=50.000000,Max=100.000000))
         StartLocationShape=PTLS_Sphere
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=3.000000)
         InitialParticlesPerSecond=10.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'AW-2004Particles.Weapons.DustSmoke'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         LifetimeRange=(Min=1.000000,Max=1.000000)
     End Object
     Emitters(0)=SpriteEmitter'mayhemweapons.EffectRocketFragExplosion.SpriteEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         BlendBetweenSubdivisions=True
         Opacity=0.500000
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Max=48.000000)
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=0.750000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.500000)
         StartSizeRange=(X=(Min=30.000000,Max=40.000000))
         InitialParticlesPerSecond=3000.000000
         Texture=Texture'ExplosionTex.Framed.exp1_frames'
         TextureUSubdivisions=2
         TextureVSubdivisions=4
         LifetimeRange=(Min=0.400000,Max=0.400000)
     End Object
     Emitters(1)=SpriteEmitter'mayhemweapons.EffectRocketFragExplosion.SpriteEmitter1'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter2
         UseColorScale=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(G=180,R=245))
         ColorScale(1)=(RelativeTime=1.000000)
         ColorMultiplierRange=(Y=(Min=0.750000,Max=0.750000),Z=(Min=0.000000,Max=0.000000))
         Opacity=3.000000
         MaxParticles=2
         SpinsPerSecondRange=(X=(Max=1.000000))
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=3.500000)
         StartSizeRange=(X=(Min=65.000000,Max=70.000000))
         InitialParticlesPerSecond=100.000000
         Texture=Texture'AW-2004Particles.Weapons.GrenExpl'
         LifetimeRange=(Min=0.100000,Max=0.200000)
     End Object
     Emitters(2)=SpriteEmitter'mayhemweapons.EffectRocketFragExplosion.SpriteEmitter2'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter3
         UseDirectionAs=PTDU_Up
         UseCollision=True
         UseColorScale=True
         RespawnDeadParticles=False
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=255,G=255,R=255))
         ColorScale(1)=(RelativeTime=0.700000,Color=(B=60,G=187,R=255))
         ColorScale(2)=(RelativeTime=1.000000)
         ColorMultiplierRange=(Y=(Min=0.500000,Max=0.500000),Z=(Min=0.000000,Max=0.000000))
         MaxParticles=20
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=32.000000,Max=32.000000)
         StartSizeRange=(X=(Min=7.000000,Max=10.000000),Y=(Min=35.000000,Max=45.000000))
         InitialParticlesPerSecond=50000.000000
         Texture=Texture'AW-2004Particles.Energy.SparkHead'
         LifetimeRange=(Min=0.350000,Max=0.450000)
         StartVelocityRadialRange=(Min=-1250.000000,Max=-1750.000000)
         GetVelocityDirectionFrom=PTVD_AddRadial
     End Object
     Emitters(3)=SpriteEmitter'mayhemweapons.EffectRocketFragExplosion.SpriteEmitter3'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter6
         FadeOut=True
         FadeIn=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         FadeOutStartTime=0.075000
         FadeInEndTime=0.025000
         MaxParticles=1
         SpinsPerSecondRange=(X=(Min=-1.000000,Max=1.000000))
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=3.000000)
         StartSizeRange=(X=(Min=200.000000,Max=225.000000))
         InitialParticlesPerSecond=50.000000
         Texture=Texture'AW-2004Particles.Weapons.PlasmaStar'
         LifetimeRange=(Min=0.100000,Max=0.100000)
     End Object
     Emitters(4)=SpriteEmitter'mayhemweapons.EffectRocketFragExplosion.SpriteEmitter6'

     AutoDestroy=True
     LightType=LT_FadeOut
     LightEffect=LE_QuadraticNonIncidence
     LightHue=25
     LightSaturation=25
     LightBrightness=255.000000
     LightRadius=8.000000
     LightPeriod=32
     LightCone=128
     bNoDelete=False
     bDynamicLight=True
     LifeSpan=1.250000
}
