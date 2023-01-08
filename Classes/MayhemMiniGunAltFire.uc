class MayhemMinigunAltFire extends MinigunAltFire;

var byte MinigunMode;

Function DoFireEffect()
{
    // This Code makes the minigun fire more accurately if the user is crouching
    if ( Bool(Instigator.Controller.bDuck) )
        Spread = Default.Spread * ( 0.6 - ( MinigunMode * 0.1 ) );
    else
        Spread = Default.Spread;

    Super.DoFireEffect();
}

function ShakeView()
{
    local PlayerController P;

    P = PlayerController(Instigator.Controller);
    if ( P != None )
    {
        // Don't Reset them again if they've already been set.
        if ( ShakeRotMag != Default.ShakeRotMag && MinigunMode == 0 )
        {
            ShakeRotMag = Default.ShakeRotMag;
            ShakeRotRate = Default.ShakeRotRate;
            ShakeOffSetMag = Default.ShakeOffSetMag;
            ShakeOffSetRate = Default.ShakeOffSetRate;
        }
        else if ( ShakeRotMag == Default.ShakeRotMag && MinigunMode == 1 )
        {
            ShakeRotMag *= 0.5;
            ShakeRotRate *= 0.5;
            ShakeOffSetMag *= 0.5;
            ShakeOffSetRate *= 0.5;
        }

        P.WeaponShakeView(ShakeRotMag, ShakeRotRate, ShakeRotTime, ShakeOffsetMag, ShakeOffsetRate, ShakeOffsetTime);
    }
}
// Berserk Stuff ----------
function StartBerserk()
{
    if ( (Level.GRI != None) && (Level.GRI.WeaponBerserk > 1.0) )
	return;
    Super.StartBerserk();
    ScaleDamage(1.33);
}

function StopBerserk()
{
    if ( (Level.GRI != None) && (Level.GRI.WeaponBerserk > 1.0) )
	return;
    Super.StopBerserk();
    ScaleDamage(1.0);
}

function StartSuperBerserk()
{
    Super.StartSuperBerserk();
    ScaleDamage(1.5);
}

function ScaleDamage(float DMod)
{
    DamageMin = Default.DamageMin * DMod;
    DamageMax = Default.DamageMax * DMod;
}
//End Berserk ----------

defaultproperties
{
     DamageType=Class'mayhemweapons.DamageTypeMayhemMiniGun'
     AmmoClass=Class'mayhemweapons.MayhemMinigunAmmo'
}
