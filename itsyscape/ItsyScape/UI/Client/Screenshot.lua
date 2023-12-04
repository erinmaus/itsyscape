--------------------------------------------------------------------------------
-- ItsyScape/UI/Client/Screenshot.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local TextureResource = require "ItsyScape.Graphics.TextureResource"
local Button = require "ItsyScape.UI.Button"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local Texture = require "ItsyScape.UI.Texture"
local Widget = require "ItsyScape.UI.Widget"

local Screenshot = Class(Widget)
Screenshot.WIDTH       = 480
Screenshot.HEIGHT      = 270
Screenshot.TEXT_HEIGHT = 64
Screenshot.PADDING     = 8

Screenshot.DURATION_IN_SECONDS = 2

function Screenshot:new(view, filename)
	Widget.new(self)

	do
		local success, result = xpcall(love.graphics.newImage, debug.traceback, filename)

		if not success then
			Log.warn("Couldn't load screenshot: %s", result)
		else
			self.screenshot = result
			self.screenshot:setFilter('linear', 'linear')
		end
	end

	self:setPosition(Screenshot.PADDING, Screenshot.PADDING)
	self:setSize(
		Screenshot.WIDTH + Screenshot.PADDING * 4,
		Screenshot.HEIGHT + Screenshot.PADDING * 5 + Screenshot.TEXT_HEIGHT)

	self.button = Button()
	self.button:setStyle(ButtonStyle({
		inactive = "Resources/Renderers/Widget/Panel/GenericNotification.9.png",
		hover = "Resources/Renderers/Widget/Panel/GenericNotification.9.png",
		pressed = "Resources/Renderers/Widget/Panel/GenericNotification.9.png"
	}, view:getResources()))
	self.button:setSize(
		Screenshot.WIDTH + Screenshot.PADDING * 2,
		Screenshot.HEIGHT + Screenshot.PADDING * 3 + Screenshot.TEXT_HEIGHT)
	self.button:setPosition(Screenshot.PADDING, Screenshot.PADDING)
	self.button.onClick:register(self.onShowFolder, self)
	self:addChild(self.button)

	self.texture = Texture()
	self.texture:setSize(Screenshot.WIDTH, Screenshot.HEIGHT)
	self.texture:setPosition(Screenshot.PADDING, Screenshot.PADDING)
	if self.screenshot then
		self.texture:setTexture(TextureResource(self.screenshot))
	end
	self.button:addChild(self.texture)

	self.text = Label()
	self.text:setStyle(LabelStyle({
		font = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
		fontSize = 22,
		textShadow = true,
		width = Screenshot.WIDTH,
		align = 'center'
	}, view:getResources()))
	self.text:setPosition(
		Screenshot.PADDING,
		Screenshot.HEIGHT + Screenshot.PADDING * 5)
	self.text:setText("Took screenshot! Click here to open!")
	self.button:addChild(self.text)

	self.time = Screenshot.DURATION_IN_SECONDS
end

function Screenshot:isReady()
	return self.screenshot ~= nil
end

function Screenshot:onShowFolder()
	love.system.openURL("file://" .. love.filesystem.getSaveDirectory())
end

function Screenshot:update(delta)
	Widget.update(self, delta)

	self.time = self.time - delta
	if self.time < 0 then
		local parent = self:getParent()
		if parent then
			parent:removeChild(self)
		end
	end
end

return Screenshot
