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
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local BasicTree = require "Resources.Game.Peeps.Props.BasicTree"

local PetrifiedSpiderTree = Class(BasicTree)

PetrifiedSpiderTree.IDLE_PRIORITY   = 50
PetrifiedSpiderTree.CHOP_PRIORITY   = 100
PetrifiedSpiderTree.FELLED_PRIORITY = 2000

PetrifiedSpiderTree.ATTACK_TIME_SECONDS = 2

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
	end

	if self.hadSpider then
		self:spawnOrPoof("spawn")
	end

	local size = self:getBehavior(SizeBehavior)
	size.size = size.oldSize or size.size
	size.oldSize = nil
end

function PetrifiedSpiderTree:onResourceHit(...)
	BasicTree.onResourceHit(self, ...)

	if self.spider then
		self.spider:playAnimation(
			"chop",
			PetrifiedSpiderTree.CHOP_PRIORITY,
			CacheRef(
				"ItsyScape.Graphics.AnimationResource",
				"Resources/Game/Animations/Spider_Tree_Chopped/Script.lua"))
	end
end

function PetrifiedSpiderTree:onResourceObtained(e)
	if self.spider then
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
			e.peep)

		self.hadSpider = self.spider ~= nil
		self.spider = nil

		self:spawnOrPoof("poof")

		local size = self:getBehavior(SizeBehavior)
		size.oldSize = size.size
		size.size = Vector.ZERO
	end
end

return PetrifiedSpiderTree
