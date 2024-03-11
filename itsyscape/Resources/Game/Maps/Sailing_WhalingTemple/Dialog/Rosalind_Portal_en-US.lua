local FollowerBehavior = require "ItsyScape.Peep.Behaviors.FollowerBehavior"

PLAYER_NAME = _TARGET:getName()

speaker "Rosalind"
if Utility.Quest.isNextStep("PreTutorial", "PreTutorial_InformedJenkins", _TARGET) then
	message "Looks like the portal is stable now..."
	message "I tuned it to %location{Isabelle Island}. There's %hint{a already rift at the top of Isabelle Island tower} so it was pretty easy!"
	message "We should go let Jenkins know what happened."
elseif Utility.Quest.isNextStep("PreTutorial", "PreTutorial_Teleported", _TARGET) then
	message "Well, we're parting ways for now."
	message "If I don't bump into you, you can usually find me on %hint{the fourth floor} of %location{Isabelle Island tower}."
	message "I can always help you change how others perceive you. I'm an Idromancer, after all! That's what we do."
	message "Farewell, %person{${PLAYER_NAME}}."

	local rosalind = _SPEAKERS["Rosalind"]
	if rosalind then
		rosalind:removeBehavior(FollowerBehavior)
	end

	_TARGET:getState():give("KeyItem", "PreTutorial_Teleported")

	local stage = _DIRECTOR:getGameInstance():getStage()
	stage:movePeep(
		_TARGET,
		"IsabelleIsland_Tower_Floor5",
		"Anchor_StartGame")
end
