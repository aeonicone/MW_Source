class MayhemShockRifle extends ShockRifle
    HideDropDown;

#exec Texture Import Name=ShockRifleTex File=Textures\ShockRifleTex.tga

// Shock Gell ----------------------------------------------------------------------
var enum EFadeTo
{
    TO_Yellow,
    TO_Green,
    TO_Aqua,
    TO_Blue,
    TO_Purple,
    TO_Red
} FadeToColor;

var bool bRainbowColors;
var ConstantColor GelColor;
var Color GelCTS;  // Color to set the shockgel, Will not be set if it is a bot.
const RepeatRate = 0.05;   // Rate for the timer to repeat at.
const ChangeRate = 8;      // Amount to increment colors per repeat rate.
// ---------------------------------------------------------------------------------

//locking on projectiles variables.------------
var Pawn SeekTarget;
var float LockTime, UnLockTime, SeekCheckTime;
var bool bLockedOn, bBreakLock;
var bool bTightSpread;
var() float SeekCheckFreq, SeekRange;
var() float LockRequiredTime, UnLockRequiredTime;
var() float LockAim;
var() Color CrosshairColor;
var() float CrosshairX, CrosshairY;
//---------------------------------------------

// ShockBeam Color ----------------------------
var enum EShockColor
{
    SHOCK_Ice,
    SHOCK_Fire,
    SHOCK_Violet,
    SHOCK_Toxic,
    SHOCK_Holy,
    SHOCK_Rainbow
} ShockColor;
var byte RandPick;
var bool bPickupRandom;
// --------------------------------------------

// FireModes -----------------------
//Var ReflectiveShockBeamFire P_Fire;
//Var ReflectiveShockProjFire A_Fire;
// ---------------------------------

const CM = class'ColorManager';
Var byte CurrentIndex;

replication
{
    reliable if (Role == ROLE_Authority && bNetOwner)
        bLockedOn;
    
    /*Server replicates this to the client whenever there is a status change*/
    Reliable if ( bNetDirty && Role == Role_Authority )
        RandPick, bRainbowColors, CurrentIndex;

    /* the client can call this function on the server*/
    reliable if ( Role < ROLE_Authority )
        ToggleMayhemWeaponMode;
}

Simulated Function PostBeginPlay()
{
    Super.PostBeginPlay();

    //P_Fire = ReflectiveShockBeamFire(Firemode[0]);
    //A_Fire = ReflectiveShockProjFire(Firemode[1]);

    if (bPickupRandom)
        RandPick = Rand(6); // Pick a random color to use for this shockrifle
}

Simulated Function PostNetBeginPlay()
{
    Super.PostNetBeginPlay();

    SetGelColor(RandPick, CM.Default.ShockTranslator[RandPick]);

    //P_Fire.BeamColorIndex = RandPick;
    //A_Fire.BeamSyncIndex = RandPick;
}

simulated Function SetGelColor(byte Pick, byte MatchIndex)
{
    Switch(Pick)
    {
        case 0:  ShockColor = SHOCK_Ice;     GelCTS = CM.Default.ColorBank[0];                      Break;
        case 1:  ShockColor = SHOCK_Fire;    GelCTS = class'Canvas'.Static.MakeColor(255, 100, 0);  Break;
        case 2:  ShockColor = SHOCK_Violet;  GelCTS = CM.Default.ColorBank[4];                      Break;
        case 3:  ShockColor = SHOCK_Toxic;   GelCTS = Class'Canvas'.static.Makecolor(125, 255, 50); Break;
        case 4:  ShockColor = SHOCK_Holy;    GelCTS = CM.Default.ColorBank[10];                     Break;
        Default: ShockColor = SHOCK_Rainbow; GelCTS = CM.Default.ColorBank[5];   // Red             Break;
    }

    GelCTS.A = 128;

    if (Pick != 5)
    {
         LightHue        = CM.Default.LightBank[MatchIndex].Hue;
         LightSaturation = CM.Default.LightBank[MatchIndex].Saturation;
         bRainbowColors = False;
    }
    else
    {
         LightHue = CM.Default.LightBank[8].Hue;               // yellow
         LightSaturation = CM.Default.LightBank[8].Saturation; // yellow
         bRainbowColors = True;
    }

    //P_Fire.BeamColorIndex = Pick;
    //A_Fire.BeamSyncIndex = Pick;
}

SIMULATED function AttachToPawn(Pawn P)
{
    AttachmentClass = CM.Default.ShockAttachment_Class[RandPick];
    Super.AttachToPawn(P);
}

