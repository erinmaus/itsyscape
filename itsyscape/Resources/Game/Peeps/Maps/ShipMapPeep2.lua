--------------------------------------------------------------------------------
-- Resources/Game/Peeps/Maps/ShipMapPeep2.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Vector = require "ItsyScape.Common.Math.Vector"
local Utility = require "ItsyScape.Game.Utility"
local Sailing = require "ItsyScape.Game.Skills.Sailing"
local Color = require "ItsyScape.Graphics.Color"
local MapScript = require "ItsyScape.Peep.Peeps.Map"
local MapOffsetBehavior = require "ItsyScape.Peep.Behaviors.MapOffsetBehavior"
local ColorBehavior = require "ItsyScape.Peep.Behaviors.ColorBehavior"
local OceanBehavior = require "ItsyScape.Peep.Behaviors.OceanBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local SailingResourceBehavior = require "ItsyScape.Peep.Behaviors.SailingResourceBehavior"
local ShipMovementBehavior = require "ItsyScape.Peep.Behaviors.ShipMovementBehavior"
local ShipStatsBehavior = require "ItsyScape.Peep.Behaviors.ShipStatsBehavior"

local ShipMapScript = Class(MapScript)

function ShipMapScript:new(resource, name, ...)
	MapScript.new(self, resource, name or 'ShipMapScript', ...)

	self:addBehavior(PositionBehavior)
	self:addBehavior(RotationBehavior)

	self:addBehavior(BossStatsBehavior)
	self:addBehavior(ShipMovementBehavior)
	self:addBehavior(ShipStatsBehavior)

	local _, movement = self:addBehavior(MovementBehavior)
	movement.noClip = true

	self:addPoke('hit')
	self:addPoke('sink')
	self:addPoke('sunk')
	self:addPoke('beach')
	self:addPoke('rock')
	self:addPoke('leak')

	self.isBeached = false

	self.props = {}
end

function ShipMapScript:onLoad(...)
	MapScript.onLoad(self, ...)

	local shipMovement = self:getBehavior(ShipMovementBehavior)
	if shipMovement then
		local map = self:getDirector():getMap(self:getLayer())
		if map then
			shipMovement.length = map:getWidth() * map:getCellSize()
			shipMovement.beam = map:getHeight() * map:getCellSize()
		end
	end
end

function ShipMapScript:onCustomize(sailingDetails)
	for _, prop in ipairs(self.props) do
		Utility.Peep.poof(prop)
	end
	table.clear(self.props)

	local gameDB = self:getDirector():getGameDB()
	local shipMapResource = Utility.Peep.getResource(self)
	local mapHotspots = gameDB:getRecords("ShipSailingItemMapObjectHotspot", { Map = shipMapResource })

	for _, sailingItem in ipairs(sailingDetails) do
		for _, mapHotspot in ipairs(mapHotspots) do
			if (sailingItem.slot == "" or sailingItem.slot == mapHotspot:get("Slot")) and
			   sailingItem.itemGroup == mapHotspot:get("ItemGroup") and
			   sailingItem.index == mapHotspot:get("Index")
			then
				local mapObject = mapHotspot:get("MapObject")
				local mapObjectLocation = gameDB:getRecord("MapObjectLocation", {
					Resource = mapObject
				})

				local propResource = sailingItem.props[mapHotspot:get("Slot")]
				if propResource then
					local prop = Utility.spawnPropAtAnchor(
						self,
						propResource,
						mapObjectLocation:get("Name"))

					if prop then
						local peep = prop:getPeep()
						local _, sailingResource = peep:addBehavior(SailingResourceBehavior)
						sailingResource.resource = gameDB:getResource(sailingItem.sailingItemID, "SailingItem")

						local _, color = peep:addBehavior(ColorBehavior)
						color.primary = Color(unpack(sailingItem.colors[1] or {}))
						color.secondaries = { Color(unpack(sailingItem.colors[2] or {})) }
						
						table.insert(self.props, prop:getPeep())
					end
				end
			end
		end
	end
end

function ShipMapScript:update(director, game)
	MapScript.update(self, director, game)

	local position, rotation = Sailing.Ocean.getPositionRotation(self)
	Utility.Peep.setRotation(self, rotation)
	Utility.Peep.setPosition(self, position + Vector(0, 8, 0))
end

return ShipMapScript
