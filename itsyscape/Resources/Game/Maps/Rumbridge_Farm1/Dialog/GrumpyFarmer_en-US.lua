if _TARGET:getState():has("KeyItem", "SuperSupperSaboteur_GotPermissionForGoldenCarrot") then
	speaker "_TARGET"
	message "Thanks for letting me pick the carrot!"

	speaker "Farmer"
	message "Ya welcome. Anything for %person{Earl Reddick}!"
elseif _TARGET:getState():has("KeyItem", "SuperSupperSaboteur_GotYelledAtForGoldenCarrot") then
	speaker "_TARGET"
	message "Hey, I really need the golden carrot!"

	speaker "Farmer"
	message {
		"NO! I don't care who ya are, the carrot is mine!"
	}

	speaker "_TARGET"
	message {
		"What if I told you it's for %person{Earl Reddick}?",
		"%person{Chef Allon} tasked me with making him",
		"a super secret birthday carrot cake!"
	}

	speaker "Farmer"
	message {
		"Well, where's ya proof?",
		"Surely %hint{you have a recipe or some such} to prove it...",
	}

	message {
		"%person{Chef Allon} ain't the kind of guy",
		"to give out his secret recipe willy-nilly."
	}

	if not _TARGET:getState():has("Item", "SuperSupperSaboteur_SecretCarrotCakeRecipeCard", 1, { ['item-inventory'] = true }) then
		speaker "_TARGET"
		message {
			"Oh, I have the recipe somewhere! Let me go get it."
		}

		return
	end

	speaker "_TARGET"
	message {
		"Look! I have the chef's super secret recipe!"
	}

	_TARGET:getState():give("KeyItem", "SuperSupperSaboteur_GotPermissionForGoldenCarrot")

	speaker "Farmer"
	message {
		"Well I'll be - ya sure do!",
		"Go ahead, you can pick the carrot.",
		"But be careful, he's an angry lil' guy."
	}
else
	speaker "Farmer"
	message {
		"Leave me alone.",
		"Ya better not think about messin'",
		"with my %item{golden carrot}..."
	}
end
