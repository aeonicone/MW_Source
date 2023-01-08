//==========================================================================
// MayhemShockRiflePickup
//==========================================================================
class MayhemShockRiflePickup extends ShockRiflePickup;

#exec Texture Import Name=ShockRifleTex File=Textures\ShockRifleTex.tga
#exec Object Load File=MayhemWeaponPickups.usx

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheMaterial(Material'ShockBeam_Rainbow1');
    L.AddPrecacheMaterial(Material'ShockBeam_Ice');
    L.AddPrecacheMaterial(Material'ShockBeam_Fire');
    L.AddPrecacheMaterial(Material'ShockBeamTex');
    L.AddPrecacheMaterial(Material'ShockBeam_Green');
    L.AddPrecacheMaterial(Material'ShockBeam_Holy');
    L.AddPrecacheMaterial(Material'ShockHeatDecalIce');
    L.AddPrecacheMaterial(Material'ShockHeatDecalFire');
    L.AddPrecacheMaterial(Material'ShockHeatDecalViolet');
    L.AddPrecacheMaterial(Material'ShockHeatDecalGreen');
    L.AddPrecacheMaterial(Material'ShockHeatDecalHoly');
    L.AddPrecacheMaterial(Material'MayhemWeaponEffects.Shock.shock_core_low_ICE');
    L.AddPrecacheMaterial(Material'MayhemWeaponEffects.Shock.shock_core_low_FIRE');
    L.AddPrecacheMaterial(Material'Shock_core_low');
    L.AddPrecacheMaterial(Material'MayhemWeaponEffects.Shock.shock_core_low_TOXIC');
    L.AddPrecacheMaterial(Material'MayhemWeaponEffects.Shock.shock_core_low_Desat');
    L.AddPrecacheMaterial(Material'MayhemWeaponEffects.ElecFBIce');
    L.AddPrecacheMaterial(Material'MayhemWeaponEffects.ElecFBFire');
    L.AddPrecacheMaterial(Material'MayhemWeaponEffects.ElecFBViolet');
    L.AddPrecacheMaterial(Material'MayhemWeaponEffects.ElecFBGreen');
    L.AddPrecacheMaterial(Material'MayhemWeaponEffects.ShockElecRingFB');
    L.AddPrecacheMaterial(Material'MayhemWeaponEffects.Shock.purple_line');
    L.AddPrecacheMaterial(Material'MayhemWeaponEffects.shock_core');
    L.AddPrecacheMaterial(Material'MayhemWeaponEffects.shock_Energy_green_faded');
    L.AddPrecacheMaterial(Material'MayhemWeaponEffects.shock_flash');
    L.AddPrecacheMaterial(Material'MayhemWeaponEffects.shock_flare_a');
    L.AddPrecacheMaterial(Material'MayhemWeaponEffects.shock_sparkle');
    L.AddPrecacheMaterial(Material'MayhemWeaponEffects.shock_gradient_b');
    L.AddPrecacheMaterial(Material'MayhemWeaponEffects.Shock_ring_a');
    L.AddPrecacheMaterial(Material'MayhemWeaponEffects.ShockComboFlash');
    L.AddPrecacheMaterial(Material'MayhemWeaponEffects.shock_muzflash_1st');
    L.AddPrecacheMaterial(Material'MayhemWeaponEffects.shock_muzflash_3rd');
    L.AddPrecacheMaterial(Texture'MayhemWeapons.ShockRifleTex');

    L.AddPrecacheMaterial(Material'DeployableTex.C_T_Electricity_SG');
    L.AddPrecacheMaterial(Material'XEffects.SaDScorcht');
    L.AddPrecacheMaterial(Material'UT2004Weapons.ShockRipple');
    
    //L.AddPrecacheStaticMesh(StaticMesh'MayhemWeaponPickups.Weapons.MayhemShockPickupSM');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'ShockBeam_Rainbow1');
    Level.AddPrecacheMaterial(Material'ShockBeam_Ice');
    Level.AddPrecacheMaterial(Material'ShockBeam_Fire');
    Level.AddPrecacheMaterial(Material'ShockBeamTex');
    Level.AddPrecacheMaterial(Material'ShockBeam_Green');
    Level.AddPrecacheMaterial(Material'ShockBeam_Holy');
    Level.AddPrecacheMaterial(Material'ShockHeatDecalIce');
    Level.AddPrecacheMaterial(Material'ShockHeatDecalFire');
    Level.AddPrecacheMaterial(Material'ShockHeatDecalViolet');
    Level.AddPrecacheMaterial(Material'ShockHeatDecalGreen');
    Level.AddPrecacheMaterial(Material'ShockHeatDecalHoly');
    Level.AddPrecacheMaterial(Material'MayhemWeaponEffects.Shock.shock_core_low_ICE');
    Level.AddPrecacheMaterial(Material'MayhemWeaponEffects.Shock.shock_core_low_FIRE');
    Level.AddPrecacheMaterial(Material'Shock_core_low');
    Level.AddPrecacheMaterial(Material'MayhemWeaponEffects.Shock.shock_core_low_TOXIC');
    Level.AddPrecacheMaterial(Material'MayhemWeaponEffects.Shock.shock_core_low_Desat');
    Level.AddPrecacheMaterial(Material'MayhemWeaponEffects.ElecFBIce');
    Level.AddPrecacheMaterial(Material'MayhemWeaponEffects.ElecFBFire');
    Level.AddPrecacheMaterial(Material'MayhemWeaponEffects.ElecFBViolet');
    Level.AddPrecacheMaterial(Material'MayhemWeaponEffects.ElecFBGreen');
    Level.AddPrecacheMaterial(Material'MayhemWeaponEffects.ShockElecRingFB');
    Level.AddPrecacheMaterial(Material'MayhemWeaponEffects.Shock.purple_line');
    Level.AddPrecacheMaterial(Material'MayhemWeaponEffects.shock_core');
    Level.AddPrecacheMaterial(Material'MayhemWeaponEffects.shock_Energy_green_faded');
    Level.AddPrecacheMaterial(Material'MayhemWeaponEffects.shock_flash');
    Level.AddPrecacheMaterial(Material'MayhemWeaponEffects.shock_flare_a');
    Level.AddPrecacheMaterial(Material'MayhemWeaponEffects.shock_sparkle');
    Level.AddPrecacheMaterial(Material'MayhemWeaponEffects.shock_gradient_b');
    Level.AddPrecacheMaterial(Material'MayhemWeaponEffects.Shock_ring_a');
    Level.AddPrecacheMaterial(Material'MayhemWeaponEffects.ShockComboFlash');
    Level.AddPrecacheMaterial(Material'MayhemWeaponEffects.shock_muzflash_1st');
    Level.AddPrecacheMaterial(Material'MayhemWeaponEffects.shock_muzflash_3rd');
    Level.AddPrecacheMaterial(Texture'MayhemWeapons.ShockRifleTex');

    Level.AddPrecacheMaterial(Material'DeployableTex.C_T_Electricity_SG');
    Level.AddPrecacheMaterial(Material'XEffects.SaDScorcht');
    Level.AddPrecacheMaterial(Material'UT2004Weapons.ShockRipple');

        super(UTWeaponPickup).UpdatePrecacheMaterials();
}

defaultproperties
{
     InventoryType=Class'mayhemweapons.MayhemShockRifle'
     PickupMessage="You got the Mayhem Shock Rifle."
     Skins(0)=Texture'mayhemweapons.ShockRifleTex'
}
