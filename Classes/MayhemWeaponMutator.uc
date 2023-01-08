//======================================================
// MUTATOR FILE
//======================================================
class MayhemWeaponMutator extends ColorManager Config(MayhemWeapons);

//Display and hint text-------
var localized Array<string>  // Array indexes: 0 = DISPLAY TEXT, 1 = TOOLTIP TEXT
TxtArenaWeapon, TxtFlaksTrailLength,
TxtFlaksTrailColor, TxtRocketTrailColor, TxtShockColor, TxtLinkColor,
TxtBeamDamage, TxtLinkProjDamage, TxtShockProjDamage, TxtSolidDamage, TxtBoltDamage,
TxtRN_Solid, TxtRN_LinkProj, TxtRN_ShockProj, TxtRN_Beam, TxtRN_Bolt;
//From the Arena Mutator ---------------------
var() config string ArenaWeaponClassName;
var bool bInitialized;
var class<Weapon> ArenaWeaponClass;
var string ArenaWeaponPickupClassName;
var string ArenaAmmoPickupClassName;
//Numbers----------------------
var config byte RN_LinkProj, RN_ShockProj, RN_Solid, RN_Beam, RN_Bolt;
var config float FlaksTrailLength;
//Strings-----------------------
var config string sFlaksTrailColor, sRocketTrailColor, sShockColor, sLinkColor;
var string FlaksColorOptions, RocketColorOptions, ShockColorOptions, LinkColorOptions;
const M_W = "MayhemWeapons.Mayhem";  // Used in replacement of weapons and ammo classes.

//Interaction stuff
var bool bAffectSpectators, // If this is set to true, an interaction will be created for spectators
         bAffectPlayers,    // If this is set to true, an interaction will be created for players
         bHasInteraction;
//============================================
// Interaction - Waiting for class to be created/fixed
//============================================
simulated function Tick(float DeltaTime)
{
    //local PlayerController PC;

    // If the player has an interaction already, exit function.
    if (bHasInteraction)
        Return;
    //PC = Level.GetLocalPlayerController();

    // Run a check to see whether this mutator should create an interaction for the player
    if ( Level.GetLocalPlayerController() != None && ((Level.GetLocalPlayerController().PlayerReplicationInfo.bIsSpectator && bAffectSpectators) || (bAffectPlayers && !Level.GetLocalPlayerController().PlayerReplicationInfo.bIsSpectator)) )
    {
        Level.GetLocalPlayerController().Player.InteractionMaster.AddInteraction("MayhemWeapons.MayhemInteraction", Level.GetLocalPlayerController().Player); // Create the interaction
        bHasInteraction = True; // Set the variable so this lot isn't called again
    }
}

//============================================
//WEAPON REPLACEMENT PROCESSES
//============================================
function string GetInventoryClassOverride(string ICN) // ICN = Inventory Class Name
{
    if ( ICN == "XWeapons.AssaultRifle" )             ICN = M_W$"AssaultRifle";
    else if ( ICN == "XWeapons.ShieldGun" )           ICN = M_W$"ShieldGun";
    else if ( ICN == "XWeapons.ShockRifle" )          ICN = M_W$"ShockRifle";
    else if ( ICN == "XWeapons.SniperRifle" )         ICN = M_W$"SniperRifle";
    else if ( ICN == "UTClassic.SniperRifleClassic" ) ICN = M_W$"SniperRifle";
    else if ( ICN == "XWeapons.RocketLauncher" )      ICN = M_W$"RocketLauncher";
    else if ( ICN == "XWeapons.LinkGun" )             ICN = M_W$"LinkGun";
    else if ( ICN == "XWeapons.FlakCannon"  )         ICN = M_W$"FlakCannon";
    else if ( ICN == "XWeapons.Minigun" )             ICN = M_W$"MiniGun";
    else if ( ICN == "XWeapons.BioRifle" )            ICN = M_W$"BioRifle";
    else if ( ICN == "Onslaught.ONSGrenadeLauncher" ) ICN = M_W$"ONSGrenadeLauncher";
    else if ( ICN == "Onslaught.ONSMineLayer" )       ICN = M_W$"ONSMineLayer";
    else if ( ICN == "Onslaught.ONSAVRiL" )           ICN = M_W$"ONSAVRiL";

    if ( NextMutator != None )
        return NextMutator.GetInventoryClassOverride(ICN);
    return ICN;
}

