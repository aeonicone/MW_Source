class EffectRocketFlaming extends Emitter;

simulated Function postbeginplay()
{
    Super.PostBeginPlay();
    SetTimer(0.2, True);
}

function timer()
{
    super.Timer();

    if ( Self.Base == None )
        Self.Kill();
}

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         UseDirectionAs=PTDU_Scale
         UseColorScale=True
         FadeOut=True
         FadeIn=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         ColorMultiplierRange=(Z=(Min=0.000000,Max=0.000000))
         Opacity=0.500000
         FadeOutStartTime=0.125000
         FadeInEndTime=0.100000
         CoordinateSystem=PTCS_Relative
         MaxParticles=2
         StartLocationOffset=(X=30.000000)
         StartLocationRange=(X=(Min=-50.000000,Max=-50.000000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=1.250000)
         StartSizeRange=(X=(Min=55.000000,Max=60.000000))
         InitialParticlesPerSecond=8000.000000
         Texture=Texture'AW-2004Particles.Weapons.PlasmaStarRed'
         LifetimeRange=(Min=0.200000,Max=0.200000)
     End Object
     Emitters(0)=SpriteEmitter'mayhemweapons.EffectRocketFlaming.SpriteEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         UseDirectionAs=PTDU_Right
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=15,G=9,R=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=7,G=1,R=250))
         ColorMultiplierRange=(Z=(Min=0.250000,Max=0.250000))
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         StartLocationRange=(X=(Min=-50.000000,Max=-50.000000))
         StartSizeRange=(X=(Min=-40.000000,Max=-40.000000),Y=(Min=30.000000,Max=30.000000))
         InitialParticlesPerSecond=500.000000
         Texture=Texture'AW-2004Particles.Weapons.PlasmaHeadRed'
         LifetimeRange=(Min=0.200000,Max=0.200000)
         StartVelocityRange=(X=(Max=10.000000))
         VelocityLossRange=(X=(Min=1.000000,Max=1.000000))
     End Object
     Emitters(1)=SpriteEmitter'mayhemweapons.EffectRocketFlaming.SpriteEmitter1'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter2
         UseColorScale=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         BlendBetweenSubdivisions=True
         ColorScale(1)=(RelativeTime=0.100000,Color=(G=128,R=255))
         ColorScale(2)=(RelativeTime=0.500000,Color=(R=251))
         ColorScale(3)=(RelativeTime=1.000000)
         ColorMultiplierRange=(Z=(Min=0.000000,Max=0.000000))
         CoordinateSystem=PTCS_Relative
         MaxParticles=15
         DetailMode=DM_High
         StartLocationOffset=(X=-15.000000)
         SpinsPerSecondRange=(X=(Max=0.200000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000)
         StartSizeRange=(X=(Min=15.000000,Max=15.000000))
         Texture=Texture'AW-2004Particles.Fire.MuchSmoke2t'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         LifetimeRange=(Min=0.300000,Max=0.350000)
         StartVelocityRange=(X=(Min=-500.000000,Max=-500.000000))
         WarmupTicksPerSecond=1.000000
         RelativeWarmupTime=2.000000
     End Object
     Emitters(2)=SpriteEmitter'mayhemweapons.EffectRocketFlaming.SpriteEmitter2'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter3
         FadeOut=True
         FadeIn=True
         UniformSize=True
         ColorMultiplierRange=(Y=(Min=0.500000,Max=0.500000),Z=(Min=0.000000,Max=0.000000))
         FadeOutStartTime=0.300000
         FadeInEndTime=0.200000
         CoordinateSystem=PTCS_Relative
         MaxParticles=25
         StartLocationRange=(X=(Min=-15.000000,Max=15.000000))
         StartSizeRange=(X=(Min=15.000000,Max=25.000000))
         Texture=Texture'EpicParticles.Flares.SoftFlare'
         LifetimeRange=(Min=0.500000,Max=0.500000)
     End Object
     Emitters(3)=SpriteEmitter'mayhemweapons.EffectRocketFlaming.SpriteEmitter3'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter4
         UseColorScale=True
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         UseRandomSubdivision=True
         Acceleration=(Z=100.000000)
         ColorScale(0)=(Color=(B=160,G=160,R=160,A=255))
         ColorScale(1)=(RelativeTime=0.500000,Color=(B=120,G=120,R=120,A=255))
         ColorScale(2)=(RelativeTime=1.000000,Color=(B=100,G=100,R=100))
         Opacity=0.250000
         MaxParticles=100
         SpinsPerSecondRange=(X=(Max=0.050000))
         StartSpinRange=(X=(Min=0.550000,Max=0.450000))
         SizeScale(0)=(RelativeTime=0.300000,RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.500000)
         StartSizeRange=(X=(Min=10.000000,Max=15.000000))
         ParticlesPerSecond=150.000000
         InitialParticlesPerSecond=150.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'AW-2004Particles.Fire.MuchSmoke1'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         LifetimeRange=(Min=1.000000,Max=1.200000)
         StartVelocityRange=(X=(Min=15.000000,Max=-15.000000),Y=(Min=-15.000000,Max=15.000000),Z=(Min=-15.000000,Max=15.000000))
     End Object
     Emitters(4)=SpriteEmitter'mayhemweapons.EffectRocketFlaming.SpriteEmitter4'

     bNoDelete=False
     LifeSpan=10.000000
     bRotateToDesired=True
}
