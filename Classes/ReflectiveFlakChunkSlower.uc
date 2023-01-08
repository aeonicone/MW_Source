class ReflectiveFlakChunkSlower Extends ReflectiveFlakChunk;

Simulated function BounceProjectile(Vector HitNormal)
{
    local float V_Absorbed;  // Percentage of force vector facing perpendicular to wall absorbed
    local float V_Returned;  // Percentage of force returned by wall

    V_Absorbed = 0.15;
    V_Returned = 1 - V_Absorbed; // always equal to the percentage that wasn't absorbed.

    if ( VSize(Velocity) < 20 )
        Destroy();
    
    //if ( ReflectNum == 0 )
    //    SetPhysics(PHYS_Falling);

    //if (bIgnoreGravity) // bounce this projectile without gravity
    //    Velocity = MirrorVectorByNormal(Velocity, HitNormal);
    //else // Absorb some velocity, and reflect based on angle hit.
    Velocity = Normal( MirrorVectorByNormal(Velocity,HitNormal) ) * (VSize(Velocity) * V_Returned + V_Absorbed * VSize(Velocity) * (0.5 + 0.5 * (normal(velocity) dot hitnormal)));
}

defaultproperties
{
     Speed=1700.000000
     MaxSpeed=1700.000000
     TossZ=15.000000
     Physics=PHYS_Falling
}
