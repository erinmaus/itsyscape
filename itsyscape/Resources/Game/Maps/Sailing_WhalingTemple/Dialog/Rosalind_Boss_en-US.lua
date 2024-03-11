local Weapon = require "ItsyScape.Game.Weapon"
local Probe = require "ItsyScape.Peep.Probe"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local DisabledBehavior = require "ItsyScape.Peep.Behaviors.DisabledBehavior"
local PreTutorialCommon = require "Resources.Game.Peeps.PreTutorial.V2Common"
local StanceBehavior = require "ItsyScape.Peep.Behaviors.StanceBehavior"
local PowerCoolDownBehavior = require "ItsyScape.Peep.Behaviors.PowerCoolDownBehavior"
local PendingPowerBehavior = require "ItsyScape.Peep.Behaviors.PendingPowerBehavior"

local INVENTORY_FLAGS = {
	['item-inventory'] = true
}

local EQUIPMENT_FLAGS = {
	['item-equipment'] = true
}

speaker "Rosalind"

local isGoodNewsButNotReally = not _TARGET:getState():has("KeyItem", "PreTutorial_TalkedAboutWeather")
if not _TARGET:getState():has("KeyItem", "PreTutorial_TalkedAboutWeather") then
	message {
		"Looks like the weather has let up...",
		"This is good news!"
	}

	message {
		"Sailing to %location{Isabelle Island} should be safer...\n",
		"It also means %person{Cthulhu} is not in the area."
	}

	_TARGET:getState():give("KeyItem", "PreTutorial_TalkedAboutWeather")
end

if not Utility.Peep.isInPassage(_TARGET, "Passage_BossArena") or not _SPEAKERS["Yendorian"] then
	return
end

local function focus(speakerName)
	local speakerPeep = _SPEAKERS[speakerName]
	local actor = speakerPeep and speakerPeep:getBehavior("ActorReference")
	actor = actor and actor.actor

	if actor then
		local player = Utility.Peep.getPlayerModel(_TARGET)
		player:pokeCamera("targetActor", actor:getID())
		player:pokeCamera("zoom", 25)
	end

	speaker(speakerName)
end

if Utility.Quest.isNextStep("PreTutorial", "PreTutorial_FoundInjuredYendorian", _TARGET) or
   Utility.Quest.isNextStep("PreTutorial", "PreTutorial_ReasonedWithYendorian", _TARGET) -- or any others on that branch
then
	local playerModel = Utility.Peep.getPlayerModel(_TARGET)
	playerModel:changeCamera("StandardCutscene")

	if isGoodNewsButNotReally then
		message {
			"Wait! I take that back...",
			"There's a Yendorian ahead!",
		}
	else
		message "Look! There's a Yendorian soldier ahead!"
	end

	message "Yendorians are fearsome zealots of Yendor, often called Her First Ones."
	message "They arrived in the Realm eons ago, but Yendorian soldiers are a rare sight this far north of Rh'lor..."
	message "And it looks like it spotted us!"

	focus "Yendorian"
	Utility.Peep.lookAt(_SPEAKERS["Yendorian"], _TARGET)

	message "*cough* You two! *cough* What are you rodents doing on %person{Yendor's} holy island? *cough*"

	focus "Rosalind"
	message "*whispers* Looks like it's injured! We might stand a chance if it comes to fighting!"

	focus "_TARGET"
	message "Let's see..."

	_TARGET:getState():give("KeyItem", "PreTutorial_FoundInjuredYendorian")

	local FIGHT   = option "We're here to defeat you in combat, shrimp!"
	local NEUTRAL = option "We were attacked by a pirate and had to make land."
	local FLEE    = option "Uh, we were just leaving...! See ya!"

	local result = select { FIGHT, NEUTRAL, FLEE }

	if result == FIGHT then
		_TARGET:getState():give("KeyItem", "PreTutorial_InsultedYendorian")

		focus "_TARGET"
		message {
			"We're here to defeat you in single... (Or is it double...?)... Combat, weird... Shrimp... Octopus thing!",
			"Go tell %person{Cthulhu} what human boot tastes like!"
		}

		focus "Rosalind"
		message "WHAT ARE YOU THINKING?! THIS IS A BAD IDEA!"

		focus "Yendorian"
		playerModel:pokeCamera("shake", 0.75)

		message "*cough* FOOLS! RODENTS! VERMINS! ROACHES! *hack*"
		message "You'll be reborn to serve *cough* %person{Yendor} soon enough as the lowliest of the undead!"

		focus "Rosalind"
		message "Good job! *facepalm*"
		message "Let's take care of this then..."
	elseif result == NEUTRAL then
		_TARGET:getState():give("KeyItem", "PreTutorial_ReasonedWithYendorian")

		focus "_TARGET"
		message {
			"We were attacked by the dreaded pirate lord %person{Cap'n Raven}",
			"and had to make land to fix our ship. We mean no harm or insult!"
		}

		focus "Rosalind"
		message {
			Utility.Text.getPronoun(_TARGET, Utility.Text.PRONOUN_SUBJECT, "en-US", true) .. " is right!",
			"We will be leaving as soon as it's safe to do so!"
		}

		focus "Yendorian"
		message "*cough* I do not reason with a mortal and lowly witch-servant of %empty{Them}!"
		message "You'll be reborn *cough* to serve %person{Yendor} soon enough!"

		focus "Rosalind"
		message "Well, diplomacy failed. Let's take care of this then..."
	elseif result == FLEE then
		_TARGET:getState():give("KeyItem", "PreTutorial_DidACowardlyThing")

		focus "_TARGET"
		message "Uh, we were just leaving! Sorry about everything! See ya!"

		focus "Rosalind"
		message "*whispers* Have you been hanging around %person{Orlando} too much?! Cowardice will get us nowhere!"

		focus "Yendorian"
		message "*cough* %person{Yendor} abhors fear. *cough* But bones are bones and meat is meat. You will serve well as zombi food."
	end

	playerModel:changeCamera("Default")
	_TARGET:removeBehavior(DisabledBehavior)
elseif Utility.Quest.isNextStep("PreTutorial", "PreTutorial_DefeatedInjuredYendorian", _TARGET) then
	if not _TARGET:hasBehavior(DisabledBehavior) then
		_TARGET:addBehavior(DisabledBehavior)

		speaker "Rosalind"
		message {
			"The Yendorian is trying to summon %person{The First One}!",
			"That would be apocalyptic!",
			"I didn't even know that was possible anymore!"
		}

		message "We need to %hint{surprise the Yendorian} to break its concentration!"

		speaker "A %hint{use a stronger type of attack}, called a power, is perfect for this."

		speaker "Let me show you how to use a power..."

		local powers = _TARGET:getBehavior(PendingPowerBehavior)
		_TARGET:removeBehavior(PowerCoolDownBehavior)

		PreTutorialCommon.startRibbonTutorial(_TARGET, PreTutorialCommon.USE_POWER, "PlayerPowers")
	else
		local playerModel = Utility.Peep.getPlayerModel(_TARGET)
		playerModel:changeCamera("StandardCutscene")

		focus "Yendorian"
		Utility.Peep.lookAt(_SPEAKERS["Yendorian"], _TARGET)

		message "*cough* You're back for more punishment?! *cough*"

		focus "Rosalind"
		message "Let's take care of this!"

		playerModel:changeCamera("Default")
		_TARGET:removeBehavior(DisabledBehavior)
	end
end
