--------------------------------------------------------------------------------
-- Resources/Peeps/Props/BasicPointLight.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local BasicLight = require "Resources.Game.Peeps.Props.BasicLight"

local BasicPointLight = Class(BasicLight)

function BasicPointLight:new(...)
	BasicLight.new(self, ...)

	self.attenuation = 2
	self.global = false
end 

function BasicPointLight:ready(director, game)
	BasicLight.ready(self, director, game)

	local resource = Utility.Peep.getMapObject(self)
	if resource then
		local gameDB = director:getGameDB()
		local light = gameDB:getRecord("PointLight", {
			Resource = resource
		})

		self.attenuation = light:get("Attenuation") or 2
	end
end

function BasicPointLight:getPropState()
	local result = BasicLight.getPropState(self)
	result.attenuation = self.attenuation

	return result
end

return BasicPointLight
