class ReflectiveLinkAttachment extends LinkAttachment;

var bool bRandomColor;

simulated event ThirdPersonEffects()
{
    local Rotator R;
    local byte i;
    local Color CTS;

    if ( Level.NetMode != NM_DedicatedServer && FlashCount > 0 )
    {
        if (FiringMode == 0)
        {
            if (MuzFlash == None)
            {                                                           // making customized 3rd effect classes.
                MuzFlash = Spawn(class'ReflectiveLinkMuzFlashProj3rd');
                AttachToBone(MuzFlash, 'tip');
			UpdateLinkColor();
            }
            if (MuzFlash != None)
            {
                MuzFlash.mSizeRange[0] = MuzFlash.default.mSizeRange[0] * (class'LinkFire'.default.LinkScale[Min(Links,5)]+1); // (1.0 + 0.3*float(Links));
                MuzFlash.mSizeRange[1] = MuzFlash.mSizeRange[0];

                CTS = Class'ColorManager'.default.ColorBank[Rand(11)];
                for (i=0; i < 2; i++)
                    MuzFlash.mColorRange[i] = CTS;

                MuzFlash.Trigger(self, None);
                R.Roll = Rand(65536);
                SetBoneRotation('bone flashA', R, 0, 1.0);
            }
        }
    }
    super(xWeaponAttachment).ThirdPersonEffects();    // skipping LinkAttachment class super
}

simulated function UpdateLinkColor()
{
    super.UpdateLinkColor();
    // overridding skin that was set by super method.
    if ( MuzFlash != None )
        MuzFlash.Skins[0] = FinalBlend'MayhemWeaponEffects.LinkMuzProjGreenFB'; // named green, but actually is desaturated.
}

defaultproperties
{
     Skins(0)=Texture'mayhemweapons.LinkGunTex'
}
