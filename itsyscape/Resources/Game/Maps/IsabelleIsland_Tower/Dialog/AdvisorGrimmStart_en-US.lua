speaker "_TARGET"
message "Are you Advisor Grimm?"

PLAYER_NAME = _TARGET:getName()
speaker "AdvisorGrimm"
message {
	"Yes, I am. You must be ${PLAYER_NAME}.",
	"I'm sure Isabelle spoke briefly of your task?"
}

speaker "_TARGET"
message "Yep!"

speaker "AdvisorGrimm"
message "Excellent. I can give you information about the items you seek."

if _TARGET:getState():give("KeyItem", "CalmBeforeTheStorm_TalkedToGrimm1") then
	defer "Resources/Game/Maps/IsabelleIsland_Tower/Dialog/AdvisorGrimmPostStart_en-US.lua"
else
	defer "I'm afraid I lost my train of thought."
	Log.warn("Couldn't continue quest 'Calm Before the Storm.'")
end
