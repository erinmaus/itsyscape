--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/Components/RechargingPowerBar.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Config = require "ItsyScape.Game.Config"
local Color = require "ItsyScape.Graphics.Color"
local Utility = require "ItsyScape.Game.Utility"
local Drawable = require "ItsyScape.UI.Drawable"

local RechargingPowerBar = Class(Drawable)

function RechargingPowerBar:new()
	Drawable.new(self)

	self.remainder = 0
	self.cost = 1
end

function RechargingPowerBar:updateRecharge(remainder, cost)
	self.remainder = remainder
	self.cost = cost
end

function RechargingPowerBar:draw(resources, state)
	if self.remainder == 0 then
		return
	end

	love.graphics.push("all")
	local colors = {
		Color.fromHexString(Config.get("Config", "COLOR", "color", "ui.combat.zeal.tier0Fire")),
		Color.fromHexString(Config.get("Config", "COLOR", "color", "ui.combat.zeal.tier1Fire")),
		Color.fromHexString(Config.get("Config", "COLOR", "color", "ui.combat.zeal.tier2Fire")),
		Color.fromHexString(Config.get("Config", "COLOR", "color", "ui.combat.zeal.tier3Fire")),
		Color.fromHexString(Config.get("Config", "COLOR", "color", "ui.combat.zeal.tier4Fire"))
	}

	local delta = 1 - self.remainder / math.max(self.cost, 0.01)
	local lerpedIndex = math.lerp(1, #colors, delta)
	local index = math.floor(lerpedIndex)
	local mu = lerpedIndex - math.floor(lerpedIndex)
	local colorA = colors[index]
	local colorB = colors[math.min(index + 1, #colors)]
	local progressColor = colorA:lerp(colorB, mu)

	local width, height = self:getSize()

	local backgroundColor = Color.fromHexString(Config.get("Config", "COLOR", "color", "ui.combat.zeal.remainder"))
	love.graphics.setColor(backgroundColor:get())
	itsyrealm.graphics.rectangle("fill", 0, 0, width, height, 2)

	love.graphics.setColor(progressColor:get())
	itsyrealm.graphics.rectangle("fill", 0, 0, math.floor(width * delta), height, math.min(2, width * delta / 2))

	love.graphics.setColor(1, 1, 1, 1)
	itsyrealm.graphics.rectangle(
		"fill",
		0 + math.floor(width * delta) - 1,
		0,
		2,
		height)


	love.graphics.setColor(progressColor:get())
	love.graphics.setLineWidth(2)
	itsyrealm.graphics.rectangle("line", 0, 0, width, height, 2)

	love.graphics.pop()
end

return RechargingPowerBar
