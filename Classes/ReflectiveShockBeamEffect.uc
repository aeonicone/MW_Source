class ReflectiveShockBeamEffect extends ShockBeamEffect;

// This is what the original import line looked like:
//#exec TEXTURE IMPORT NAME=ShockBeamTex FILE=textures\shockbeampurple.tga GROUP=Effects LODSET=0 MIPS=0

#exec Texture Import Name=ShockBeam_Rainbow1 File=Textures\ShockBeam_Rainbow1.tga   GROUP=Effects LODSET=0 MIPS=0
#exec Texture Import Name=ShockBeam_Fire     File=Textures\ShockBeam_Fire.tga       GROUP=Effects LODSET=0 MIPS=0
#exec Texture Import Name=ShockBeam_Ice      File=Textures\ShockBeam_Ice.tga        GROUP=Effects LODSET=0 MIPS=0
#exec Texture Import Name=ShockBeam_Holy     File=Textures\ShockBeam_Holy.tga       GROUP=Effects LODSET=0 MIPS=0
#exec Texture Import Name=ShockBeam_Green    File=Textures\ShockBeam_Green.tga      GROUP=Effects LODSET=0 MIPS=0

var class<ColorShockExplosionCore> Core;
var class<ReflectiveShockImpactScorch> Scorch;
Var class<ReflectiveShockImpactRing> Ring;
var class<ReflectiveShockImpactFlare> Flare;
const CM = Class'ColorManager';

simulated function SpawnImpactEffects(rotator HitRot, vector EffectLoc)
{
    Spawn(Flare,,, EffectLoc, HitRot);
    Spawn(Ring,,, EffectLoc, HitRot);
    Spawn(Scorch,,, EffectLoc, Rotator(-HitNormal));
    Spawn(Core,,, EffectLoc+HitNormal*8, HitRot);
}

defaultproperties
{
     Core=Class'mayhemweapons.ColorShockExplosionCoreHoly'
     Scorch=Class'mayhemweapons.ReflectiveShockImpactScorch'
     Ring=Class'mayhemweapons.ReflectiveShockImpactRing'
     Flare=Class'mayhemweapons.ReflectiveShockImpactFlare'
     CoilClass=Class'mayhemweapons.ReflectiveShockCoilEffect'
     MuzFlashClass=Class'mayhemweapons.ReflectiveShockMuzFlash'
     MuzFlash3Class=Class'mayhemweapons.ReflectiveShockMuzFlash3rd'
     Texture=Texture'mayhemweapons.Effects.ShockBeam_Holy'
     Skins(0)=Texture'mayhemweapons.Effects.ShockBeam_Holy'
}
