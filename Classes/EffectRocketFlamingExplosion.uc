class EffectRocketFlamingExplosion extends Emitter;

Const RepeatRate = 0.1;  // rate for the timer to repeat at.
var bool bStuckToTarget;

Simulated Function PostBeginPlay()
{
    local PlayerController PC;
    local float EffectDist;
    local bool bLowerDetail;
    //log("New Explosion ----------------------------- ");
    super.PostBeginPlay();

    PC = Level.GetLocalPlayerController();

    if ( PC.ViewTarget != None )
    {
        bLowerDetail = ( Level.bDropDetail || Level.DetailMode == DM_Low );
        EffectDist = VSize(PC.ViewTarget.Location - Location);

        //Log("EffectDist ="@EffectDist);
        //Log("Lower Detail ="@bLowerDetail);

        Emitters[0].Disabled = ( EffectDist > 6000 || ( bLowerDetail && EffectDist > 4900 ) );
        Emitters[5].Disabled = ( EffectDist > 5000 || ( bLowerDetail && EffectDist > 3200 ) );
        Emitters[3].Disabled = ( EffectDist > 1500 || ( bLowerDetail ) );
    }
    else
    {
        Emitters[3].Disabled = True;
    }

    //Log("Smoke"@!Emitters[0].Disabled);
    //Log("Sparks"@!Emitters[3].Disabled);
    //Log("Flares"@!Emitters[5].Disabled);

    setTimer(RepeatRate, True);
}

simulated function AdhereToTarget(Actor Target)
{
    if (bStuckToTarget)
        SetBase(Target);
}

Simulated Function Timer()   // "simulated" new in version after 14.1
{
    if (PhysicsVolume.bWaterVolume)
    {
        bStuckToTarget = False;
        //log("NOTICE: Incendiary flame was put out by water volume.");
        self.Kill();
    }
    //Log("Flame Explosion Active");
}

