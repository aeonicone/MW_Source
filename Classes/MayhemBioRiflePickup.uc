class MayhemBioRiflePickup extends BioRiflePickup;

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheMaterial(Texture'XEffects.xbiosplat2');
    L.AddPrecacheMaterial(Texture'XEffects.xbiosplat');
    L.AddPrecacheMaterial(Texture'XGameShaders.bio_flash');
    L.AddPrecacheMaterial(Texture'WeaponSkins.BioGoo.BRInnerGoo');
    L.AddPrecacheMaterial(Texture'WeaponSkins.BioGoo.BRInnerBubbles');
    L.AddPrecacheMaterial(Texture'MayhemWeapons.NewBio');

	L.AddPrecacheStaticMesh(StaticMesh'WeaponStaticMesh.BioRiflePickup');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Texture'MayhemWeapons.newbio');

	super.UpdatePrecacheMaterials();
}

defaultproperties
{
     InventoryType=Class'mayhemweapons.MayhemBioRifle'
     PickupMessage="You got the Mayhem Bio-Rifle"
     Skins(0)=Texture'mayhemweapons.newbio'
}
