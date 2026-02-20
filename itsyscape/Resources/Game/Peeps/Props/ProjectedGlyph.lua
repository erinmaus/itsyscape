--------------------------------------------------------------------------------
-- Resources/Peeps/Props/ProjectedGlyph.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Utility = require "ItsyScape.Game.Utility"
local Color = require "ItsyScape.Graphics.Color"
local Prop = require "ItsyScape.Peep.Peeps.Prop"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local StaticBehavior = require "ItsyScape.Peep.Behaviors.StaticBehavior"
local OldOneDescriptionBehavior = require "ItsyScape.Peep.Behaviors.OldOneDescriptionBehavior"

local ProjectedGlyph = Class(Prop)

ProjectedGlyph.DEFAULT_FADE_COOLDOWN  = 1
ProjectedGlyph.DEFAULT_DELAY_COOLDOWN = 1

function ProjectedGlyph:new(...)
	Prop.new(self, ...)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(4, 0, 4)

	local static = self:getBehavior(StaticBehavior)
	static.type = StaticBehavior.PASSABLE

	self.currentFadeCooldown = self.DEFAULT_FADE_COOLDOWN + self.DEFAULT_DELAY_COOLDOWN
	self.fadeCooldownDuration = self.DEFAULT_FADE_COOLDOWN
	self.fadeCooldownDelay = self.DEFAULT_DELAY_COOLDOWN
	self.isFadingOut = false

	self:addPoke("fade")
	self:addPoke("faded")
end

function ProjectedGlyph:onFade(duration, delay)
	duration = duration or self.DEFAULT_FADE_COOLDOWN
	delay = delay or self.DEFAULT_DELAY_COOLDOWN

	self.currentFadeCooldown = 0
	self.fadeCooldownDelay = delay
	self.fadeCooldownDuration = duration
	self.isFadingOut = true
end

function ProjectedGlyph:onFaded()
	Utility.Peep.poof(self)
end

function ProjectedGlyph:spawnOrPoofTile(tile, i, j, mode)
	-- Nothing.
end

function ProjectedGlyph:getPropState()
	local glyph
	do
		local gameDB = self:getDirector():getGameDB()
		local mapObject = Utility.Peep.getMapObject(self)
		if mapObject then
			local description = gameDB:getRecord("OldOneDescription", { Resource = mapObject })
			glyph = description and description:get("Value")
		end

		local oldOneDescription = self:getBehavior(OldOneDescriptionBehavior)
		glyph = (oldOneDescription and oldOneDescription.description) or glyph
		glyph = Utility.getOldOneDescription(mapObject, gameDB) or 0
	end

	local map = Utility.Peep.getMap(self)

	local width, _, height = Utility.Peep.getSize(self):get()
	width = math.floor(width / map:getCellSize())
	height = math.floor(height / map:getCellSize())

	local i, j = Utility.Peep.getTile(self)
	local center = map:getTileCenter(i, j)
	local position = Utility.Peep.getPosition(self)
	local elevation = math.max(position.y - center.y, 0)

	local currentTime
	do
		local player = Utility.Peep.getPlayer(self)
		if player then
			local rootStorage = player:getDirector():getPlayerStorage(player):getRoot()
			currentTime = Utility.Time.getAndUpdateTime(rootStorage)
		end

		currentTime = currentTime or 0
	end

	local alpha = math.clamp(math.max(self.currentFadeCooldown - self.fadeCooldownDelay, 0) / (self.fadeCooldownDuration or 1))
	if self.isFadingOut then
		alpha = 1 - alpha
	end

	return {
		glyph = glyph,
		time = currentTime,
		alpha = alpha,
		width = width,
		height = height,
		glyphColor = { Color.fromHexString("463779"):get() },
		glowColor = { Color.fromHexString("f26722"):get() },
		outlineColor = { Color.fromHexString("000000"):get() },
		elevation = elevation
	}
end

function ProjectedGlyph:update(director, game)
	Prop.update(self, director, game)

	local delta = game:getDelta()
	self.currentFadeCooldown = math.min(self.currentFadeCooldown + delta, self.fadeCooldownDelay + self.fadeCooldownDuration)

	if self.isFadingOut and self.currentFadeCooldown >= self.fadeCooldownDelay + self.fadeCooldownDuration then
		self:pushPoke("faded")
	end
end

return ProjectedGlyph
