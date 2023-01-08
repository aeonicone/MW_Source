class MayhemONSMineLayerPickup extends ONSMineLayerPickup;

static function StaticPrecache(LevelInfo L)
{
        L.AddPrecacheMaterial(Texture'MayhemWeapons.empblue');
        L.AddPrecacheMaterial(Texture'MayhemWeapons.empred');
        L.AddPrecacheMaterial(Texture'MayhemWeapons.newMineLayer');
        L.AddPrecacheMaterial(Texture'MayhemWeaponEffects.Mines.ring');

        L.AddPrecacheMaterial(Texture'VMWeaponsTX.PlayerWeaponsGroup.SpiderMineTEX');
	L.AddPrecacheMaterial(Shader'VMWeaponsTX.PlayerWeaponsGroup.ParasiteMineImplantTEXshad');
	L.AddPrecacheMaterial(Texture'VMWeaponsTX.PlayerWeaponsGroup.SpiderMineBLUETEX');
	L.AddPrecacheMaterial(Texture'XGameShaders.WeaponShaders.bio_flash');
	L.AddPrecacheMaterial(Texture'AW-2004Particles.Weapons.BeamFragment');
	L.AddPrecacheStaticMesh(default.StaticMesh);
}

simulated function UpdatePrecacheMaterials()
{
	Level.AddPrecacheMaterial(Texture'MayhemWeapons.empblue');
        Level.AddPrecacheMaterial(Texture'MayhemWeapons.empred');
        Level.AddPrecacheMaterial(Texture'MayhemWeapons.newMineLayer');
        Level.AddPrecacheMaterial(Texture'MayhemWeaponEffects.Mines.ring');
        super.UpdatePrecacheMaterials();
}

defaultproperties
{
     InventoryType=Class'mayhemweapons.MayhemONSMineLayer'
     PickupMessage="You got the Mayhem Mine Layer."
     Skins(0)=Texture'mayhemweapons.newminelayer'
}
