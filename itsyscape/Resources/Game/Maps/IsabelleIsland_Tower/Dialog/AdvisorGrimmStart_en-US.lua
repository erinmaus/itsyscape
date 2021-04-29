speaker "_TARGET"
message "Are you %person{Advisor Grimm}?"

PLAYER_NAME = _TARGET:getName()
speaker "AdvisorGrimm"
message {
	"Correct. You must be %person{${PLAYER_NAME}}!",
	"Apologies on your tumultuous journey here.",
	"I'm sure %person{Isabelle} spoke briefly of your task?"
}

speaker "_TARGET"
message "Yep!"

speaker "AdvisorGrimm"
message {
	"Excellent!",
	"I can give you information about your quest.",
	"%person{Isabelle} is too busy to bother with the minutiae."
}

if _TARGET:getState():give("KeyItem", "CalmBeforeTheStorm_TalkedToGrimm1") then
	defer "Resources/Game/Maps/IsabelleIsland_Tower/Dialog/AdvisorGrimmPostStart_en-US.lua"
else
	defer "I'm afraid I lost my train of thought."
	Log.warn("Couldn't continue quest 'Calm Before the Storm.'")
end
