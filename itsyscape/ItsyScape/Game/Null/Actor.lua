--------------------------------------------------------------------------------
-- ItsyScape/Game/Null/Actor.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local CacheRef = require "ItsyScape.Game.CacheRef"
local Vector = require "ItsyScape.Common.Math.Vector"
local Actor = require "ItsyScape.Game.Model.Actor"
local Color = require "ItsyScape.Graphics.Color"

local NullActor = Class(Actor)

function NullActor:spawn(id)
	self.id = id or 1
end

function NullActor:depart()
	self.id = Actor.NIL_ID
end

function NullActor:getID()
	return self.id
end

function NullActor:getPeepID()
	return "Null"
end

function NullActor:getName()
	return "Null"
end

function NullActor:getResourceType()
	return "Peep"
end

function NullActor:getResourceName()
	return "Null"
end

function NullActor:setName(value)
	-- Nothing.
end

function NullActor:setDirection(direction)
	-- Nothing.
end

function NullActor:getDirection()
	return Vector.ZERO
end

function NullActor:teleport(position)
	self.onTeleport(self, position)
end

function NullActor:move(position)
	self.onMove(self, position)
end

function NullActor:getPosition()
	return Vector.ZERO
end

function NullActor:getTile()
	return 0, 0, 1
end

function NullActor:getBounds()
	return Vector.ZERO, Vector.ZERO
end

function NullActor:getActions(scope)
	return {}
end

function NullActor:poke(action, scope)
	-- Nothing.
end

function NullActor:getCurrentHitpoints()
	return 100
end

function NullActor:getMaximumHitpoints()
	return 100
end

function NullActor:playAnimation(slot, priority, animation, force, time)
	self.onAnimationPlayed(self, slot, priority, animation, force, time)
end

function NullActor:setBody(body)
	self.onTransmogrified(self, body)
end

function NullActor:setSkin(slot, priority, skin, config)
	self.onSkinChanged(self, slot, priority, skin, config)
end

function NullActor:unsetSkin(slot, priority, skin)
	self.onSkinRemoved(self, slot, priority, skin)
end

function NullActor:setAppearance(t)
	t = t or {}

	if t.body then
		self:setBody(CacheRef("ItsyScape.Game.Body", string.format("Resources/Game/Bodies/%s.lskel", t.body)))
	end

	for slot, skins in pairs(t.skins or {}) do
		for priority, skin in ipairs(skins) do
			local config = {}
			for _, color in ipairs(skin.colors or {}) do
				if type(color) == "string" then
					table.insert(config, { Color.fromHexString(color):get() })
				elseif Class.isCompatibleType(color, Color) then
					table.insert(config, { color:get() })
				else
					table.insert(config, { unpack(color) })
				end
			end

			self:setSkin(
				slot,
				skin.priority or priority,
				CacheRef("ItsyScape.Game.Skin.ModelSkin", string.format("Resources/Game/Skins/%s", skin.skin)),
				config)
		end
	end

	for slot, animation in pairs(t.animations or {}) do
		self:playAnimation(
			slot,
			animation.priority or 0,
			CacheRef("ItsyScape.Graphics.AnimationResource", string.format("Resources/Game/Animations/%s/Script.lua", animation.animation)),
			not not animation.force,
			animation.time or 0)
	end
end

function NullActor:fromStorage(playerStorage)
	self:setBody(CacheRef("ItsyScape.Game.Body", "Resources/Game/Bodies/Human.lskel"))

	local skinStorage = playerStorage:getRoot():getSection("Player"):get("Skin"):get()
	for _, skin in pairs(skinStorage) do
		self:setSkin(
			skin.slot,
			skin.priority,
			CacheRef(skin.type, skin.filename),
			skin.config)
	end
end

function NullActor:getSkin(slot)
	return
end

return NullActor
