class MayhemLinkGunPickup extends LinkGunPickup;

#exec Texture Import Name=LinkGunTex File=Textures\LinkGunTex.tga

static function StaticPrecache(LevelInfo L)
{
	L.AddPrecacheMaterial(Texture'MayhemWeapons.LinkGunTex');
    L.AddPrecacheMaterial(Texture'MayhemWeaponEffects.link_muz_green');
    L.AddPrecacheMaterial(Texture'MayhemWeaponEffects.link_muz_Blue');
    L.AddPrecacheMaterial(Texture'MayhemWeaponEffects.link_muz_Desat');
    L.AddPrecacheMaterial(Texture'MayhemWeaponEffects.link_muz_Orange');
    L.AddPrecacheMaterial(Texture'MayhemWeaponEffects.link_muz_Red');
    L.AddPrecacheMaterial(Texture'MayhemWeaponEffects.link_muz_Purple');
    L.AddPrecacheMaterial(Texture'MayhemWeaponEffects.link_muz_Yellow');
    L.AddPrecacheMaterial(Texture'MayhemWeaponEffects.link_muzmesh_green');
    L.AddPrecacheMaterial(Texture'XEffectMat.link_muz_green');
    L.AddPrecacheMaterial(Texture'XEffectMat.link_muzmesh_green');
    L.AddPrecacheMaterial(Texture'XEffectMat.link_beam_green');
        L.AddPrecacheMaterial(Texture'MayhemWeaponEffects.link_spark_green');
        L.AddPrecacheMaterial(Texture'XEffectMat.link_spark_green');
        L.AddPrecacheMaterial(Texture'XEffectMat.Link.link_muz_blue');
	L.AddPrecacheMaterial(Texture'XEffectMat.Link.link_beam_blue');
	L.AddPrecacheMaterial(Texture'XEffectMat.Link.link_muz_red');
	L.AddPrecacheMaterial(Texture'XEffectMat.Link.link_beam_red');
	L.AddPrecacheMaterial(Texture'AW-2004Particles.Weapons.PlasmaShaft');
    L.AddPrecacheMaterial(Texture'XEffectMat.link_muz_yellow');
    L.AddPrecacheMaterial(Texture'XEffectMat.link_muzmesh_yellow');
    L.AddPrecacheMaterial(Texture'XEffectMat.link_beam_yellow');
	L.AddPrecacheMaterial(Texture'XEffectMat.link_spark_yellow');
	L.AddPrecacheMaterial(Texture'UT2004Weapons.NewWeaps.LinkPowerBlue');
	L.AddPrecacheMaterial(Texture'UT2004Weapons.NewWeaps.LinkPowerRed');
	L.AddPrecacheMaterial(Texture'EpicParticles.Flares.FlickerFlare');
	
	L.AddPrecacheStaticMesh(StaticMesh'WeaponStaticMesh.linkprojectile');
	L.AddPrecacheStaticMesh(StaticMesh'NewWeaponPickups.LinkPickupSM');
}


simulated function UpdatePrecacheMaterials()
{
	Level.AddPrecacheMaterial(Texture'MayhemWeapons.LinkGunTex');
    Level.AddPrecacheMaterial(Texture'MayhemWeaponEffects.link_muz_green');
    Level.AddPrecacheMaterial(Texture'MayhemWeaponEffects.link_muz_Blue');
    Level.AddPrecacheMaterial(Texture'MayhemWeaponEffects.link_muz_Desat');
    Level.AddPrecacheMaterial(Texture'MayhemWeaponEffects.link_muz_Orange');
    Level.AddPrecacheMaterial(Texture'MayhemWeaponEffects.link_muz_Red');
    Level.AddPrecacheMaterial(Texture'MayhemWeaponEffects.link_muz_Purple');
    Level.AddPrecacheMaterial(Texture'MayhemWeaponEffects.link_muz_Yellow');
    Level.AddPrecacheMaterial(Texture'MayhemWeaponEffects.link_muzmesh_green');
    Level.AddPrecacheMaterial(Texture'XEffectMat.link_muz_green');
    Level.AddPrecacheMaterial(Texture'XEffectMat.link_muzmesh_green');
    Level.AddPrecacheMaterial(Texture'XEffectMat.link_beam_green');
        Level.AddPrecacheMaterial(Texture'MayhemWeaponEffects.link_spark_green');
        Level.AddPrecacheMaterial(Texture'XEffectMat.link_spark_green');
        Level.AddPrecacheMaterial(Texture'XEffectMat.Link.link_muz_blue');
	Level.AddPrecacheMaterial(Texture'XEffectMat.Link.link_beam_blue');
	Level.AddPrecacheMaterial(Texture'XEffectMat.Link.link_muz_red');
	Level.AddPrecacheMaterial(Texture'XEffectMat.Link.link_beam_red');
	Level.AddPrecacheMaterial(Texture'AW-2004Particles.Weapons.PlasmaShaft');
    Level.AddPrecacheMaterial(Texture'XEffectMat.link_muz_yellow');
    Level.AddPrecacheMaterial(Texture'XEffectMat.link_muzmesh_yellow');
    Level.AddPrecacheMaterial(Texture'XEffectMat.link_beam_yellow');
	Level.AddPrecacheMaterial(Texture'XEffectMat.link_spark_yellow');
	Level.AddPrecacheMaterial(Texture'UT2004Weapons.NewWeaps.LinkPowerBlue');
	Level.AddPrecacheMaterial(Texture'UT2004Weapons.NewWeaps.LinkPowerRed');
	Level.AddPrecacheMaterial(Texture'EpicParticles.Flares.FlickerFlare');

	super(UTWeaponPickup).UpdatePrecacheMaterials();
}

defaultproperties
{
     InventoryType=Class'mayhemweapons.MayhemLinkGun'
     PickupMessage="You got the Mayhem Link Gun."
     Skins(0)=Texture'mayhemweapons.LinkGunTex'
}
