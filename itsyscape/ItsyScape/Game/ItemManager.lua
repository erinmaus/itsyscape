--------------------------------------------------------------------------------
-- ItsyScape/Game/ItemManager.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Item = require "ItsyScape.Game.Item"
local ItemUserdata = require "ItsyScape.Game.ItemUserdata"
local ItemInstance = require "ItsyScape.Game.ItemInstance"

local ItemManager = Class()

function ItemManager:new(gameDB)
	self.items = {}
	self.logic = {}
	self.gameDB = gameDB
end

function ItemManager:getGameDB()
	return self.gameDB
end

function ItemManager:getResource(id)
	return self.gameDB:getResource(id, "Item")
end

function ItemManager:getItemRecord(id)
	local resource = self.gameDB:getResource(id, "Item")
	if resource then
		return self.gameDB:getRecords("Item", { Resource = resource }, 1)[1]
	end
end

function ItemManager:isNoteable(id)
	local item = self:getItemRecord(id)
	if not item then
		return true
	else
		return item:get("Unnoteable") == 0 and not self:isStackable(id)
	end
end

function ItemManager:isStackable(id)
	local item = self:getItemRecord(id)
	if not item then
		return false
	else
		return item:get("Stackable") ~= 0
	end
end

function ItemManager:hasUserdata(id)
	local item = self:getItemRecord(id)
	if not item then
		return false
	else
		return item:get("HasUserdata") ~= 0
	end
end

function ItemManager:isTradeable(id)
	local item = self:getItemRecord(id)
	if not item then
		return false
	else
		return item:get("Untradeable") ~= 0
	end
end

function ItemManager:newUserdata(id)
	local typeName = string.format("ItsyScape.Game.ItemUserdata.%s", id)
	local s, r = pcall(require, typeName)
	if not s then
		Log.error("Could not create item userdata '%s': %s", id, r)
		return nil
	end

	if not Class.isDerived(r, ItemUserdata) then
		Log.error("Item userdata '%s' (type name: '%s') is not derived from 'ItsyScape.Game.ItemUserdata'")
		return nil
	end

	local instance = r(id, self)
	return instance
end

function ItemManager:getLogic(id, unique, tryXWeapon)
	if not self.logic[id] or unique then
		local Logic
		do
			local file = string.format("Resources.Game.Items.%s.Logic", id)
			local s, r = pcall(require, file)
			if not s and tryXWeapon then
				local fileXWeapon = string.format("Resources.Game.Items.X_%s.Logic", id)
				s, r = pcall(require, fileXWeapon)
			end

			if s and Class.isDerived(r, Item) then
				Logic = function(manager)
					return r(id, manager)
				end
			else
				if love.filesystem.getInfo(string.format("Resources/Game/Items/%s/Logic.lua", id)) then
					Log.warn("failed to load '%s': %s", file, r)
				end

				local resource = self.gameDB:getResource(id, "Item")
				if resource then
					Logic = function(manager)
						local Type = require "ItsyScape.Game.Item"
						return Type(id, manager)
					end
				end
			end
		end

		if not Logic then
			return nil
		end

		if unique then
			return Logic(self)
		end

		self.logic[id] = Logic(self)
	end

	return self.logic[id]
end

return ItemManager
