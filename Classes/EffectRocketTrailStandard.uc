class EffectRocketTrailStandard extends Emitter;

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
     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         FadeOut=True
         FadeIn=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         UseRandomSubdivision=True
         ColorMultiplierRange=(Z=(Min=0.950000))
         FadeOutStartTime=0.200000
         FadeInEndTime=0.050000
         MaxParticles=90
         SpinsPerSecondRange=(X=(Min=-0.100000,Max=0.100000))
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=1.750000)
         StartSizeRange=(X=(Min=15.000000,Max=17.000000))
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'XEffects.SmokeAlphab_t'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         LifetimeRange=(Min=1.250000,Max=1.250000)
     End Object
     Emitters(0)=SpriteEmitter'mayhemweapons.EffectRocketTrailStandard.SpriteEmitter1'

     bNoDelete=False
}
