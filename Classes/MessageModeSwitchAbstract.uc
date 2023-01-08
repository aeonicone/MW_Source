class MessageModeSwitchAbstract extends LocalMessage abstract;

var Array<string> MessageBio;             var array<Color> ColorBio;
var Array<string> MessageMiniGun;         var array<Color> ColorMiniGun;
var Array<string> MessageLink;            var array<Color> ColorLink;
var Array<string> MessageFlak;            var array<Color> ColorFlak;
Var Array<String> MessageRocket;          var array<Color> ColorRocket;
Var Array<String> MessageLightning;       var array<Color> ColorLightning;
Var Array<String> MessageMine;            var array<Color> ColorMine;
Var Array<String> MessageGrenade;         var array<Color> ColorGrenade;
Var Array<String> MessageAVRiL;           var array<Color> ColorAVRiL;

static function string GetString(
	optional int Index,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object WeapClass
	)
{
    const MS = Class'MessageModeSwitchAbstract';
    Switch(WeapClass)
    {                                         // for some reason, it wants the class reference first.
        Case class'MayhemBioRifle':           MS.Default.DrawColor = Default.ColorBio[Index];       Return Default.MessageBio[Index];
        Case Class'MayhemMiniGun':            MS.Default.DrawColor = Default.ColorMinigun[Index];   Return Default.MessageMiniGun[Index];
        Case Class'MayhemLinkGun':            MS.Default.DrawColor = Default.ColorLink[Index];      Return Default.MessageLink[Index];
        Case Class'MayhemFlakCannon':         MS.Default.DrawColor = Default.ColorFlak[Index];      Return Default.MessageFlak[Index];
        Case Class'MayhemRocketLauncher':     MS.Default.DrawColor = Default.ColorRocket[Index];    Return Default.MessageRocket[Index];
        Case Class'MayhemSniperRifle':        MS.Default.DrawColor = Default.ColorLightning[Index]; Return Default.MessageLightning[Index];
        Case Class'MayhemONSMineLayer':       MS.Default.DrawColor = Default.ColorMine[Index];      Return Default.MessageMine[Index];
        Case Class'MayhemONSGrenadeLauncher': MS.Default.DrawColor = Default.ColorGrenade[Index];   Return Default.MessageGrenade[Index];
        Case Class'MayhemONSAVRiL':           MS.Default.DrawColor = Default.ColorAVRiL[Index];     Return Default.MessageAVRiL[Index];
        Default:                              Return "Weapon Class Unknown";
    }
}

defaultproperties
{
     MessageBio(0)="Standard Goop"
     MessageBio(1)="Bouncy Goop"
     MessageBio(2)="Splitting Goop"
     ColorBio(0)=(B=120,G=255,A=255)
     ColorBio(1)=(B=240,G=255,A=255)
     ColorBio(2)=(B=30,G=60,R=255,A=255)
     MessageMiniGun(0)="Standard FireModes"
     MessageMiniGun(1)="Super & Precision Fire"
     ColorMiniGun(0)=(G=125,R=255,A=255)
     ColorMiniGun(1)=(B=255,G=175,A=255)
     MessageLink(0)="Extended Link Beam"
     MessageLink(1)="Standard Link Beam"
     MessageLink(2)="Strong Link Beam"
     ColorLink(0)=(G=255,A=255)
     ColorLink(1)=(B=255,G=255,R=255,A=255)
     ColorLink(2)=(G=255,R=255,A=255)
     MessageFlak(0)="Tight Pattern"
     MessageFlak(1)="Regular Pattern"
     MessageFlak(2)="Wide Pattern"
     ColorFlak(0)=(G=255,R=255,A=255)
     ColorFlak(1)=(G=125,R=255,A=255)
     ColorFlak(2)=(B=255,G=200,R=100,A=255)
     MessageRocket(0)="Incendiary Rockets"
     MessageRocket(1)="Fragmentation Rockets"
     MessageRocket(2)="Standard Rockets"
     ColorRocket(0)=(G=125,R=255,A=255)
     ColorRocket(1)=(B=50,G=255,R=150,A=255)
     ColorRocket(2)=(B=255,G=255,R=255,A=255)
     MessageLightning(0)="Standard Bolts"
     MessageLightning(1)="Branch Fire"
     ColorLightning(0)=(B=255,G=200,R=100,A=255)
     ColorLightning(1)=(G=200,R=255,A=255)
     MessageMine(0)="Standard Mines"
     MessageMine(1)="EMP Mines"
     ColorMine(0)=(B=30,G=255,R=50,A=255)
     ColorMine(1)=(B=255,G=200,R=100,A=255)
     MessageGrenade(0)="Standard Grenade"
     MessageGrenade(1)="Super Sticky Grenade"
     ColorGrenade(0)=(B=175,G=175,R=175,A=255)
     ColorGrenade(1)=(G=255,R=255,A=255)
     MessageAVRiL(0)="Standard AVR's"
     MessageAVRiL(1)="Wolfpack Infantry Missles"
     ColorAVRiL(0)=(G=255,R=255,A=255)
     ColorAVRiL(1)=(B=20,G=60,R=255,A=255)
     bIsUnique=True
     bIsConsoleMessage=False
     bFadeMessage=True
     Lifetime=1
     PosY=0.810000
}
