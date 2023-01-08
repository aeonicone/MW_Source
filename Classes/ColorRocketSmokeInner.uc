class ColorRocketSmokeInner extends ColorRocketSmokeOuter;

#exec TEXTURE  IMPORT NAME=RocketTrailTex FILE=textures\RocketTrailTex.tga

Simulated Function SetRandomColor() // overridden so that color is in sync with outer rocket smoke
{
    mColorRange[0] = Class'ColorRocketSmokeOuter'.Default.CTS;
    mColorRange[1] = mColorRange[0];
}

defaultproperties
{
     mParticleType=PT_Stream
     mLifeRange(0)=1.000000
     mRegenRange(0)=10.000000
     mRegenRange(1)=10.000000
     mMassRange(0)=0.000000
     mMassRange(1)=0.000000
     mRandOrient=False
     mSpinRange(0)=0.000000
     mSpinRange(1)=0.000000
     mSizeRange(0)=10.000000
     mSizeRange(1)=10.000000
     mGrowthRate=0.000000
     mColorRange(1)=(B=255,G=255)
     mAttenKa=0.000000
     mAttenFunc=ATF_LerpInOut
     mRandTextures=False
     mNumTileColumns=1
     mNumTileRows=1
     Skins(0)=Texture'mayhemweapons.RocketTrailTex'
     Style=STY_Additive
}
