class MayhemONSAVRiLPickup extends ONSAVRiLPickup;

static function StaticPrecache(LevelInfo L)
{
        L.AddPrecacheMaterial(Texture'MayhemWeapons.newavril');
        L.AddPrecacheMaterial(Texture'VMWeaponsTX.PlayerWeaponsGroup.AVRiLtex');
	L.AddPrecacheMaterial(Texture'AW-2004Particles.Weapons.DustSmoke');
    L.AddPrecacheMaterial(Texture'ONSInterface-TX.avrilRETICLE');
    L.AddPrecacheMaterial(Texture'VMWeaponsTX.PlayerWeaponsGroup.LGRreticleRed');
	L.AddPrecacheStaticMesh(StaticMesh'VMWeaponsSM.AVRiLGroup.AVRiLprojectileSM');
	L.AddPrecacheStaticMesh(StaticMesh'VMWeaponsSM.AVRiLsm');
}

simulated function UpdatePrecacheMaterials()
{
        Level.AddPrecacheMaterial(Texture'MayhemWeapons.newavril');
        Level.AddPrecacheMaterial(Texture'VMWeaponsTX.PlayerWeaponsGroup.AVRiLtex');
	Level.AddPrecacheMaterial(Texture'VMParticleTextures.VehicleExplosions.VMExp2_framesANIM');
	Level.AddPrecacheMaterial(Texture'AW-2004Particles.Weapons.DustSmoke');
    Level.AddPrecacheMaterial(Texture'ONSInterface-TX.avrilRETICLE');
    Level.AddPrecacheMaterial(Texture'VMWeaponsTX.PlayerWeaponsGroup.LGRreticleRed');
	super.UpdatePrecacheMaterials();
}

defaultproperties
{
     InventoryType=Class'mayhemweapons.MayhemONSAVRiL'
     PickupMessage="You got the Mayhem AVRiL."
     Skins(0)=Texture'mayhemweapons.newavril'
}