simulated function BeginPlay()
{
	local WeaponLocker L;

	if ( ArenaWeaponClassName != "NONE" )
	    foreach AllActors(class'WeaponLocker', L)
		L.GotoState('Disabled');

	Super.BeginPlay();
}

function Initialize()
{
    local int FireMode;

	bInitialized = true;
	DefaultWeaponName = ArenaWeaponClassName;
	ArenaWeaponClass = class<Weapon>(DynamicLoadObject(ArenaWeaponClassName,class'Class'));
	DefaultWeapon = ArenaWeaponClass;
	ArenaWeaponPickupClassName = string(ArenaWeaponClass.default.PickupClass);
    for( FireMode = 0; FireMode<2; FireMode++ )
    {
        if( (ArenaWeaponClass.default.FireModeClass[FireMode] != None)
        && (ArenaWeaponClass.default.FireModeClass[FireMode].default.AmmoClass != None)
        && (ArenaWeaponClass.default.FireModeClass[FireMode].default.AmmoClass.default.PickupClass != None) )
        {
			ArenaAmmoPickupClassName = string(ArenaWeaponClass.default.FireModeClass[FireMode].default.AmmoClass.default.PickupClass);
			break;
		}
	}
}

function bool CheckReplacement (Actor Other, out byte bSuperRelevant)
{
    local int i;
    local string S;
    local xWeaponBase B;
    local WeaponLocker L;
    local Class<Weapon> W_Class;

    if ( ArenaWeaponClassName != "NONE" )
    {
        if ( !bInitialized )
		Initialize();

	bSuperRelevant = 0;
	
	B = xWeaponBase(Other);

        if ( B != None )
		B.WeaponType = ArenaWeaponClass;
        else if ( (Weapon(Other) != None) && (Other.Class != ArenaWeaponClass) )
        {
            if ( Weapon(Other).bNoInstagibReplace )
            {
                bSuperRelevant = 0;
                return true;
            }
   	    return false;
 	}
	else if ( (WeaponPickup(Other) != None) && (string(Other.Class) != ArenaWeaponPickupClassName) )
		ReplaceWith( Other, ArenaWeaponPickupClassName);
	else if ( (Ammo(Other) != None) && (string(Other.Class) != ArenaAmmoPickupClassName) )
		ReplaceWith( Other, ArenaAmmoPickupClassName);
	else
	{
		if ( Other.IsA('WeaponLocker') )
			Other.GotoState('Disabled');
		return true;
	}
	return false;
    }

    if (xWeaponBase(other) != None)
    {
        B = xWeaponBase(Other);
        W_Class = B.WeaponType;

        if (W_Class == class'ShockRifle' )              W_Class = class'MayhemShockRifle';
        else if ((W_Class == class'SniperRifle' ) ||
                (W_Class == class'ClassicSniperRifle')) W_Class = class'MayhemSniperRifle';
        else if (W_Class == class'RocketLauncher' )     W_Class = class'MayhemRocketLauncher';
        else if (W_Class == class'LinkGun' )            W_Class = class'MayhemLinkGun';
        else if (W_Class == class'FlakCannon' )         W_Class = class'MayhemFlakCannon';
        else if (W_Class == class'Minigun' )            W_Class = class'MayhemMiniGun';
        else if (W_Class == class'BioRifle' )           W_Class = class'MayhemBioRifle';
        else if (W_Class == class'ONSGrenadeLauncher' ) W_Class = class'MayhemONSGrenadeLauncher';
        else if (W_Class == class'ONSMineLayer' )       W_Class = class'MayhemONSMineLayer';
        else if (W_Class == class'ONSAVRiL'  )          W_Class = class'MayhemONSAVRiL';
        else if (W_Class == class'AssaultRifle' )       W_Class = class'MayhemAssaultRifle';
        else if (W_Class == class'ShieldGun' )          W_Class = class'MayhemShieldGun';
        else                                            return true;

        B.WeaponType = W_Class;   // Assign the new weapon class, if there is a new one.
    }
    else if (WeaponPickup(other) != None)
    {
        S = string(other.class);
        if (S == "xWeapons.ShockRiflePickup" )           S = M_W$"ShockRiflePickup";
        else if ((S == "xWeapons.SniperRiflePickup" ) ||
                (S == "UTClassic.ClassicSniperRiflePickup")) S = M_W$"SniperRiflePickup";
        else if (S == "xWeapons.RocketLauncherPickup" )  S = M_W$"RocketLauncherPickup";
        else if (S == "xWeapons.LinkGunPickup" )         S = M_W$"LinkGunPickup";
        else if (S == "xWeapons.FlakCannonPickup" )      S = M_W$"FlakCannonPickup";
        else if (S == "xWeapons.MinigunPickup" )         S = M_W$"MinigunPickup";
        else if (S == "xWeapons.BioRiflePickup" )        S = M_W$"BioRiflePickup";
        else if (S == "Onslaught.ONSGrenadePickup" )     S = M_W$"ONSGrenadePickup";
        else if (S == "Onslaught.ONSMineLayer" )         S = M_W$"ONSMineLayerPickup";
        else if (S == "Onslaught.ONSAVRiL" )             S = M_W$"ONSAVRiLPickup";
        else if (S == "xWeapons.AssaultPickup" )         S = M_W$"AssaultRiflePickup";
        else if (S == "xWeapons.ShieldGunPickup" )       S = M_W$"ShieldGunPickup";
        else                                             return true;

        ReplaceWith(Other, S);  // S will be a new string if it has reached this point.
    }
    else if ( WeaponLocker(Other) != None )
    {
	L = WeaponLocker(Other);
	for (i = 0; i < L.Weapons.Length; i++)
	{
            W_Class = L.Weapons[i].WeaponClass; // What Weapon are we looking at?

            if (W_Class == class'ShockRifle' )              W_Class = class'MayhemShockRifle';
	    else if ((W_Class == class'SniperRifle' ) ||
                     (W_Class == class'ClassicSniperRifle')) W_Class = class'MayhemSniperRifle';
	    else if (W_Class == class'RocketLauncher' )     W_Class = class'MayhemRocketLauncher';
	    else if (W_Class == class'LinkGun' )            W_Class = class'MayhemLinkGun';
	    else if (W_Class == class'FlakCannon' )         W_Class = class'MayhemFlakCannon';
	    else if (W_Class == class'Minigun' )            W_Class = class'MayhemMinigun';
    	    else if (W_Class == class'ONSGrenadeLauncher' ) W_Class = class'MayhemONSGrenadeLauncher';
    	    else if (W_Class == class'ONSMineLayer' )       W_Class = class'MayhemONSMineLayer';
   	    else if (W_Class == class'ONSAVRiL' )           W_Class = class'MayhemONSAVRiL';
            else if (W_Class == class'BioRifle' )           W_Class = class'MayhemBioRifle';
            else if (W_Class == class'AssaultRifle' )       W_Class = class'MayhemAssaultRifle';
            else if (W_Class == class'ShieldGun' )          W_Class = class'MayhemShieldGun';
        
            L.Weapons[i].WeaponClass = W_Class;  // Assign the new weapon class, if there is a new one.
        }
        return true;
    }
    else if ( UTAmmoPickup(Other) != None )
    {
        S = string(other.class);
        if (S == "XWeapons.ShockAmmoPickup" )             S = M_W$"ShockAmmoPickup";
        else if ((S == "XWeapons.SniperAmmoPickup" ) ||
                (S == "UTClassic.ClassicSniperAmmoPickup")) S = M_W$"SniperAmmoPickup";
        else if (S == "XWeapons.RocketAmmoPickup" )       S = M_W$"RocketAmmoPickup";
        else if (S == "XWeapons.LinkAmmoPickup" )         S = M_W$"LinkAmmoPickup";
        else if (S == "XWeapons.FlakAmmoPickup" )         S = M_W$"FlakAmmoPickup";
        else if (S == "XWeapons.MinigunAmmoPickup" )      S = M_W$"MinigunAmmoPickup";
        else if (S == "XWeapons.BioAmmoPickup" )          S = M_W$"BioAmmoPickup";
        else if (S == "Onslaught.ONSGrenadeAmmoPickup" )  S = M_W$"ONSGrenadeAmmoPickup";
        else if (S == "Onslaught.ONSMineAmmoPickup" )     S = M_W$"ONSMineAmmoPickup";
        else if (S == "Onslaught.ONSAVRiLAmmoPickup" )    S = M_W$"ONSAVRiLAmmoPickup";
        else                                              Return true;

        ReplaceWith(Other, S);  // S will be a new string if it has reached this point.
    }
    else
        return true;
    return false;
}

