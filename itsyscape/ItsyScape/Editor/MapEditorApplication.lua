--------------------------------------------------------------------------------
-- ItsyScape/Editor/EditorApplication.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local EditorApplication = require "ItsyScape.Editor.EditorApplication"
local NewMapInterface = require "ItsyScape.Editor.Map.NewMapInterface"
local MapMotion = require "ItsyScape.World.MapMotion"

local MapEditorApplication = Class(EditorApplication)
function MapEditorApplication:new()
	EditorApplication.new(self)

	self.motion = false
end

function MapEditorApplication:initialize()
	EditorApplication.initialize(self)

	local newMapInterface = NewMapInterface(self)
	self:getUIView():getRoot():addChild(newMapInterface)
end

function MapEditorApplication:mousePress(x, y, button)
	if not EditorApplication.mousePress(self, x, y, button) then
		if button == 1 then
			self.motion = MapMotion(self:getGame():getStage():getMap(1))
			self.motion:onMousePressed({
				x = x,
				y = y,
				button = button,
				ray = self:shoot(x, y)
			})
		end
	end
end

function MapEditorApplication:mouseMove(x, y, dx, dy)
	if not EditorApplication.mouseMove(self, x, y, dx, dy) then
		if self.motion then
			local r = self.motion:onMouseMoved({
				x = x,
				y = y,
				button = button,
				ray = self:shoot(x, y)
			})

			if r then
				self:getGame():getStage():updateMap(1)
			end
		end
	end
end

function MapEditorApplication:mouseRelease(x, y, button)
	if not EditorApplication.mouseRelease(self, x, y, button) then
		if button == 1 and self.motion then
			self.motion:onMouseReleased({
				x = x,
				y = y,
				button = button,
				ray = self:shoot(x, y)
			})
			self.motion = false
		end
	end
end

return MapEditorApplication
