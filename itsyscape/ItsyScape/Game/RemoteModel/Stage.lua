--------------------------------------------------------------------------------
-- ItsyScape/Game/RemoteModel/Stage.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Stage = require "ItsyScape.Game.Model.Stage"

local RemoteStage = Class(Stage)

function RemoteStage:new(gameManager)
	Stage.new(self)

	self.gameManager = gameManager

	self.itemSpies = {}
	self.onDropItem:register(self.spyOnDropItem)
	self.onTakeItem:register(self.spyOnTakeItem)
end

function RemoteStage:spyOnDropItem(item, tile, position)
	self.itemSpies[item.ref] = {
		item = item,
		tile = tile,
		position = positions
	}
end

function RemoteStage:spyOnTakeItem(item)
	self.itemSpies[item.ref] = nil
end

function RemoteStage:getItemsAtTile(i, j, layer)
	local result = {}
	for _, item in pairs(self.itemSpies) do
		if item.tile.i == i and item.tile.j == j and item.tile.layer == layer then
			table.insert(result, item)
		end
	end

	return result
end

function RemoteStage:iterateActors()
	return self.gameManager:iterateInstances("ItsyScape.Game.Model.Actor")
end

function RemoteStage:iterateProps()
	return self.gameManager:iterateInstances("ItsyScape.Game.Model.Prop")
end

return RemoteStage