//=============================================================
//ADDING MUTATOR-CONFIGUREABLE SETTINGS TO MENU
//=============================================================
static function FillPlayInfo(PlayInfo PI)
{
    local String RG, ArenaOptions;

    ArenaOptions = "NONE;NONE;"$M_W$"ShieldGun;Mayhem Shield Gun;"$M_W$"AssaultRifle;Mayhem Assault Rifle;"
                   $M_W$"BioRifle;Mayhem Bio Rifle;"$M_W$"ShockRifle;Mayhem Shock Rifle;"
                   $M_W$"Minigun;Mayhem Minigun;"$M_W$"LinkGun;Mayhem Link Gun;"$M_W$"FlakCannon;Mayhem Flak Cannon;"
                   $M_W$"RocketLauncher;Mayhem Rocket Launcher;"$M_W$"SniperRifle;Mayhem Lightning Gun;"
                   $M_W$"ONSAVRiL;Mayhem AVRiL;"$M_W$"ONSGrenadeLauncher;Mayhem Grenade Launcher;"
                   $M_W$"ONSMineLayer;Mayhem Mine Layer";

    RG = Default.RulesGroup;

    Super.FillPlayInfo(PI);
    //Arena Weapon Option
    PI.AddSetting(RG, "ArenaWeaponClassName", Default.TxtArenaWeapon[0], 0, 1, "Select", ArenaOptions);

    //Reflection Adjustment
    PI.AddSetting(RG, "RN_Beam", default.TxtRN_Beam[0], 0, 0, "Text", Default.RN_Beam$";0:10");
    PI.AddSetting(RG, "RN_Solid", default.TxtRN_Solid[0], 0, 0, "Text", Default.RN_Solid$";0:10");
    PI.AddSetting(RG, "RN_LinkProj", default.TxtRN_LinkProj[0], 0, 0, "Text", Default.RN_LinkProj$";0:10");
    PI.AddSetting(RG, "RN_ShockProj", default.TxtRN_ShockProj[0], 0, 0, "Text", Default.RN_ShockPRoj$";0:10");
    PI.AddSetting(RG, "RN_Bolt", default.TxtRN_Bolt[0], 0, 0, "Text", Default.RN_Bolt$";0:10");
    //Other
    PI.AddSetting(RG, "FlaksTrailLength", default.TxtFlaksTrailLength[0], 0, 0, "Text", Default.FlaksTrailLength$";0.30:0.50");
    //Color
    PI.AddSetting(RG, "sFlaksTrailColor", default.TxtFlaksTrailColor[0], 0, 1, "Select", Default.FlaksColorOptions);
    PI.AddSetting(RG, "sRocketTrailColor", default.TxtRocketTrailColor[0], 0, 1, "Select", Default.RocketColorOptions);
    PI.AddSetting(RG, "sShockColor", default.TxtShockColor[0], 0, 1, "Select", Default.ShockColorOptions);
    PI.AddSetting(RG, "sLinkColor", default.TxtLinkColor[0], 0, 1, "Select", Default.LinkColorOptions);
}

