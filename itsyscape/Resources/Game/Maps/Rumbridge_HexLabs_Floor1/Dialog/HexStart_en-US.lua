PLAYER_NAME = _TARGET:getName()

speaker "Hex"
message {
	"Huh-H-E-Y! You there! %person{${PLAYER_NAME}}!",
	"Watcha need?"
}

defer "Resources/Game/Maps/Rumbridge_HexLabs_Floor1/Dialog/HexMysteriousMachinations_en-US.lua"

speaker "Hex"
message "Later!"
