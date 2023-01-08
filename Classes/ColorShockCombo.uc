class ColorShockCombo extends ShockCombo;

Var Class<ColorShockComboExpRing> ExpRing;
Var Class<ColorShockComboFlare> ComboFlare;
Var Class<ColorShockComboCore> Core;
Var Class<ColorShockComboSphereDark> SphereDark;
var Class<ColorShockComboVortex> Vortex;
Var Class<ColorShockComboWiggles> Wiggles;
Var Class<ColorShockComboFlash> Flash;

simulated Function PostBeginPlay()
{
    Super(Actor).PostBeginPlay();

    if (Level.NetMode != NM_DedicatedServer)
    {
        Spawn(ExpRing);
        Flare = Spawn(ComboFlare);
        Spawn(Core);
        Spawn(SphereDark);
        Spawn(Vortex);         // Mesh
        Spawn(Wiggles);
        Spawn(Flash);
    }
}

defaultproperties
{
     ExpRing=Class'mayhemweapons.ColorShockComboExpRing'
     ComboFlare=Class'mayhemweapons.ColorShockComboFlare'
     Core=Class'mayhemweapons.ColorShockComboCore'
     SphereDark=Class'mayhemweapons.ColorShockComboSphereDark'
     Vortex=Class'mayhemweapons.ColorShockComboVortex'
     Wiggles=Class'mayhemweapons.ColorShockComboWiggles'
     Flash=Class'mayhemweapons.ColorShockComboFlash'
}
