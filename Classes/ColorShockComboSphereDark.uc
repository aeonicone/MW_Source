class ColorShockComboSphereDark extends xEmitter;
#exec OBJ LOAD FILE=MayhemWeaponEffects.utx
#exec OBJ LOAD FILE=MayhemWeaponSM.usx

defaultproperties
{
     mParticleType=PT_Beam
     mMaxParticles=1
     mLifeRange(0)=1.000000
     mSizeRange(0)=1.000000
     mSizeRange(1)=1.000000
     mMeshNodes(0)=StaticMesh'MayhemWeaponSM.Shock.shocksphere'
     LifeSpan=0.750000
     Skins(0)=Shader'MayhemWeaponEffects.Shock.shockelecshad'
}
