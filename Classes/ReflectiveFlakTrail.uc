class ReflectiveFlakTrail extends FlakTrail;

#exec TEXTURE  IMPORT NAME=FlakTrailTex FILE=textures\FlakTrailTex.tga DXT=1

Function PostBeginPlay()
{
    if (Class'MayhemFlakCannon'.Default.FlakTrailColor == FTC_Wild)
        SetTimer(0.04, true);
    else if (Class'MayhemFlakCannon'.Default.FlakTrailColor == FTC_Random)
        SetRandomColor();
}

simulated function Timer()
{
    SetRandomColor();
}

Simulated Function SetRandomColor()
{
    mColorRange[0] = class'ColorManager'.static.AssignRandomColor();
    mColorRange[1] = mColorRange[0];
}

defaultproperties
{
     mGrowthRate=-1.200000
     Skins(0)=Texture'mayhemweapons.FlakTrailTex'
}
