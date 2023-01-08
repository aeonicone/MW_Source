class MayhemInteraction Extends Interaction;
var array<string> sMessage;
var bool bBindIsSet;

function PostRender( canvas C )
{
    local byte i;

    if ( bBindIsSet )
        Return;

    if ( HasAssignedKeys("ToggleMayhemWeaponMode") )
    {
        bBindIsSet = True;
        Return;
    }

    //C.Font = ;
    C.bCenter = True;
    C.SetDrawColor(255,150,30,220);

    for ( i = 0; i < 4; i++ )
    {
        c.SetPos(0, ( 0.55 + (i * 0.02) ) * C.SizeY );
        C.DrawText(sMessage[i]);
    }
}

final function bool HasAssignedKeys( string BindAlias )   // based on GetAssignedKeys of xInterface.GUIController.uc
{
	local Array<string> BindKeyNames;
	local string s;

	BindKeyNames.Length = 0;
	s = ViewportOwner.Actor.ConsoleCommand("BINDINGTOKEY" @ "\"" $ BindAlias $ "\"");
	if ( s != "" )
		Split(s, ",", BindKeyNames);

	return BindKeyNames.Length > 0;
}

defaultproperties
{
     sMessage(0)="WARNING: No keybind detected for switching mayhem weapon modes, please bind a key now."
     sMessage(1)="To set a keybind; hit Esc, go to Settings->Input->Configure Controls, search for category "
     sMessage(2)=""Mayhem Weapons Mutator" and bind a key to "Toggle Weapon Mode", press it to toggle "
     sMessage(3)="modes on almost every weapon."
     bVisible=True
}
