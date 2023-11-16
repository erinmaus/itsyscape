--------------------------------------------------------------------------------
-- ItsyScape/Game/ItemUserdata/ItemIngredientsUserdata.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local ItemUserdata = require "ItsyScape.Game.ItemUserdata"

local ItemIngredientsUserdata = Class(ItemUserdata)

function ItemIngredientsUserdata:new(...)
	ItemUserdata.new(self, ...)

	self.ingredients = {}
end

function ItemIngredientsUserdata:addIngredient(resource, ingredient, count)
	local hasIngredient = false

	for i = 1, #self.ingredients do
		if self.ingredients[i].resource == resource then
			hasIngredient = true
			self.ingredients[i].value = self.ingredients[i].value + math.max(count, 0)
			break
		end
	end

	if not hasIngredient then
		table.insert(self.ingredients, { name = ingredient, value = count, resource = resource })
	end

	self:_sortIngredients()
end

function ItemIngredientsUserdata:_sortIngredients()
	table.sort(self.ingredients, function(a, b)
		if a.value < b.value then
			return true
		elseif a.value == b.value then
			return a.resource < b.resource
		end

		return false
	end)
end

function ItemIngredientsUserdata:hasIngredient(resource)
	for i = 1, #self.ingredients do
		if self.ingredients[i].resource == resource then
			return true
		end
	end

	return false
end

function ItemIngredientsUserdata:iterateIngredients()
	return pairs(self.ingredients)
end

function ItemIngredientsUserdata:getDescription()
	if not next(self.ingredients) then
		return nil
	end

	local result = {}
	for _, ingredient in self:iterateIngredients() do
		if ingredient.value <= 1 then
			table.insert(result, self:buildDescription("Message_ItemIngredientsUserdata_Single", ingredient.name))
		else
			table.insert(result, self:buildDescription("Message_ItemIngredientsUserdata_Multiple", ingredient.value, ingredient.name))
		end
	end

	table.sort(result)
	return self:buildDescription("Message_ItemIngredientsUserdata_Prefix", table.concat(result, ", "))
end

function ItemIngredientsUserdata:combine(otherUserdata)
	if otherUserdata:getType() ~= self:getType() then
		return false
	end

	for _, ingredient in otherUserdata:iterateIngredients() do
		self:addIngredient(ingredient.resource, ingredient.name, ingredient.value)
	end

	return true
end

function ItemIngredientsUserdata:serialize()
	return self.ingredients
end

function ItemIngredientsUserdata:deserialize(data)
	self.ingredients = data
	self:_sortIngredients()
end

return ItemIngredientsUserdata
