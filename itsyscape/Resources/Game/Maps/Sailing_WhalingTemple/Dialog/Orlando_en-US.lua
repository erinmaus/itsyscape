speaker "Orlando"
message "'Ey! Nice to meet you!"
message {
	"Good job out there when %person{Cap'n Raven} attacked us!",
	"And don't get me started on how you handled %person{Cthulhu} and those squid!"
}

if _TARGET:getState():has("KeyItem", "PreTutorial_InformedJenkins") then
	if _TARGET:getState():has("KeyItem", "PreTutorial_DidACowardlyThing") then
		message {
			"But... I hope I'm not rubbing off on you.",
			"You should be brave! That's what adventurers do!",
			"Especially if you wanna be a hero one day!"
		}
	elseif _TARGET:getState():has("KeyItem", "PreTutorial_ReasonedWithYendorian") then
		message {
			"You're so brave for trying to reason with that Yendorian!",
			"I probaberly would've run away!",
			"But you tried peace first and then beat it up!"
		}
	elseif _TARGET:getState():has("KeyItem", "PreTutorial_InsultedYendorian") then
		message {
			"I guess you got a mean streak!",
			"I wouldn't know what it's like to be mean... I'm a little too... soft."
		}

		message {
			"But I think you kinda made %person{Rosalind} mad.",
			"You probaberly should've tried to reason with the Yendorian and only went with the classic kick-ass as a last resort."
		}
	end

	message {
		"Like %person{Rosalind}! Awww. %person{Rosalind}... *sigh*"
	}
end