Simulated Function Timer()
{
    Super.Timer();

    if (AIController(Instigator.Controller) != None)
        Return;

    if (bRainbowColors)
    {
        setTimer(RepeatRate, True);
        DoFading();
    }
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Gel color shifting
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Simulated Function DoFading()
{
    GelCTS = GelColor.Color;
    Switch (FadeToColor)
    {
        // To Yellow--------------------------------------
        Case TO_Yellow:
            if (GelCTS.G + ChangeRate > 255)
            {
                GelCTS.G = 255;
                FadeToColor = TO_Green;
            }
            else
                GelCTS.G += ChangeRate;
            Break;
        // To Green---------------------------------------
        Case TO_Green:
            if (GelCTS.R - ChangeRate < 0)
            {
                GelCTS.R = 0;
                FadeToColor = TO_Aqua;
            }
            else
                GelCTS.R -= ChangeRate;
            Break;
        // To Aqua----------------------------------------
        Case TO_Aqua:
            if (GelCTS.B + ChangeRate > 255)
            {
                GelCTS.B = 255;
                FadeToColor = TO_Blue;
            }
            else
                GelCTS.B += ChangeRate;
            Break;
        // To Blue----------------------------------------
        Case TO_Blue:
            if (GelCTS.G - ChangeRate < 0)
            {
                GelCTS.G = 0;
                FadeToColor = TO_Purple;
            }
            else
                GelCTS.G -= ChangeRate;
            Break;
        // To Purple--------------------------------------
        Case TO_Purple:
            if (GelCTS.R + ChangeRate > 255)
            {
                GelCTS.R = 255;
                FadeToColor = TO_Red;
            }
            else
                GelCTS.R += ChangeRate;
            Break;
        // To Red-----------------------------------------
        Case TO_Red:
            if (GelCTS.B - ChangeRate < 0)
            {
                GelCTS.B = 0;
                FadeToColor = TO_Yellow;
            }
            else
                GelCTS.B -= ChangeRate;
            Break;
    }
    GelColor.Color = GelCTS;
    //log("New Color: ("$GelColor.Color.R$","@GelColor.Color.G$","@GelColor.Color.B$")");
}
   /*     Algorithm
      At Red     or  (255, 0, 0),   + G Amt if G < 255
      At Yellow  or  (255, 255, 0), - R Amt if R > 0
      At Green   or  (0, 255, 0),   + B Amt if B < 255
      At Aqua    or  (0, 255, 255), - G Amt if G > 0
      At Blue    or  (0, 0, 255),   + R Amt if R < 255
      At Purple  or  (255, 0, 255), - B Amt if B > 0    */

function Projectile SpawnProjectile(Vector Start, Rotator Dir)
{
    local ReflectiveShockProjectileHoming SeekingBall;
    local ReflectiveShockProjectile Ball;
    local bot B;

    bBreakLock = true;

	// decide if bot should be locked on
	B = Bot(Instigator.Controller);
	if ( (B != None) && (B.Skill > 2 + 5 * FRand()) && (FRand() < 0.6)
		&& (B.Target == B.Enemy) && (VSize(B.Enemy.Location - B.Pawn.Location) > 2000 + 2000 * FRand())
		&& (Level.TimeSeconds - B.LastSeenTime < 0.4) && (Level.TimeSeconds - B.AcquireTime > 1.5) )
	{
		bLockedOn = true;
		SeekTarget = B.Enemy;
	}

    if (bLockedOn && SeekTarget != None)
    {
        SeekingBall = Spawn(CM.Default.Hom_ShockProj_Class[ShockColor],,, Start, Dir);
        SeekingBall.Seeking = SeekTarget;
        if ( B != None )
        {
		//log("LOCKED");
		bLockedOn = false;
		SeekTarget = None;
	}
        return SeekingBall;
    }
    else
    {
        Ball = spawn(CM.Default.ShockProj_Class[ShockColor],,, Start, Dir);
    }
    return Ball;
}

simulated event RenderOverlays( Canvas Canvas )
{
    local float A;

    A = 128 * (1.0 - FMax(0,FMax((FireMode[0].NextFireTime - Level.TimeSeconds)/FireMode[0].FireRate,
								(FireMode[1].NextFireTime - Level.TimeSeconds)/FireMode[1].FireRate)));
    if ( GelColor.Color != GelCTS )
        GelColor.Color = GelCTS;

    GelColor.Color.A = A;

    Super(Weapon).RenderOverlays(Canvas); //moved

    if (bLockedOn)
    {
        Canvas.DrawColor = CrosshairColor;
        Canvas.DrawColor.A = 255;
        Canvas.Style = ERenderStyle.STY_Alpha;

        Canvas.SetPos(Canvas.SizeX*0.5-CrosshairX, Canvas.SizeY*0.5-CrosshairY);
        Canvas.DrawTile(Texture'SniperArrows', CrosshairX*2.0, CrosshairY*2.0, 0.0, 0.0, Texture'SniperArrows'.USize, Texture'SniperArrows'.VSize);
    }
}

function Tick(float dt)
{
    local Pawn Other;
    local Vector StartTrace;
    local Rotator Aim;
    local float BestDist, BestAim;

    if (Instigator == None || Instigator.Weapon != self)
        return;

	if ( Role < ROLE_Authority )
		return;

    if ( !Instigator.IsHumanControlled() )
        return;

    if (Level.TimeSeconds > SeekCheckTime)
    {
        if (bBreakLock)
        {
            bBreakLock = false;
            bLockedOn = false;
            SeekTarget = None;
        }

        StartTrace = Instigator.Location + Instigator.EyePosition();
        Aim = Instigator.GetViewRotation();

        BestAim = LockAim;
        Other = Instigator.Controller.PickTarget(BestAim, BestDist, Vector(Aim), StartTrace, SeekRange);

        if ( CanLockOnTo(Other) )
        {
            if (Other == SeekTarget)
            {
                LockTime += SeekCheckFreq;
                if (!bLockedOn && LockTime >= LockRequiredTime)
                {
                    bLockedOn = true;
                    PlayerController(Instigator.Controller).ClientPlaySound(Sound'WeaponSounds.LockOn');
                }
            }
            else
            {
                SeekTarget = Other;
                LockTime = 0.0;
            }
            UnLockTime = 0.0;
        }
        else
        {
            if (SeekTarget != None)
            {
                UnLockTime += SeekCheckFreq;
                if (UnLockTime >= UnLockRequiredTime)
                {
                    SeekTarget = None;
                    if (bLockedOn)
                    {
                        bLockedOn = false;
                        PlayerController(Instigator.Controller).ClientPlaySound(Sound'WeaponSounds.SeekLost');
                    }
                }
            }
            else
                 bLockedOn = false;
        }

        SeekCheckTime = Level.TimeSeconds + SeekCheckFreq;
    }
}

function bool CanLockOnTo(Actor Other)    // From RocketLauncher
{
    local Pawn P;
    
    P = Pawn(Other);

    if (P == None || P == Instigator || !P.bProjTarget)
        return false;

    if (!Level.Game.bTeamGame)
        return true;

	if ( (Instigator.Controller != None) && Instigator.Controller.SameTeamAs(P.Controller) )
		return false;

    return ( (P.PlayerReplicationInfo == None) || (P.PlayerReplicationInfo.Team != Instigator.PlayerReplicationInfo.Team) );
}

simulated function String GetHumanReadableName()
{
    Super.GetHumanReadableName();
    CurrentIndex = 0;
    return ItemName;
}

exec function ToggleMayhemWeaponMode()
{
    PlayerController(Instigator.Controller).ClientPlaySound(sound'Menusounds.selectj');
    Instigator.ReceiveLocalizedMessage( class'MessageModeSwitchDummy', CurrentIndex);
    CurrentIndex = (CurrentIndex+1) % class'MessageModeSwitchDummy'.Default.ModeMessage.Length;
}

defaultproperties
{
     GelColor=ConstantColor'UT2004Weapons.Shaders.ShockControl'
     SeekCheckFreq=0.500000
     SeekRange=8000.000000
     LockRequiredTime=1.150000
     UnLockRequiredTime=0.500000
     LockAim=0.996000
     CrossHairColor=(G=250,R=250,A=255)
     CrosshairX=16.000000
     CrosshairY=16.000000
     bPickupRandom=True
     FireModeClass(0)=Class'mayhemweapons.ReflectiveShockBeamFire'
     FireModeClass(1)=Class'mayhemweapons.ReflectiveShockProjFire'
     AmmoClass(0)=Class'mayhemweapons.MayhemShockAmmo'
     HudColor=(B=0,R=255)
     CenteredOffsetY=-5.000000
     CenteredYaw=-500
     CustomCrosshair=8
     CustomCrossHairColor=(B=0)
     CustomCrossHairTextureName="Crosshairs.Hud.Crosshair_Triad2"
     PickupClass=Class'mayhemweapons.MayhemShockRiflePickup'
     AttachmentClass=Class'mayhemweapons.ReflectiveShockAttachment'
     IconMaterial=Texture'MayhemHudContent.Generic.HUD'
     ItemName="Mayhem Shock Rifle"
     Skins(0)=Texture'mayhemweapons.ShockRifleTex'
}
