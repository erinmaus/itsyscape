--------------------------------------------------------------------------------
-- ItsyScape/Editor/Map/NewMapInterface.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Button = require "ItsyScape.UI.Button"
local Panel = require "ItsyScape.UI.Panel"
local TextInput = require "ItsyScape.UI.TextInput"
local Widget = require "ItsyScape.UI.Widget"

local NewMapInterface = Class(Widget)
NewMapInterface.WIDTH = 320
NewMapInterface.HEIGHT = 240
function NewMapInterface:new(application)
	Widget.new(self)

	self.application = application

	local windowWidth, windowHeight = love.window.getMode()
	self:setPosition(
		windowWidth / 2 - NewMapInterface.WIDTH / 2,
		windowHeight / 2 - NewMapInterface.HEIGHT / 2)
	self:setSize(NewMapInterface.WIDTH, NewMapInterface.HEIGHT)

	local panel = Panel()
	panel:setSize(self:getSize())
	self:addChild(panel)

	self.widthInput = TextInput()
	self.widthInput:setPosition(NewMapInterface.WIDTH - 128 - 16, 16)
	self.widthInput:setSize(128, 32)
	self.widthInput:setText("32")
	self:addChild(self.widthInput)

	self.heightInput = TextInput()
	self.heightInput:setPosition(NewMapInterface.WIDTH - 128 - 16, 32 + 16 + 8)
	self.heightInput:setSize(128, 32)
	self.heightInput:setText("32")
	self:addChild(self.heightInput)

	self.tileSetIDInput = TextInput()
	self.tileSetIDInput:setPosition(NewMapInterface.WIDTH - 128 - 16, (32 + 8) * 2  + 16)
	self.tileSetIDInput:setSize(128, 32)
	self.tileSetIDInput:setText("GrassyPlain")
	self:addChild(self.tileSetIDInput)

	self.okButton = Button()
	self.okButton:setPosition(NewMapInterface.WIDTH - 128 - 16, NewMapInterface.HEIGHT - 64 - 16)
	self.okButton:setSize(128, 64)
	self.okButton.onClick:register(function()
		local stage = self.application:getGame():getStage()
		local width = tonumber(self.heightInput:getText())
		local height = tonumber(self.heightInput:getText())
		if width and height then
			stage:newMap(width, height, 1, self.tileSetIDInput:getText())
			local map = stage:getMap(1)
			if map then
				for j = 1, map:getHeight() do
					for i = 1, map:getWidth() do
						local tile = map:getTile(i, j)
						tile.flat = 1
						tile.edge = 2
						tile.topLeft = 1
						tile.topRight = 1
						tile.bottomLeft = 1
						tile.bottomRight = 1
					end
				end

				stage:updateMap(1)

				self.application:getUIView():getRoot():removeChild(self)
			end
		end
	end)
	self.okButton:setText("OK")
	self:addChild(self.okButton)

	self.cancelButton = Button()
	self.cancelButton:setPosition(
		NewMapInterface.WIDTH - 128 - 16 - 128 - 8,
		NewMapInterface.HEIGHT - 64 - 16)
	self.cancelButton:setSize(128, 64)
	self.cancelButton.onClick:register(function()
		self.application:getUIView():getRoot():removeChild(self)
	end)
	self.cancelButton:setText("Cancel")
	self:addChild(self.cancelButton)
end

return NewMapInterface
