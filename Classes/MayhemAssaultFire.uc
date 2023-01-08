Class MayhemAssaultFire extends AssaultFire;

var float MaxSpread, // The Maximum size cone of fire
          SpreadQuickness;  // The speed that the spread looses accuracy per shot.

event ModeDoFire()
{
    if ( !Bool(Instigator.Controller.bDuck) )    // When not crouching
    {
        if ( MaxSpread != Default.MaxSpread )
        {
            MaxSpread = Default.MaxSpread;
            SpreadQuickness = Default.SpreadQuickness;
        }
    }
    else
    {
        if ( MaxSpread == Default.MaxSpread )
        {
            MaxSpread = 0.027;
            SpreadQuickness *= 0.3;
        }
    }
    if ( Level.TimeSeconds - LastFireTime > 0.5 )
	Spread = Default.Spread;
    else
	Spread = FMin(Spread + SpreadQuickness, MaxSpread);  // default parameters are ( Spread + 0.02, 0.12 )
    LastFireTime = Level.TimeSeconds;
    Super(InstantFire).ModeDoFire();
}

defaultproperties
{
     MaxSpread=0.060000
     SpreadQuickness=0.015000
     DamageType=Class'mayhemweapons.DamageTypeMayhemAssaultFire'
     DamageMin=8
     DamageMax=8
     Spread=0.010000
}
