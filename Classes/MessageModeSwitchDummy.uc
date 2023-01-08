class MessageModeSwitchDummy extends LocalMessage abstract;
var Array<string> ModeMessage;

static function string GetString(
	optional int GivenIndex,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
    Return Default.ModeMessage[GivenIndex];
}

static function color GetColor(
    optional int GivenIndex,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional PlayerReplicationInfo RelatedPRI_2
    )
{
    Return Class'Hud'.Default.GoldColor;
}

defaultproperties
{
     ModeMessage(0)="This weapon can't change modes"
     ModeMessage(1)="This weapon can't change modes"
     ModeMessage(2)="This weapon can't change modes"
     ModeMessage(3)="Can't you read?"
     ModeMessage(4)="I said it can't change modes!"
     ModeMessage(5)="n00b!"
     ModeMessage(6)="Having fun pressing that button?"
     ModeMessage(7)="Got brain?"
     ModeMessage(8)="Stop it!"
     ModeMessage(9)="Stop touching me!"
     ModeMessage(10)="Keyboard abuse!"
     ModeMessage(11)="Computer harrassment!"
     ModeMessage(12)="Play the game stupid!"
     ModeMessage(13)="Ok... let's try this again..."
     bIsUnique=True
     bIsConsoleMessage=False
     bFadeMessage=True
     Lifetime=2
     PosY=0.810000
}
