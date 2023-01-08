class ColorManager extends Mutator Abstract;

/*
    This Class is mostly a reference device for several weapons in the mutator.
    It stores Colors that are commonly used in the mutator, as well as some classes,
    damagetypes, and other such things.
*/

//Enums------------------------
enum EBankColor
{
    BANK_IceBlue,
    BANK_NeonViolet,
    BANK_NeonGreen,
    BANK_NeonRed,
    BANK_Violet,
    BANK_Red,
    BANK_Blue,
    BANK_Green,
    BANK_Yellow,
    BANK_Orange,
    BANK_White
};

//Structs----------------------
struct LightColor
{
   var byte Hue, Saturation;
};

//Translators------------------
/*   Some weapons produce lesser variety of colors, and the colors produced do not
   match the correct indexes of the colors used in the banks.  The translators 
   use that incorrect index given by whatever function, to reference the correct
   element which contains the appropriate matching index for the needed color.      */
var Array<byte> ShockTranslator;
var Array<byte> LinkTranslator;

// Reference Class Names
Var Class<LinkProjectile> LinkProj_Class[7];
Var Class<ReflectiveShockProjectile> ShockProj_Class[6];
Var Class<ReflectiveShockProjectileHoming> Hom_ShockProj_Class[6];
Var Class<ShockBeamEffect> ShockBeam_Class[6];
Var Class<ShockBeamEffect> Rd_ShockBeam_Class[6];
Var Class<WeaponAttachment> ShockAttachment_Class[6];
Var class<DamageType> DamageTypeBeam_Class[6];
var class<DamageType> DamageTypeLightning_Class[6];
var class<xEmitter> ShockBeamFlashEmitter_Class[6];
var class<xEmitter> ShockProjFlashEmitter_Class[6];
var class<xEmitter> LinkProjFlash_Class[7];
var class<BioGlob> GlobClass[3];
var class<RocketProj> RocketClass[3];

//Textures
var Array<Texture> ShockBeamTX;
//Color
var Array<Color> ColorBank;
var Array<string> ColorName;
var Array<LightColor> LightBank;

//===============================================================================
// Shock Rifle Color Settings
//===============================================================================
Simulated Static Final Function AssignShockRifleColors(string sColor) // Yes, it deserves its own function!
{
    local byte i;
    Switch(sColor)
    {
        Case "Ice Blue":     i = 0;  Break;
        Case "Neon Red":     i = 1;  Break;
        Case "Neon Violet":  i = 2;  Break;
        Case "Neon Green":   i = 3;  Break;
        Case "Holy White":   i = 4;  Break;
        Default:             i = 5;  Break;
    }
    class'MayhemShockRifle'.Default.RandPick = i;
}

//===============================================================================
// Link Gun Color Settings
//===============================================================================
Simulated Static Final Function AssignLinkGunColor(String sColor)
{
    local byte i;
    switch(sColor)
    {
        Case "Ice Blue":    i = 0;  Break;
        Case "Neon Red":    i = 1;  Break;
        Case "Neon Violet": i = 2;  Break;
        Case "Neon Green":  i = 3;  Break;
        case "Orange":      i = 4;  Break;
        case "Yellow":      i = 5;  Break;
        Default:            i = 6;  Break;
    }
    class'ReflectiveLinkAltFire'.Default.RandPick = i;
}

simulated static Final function RangeVector AssignColorRange(Color C)
{                                                            
    local RangeVector RV;

    RV.X.Min = float(C.R) / 255.0;
    RV.Y.Min = float(C.G) / 255.0;
    RV.Z.Min = float(C.B) / 255.0;
    RV.X.Max = RV.X.Min;
    RV.Y.Max = RV.Y.Min;
    RV.Z.Max = RV.Z.Min;

    return RV;
}

/*Simulated Static Final Function Color AssignColorFromRange(RangeVector RV)
{
    Return class'Canvas'.Static.MakeColor(RV.X.Min * 255, RV.Y.Min * 255, RV.Z.Min * 255 );
}   */

