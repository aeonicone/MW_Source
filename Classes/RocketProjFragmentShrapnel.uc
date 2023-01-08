class RocketProjFragmentShrapnel extends ReflectiveFlakChunk;

simulated function HitWall( vector HitNormal, actor Wall )
{
    local float V_Absorbed;  // Percentage of force vector facing perpendicular to wall absorbed
    local float V_Returned;  // Percentage of force returned by wall

    V_Absorbed = 0.25;
    V_Returned = 1 - V_Absorbed; // always equal to the percentage that wasn't absorbed.

    if ( !Wall.bStatic && !Wall.bWorldGeometry
		&& ((Mover(Wall) == None) || Mover(Wall).bDamageTriggered) )
    {
        if ( Level.NetMode != NM_Client )
	{
	    if ( Instigator == None || Instigator.Controller == None )
		Wall.SetDelayedDamageInstigatorController( InstigatorController );
            SetNewDamage();
            Wall.TakeDamage( NewDamage, instigator, Location, MomentumTransfer * Normal(Velocity), MyDamageType);
	}
        Destroy();
        return;
    }

    if (ReflectNum < ReflectMaxNum)
    {
        if ( !Level.bDropDetail && (FRand() < 0.4) )
  	     Playsound(ImpactSounds[Rand(6)]);
        // Absorb some velocity, and reflect based on angle hit.
        Velocity = Normal( MirrorVectorByNormal(Velocity,HitNormal) ) * (VSize(Velocity) * V_Returned + V_Absorbed * VSize(Velocity) * (0.5 + 0.5 * (normal(velocity) dot hitnormal)));
        ReflectNum++;
        return;
    }
    Destroy();   // if this is reached, the reflectnum = reflectmaxnum and it has bounced max times.
}

SIMULATED function SetNewDamage() // Damage Dealt is based on the speed of the projectile
{
    NewDamage = ( Vsize(Velocity) / Default.Speed ) * Default.Damage;
}

defaultproperties
{
     ReflectMaxNum=4
     TrailClass=Class'mayhemweapons.RocketProjShrapnelTrail'
     Speed=2800.000000
     MaxSpeed=2800.000000
     Damage=15.000000
     MyDamageType=Class'mayhemweapons.DamageTypeShrapnel'
     Physics=PHYS_Falling
}
