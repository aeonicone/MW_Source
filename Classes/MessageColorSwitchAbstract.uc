class MessageColorSwitchAbstract extends LocalMessage abstract;
var Array<string> ColorMessage;
var String sBaseMessage;

static function string GetString(
	optional int GivenIndex,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
     Return  Default.ColorMessage[GivenIndex]@Default.sBaseMessage;
}

static function color GetColor(
    optional int GivenIndex,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional PlayerReplicationInfo RelatedPRI_2
    )
{
    if ( GivenIndex < 11 )
        return class'ColorManager'.Default.ColorBank[GivenIndex];
    Return class'ColorManager'.static.AssignRandomColor();
}

defaultproperties
{
     ColorMessage(0)="1"
     ColorMessage(1)="2"
     ColorMessage(2)="3"
     ColorMessage(3)="4"
     ColorMessage(4)="5"
     ColorMessage(5)="6"
     ColorMessage(6)="7"
     ColorMessage(7)="8"
     ColorMessage(8)="9"
     ColorMessage(9)="10"
     ColorMessage(10)="11"
     ColorMessage(11)="12"
     ColorMessage(12)="13"
     ColorMessage(13)="14"
     sBaseMessage="Switching color to"
     bIsUnique=True
     bIsConsoleMessage=False
     bFadeMessage=True
     Lifetime=1
     PosY=0.900000
}
