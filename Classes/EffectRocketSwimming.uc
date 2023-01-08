class EffectRocketSwimming extends Emitter;

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
     Begin Object Class=SpriteEmitter Name=SpriteEmitter12
         UseColorScale=True
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         UseRandomSubdivision=True
         Acceleration=(Z=200.000000)
         ColorScale(0)=(Color=(B=160,G=160,R=160,A=255))
         ColorScale(1)=(RelativeTime=0.500000,Color=(B=120,G=120,R=120,A=255))
         ColorScale(2)=(RelativeTime=1.000000,Color=(B=100,G=100,R=100))
         Opacity=0.750000
         MaxParticles=34
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Max=4.000000)
         SpinsPerSecondRange=(X=(Max=0.050000))
         StartSpinRange=(X=(Min=0.550000,Max=0.450000))
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=0.500000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=0.500000)
         StartSizeRange=(X=(Min=3.000000,Max=5.000000))
         ParticlesPerSecond=50.000000
         InitialParticlesPerSecond=50.000000
         Texture=Texture'EmitterTextures.SingleFrame.Bubble'
         TextureUSubdivisions=1
         TextureVSubdivisions=1
         LifetimeRange=(Min=0.750000,Max=1.000000)
         StartVelocityRange=(X=(Min=-5.000000,Max=-5.000000),Y=(Min=-5.000000,Max=-5.000000),Z=(Min=-5.000000,Max=-5.000000))
     End Object
     Emitters(4)=SpriteEmitter'mayhemweapons.EffectRocketSwimming.SpriteEmitter12'

     bNoDelete=False
     LifeSpan=7.000000
}