simulated Static function byte AssignColorIndex(string sColor)
{
    local byte i;
    While (sColor != Default.ColorName[i] && i < 13)   {  i++;  }
    Return i;
}

simulated Static function Color AssignBankColor(string sColor)
{
    local byte i;
    While (sColor != Default.ColorName[i] && i < 10)   {  i++;  }
    Return Default.ColorBank[i];
}

simulated Static Final Function Color AssignRandomColor()
{
    Return class'Canvas'.Static.MakeColor( Rand(256), Rand(256), Rand(256) );
}

/*simulated static function AssignBankLight(string sColor)
{
    local byte i;
    While (sColor != Default.ColorName[i] && i < 10)   {  i++;  }
    Return Default.LightBank[i];
} */                              

Simulated Static Function SetRandomTrailColor()
{
    class'ReflectiveFlakTrail'.default.mColorRange[0] = AssignRandomColor();
    class'ReflectiveFlakTrail'.default.mColorRange[1] = class'ReflectiveFlakTrail'.default.mColorRange[0];
}

//======================================================================
// DefaultProperties
//======================================================================

defaultproperties
{
     ShockTranslator(1)=3
     ShockTranslator(2)=4
     ShockTranslator(3)=2
     ShockTranslator(4)=10
     LinkTranslator(1)=3
     LinkTranslator(2)=4
     LinkTranslator(3)=2
     LinkTranslator(4)=9
     LinkTranslator(5)=8
     LinkTranslator(6)=10
     LinkProj_Class(0)=Class'mayhemweapons.ColorLinkProjBlue'
     LinkProj_Class(1)=Class'mayhemweapons.ColorLinkProjRed'
     LinkProj_Class(2)=Class'mayhemweapons.ColorLinkProjViolet'
     LinkProj_Class(3)=Class'mayhemweapons.ColorLinkProjGreen'
     LinkProj_Class(4)=Class'mayhemweapons.ColorLinkProjOrange'
     LinkProj_Class(5)=Class'mayhemweapons.ColorLinkProjYellow'
     LinkProj_Class(6)=Class'mayhemweapons.ColorLinkProjWhite'
     ShockProj_Class(0)=Class'mayhemweapons.ReflectiveShockProjectileIce'
     ShockProj_Class(1)=Class'mayhemweapons.ReflectiveShockProjectileFire'
     ShockProj_Class(2)=Class'mayhemweapons.ReflectiveShockProjectileViolet'
     ShockProj_Class(3)=Class'mayhemweapons.ReflectiveShockProjectileToxic'
     ShockProj_Class(4)=Class'mayhemweapons.ReflectiveShockProjectileHoly'
     ShockProj_Class(5)=Class'mayhemweapons.ReflectiveShockProjectileRainbow'
     Hom_ShockProj_Class(0)=Class'mayhemweapons.ReflectiveShockProjectileHomingIce'
     Hom_ShockProj_Class(1)=Class'mayhemweapons.ReflectiveShockProjectileHomingFire'
     Hom_ShockProj_Class(2)=Class'mayhemweapons.ReflectiveShockProjectileHomingViolet'
     Hom_ShockProj_Class(3)=Class'mayhemweapons.ReflectiveShockProjectileHomingToxic'
     Hom_ShockProj_Class(4)=Class'mayhemweapons.ReflectiveShockProjectileHomingHoly'
     Hom_ShockProj_Class(5)=Class'mayhemweapons.ReflectiveShockProjectileHomingRainbow'
     ShockBeam_Class(0)=Class'mayhemweapons.ReflectiveShockBeamEffectIce'
     ShockBeam_Class(1)=Class'mayhemweapons.ReflectiveShockBeamEffectFire'
     ShockBeam_Class(2)=Class'mayhemweapons.ReflectiveShockBeamEffectViolet'
     ShockBeam_Class(3)=Class'mayhemweapons.ReflectiveShockBeamEffectToxic'
     ShockBeam_Class(4)=Class'mayhemweapons.ReflectiveShockBeamEffectHoly'
     ShockBeam_Class(5)=Class'mayhemweapons.ReflectiveShockBeamEffectRainbow'
     Rd_ShockBeam_Class(0)=Class'mayhemweapons.ReflectedShockBeamEffectIce'
     Rd_ShockBeam_Class(1)=Class'mayhemweapons.ReflectedShockBeamEffectFire'
     Rd_ShockBeam_Class(2)=Class'mayhemweapons.ReflectedShockBeamEffectViolet'
     Rd_ShockBeam_Class(3)=Class'mayhemweapons.ReflectedShockBeamEffectToxic'
     Rd_ShockBeam_Class(4)=Class'mayhemweapons.ReflectedShockBeamEffectHoly'
     Rd_ShockBeam_Class(5)=Class'mayhemweapons.ReflectedShockBeamEffectRainbow'
     ShockAttachment_Class(0)=Class'mayhemweapons.ReflectiveShockAttachmentIce'
     ShockAttachment_Class(1)=Class'mayhemweapons.ReflectiveShockAttachmentFire'
     ShockAttachment_Class(2)=Class'mayhemweapons.ReflectiveShockAttachmentViolet'
     ShockAttachment_Class(3)=Class'mayhemweapons.ReflectiveShockAttachmentToxic'
     ShockAttachment_Class(4)=Class'mayhemweapons.ReflectiveShockAttachmentHoly'
     ShockAttachment_Class(5)=Class'mayhemweapons.ReflectiveShockAttachmentRainbow'
     DamageTypeBeam_Class(0)=Class'mayhemweapons.DamageTypeBeamIce'
     DamageTypeBeam_Class(1)=Class'mayhemweapons.DamageTypeBeamFire'
     DamageTypeBeam_Class(2)=Class'mayhemweapons.DamageTypeBeamViolet'
     DamageTypeBeam_Class(3)=Class'mayhemweapons.DamageTypeBeamToxic'
     DamageTypeBeam_Class(4)=Class'mayhemweapons.DamageTypeBeamHoly'
     DamageTypeBeam_Class(5)=Class'mayhemweapons.DamageTypeBeamRainbow'
     DamageTypeLightning_Class(0)=Class'mayhemweapons.DamageTypeLightning'
     DamageTypeLightning_Class(1)=Class'mayhemweapons.DamageTypeLightningBranch'
     ShockBeamFlashEmitter_Class(0)=Class'mayhemweapons.ReflectiveShockBeamMuzFlashIce'
     ShockBeamFlashEmitter_Class(1)=Class'mayhemweapons.ReflectiveShockBeamMuzFlashFire'
     ShockBeamFlashEmitter_Class(2)=Class'mayhemweapons.ReflectiveShockBeamMuzFlashViolet'
     ShockBeamFlashEmitter_Class(3)=Class'mayhemweapons.ReflectiveShockBeamMuzFlashToxic'
     ShockBeamFlashEmitter_Class(4)=Class'mayhemweapons.ReflectiveShockBeamMuzFlashHoly'
     ShockBeamFlashEmitter_Class(5)=Class'mayhemweapons.ReflectiveShockBeamMuzFlashRainbow'
     ShockProjFlashEmitter_Class(0)=Class'mayhemweapons.ReflectiveShockProjMuzFlashIce'
     ShockProjFlashEmitter_Class(1)=Class'mayhemweapons.ReflectiveShockProjMuzFlashFire'
     ShockProjFlashEmitter_Class(2)=Class'mayhemweapons.ReflectiveShockProjMuzFlashViolet'
     ShockProjFlashEmitter_Class(3)=Class'mayhemweapons.ReflectiveShockProjMuzFlashToxic'
     ShockProjFlashEmitter_Class(4)=Class'mayhemweapons.ReflectiveShockProjMuzFlashHoly'
     ShockProjFlashEmitter_Class(5)=Class'mayhemweapons.ReflectiveShockProjMuzFlashRainbow'
     LinkProjFlash_Class(0)=Class'mayhemweapons.ReflectiveLinkMuzFlashProj1stBlue'
     LinkProjFlash_Class(1)=Class'mayhemweapons.ReflectiveLinkMuzFlashProj1stRed'
     LinkProjFlash_Class(2)=Class'mayhemweapons.ReflectiveLinkMuzFlashProj1stViolet'
     LinkProjFlash_Class(3)=Class'mayhemweapons.ReflectiveLinkMuzFlashProj1stGreen'
     LinkProjFlash_Class(4)=Class'mayhemweapons.ReflectiveLinkMuzFlashProj1stOrange'
     LinkProjFlash_Class(5)=Class'mayhemweapons.ReflectiveLinkMuzFlashProj1stYellow'
     LinkProjFlash_Class(6)=Class'mayhemweapons.ReflectiveLinkMuzFlashProj1stWhite'
     GlobClass(0)=Class'mayhemweapons.MayhemBioGlobStandard'
     GlobClass(1)=Class'mayhemweapons.MayhemBioGlob'
     GlobClass(2)=Class'mayhemweapons.MayhemBioGlobSplitter'
     RocketClass(0)=Class'mayhemweapons.RocketProjFlaming'
     RocketClass(1)=Class'mayhemweapons.RocketProjFragmentation'
     RocketClass(2)=Class'mayhemweapons.RocketProjStandard'
     ShockBeamTX(0)=Texture'mayhemweapons.Effects.ShockBeam_Ice'
     ShockBeamTX(1)=Texture'mayhemweapons.Effects.ShockBeam_Fire'
     ShockBeamTX(2)=Texture'XWeapons_rc.Effects.ShockBeamTex'
     ShockBeamTX(3)=Texture'mayhemweapons.Effects.ShockBeam_Green'
     ShockBeamTX(4)=Texture'mayhemweapons.Effects.ShockBeam_Holy'
     ShockBeamTX(5)=Texture'mayhemweapons.Effects.ShockBeam_Rainbow1'
     ColorBank(0)=(B=255,G=200,R=100,A=255)
     ColorBank(1)=(B=255,R=175,A=255)
     ColorBank(2)=(B=50,G=255,R=150,A=255)
     ColorBank(3)=(B=50,G=100,R=255,A=255)
     ColorBank(4)=(B=255,R=100,A=255)
     ColorBank(5)=(R=255,A=255)
     ColorBank(6)=(B=255,A=255)
     ColorBank(7)=(G=255,A=255)
     ColorBank(8)=(G=200,R=255,A=255)
     ColorBank(9)=(G=125,R=255,A=255)
     ColorBank(10)=(B=255,G=255,R=255,A=255)
     colorname(0)="Ice Blue"
     colorname(1)="Neon Violet"
     colorname(2)="Neon Green"
     colorname(3)="Neon Red"
     colorname(4)="Violet"
     colorname(5)="Red"
     colorname(6)="Blue"
     colorname(7)="Green"
     colorname(8)="Yellow"
     colorname(9)="Orange"
     colorname(10)="White"
     colorname(11)="Random(Mix)"
     colorname(12)="Random(Crazy)"
     colorname(13)="Random(Group)"
     LightBank(0)=(Hue=150,Saturation=175)
     LightBank(1)=(Hue=190,Saturation=75)
     LightBank(2)=(Hue=70,Saturation=50)
     LightBank(3)=(Hue=10,Saturation=30)
     LightBank(4)=(Hue=175,Saturation=50)
     LightBank(6)=(Hue=155)
     LightBank(7)=(Hue=60)
     LightBank(8)=(Hue=30,Saturation=50)
     LightBank(9)=(Hue=23,Saturation=50)
     LightBank(10)=(Saturation=255)
}
