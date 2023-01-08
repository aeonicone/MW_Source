class MayhemRocketLauncherPickup extends RocketLauncherPickup;

#exec Texture Import Name=RocketTex File=Textures\RocketTex.tga
#exec Texture Import Name=RocketShellTexGold File=Textures\RocketShellTexGold.tga    DXT = 1

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheMaterial(Texture'MayhemWeapons.RocketTex');
    L.AddPrecacheMaterial(Material'MayhemWeapons.RocketShellTexGold');

    L.AddPrecacheMaterial(Material'XEffects.RocketFlare');
    L.AddPrecacheMaterial(Material'XEffects.SmokeAlphab_t');
    L.AddPrecacheMaterial(Material'EmitterTextures.rockchunks02');
    L.AddPrecacheMaterial(Material'EmitterTextures.fire3');
    L.AddPrecacheMaterial(Material'EmitterTextures.LargeFlames');
	L.AddPrecacheStaticMesh(StaticMesh'WeaponStaticMesh.rocketproj');
	L.AddPrecacheStaticMesh(StaticMesh'WeaponStaticMesh.RocketLauncherPickup');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Texture'MayhemWeapons.RocketTex');
    Level.AddPrecacheMaterial(Material'MayhemWeapons.RocketShellTexGold');                                                                           // Add when ready
	super.UpdatePrecacheMaterials();
}

defaultproperties
{
     InventoryType=Class'mayhemweapons.MayhemRocketLauncher'
     PickupMessage="You got the Mayhem Rocket Launcher."
     Skins(0)=Texture'mayhemweapons.RocketTex'
}
