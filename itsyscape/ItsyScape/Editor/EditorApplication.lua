--------------------------------------------------------------------------------
-- ItsyScape/Editor/EditorApplication.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Application = require "ItsyScape.Application"
local Class = require "ItsyScape.Common.Class"

local EditorApplication = Class(Application)
function EditorApplication:new()
	Application.new(self)

	self.isCameraDragging = false
end

function EditorApplication:initialize()
	self:getGame():getStage():newMap(1, 1, 1)
end

function EditorApplication:mousePress(x, y, button)
	if not Application.mousePress(self, x, y, button) then
		local isShiftDown = love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift")
		if button == 1 and isShiftDown then
			self:probe(x, y, true)
		elseif button == 2 and isShiftDown then
			self:probe(x, y, false)
		elseif button == 3 then
			self.isCameraDragging = true
		end
	end
end

function EditorApplication:mouseRelease(x, y, button)
	Application.mouseRelease(self, x, y, button)

	if button == 3 then
		self.isCameraDragging = false
	end
end

function EditorApplication:mouseScroll(x, y)
	Application.mouseScroll(self, x, y)
	local distance = self.camera:getDistance() - y * 0.5
	self:getCamera():setDistance(math.min(math.max(distance, 1), 40))
end

function EditorApplication:mouseMove(x, y, dx, dy)
	Application.mouseMove(self, x, y, dx, dy)

	if self.isCameraDragging then
		local angle1 = dx / 128
		local angle2 = -dy / 128
		self:getCamera():setVerticalRotation(
			self:getCamera():getVerticalRotation() + angle1)
		self:getCamera():setHorizontalRotation(
			self:getCamera():getHorizontalRotation() + angle2)
	end
end

return EditorApplication
