class MayhemSniperRifle extends SniperRifle
    HideDropDown;

#exec Texture Import Name=SniperTex File=Textures\SniperTex.tga

var Sound ModeCycleSound;
var byte CurrentLightningIndex;
var Array<Float> Vol;

replication
{
    /* the client can call this function on the server*/
    reliable if ( Role < ROLE_Authority )
        ToggleMayhemWeaponMode;

    Reliable if ( Role == ROLE_Authority )
        UpdateClientSide;

    /*Server replicates this to the client whenever there is a status change*/
    reliable if ( bNetDirty && (Role == ROLE_Authority) )
        CurrentLightningIndex;
}

// AI Interface
function float SuggestAttackStyle()
{
    if ( CurrentLightningIndex == 0 )
        return -0.4;  // original value
    return 0.0;
}

function float SuggestDefenseStyle()
{
    if ( CurrentLightningIndex == 0 )
        return 0.2;   // original value
    return 0.0;
}

/* BestMode()
choose between regular or alt-fire
*/
function byte BestMode() // Switch Lightning modes here if needed.
{
    // pick which Lightning Mode to use first.
    local AIController AI;
    local float Dist;

    AI = AIController(Instigator.Controller);

    if (AI.Enemy != None)
    {
        Dist = VSize(AI.Enemy.Location - Instigator.Location);
        //Log("Dist ="@Dist);
        if (Dist > 500)
            SwitchToMode(0);
        else
            SwitchToMode(1);
    }
    else
        SwitchToMode(0);

    return 0;
}

Function SwitchToMode(byte Mode)
{
    If ( CurrentLightningIndex != Mode )
    {
        CurrentLightningIndex = Mode;
        ToggleMayhemWeaponMode();
    }
}

function float GetAIRating() // do not change modes here, might've not taken out the weapon yet.
{
	local Bot B;
	local float ZDiff, dist, Result;

	B = Bot(Instigator.Controller);
	if ( B == None )
		return AIRating;
	if ( B.IsShootingObjective() )
		return AIRating - 0.15;
	if ( B.Enemy == None )
		return AIRating;

        // gather more info...
        result = AIRating;
        ZDiff = Instigator.Location.Z - B.Enemy.Location.Z;
	dist = VSize(B.Enemy.Location - Instigator.Location);
        
        // Vehicle?
        if ( Vehicle(B.Enemy) != None )
	    result -= 0.2;

        // Consider Distance....
        if ( Dist > 500 )
        {
            if ( B.Stopped() )
		result += 0.1;
	    else
		result -= 0.1;

            if ( ZDiff < -200 )
		result += 0.1;
		
	    if ( dist > 2000 )
	    {
	        if ( !B.EnemyVisible() )
	   	    result -= 0.15;
	        return ( FMin(2.0,result + (dist - 2000) * 0.0002) );
	    }

            if ( !B.EnemyVisible() )
		return AIRating - 0.1;
        }
        else // must be short range.
        {
            Result += 0.2; // (-1 * (Dist - 500)) * 0.0002;

        }


	return result;
}

function bool RecommendRangedAttack()
{
    if ( CurrentLightningIndex == 0 )
        Return Super.RecommendRangedAttack();
    Return False;
}
// end AI Interface

simulated function BringUp(optional Weapon PrevWeapon)
{
    Super.BringUp(PrevWeapon);
    if ( Instigator.IsHumanControlled() )
        Instigator.ReceiveLocalizedMessage( class'MessageModeSwitchAbstract', CurrentLightningIndex,,, Class );
}

exec function ToggleMayhemWeaponMode()
{
    local MayhemSniperFire PF;

    PF = MayhemSniperFire(FireMode[0]);

    if ( PF == None )
        Return;

    if ( PlayerController(Instigator.Controller) != None )
    {
        CurrentLightningIndex = (PF.LightningMode+1) % PF.ELightningMode.EnumCount;

        Instigator.ReceiveLocalizedMessage( class'MessageModeSwitchAbstract', CurrentLightningIndex,,, Class);
        PlayerController(Instigator.Controller).ClientPlaySound(ModeCycleSound);
    }

    PF.LightningMode = ELightningMode(CurrentLightningIndex);

    FireMode[0].FireSound = GetNewFireSound(CurrentLightningIndex);
    FireMode[0].TransientSoundVolume = Vol[CurrentLightningIndex];

    UpdateClientSide(CurrentLightningIndex);
}

Function Sound GetNewFireSound(byte LitMode)
{
    if ( LitMode == 0 )
        Return FireMode[0].Default.FireSound;
    Return MayhemSniperFire(FireMode[0]).BranchFireSound;
}

simulated Function UpdateClientSide(byte Litmode)
{
    CurrentLightningIndex = Litmode;
    FireMode[0].FireSound = GetNewFireSound(LitMode);
    FireMode[0].TransientSoundVolume = Vol[LitMode];
}

defaultproperties
{
     ModeCycleSound=Sound'WeaponSounds.BaseGunTech.BReload9'
     Vol(0)=0.500000
     Vol(1)=1.100000
     FireModeClass(0)=Class'mayhemweapons.MayhemSniperFire'
     AmmoClass(0)=Class'mayhemweapons.MayhemSniperAmmo'
     PickupClass=Class'mayhemweapons.MayhemSniperRiflePickup'
     AttachmentClass=Class'mayhemweapons.MayhemSniperAttachment'
     IconMaterial=Texture'MayhemHudContent.Generic.HUD'
     ItemName="Mayhem Lightning Gun"
     Skins(0)=Texture'mayhemweapons.SniperTex'
}