//============================================
//TOOLTIPS
//============================================
static event string GetDescriptionText(string PropName)
{
     switch (PropName)
     {
          case "ArenaWeaponClassName":        return Default.TxtArenaWeapon[1];

          case "sLinkColor":          Return default.TxtLinkColor[1];        // Link projectile color
          case "sShockColor":         return default.TxtShockColor[1];       // Shock energy's color
          case "sRocketTrailColor":   return default.TxtRocketTrailColor[1]; // Rocket's Trail color
          case "sFlaksTrailColor":    return default.TxtFlaksTrailColor[1];  // Flak's Trail color

          case "FlaksTrailLength":    return default.TxtFlaksTrailLength[1];// Flak's Trail length

          case "RN_Beam":             return default.TxtRN_Beam[1];        // Beams
          case "RN_Solid":            return default.TxtRN_Solid[1];       // Solid Projectiles
          case "RN_LinkProj":         return default.TxtRN_LinkProj[1];    // Link Projectiles
          case "RN_ShockProj":        return default.TxtRN_ShockProj[1];   // Shock Projectiles
          case "RN_Bolt":             return default.TxtRN_Bolt[1];        // Bolt
     }
     return Super.GetDescriptionText(PropName);
}

//======================================================
// SET VARIABLE VALUES IN CLASSES
//======================================================
simulated function PreBeginPlay()
{
    local Color Flaks_CTS, Rocket_CTS, Link_CTS;                    // CTS stands for Color To Set.
    local bool bLinkRandColor, bShockRandomColorPickup;
    local byte i;

    //Calculate Variables
    Rocket_CTS     = AssignBankColor(sRocketTrailColor);
    Flaks_CTS      = AssignBankColor(sFlaksTrailColor);
    Link_CTS       = AssignBankColor(sLinkColor);
    bLinkRandColor  = ( sLinkColor == "Random(Pick)" );
    bShockRandomColorPickup = ( sShockColor == "Random(Pickup)" );

    //================================================================
    //Reflection Settings
    class'RocketProjReflective'.default.ReflectMaxNum      = RN_Solid;
    class'MayhemSniperFire'.default.BounceMaxNum       = RN_Bolt;
    class'ReflectiveShockBeamFire'.default.BounceMaxNum    = RN_Beam;
    for (i = 0; i < 6; i++)
    {
        ShockProj_Class[i].Default.ReflectMaxNum     = RN_ShockProj;
        Hom_ShockProj_Class[i].Default.ReflectMaxNum = RN_ShockProj;
    }
    class'ReflectiveShockProjectile'.default.ReflectMaxNum       = RN_ShockProj;
    class'ReflectiveShockProjectileHoming'.Default.ReflectMaxNum = RN_ShockProj;
    for (i = 0; i < 7; i++)
        class<ReflectiveLinkProjectile>(LinkProj_Class[i]).Default.ReflectMaxNum  = RN_LinkProj;
    class'ReflectiveLinkProjectile'.default.ReflectMaxNum = RN_LinkProj;
    //================================================================
    // Other Features
    for (i = 0; i <= 1; i++)
        class'ReflectiveFlakTrail'.default.mLifeRange[i] = FlaksTrailLength;
    //================================================================
    //Color
    // These color strings are just so that they can be checked at spawn time if they are random-colored.
    class'MayhemFlakCannon'.default.FlakTrailColor        = EFlakTrailColor(AssignColorIndex(sFlaksTrailColor));
    class'MayhemRocketLauncher'.Default.TrailColor        = ETrailColor(AssignColorIndex(sRocketTrailColor));

    for (i = 0; i < 2; i++)
    {
        class'ReflectiveLinkMuzFlashProj3rd'.Default.mColorRange[i] = Link_CTS;
        class'ColorRocketSmokeInner'.default.mColorRange[i]         = Rocket_CTS;
        class'ColorRocketSmokeOuter'.default.mColorRange[i]         = Rocket_CTS;
        class'ReflectiveFlakTrail'.default.mColorRange[i]           = Flaks_CTS;
    }

    class'ReflectiveLinkAltFire'.default.bRandomColor    = bLinkRandColor;
    class'ReflectiveLinkAttachment'.default.bRandomColor = bLinkRandColor;
    class'MayhemShockRifle'.Default.bPickupRandom = bShockRandomColorPickup;

    AssignLinkGunColor(sLinkColor);
    AssignShockRifleColors(sShockColor);
}


