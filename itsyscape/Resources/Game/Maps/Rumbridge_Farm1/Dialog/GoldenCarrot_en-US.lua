speaker "_TARGET"
message "Don't mind if I do..."

if _TARGET:getState():has("KeyItem", "SuperSupperSaboteur_GotPermissionForGoldenCarrot") then
	_TARGET:getState():give("Skill", "Foraging", Utility.xpForResource(11))

	_DIRECTOR:addPeep(
		_SPEAKERS["GoldenCarrot"]:getLayerName(),
		require "Resources.Game.Peeps.Props.PickRespawner",
		_SPEAKERS["GoldenCarrot"])
	Utility.Peep.poof(_SPEAKERS["GoldenCarrot"])

	local position = Utility.Peep.getPosition(_SPEAKERS["GoldenCarrot"])	
	local veggie = Utility.spawnActorAtPosition(_SPEAKERS["GoldenCarrot"], "SuperSupperSaboteur_GoldenCarrot", position.x, position.y, position.z, 0)
	veggie = veggie and veggie:getPeep()

	if veggie then
		Utility.Peep.attack(veggie, _TARGET)
		veggie:listen('ready', function()
			Utility.Peep.yell(veggie, "Oi! Get ya grubby hands off me, mammal!")
		end)
	end
elseif _TARGET:getState():has("KeyItem", "SuperSupperSaboteur_GotYelledAtForGoldenCarrot") then
	speaker "Farmer"
	message {
		"GRR! What did I say, adventurer?!",
		"No pickin' my prized carrot!"
	}

	speaker "_TARGET"
	message "Sorry, I forgot!"
elseif _TARGET:getState():has("KeyItem", "SuperSupperSaboteur_Started") then
	_TARGET:getState():give("KeyItem", "SuperSupperSaboteur_GotYelledAtForGoldenCarrot")

	speaker "Farmer"
	message {
		"HEY! No pickin' my prized carrot, adventurer!",
		"I don't care who you are, that carrot is mine!"
	}

	speaker "_TARGET"
	message {
		"Oh gosh, sorry!"
	}

	speaker "Farmer"
	message {
		"You better be!"
	}
else
	speaker "GoldenCarrot"
	message {
		"Loser! Leave me alone!"
	}

	speaker "_TARGET"
	message {
		"WHAT!"
	}

	speaker "GoldenCarrot"
	message {
		"YEAH! You heard me!",
		"I'll rip out your heart!"
	}

	speaker "_TARGET"
	message {
		"(Better not find out if the carrot is telling the truth...)"
	}
end