//total effect time is about 2 seconds

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
         Acceleration=(Z=30.000000)
         DampingFactorRange=(X=(Min=0.000000,Max=0.000000),Y=(Min=0.000000,Max=0.000000),Z=(Min=0.000000,Max=0.000000))
         ColorScale(0)=(Color=(B=64,G=64,R=64,A=255))
         ColorScale(1)=(RelativeTime=0.600000,Color=(B=32,G=32,R=32,A=255))
         ColorScale(2)=(RelativeTime=1.000000)
         FadeOutStartTime=0.750000
         FadeInEndTime=0.250000
         MaxParticles=35
         StartLocationRange=(X=(Min=-60.000000,Max=60.000000),Y=(Min=-60.000000,Max=60.000000))
         StartLocationShape=PTLS_Sphere
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.000000)
         InitialParticlesPerSecond=15.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'AW-2004Particles.Weapons.DustSmoke'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         LifetimeRange=(Min=1.000000,Max=1.000000)
     End Object
     Emitters(0)=SpriteEmitter'mayhemweapons.EffectRocketFlamingExplosion.SpriteEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         BlendBetweenSubdivisions=True
         DampingFactorRange=(X=(Min=0.000000,Max=0.000000),Y=(Min=0.000000,Max=0.000000),Z=(Min=0.000000,Max=0.000000))
         ColorMultiplierRange=(Y=(Min=0.500000,Max=0.600000),Z=(Min=0.250000,Max=0.250000))
         Opacity=0.800000
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=32.000000,Max=64.000000)
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=0.750000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.500000)
         StartSizeRange=(X=(Min=65.000000,Max=75.000000))
         InitialParticlesPerSecond=3000.000000
         Texture=Texture'ExplosionTex.Framed.exp1_frames'
         TextureUSubdivisions=2
         TextureVSubdivisions=4
         LifetimeRange=(Min=0.400000,Max=0.400000)
     End Object
     Emitters(1)=SpriteEmitter'mayhemweapons.EffectRocketFlamingExplosion.SpriteEmitter1'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter2
         UseColorScale=True
         RespawnDeadParticles=False
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(G=180,R=245))
         ColorScale(1)=(RelativeTime=1.000000)
         ColorMultiplierRange=(Y=(Min=0.500000,Max=0.500000),Z=(Min=0.000000,Max=0.000000))
         Opacity=0.500000
         MaxParticles=5
         SpinsPerSecondRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=4.000000)
         StartSizeRange=(X=(Min=65.000000))
         InitialParticlesPerSecond=100.000000
         Texture=Texture'AW-2004Particles.Energy.JumpDuck'
         LifetimeRange=(Min=0.300000,Max=0.300000)
     End Object
     Emitters(2)=SpriteEmitter'mayhemweapons.EffectRocketFlamingExplosion.SpriteEmitter2'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter3
         UseDirectionAs=PTDU_Up
         UseCollision=True
         UseColorScale=True
         RespawnDeadParticles=False
         AutomaticInitialSpawning=False
         Acceleration=(Z=-600.000000)
         ColorScale(0)=(Color=(B=255,G=255,R=255))
         ColorScale(1)=(RelativeTime=0.700000,Color=(B=60,G=187,R=255))
         ColorScale(2)=(RelativeTime=1.000000)
         ColorMultiplierRange=(Y=(Min=0.500000,Max=0.500000),Z=(Min=0.000000,Max=0.000000))
         MaxParticles=50
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=32.000000,Max=32.000000)
         StartSizeRange=(X=(Min=8.000000,Max=6.000000),Y=(Min=12.000000,Max=12.000000))
         InitialParticlesPerSecond=50000.000000
         Texture=Texture'AW-2004Particles.Energy.SparkHead'
         LifetimeRange=(Min=1.000000,Max=1.000000)
         StartVelocityRadialRange=(Min=-100.000000,Max=-500.000000)
         GetVelocityDirectionFrom=PTVD_AddRadial
     End Object
     Emitters(3)=SpriteEmitter'mayhemweapons.EffectRocketFlamingExplosion.SpriteEmitter3'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter4
         UseCollision=True
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
         Acceleration=(Z=100.000000)
         ColorMultiplierRange=(X=(Min=0.750000,Max=0.750000),Y=(Min=0.750000,Max=0.750000),Z=(Min=0.250000,Max=0.250000))
         Opacity=0.750000
         FadeOutStartTime=0.250000
         FadeInEndTime=0.250000
         MaxParticles=100
         StartLocationRange=(X=(Min=-30.000000,Max=30.000000),Y=(Min=-30.000000,Max=30.000000),Z=(Max=10.000000))
         StartLocationPolarRange=(X=(Min=65536.000000,Max=65536.000000),Y=(Min=65536.000000,Max=65536.000000),Z=(Min=65536.000000,Max=65536.000000))
         SpinsPerSecondRange=(X=(Min=0.250000,Max=-0.250000))
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=8.000000)
         StartSizeRange=(X=(Min=10.000000,Max=15.000000))
         InitialParticlesPerSecond=50.000000
         Texture=Texture'AW-2004Explosions.Fire.Fireball4'
         TextureUSubdivisions=1
         TextureVSubdivisions=1
         LifetimeRange=(Min=1.000000,Max=1.000000)
         StartVelocityRange=(Z=(Min=10.000000,Max=30.000000))
         StartVelocityRadialRange=(Max=-100.000000)
         GetVelocityDirectionFrom=PTVD_AddRadial
     End Object
     Emitters(4)=SpriteEmitter'mayhemweapons.EffectRocketFlamingExplosion.SpriteEmitter4'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter5
         UseCollision=True
         FadeOut=True
         FadeIn=True
         RespawnDeadParticles=False
         SpinParticles=True
         UniformSize=True
         AutomaticInitialSpawning=False
         Acceleration=(Z=200.000000)
         ColorMultiplierRange=(Y=(Min=0.500000,Max=0.500000),Z=(Min=0.000000,Max=0.000000))
         FadeOutStartTime=0.750000
         FadeInEndTime=0.250000
         MaxParticles=40
         StartLocationRange=(X=(Min=-75.000000,Max=75.000000),Y=(Min=-75.000000,Max=75.000000))
         RevolutionsPerSecondRange=(Z=(Min=-0.500000,Max=0.500000))
         SpinsPerSecondRange=(X=(Min=20.000000,Max=20.000000))
         StartSizeRange=(X=(Min=25.000000,Max=40.000000))
         InitialParticlesPerSecond=20.000000
         Texture=Texture'EpicParticles.Flares.FlickerFlare2'
         LifetimeRange=(Min=1.000000,Max=1.000000)
         StartVelocityRange=(X=(Min=-20.000000,Max=20.000000),Y=(Min=-20.000000,Max=20.000000),Z=(Min=40.000000,Max=60.000000))
     End Object
     Emitters(5)=SpriteEmitter'mayhemweapons.EffectRocketFlamingExplosion.SpriteEmitter5'

     AutoDestroy=True
     LightType=LT_FadeOut
     LightEffect=LE_QuadraticNonIncidence
     LightHue=20
     LightSaturation=25
     LightBrightness=255.000000
     LightRadius=9.000000
     LightPeriod=32
     LightCone=128
     bNoDelete=False
     bDynamicLight=True
     LifeSpan=3.250000
}
