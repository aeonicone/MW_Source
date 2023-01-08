class EffectRocketFragTrail extends Emitter;

simulated Function postbeginplay()
{
    Super.PostBeginPlay();
    SetTimer(0.3, True);
}

function timer()
{
    //local PlayerController PC;
    //local float EffectDist;
    //local bool bLowerDetail;
    super.Timer();

    /*PC = Level.GetLocalPlayerController();

    if ( PC.ViewTarget != None )
    {
        EffectDist = VSize(PC.ViewTarget.Location - Location);
        bLowerDetail = ( Level.bDropDetail || Level.DetailMode == DM_Low );

        log("EffectDist ="@EffectDist);

        if ( !Emitters[3].Disabled && ( EffectDist > 1800 || bLowerDetail ) )
        {
            Emitters[3].Disabled = True;
            log("Sparkles Disabled");
        }
        Else if ( Emitters[3].Disabled && ( EffectDist <= 1800 || !bLowerDetail ) )
        {
            Emitters[3].Disabled = False;
            Log("Sparkles Enabled");
        }
    }
    else
    {
        if ( !Emitters[3].Disabled )
        {
            Emitters[3].Disabled = true;
            log("Sparkles Disabled, Out of View");
        }
    }                 */

    if ( Self.Base == None )
        Self.Kill();
}

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         UseDirectionAs=PTDU_Scale
         UseColorScale=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         ColorMultiplierRange=(Y=(Min=0.300000,Max=0.500000),Z=(Min=0.000000,Max=0.000000))
         CoordinateSystem=PTCS_Relative
         MaxParticles=3
         StartLocationOffset=(X=-20.000000)
         SpinsPerSecondRange=(X=(Min=-1.000000,Max=1.000000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=2.000000)
         StartSizeRange=(X=(Min=25.000000,Max=28.000000))
         InitialParticlesPerSecond=8000.000000
         Texture=Texture'EpicParticles.Flares.BurnFlare1'
         TextureUSubdivisions=1
         TextureVSubdivisions=1
         LifetimeRange=(Min=0.200000,Max=0.250000)
     End Object
     Emitters(0)=SpriteEmitter'mayhemweapons.EffectRocketFragTrail.SpriteEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         FadeOut=True
         FadeIn=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         ColorMultiplierRange=(Y=(Min=0.500000,Max=0.700000),Z=(Min=0.000000,Max=0.000000))
         Opacity=0.250000
         FadeOutStartTime=0.250000
         FadeInEndTime=0.100000
         CoordinateSystem=PTCS_Relative
         MaxParticles=20
         StartLocationRange=(X=(Min=-20.000000,Max=10.000000))
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=1.500000)
         StartSizeRange=(X=(Min=20.000000,Max=25.000000))
         Texture=Texture'EpicParticles.Flares.SoftFlare'
         LifetimeRange=(Min=0.500000,Max=0.500000)
     End Object
     Emitters(1)=SpriteEmitter'mayhemweapons.EffectRocketFragTrail.SpriteEmitter1'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter2
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         DetermineVelocityByLocationDifference=True
         AutomaticInitialSpawning=False
         UseRandomSubdivision=True
         Acceleration=(Z=300.000000)
         Opacity=0.250000
         FadeOutFactor=(W=5.000000)
         FadeOutStartTime=0.250000
         MaxParticles=100
         StartLocationRange=(X=(Min=-15.000000,Max=15.000000),Y=(Min=-15.000000,Max=15.000000),Z=(Min=-15.000000,Max=15.000000))
         SpinsPerSecondRange=(X=(Min=-0.500000,Max=0.500000))
         StartSpinRange=(X=(Min=0.550000,Max=0.450000))
         SizeScale(0)=(RelativeTime=0.100000,RelativeSize=5.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=3.000000)
         StartSizeRange=(X=(Min=4.000000,Max=4.000000))
         ParticlesPerSecond=150.000000
         InitialParticlesPerSecond=150.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'AW-2004Particles.Fire.MuchSmoke2t'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         LifetimeRange=(Min=1.000000,Max=1.250000)
         StartVelocityRange=(X=(Min=-15.000000,Max=15.000000),Y=(Min=-15.000000,Max=15.000000),Z=(Min=-15.000000,Max=15.000000))
     End Object
     Emitters(2)=SpriteEmitter'mayhemweapons.EffectRocketFragTrail.SpriteEmitter2'

     Begin Object Class=SparkEmitter Name=SparkEmitter0
         LineSegmentsRange=(Min=0.100000,Max=0.100000)
         TimeBetweenSegmentsRange=(Min=0.020000,Max=0.020000)
         FadeOut=True
         Acceleration=(Z=-200.000000)
         Opacity=0.500000
         FadeOutStartTime=0.250000
         CoordinateSystem=PTCS_Relative
         MaxParticles=75
         StartLocationRange=(X=(Min=-57.000000,Max=-45.000000),Y=(Min=-7.000000,Max=7.000000),Z=(Min=-7.000000,Max=7.000000))
         Texture=Texture'EpicParticles.Smoke.FlameGradient'
         LifetimeRange=(Min=0.500000,Max=0.500000)
         StartVelocityRange=(X=(Min=-500.000000,Max=-700.000000),Y=(Min=-100.000000,Max=100.000000),Z=(Min=-50.000000,Max=100.000000))
     End Object
     Emitters(3)=SparkEmitter'mayhemweapons.EffectRocketFragTrail.SparkEmitter0'

     AutoDestroy=True
     bNoDelete=False
     bRotateToDesired=True
}
