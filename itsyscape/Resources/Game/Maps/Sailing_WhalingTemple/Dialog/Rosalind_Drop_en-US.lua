local DisabledBehavior = require "ItsyScape.Peep.Behaviors.DisabledBehavior"
local PreTutorialCommon = require "Resources.Game.Peeps.PreTutorial.V2Common"

speaker "Rosalind"
message "Do you want me to show you how to drop items?"

local YES = option "Yes!"
local NO  = option "No, I like having a full inventory!"

local result = select { YES, NO }

if result == YES then
	PreTutorialCommon.startDropItemTutorial(_TARGET)
else
	speaker "_TARGET"
	message "No, I like having a fully inventory!"

	speaker "Rosalind"
	message "If you say so, clutterbug!"

	_TARGET:removeBehavior(DisabledBehavior)
end
