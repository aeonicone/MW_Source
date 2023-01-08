class ReflectiveFlakChunkFaster extends ReflectiveFlakChunk;

Simulated function BounceProjectile(Vector HitNormal)
{
    //local float V_Absorbed;  // Percentage of force vector facing perpendicular to wall absorbed
    //local float V_Returned;  // Percentage of force returned by wall

    //V_Absorbed = 0.45;
    //V_Returned = 1 - V_Absorbed; // always equal to the percentage that wasn't absorbed.

    //if ( ReflectNum == 0 )
    //    SetPhysics(PHYS_Falling);

    //if (bIgnoreGravity) // bounce this projectile without gravity
         Velocity = MirrorVectorByNormal(Velocity, HitNormal);
    //else // Absorb some velocity, and reflect based on angle hit.
    //Velocity = Normal( MirrorVectorByNormal(Velocity,HitNormal) ) * (VSize(Velocity) * V_Returned + V_Absorbed * VSize(Velocity) * (0.5 + 0.5 * (normal(velocity) dot hitnormal)));
}

function SetNewDamage()
{
     NewDamage = Default.Damage * ((1-DampeningFactor) ** float(ReflectNum));
     //Log("Damage Applied over"@ReflectNum$"/"$ReflectMaxNum@"reflections ="@NewDamage);
}

defaultproperties
{
     DampeningFactor=0.120000
     Speed=4200.000000
     MaxSpeed=4200.000000
}
