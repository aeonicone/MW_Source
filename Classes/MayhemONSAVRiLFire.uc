class MayhemONSAVRiLFire extends ONSAVRiLFire;

var enum EAVRiLMode
{
    MODE_Standard,
    MODE_WolfPack
} AVRiLMode;
var float WolfSpread;
var byte FlockIndex;
var float LastFireTime;  // Used to prevent exploit of switching modes to fire weapon faster.
Var sound WolfFireSound;

event ModeDoFire()        // Modeled from RocketMultiFire
{
    LastFireTime = Level.TimeSeconds;
    if ( AVRiLMode == MODE_Standard )
    {
        if (Spread != Default.Spread)
        {
            Spread = Default.Spread;
	    SpreadStyle = Default.SpreadStyle;
            KickMomentum.X = -350;
            KickMomentum.Z = 175;
  	}
    }
    else if (Spread != WolfSpread)
    {
        Spread = WolfSpread;
        SpreadStyle = SS_Ring;
        KickMomentum.X = -297.5;
        KickMomentum.Z = 148.75;
    }
    Super.ModeDoFire();
}

function DoFireEffect()      // Modeled from RocketMultiFire
{
    local Vector StartProj, StartTrace, X,Y,Z;
    local Rotator Aim;
    local Vector HitLocation, HitNormal,FireLocation;
    local Actor Other;
    local int p,q, SpawnCount, i;
	local MayhemONSAVRiLWolf FiredRockets[5];
        local bool bCurl;
        //local MayhemONSAVRiL Gun;

    if ( AVRiLMode == MODE_Standard )
    {
	Super.DoFireEffect();
	return;
    }

    Instigator.MakeNoise(1.0);
    Weapon.GetViewAxes(X,Y,Z);

    StartTrace = Instigator.Location + Instigator.EyePosition();
    StartProj = StartTrace + X*ProjSpawnOffset.X + Z*ProjSpawnOffset.Z;
    if ( !Weapon.WeaponCentered() )
	    StartProj = StartProj + Weapon.Hand * Y*ProjSpawnOffset.Y;

    // check if projectile would spawn through a wall and adjust start location accordingly
    Other = Weapon.Trace(HitLocation, HitNormal, StartProj, StartTrace, false);
    if (Other != None)
    {
        StartProj = HitLocation;
    }

    Aim = AdjustAim(StartProj, AimError);

    //Gun = MayhemONSAVRiL(Weapon);
    //SpawnCount = Gun.MisslesLeft;  // Can only fire what's left in the weapon's chambers

    SpawnCount = MayhemONSAVRiL(Weapon).MAX_MISSLE_LOAD;

    for ( p=0; p<SpawnCount; p++ )
    {
        Firelocation = StartProj - 2*((Sin(p*2*PI/SpawnCount)*8 - 7)*Y - (Cos(p*2*PI/SpawnCount)*8 - 7)*Z) - X * 8 * FRand();
        FiredRockets[p] = Spawn(Class'MayhemONSAVRiLWolf',,, FireLocation, Aim);
    }

    //Gun.MisslesLeft = Gun.MAX_MISSLE_LOAD;
    //Gun.RefillDelay = Level.TimeSeconds + FireRate - 0.3;

    FlockIndex++;
    if ( FlockIndex == 0 )
        FlockIndex = 1;
    // To get crazy flying, we tell each projectile in the flock about the others.
    for ( p = 0; p < SpawnCount; p++ )
    {
        if ( FiredRockets[p] != None )
	{
            /*Switch(p)
            {
                Case 0:  FiredRockets[p].WolfName = WOLF_Alpha;
                         //FiredRockets[p].SmokeTrail.Emitters[0].ColorMultiplierRange = class'ColorManager'.Static.AssignColorRange(Class'Canvas'.static.makecolor(0, 0, 255));
                         Break;
                Case 1:  FiredRockets[p].WolfName = WOLF_Beta;
                         //FiredRockets[p].SmokeTrail.Emitters[0].ColorMultiplierRange = class'ColorManager'.Static.AssignColorRange(Class'Canvas'.static.makecolor(255, 0, 0));
                         Break;
                Case 2:  FiredRockets[p].WolfName = WOLF_Gamma;
                         //FiredRockets[p].SmokeTrail.Emitters[0].ColorMultiplierRange = class'ColorManager'.Static.AssignColorRange(Class'Canvas'.static.makecolor(255, 255, 255));
                         Break;
                Case 3:  FiredRockets[p].WolfName = WOLF_Delta;
                         //FiredRockets[p].SmokeTrail.Emitters[0].ColorMultiplierRange = class'ColorManager'.Static.AssignColorRange(Class'Canvas'.static.makecolor(255, 255, 0));
                         Break;
                Case 4:  FiredRockets[p].WolfName = WOLF_Epsilon;
                         //FiredRockets[p].SmokeTrail.Emitters[0].ColorMultiplierRange = class'ColorManager'.Static.AssignColorRange(Class'Canvas'.static.makecolor(0, 255, 0));
                         Break;
            } */
            FiredRockets[p].bCurl = bCurl;
	    FiredRockets[p].FlockIndex = FlockIndex;
            //Log("Rocket"@P@"is Curling?"@BCurl);
            i = 0;
	    for ( q=0; q<SpawnCount; q++ )
	        if ( (p != q) && (FiredRockets[q] != None) )
	        {
		    FiredRockets[p].Flock[i] = FiredRockets[q];
		    i++;
	        }
	    
	    bCurl = !bCurl;
	    if ( Level.NetMode != NM_DedicatedServer )
	        FiredRockets[p].SetTimer(0.1, true);
	 }
    }
}


function Projectile SpawnProjectile(vector Start, rotator Dir)
{
	local Projectile P;

	P = Super.SpawnProjectile(Start, Dir);
	if (P != None)
		P.SetOwner(Weapon);

	return P;
}

defaultproperties
{
     WolfSpread=200.000000
     WolfFireSound=Sound'MayhemWeaponSounds.AVRiL.avrilmulti'
     AmmoClass=Class'mayhemweapons.MayhemONSAVRiLAmmo'
     ProjectileClass=Class'mayhemweapons.MayhemONSAVRiLRocket'
}
