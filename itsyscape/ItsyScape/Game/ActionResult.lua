--------------------------------------------------------------------------------
-- ItsyScape/Game/Spell.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Curve = require "ItsyScape.Game.Curve"
local Utility = require "ItsyScape.Game.Utility"

local ActionResult = Class()

function ActionResult:new(gameDB)
	self.gameDB = gameDB
	self.resources = {}
	self.failed = {}
	self.success = true
end

function ActionResult:good()
	return self.success
end

function ActionResult:bad()
	return not self:good()
end

function ActionResult:fail()
	self.success = false
end

-- "text" is a special callback that prints something. It accepts two arguments:
-- 'count' and 'name', where count is the required amount and name is the name
-- of the missing resource. The default one isn't very good.
function ActionResult:addMissing(resource, count, text)
	text = text or function(name, count)
		return string.format("You need %d %s(s) to do that.", count, name)
	end

	table.insert(self.resources, {
		resource = resource,
		resourceType = self.gameDB:getBrochure():getResourceTypeFromResource(resource),
		count = count,
		text = text
	})

	self.success = false
end

function ActionResult:getMessage(lang)
	local result = {}
	for i = 1, #self.resources do
		local r = self.resources[i]
		local name = Utility.getName(r.resource, self.gameDB, lang)
		if not name then
			name = "*" .. r.resource.name
		end

		local count
		if r.resourceType.name == "Skill" then
			count = Curve.XP_CURVE:getLevel(r.count)
		else
			count = r.count
		end

		local text = r.text(name, count)
		if text then
			table.insert(result)
		end
	end

	return table.concat(result, "\n")
end

return ActionResult