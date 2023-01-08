class MessageNoKeyBindWarning extends LocalMessage abstract;

Var Array<String> sMessage;

static function string GetString(
	optional int Index,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object WeapClass
	)
{
        Return Default.sMessage[Index];
}

defaultproperties
{
     sMessage(0)="WARNING: No keybind detected for switching weapon modes"
     bIsUnique=True
     bIsConsoleMessage=False
     bFadeMessage=True
     Lifetime=4
     PosY=0.550000
}
