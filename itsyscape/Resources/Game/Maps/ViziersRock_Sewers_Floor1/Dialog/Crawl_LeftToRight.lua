speaker "_TARGET"

message {
	"Ugh, I guess there's no other choice.",
	"I have to through this nasty pipe..."
}

local DisabledBehavior = require "ItsyScape.Peep.Behaviors.DisabledBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local ScaleBehavior = require "ItsyScape.Peep.Behaviors.ScaleBehavior"

_TARGET:addBehavior(DisabledBehavior)
_TARGET:addBehavior(ScaleBehavior)

movement = _TARGET:getBehavior(MovementBehavior)
movement.noClip = true

local cutscene = Utility.Map.playCutscene(
	Utility.Peep.getMapScript(_TARGET),
	"ViziersRock_Sewers_Floor1_Crawl_LeftToRight",
	nil,
	_TARGET)

cutscene:listen("done", function()
	_TARGET:removeBehavior(DisabledBehavior)
	_TARGET:removeBehavior(ScaleBehavior)
	movement.noClip = false
end)
