class RocketFireCyclical extends RocketFire;

var enum ERocketType
{
    TYPE_Flaming,
    TYPE_Fragmentation,
    TYPE_Standard
} RocketMode;

function Projectile SpawnProjectile(Vector Start, Rotator Dir)
{
    local Projectile p;
    local bot B;

    B = Bot(Instigator.Controller);

    if ( B != None )
        MayhemRocketLauncher(Weapon).CurrentRocketIndex = int(DetermineBotRocket(B));    // For bot's AI

    p = RocketLauncher(Weapon).SpawnProjectile(Start, Dir);

    // Weapon's spawnprojectile function returns none if the player did not lock onto a target.
    //   This spawnprojectile will take over in that case.
    // if ( p == None )
    //    p = Spawn(RocketClass[RocketMode],,, Start, Dir);

    if ( p != None )
        p.Damage *= DamageAtten;

    return p;
}

function ERocketType DetermineBotRocket(Bot B)       // For bots Support
{
    local float TargetDist;

    TargetDist = VSize(B.Target.Location - Instigator.Location);

    if ( TargetDist < 750 )
    {
        if ( B.Skill > 5 * FRand() )
            Return TYPE_Standard;
        Return TYPE_Flaming;
    }
    else if ( TargetDist < 1500 )
    {
        if ( B.Skill > 5 * FRand() )
            If ( FRand() > 0.4 )
                Return TYPE_Flaming;
            else
                Return TYPE_Fragmentation;
        Return TYPE_Standard;
    }
    else if ( TargetDist < 2600 )
    {
        if ( B.Skill > 6 * FRand() - 1 )
            Return TYPE_Fragmentation;
        Return TYPE_Flaming;
    }
    else
    {
        if ( B.Skill > 8 * FRand() - 3 ) // Lower level bots have an easier time figuring out super long distance.
            Return TYPE_Fragmentation;
        Return Type_Flaming;
    }
    Return Type_Flaming;
}

defaultproperties
{
     AmmoClass=Class'mayhemweapons.MayhemRocketAmmo'
}
