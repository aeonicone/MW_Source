class ReflectiveFlakShell extends FlakShell;

simulated function Explode(vector HitLocation, vector HitNormal)
{
    const FC = class'MayhemFlakCannon';
    const CM = Class'ColorManager';
    local vector start;
    local rotator rot;
    local byte i;
    local ReflectiveFlakChunk NewChunk;
    local Color CTS;

    if (FC.Default.FlakTrailColor == FTC_Group)
        CM.Static.SetRandomTrailColor();
    else if (FC.Default.FlakTrailColor < FTC_Random)
    {
        CTS = CM.Default.ColorBank[
              CM.static.AssignColorIndex(
              CM.Default.ColorName[ FC.default.FlakTrailColor ]
                                        )
                                  ];
        for (i = 0; i < 2; i++)
              class'ReflectiveFlakTrail'.default.mColorRange[i]= CTS;
    }
  	start = Location + 10 * HitNormal;
  	if ( Role == ROLE_Authority )
  	{
                HurtRadius(damage, 220, MyDamageType, MomentumTransfer, HitLocation);
  		for (i=0; i<6; i++)
  		{
  			rot = Rotation;
  			rot.yaw += FRand()*32000-16000;
  			rot.pitch += FRand()*32000-16000;
  			rot.roll += FRand()*32000-16000;
  			NewChunk = Spawn( class'ReflectiveFlakChunk',, '', Start, rot);
  		}
  	}
    Destroy();
}

defaultproperties
{
     MyDamageType=Class'mayhemweapons.DamageTypeMayhemFlakShell'
}
