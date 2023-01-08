class ColorRocketSmokeOuter Extends RocketTrailSmoke;

var Color CTS;

Function PostBeginPlay()
{
    if (class'MayhemRocketLauncher'.Default.TrailColor == TRAIL_Wild)
        setTimer(0.05, true);
}

simulated function Timer()
{
    SetRandomColor();
}

Simulated Function SetRandomColor()
{
    CTS = class'ColorManager'.static.AssignRandomColor();
    Default.CTS = CTS;

    mColorRange[0] = CTS;
    mColorRange[1] = CTS;
}

defaultproperties
{
}