//============================================
//DEFAULT PROPERTIES
//============================================

defaultproperties
{
     TxtArenaWeapon(0)="Optional Arena Weapon:"
     TxtArenaWeapon(1)="Pick a Mayhem Weapon for an Arena match."
     TxtFlaksTrailLength(0)="Other ~ Flak Trail Length"
     TxtFlaksTrailLength(1)="Adjust the length of the tracers following the flak chunks."
     TxtFlaksTrailColor(0)="Color - Flak Trails"
     TxtFlaksTrailColor(1)="Ohhh! Puuurdy!  Adjust the color of flak chunk trails."
     TxtRocketTrailColor(0)="Color - Rocket Trails"
     TxtRocketTrailColor(1)="Ooo Sweet!  Adjust color of bouncing rocket trails."
     TxtShockColor(0)="Color - Shock Beam"
     TxtShockColor(1)="Hot Damn!  Choose the color of shock beams and projectiles."
     TxtLinkColor(0)="Color - Link Projectiles"
     TxtLinkColor(1)="Groovy!  Choose the color of link projectiles."
     TxtRN_Solid(0)="Reflections > Reflective Rockets"
     TxtRN_Solid(1)="MAX # of bounces for reflective rockets."
     TxtRN_LinkProj(0)="Reflections > Link Projectiles"
     TxtRN_LinkProj(1)="MAX # of bounces for link projectiles."
     TxtRN_ShockProj(0)="Reflections > Shock Projectiles"
     TxtRN_ShockProj(1)="MAX # of bounces for shock projectiles."
     TxtRN_Beam(0)="Reflections > Shock Rifle Beam"
     TxtRN_Beam(1)="MAX # of reflections for Shock Rifle beams."
     TxtRN_Bolt(0)="Reflections > Lightning Gun Bolts"
     TxtRN_Bolt(1)="MAX # of reflections for Lightning Gun bolts."
     ArenaWeaponClassName="NONE"
     RN_LinkProj=10
     RN_ShockProj=8
     RN_Solid=10
     RN_Beam=7
     RN_Bolt=6
     FlaksTrailLength=0.400000
     sFlaksTrailColor="Random(Mix)"
     sRocketTrailColor="Random(Mix)"
     sShockColor="Random(Pickup)"
     sLinkColor="Random(Pick)"
     FlaksColorOptions="Random(Mix);Random(Mix);Random(Group);Random(Group);Random(Crazy);Random(Crazy);Ice Blue;Ice Blue;Neon Violet;Neon Violet;Neon Green;Neon Green;Neon Red;Neon Red;Red;Red;Blue;Blue;Green;Green;Violet;Violet;Yellow;Yellow;Orange;Orange;Ghost White;Ghost White"
     RocketColorOptions="Random(Mix);Random(Mix);Random(Crazy);Random(Crazy);Ice Blue;Ice Blue;Neon Violet;Neon Violet;Neon Green;Neon Green;Neon Red;Neon Red;Red;Red;Blue;Blue;Green;Green;Violet;Violet;Yellow;Yellow;Orange;Orange;Ghost White;Ghost White"
     ShockColorOptions="Random(Pickup);Random(Pickup);Rainbow1;Psychedelic;Neon Red;Fire;Ice Blue;Ice;Neon Violet;Neon Violet;Neon Green;Toxic Green;Holy White;Holy White"
     LinkColorOptions="Random(Pick);Random(Pick);Ice Blue;Ice Blue;Neon Red;Neon Red;Neon Violet;Neon Violet;Neon Green;Neon Green;Orange;Orange;Yellow;Yellow;Holy White;Holy White"
     bAffectPlayers=True
     GroupName="Arena"
     FriendlyName="Mayhem Weapons"
     Description="Replaces most weapons with weapons of mayhem!  Make sure to check options for cool configurable stuff!  ATTENTION:  Check the keybinds menu to set up a key for toggling weapon modes.  The the key listed as toggling colors is optional for instant action matches only."
     bAlwaysRelevant=True
     RemoteRole=ROLE_SimulatedProxy
}
