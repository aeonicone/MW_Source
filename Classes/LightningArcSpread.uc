Class LightningArcSpread extends LightningArcSmall;

simulated function PostNetBeginPlay()
{
	local xWeaponAttachment Attachment;
	local vector X,Y,Z;
	
    if ( (xPawn(Instigator) != None) && !Instigator.IsFirstPerson() )
    {
        Attachment = xPawn(Instigator).WeaponAttachment;
        if ( (Attachment != None) && (Level.TimeSeconds - Attachment.LastRenderTime < 0.1) )
        {
			GetAxes(Attachment.Rotation,X,Y,Z);
            SetLocation(Attachment.Location -40*X -10*Z);
        }
    }
}

defaultproperties
{
     mSpawnVecB=(X=40.000000,Y=20.000000,Z=10.000000)
     mSizeRange(0)=15.000000
     mSizeRange(1)=15.000000
}
