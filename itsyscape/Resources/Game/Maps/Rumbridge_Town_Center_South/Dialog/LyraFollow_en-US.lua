if Utility.Quest.isNextStep("SuperSupperSaboteur", "SuperSupperSaboteur_TalkedToCapnRaven", _TARGET) then
	local map = Utility.Peep.getMapResource(_TARGET)
	if map.name == "Rumbridge_Port" then
		speaker "Lyra"
		message {
			"%person{Cap'n Raven} is here at %location{the pub}.",
			"We've got to convince her!"
		}
	elseif map.name == "Rumbridge_Castle" then
		speaker "Lyra"
		message "Be careful! You'll blow our cover!"
	else
		speaker "Lyra"
		message {
			"Let's head to the %location{Rumbridge port}",
			"and talk to %person{Cap'n Raven}."
		}
	end
end
