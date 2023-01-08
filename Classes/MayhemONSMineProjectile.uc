Class MayhemONSMineProjectile extends ONSMineProjectile;

event TakeDamage( int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DType)
{   
    if (class<DamTypeONSMine>(DType) == None)    // immune to explosion damage from Spider Mines.
        Super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DType);
}

defaultproperties
{
     MyDamageType=Class'mayhemweapons.DamageTypeMayhemONSMine'
}
