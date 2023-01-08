Class MayhemAssaultRifle Extends AssaultRifle
    HideDropDown;

#exec Texture Import Name=newar File=Textures\newar.tga
var byte CurrentIndex;

replication
{
    /* the client can call this function on the server*/
    reliable if ( Role < ROLE_Authority )
        ToggleMayhemWeaponMode;

    /*Server replicates this to the client whenever there is a status change*/
    reliable if ( bNetDirty  && (Role == ROLE_Authority) )
        CurrentIndex;
}

simulated function String GetHumanReadableName()
{
    Super.GetHumanReadableName();
    CurrentIndex = 0;
    return ItemName;
}

exec function ToggleMayhemWeaponMode()
{
    if ( PlayerController(Instigator.Controller) != None )
        PlayerController(Instigator.Controller).ClientPlaySound(sound'Menusounds.selectj');
    Instigator.ReceiveLocalizedMessage( class'MessageModeSwitchDummy', CurrentIndex);
    CurrentIndex = (CurrentIndex+1) % class'MessageModeSwitchDummy'.Default.ModeMessage.Length;
}

defaultproperties
{
     FireModeClass(0)=Class'mayhemweapons.MayhemAssaultFire'
     FireModeClass(1)=Class'mayhemweapons.MayhemAssaultGrenade'
     PickupClass=Class'mayhemweapons.MayhemAssaultRiflePickup'
     AttachmentClass=Class'mayhemweapons.MayhemAssaultAttachment'
     IconMaterial=Texture'MayhemHudContent.Generic.HUD'
     ItemName="Mayhem Assault Rifle"
     Skins(0)=Texture'mayhemweapons.newar'
}
