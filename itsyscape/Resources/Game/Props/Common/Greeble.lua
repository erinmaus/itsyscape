--------------------------------------------------------------------------------
-- Resources/Game/Props/Common/Greeble/Greeble.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local PropView = require "ItsyScape.Graphics.PropView"

local Greeble = Class(PropView)

function Greeble:greebilize(parent, t, ...)
	self.parentPropView = parent

	if not t then
		return
	end

	local Type = self:getType()
	for key, value in pairs(t) do
		if Type[key] ~= nil and key:match("[A-Z][0-9A-Z_]*") then
			local isSameLuaType = type(value) == type(Type[key]) and not (type(value) == "table" and getmetatable(value) ~= nil)
			local valueClassType, typeClassType = Class.getType(value), Class.getType(Type[key])
			local isSameType = type(value) == "table" and Class.isDerived(valueClassType, typeClassType)
			assert(isSameLuaType or isSameType, string.format("%s is not the same Lua type or Class", key))

			self[key] = value
		end
	end
end

function Greeble:updateTransform()
	-- We want to basically just attach to the parent prop view.
	-- We don't want to do any of the stuff the base method does
	-- (apply transforms from prop, attach to map scene node).
	if self.parentPropView then
		self:getRoot():setParent(self.parentPropView:getRoot())
	end

	if self:getIsStatic() then
		self:getRoot():tick()
	end
end

return Greeble
