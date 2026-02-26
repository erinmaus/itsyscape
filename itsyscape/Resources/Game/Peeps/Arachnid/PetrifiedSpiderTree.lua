--------------------------------------------------------------------------------
-- Resources/Game/Peeps/PetrifiedSpiderTree/PetrifiedSpiderTree.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local CacheRef = require "ItsyScape.Game.CacheRef"
local Utility = require "ItsyScape.Game.Utility"
local Probe = require "ItsyScape.Peep.Probe"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local BasicTree = require "Resources.Game.Peeps.Props.BasicTree"

local PetrifiedSpiderTree = Class(BasicTree)

PetrifiedSpiderTree.IDLE_PRIORITY   = 50
PetrifiedSpiderTree.CHOP_PRIORITY   = 100
PetrifiedSpiderTree.FELLED_PRIORITY = 2000

PetrifiedSpiderTree.ATTACK_TIME_SECONDS = 2

PetrifiedSpiderTree.AMBUSH_DISTANCE = 8
PetrifiedSpiderTree.MIN_AMBUSH_TIME = 0.5
PetrifiedSpiderTree.MAX_AMBUSH_TIME = 1

function PetrifiedSpiderTree:new(...)
	BasicTree.new(self, ...)

	self:addPoke("ambush")
	self:addPoke("attack")
end

function PetrifiedSpiderTree:onReplenished()
	local position = Utility.Peep.getPosition(self)
	self.spider = Utility.spawnActorAtPosition(
		self,
		"PetrifiedSpider",
		position.x, position.y, position.z,
		0)

	if self.spider then
		self.spider:getPeep():listen("finalize", function()
			self.spider:playAnimation(
				"tree",
				PetrifiedSpiderTree.IDLE_PRIORITY,
				CacheRef(
					"ItsyScape.Graphics.AnimationResource",
					"Resources/Game/Animations/Spider_Tree_Spawn/Script.lua"),
				nil,
				self.hadSpider and 0 or math.huge)
		end)

		Utility.Peep.disable(self.spider:getPeep())
	end

	local size = self:getBehavior(SizeBehavior)
	size.size = size.oldSize or size.size
	size.oldSize = nil
end

function PetrifiedSpiderTree:previewChop(...)
	BasicTree.previewChop(self, ...)

	if self.spider then
		self.spider:playAnimation(
			"chop",
			PetrifiedSpiderTree.CHOP_PRIORITY,
			CacheRef(
				"ItsyScape.Graphics.AnimationResource",
				"Resources/Game/Animations/Spider_Tree_Chopped/Script.lua"))
	end
end

function PetrifiedSpiderTree:onAmbush(peep)
	local nearby = self:getDirector():probe(
		Probe.layer(Utility.Peep.getLayer(self)),
		Probe.distance(self, PetrifiedSpiderTree.AMBUSH_DISTANCE),
		Probe.lineOfSight(self, true),
		Probe.resource("Prop", "PetrifiedSpiderTree_Default"))

	for _, otherTree in ipairs(nearby) do
		otherTree:pushPoke(
			love.math.random() * (PetrifiedSpiderTree.MAX_AMBUSH_TIME - PetrifiedSpiderTree.MIN_AMBUSH_TIME) + PetrifiedSpiderTree.MIN_AMBUSH_TIME,
			"attack",
			peep)
	end
end

function PetrifiedSpiderTree:onAttack(peep)
	if not self.spider then
		return
	end

	Utility.Peep.enable(self.spider:getPeep())

	self.spider:playAnimation(
		"chop",
		PetrifiedSpiderTree.FELLED_PRIORITY,
		CacheRef(
			"ItsyScape.Graphics.AnimationResource",
			"Resources/Game/Animations/Spider_Tree_Felled/Script.lua"))

	self.spider:stopAnimation("tree")

	self.spider:getPeep():pushPoke(
		PetrifiedSpiderTree.ATTACK_TIME_SECONDS,
		"attack",
		peep)

	self.hadSpider = self.spider ~= nil
	self.spider = nil

	local size = self:getBehavior(SizeBehavior)
	size.oldSize = size.size
	size.size = Vector.ZERO
end

function PetrifiedSpiderTree:onResourceObtained(e)
	if self.spider then
		self:pushPoke("attack", e.peep)
		self:pushPoke("ambush", e.peep)
	end
end

return PetrifiedSpiderTree
