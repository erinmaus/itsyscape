--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/VideoTutorial.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Color = require "ItsyScape.Graphics.Color"
local Decoration = require "ItsyScape.Graphics.Decoration"
local StaticMesh = require "ItsyScape.Graphics.StaticMesh"
local DecorationSceneNode = require "ItsyScape.Graphics.DecorationSceneNode"
local ThirdPersonCamera = require "ItsyScape.Graphics.ThirdPersonCamera"
local Video = require "ItsyScape.Graphics.Video"
local TextureResource = require "ItsyScape.Graphics.TextureResource"
local Drawable = require "ItsyScape.UI.Drawable"
local Interface = require "ItsyScape.UI.Interface"
local Button = require "ItsyScape.UI.Button"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local SceneSnippet = require "ItsyScape.UI.SceneSnippet"
local Texture = require "ItsyScape.UI.Texture"
local ToolTip = require "ItsyScape.UI.ToolTip"
local Widget = require "ItsyScape.UI.Widget"

local VideoTutorial = Class(Interface)
VideoTutorial.BUTTON_STYLE = {
	pressed = "Resources/Renderers/Widget/Button/VideoTutorial-Pressed.9.png",
	inactive = "Resources/Renderers/Widget/Button/VideoTutorial-Inactive.9.png",
	hover = "Resources/Renderers/Widget/Button/VideoTutorial-Hover.9.png",
	color = { 1, 1, 1, 1 },
	font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Regular.ttf",
	fontSize = 24,
	textShadow = true,
	padding = 4
}
VideoTutorial.INVISIBLE_BUTTON_STYLE = {
	inactive = false,
	hover = false,
	pressed = false
}
VideoTutorial.TEXT_STYLE = function(width)
	return {
		font = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
		fontSize = 32,
		textShadow = true,
		width = width,
	}
end

VideoTutorial.BUTTON_WIDTH = 128
VideoTutorial.BUTTON_HEIGHT = 48
VideoTutorial.PADDING = 8

VideoTutorial.Pageinator = Class(Drawable)
VideoTutorial.Pageinator.PADDING = 4
VideoTutorial.Pageinator.INACTIVE_COLOR = Color(0.5, 0.5, 0.5, 0.5)
VideoTutorial.Pageinator.ACTIVE_COLOR = Color(1.0, 1.0, 1.0, 0.5)

function VideoTutorial.Pageinator:new()
	Drawable.new(self)

	self.count = 1
	self.current = 1
end

function VideoTutorial.Pageinator:getCount()
	return self.count
end

function VideoTutorial.Pageinator:setCount(value)
	self.count = value or self.count
end

function VideoTutorial.Pageinator:getCurrent()
	return self.current
end

function VideoTutorial.Pageinator:setCurrent(value)
	value = value or self.current
	self.current = math.min(math.max(value, 1), self.count)
end

function VideoTutorial.Pageinator:draw()
	local width, height = self:getSize()

	local radius
	do
		local c = math.floor(width / self.count)
		if c < height then
			radius = c / 4
		else
			radius = height / 4
		end
	end

	local actualWidth = (radius * 2) * self.count + self.PADDING * (self.count - 1)

	local x = width / 2 - actualWidth / 2
	local y = height / 2 - radius

	for i = 1, self.count do
		if i == self.current then
			love.graphics.setColor(self.ACTIVE_COLOR:get())
		else
			love.graphics.setColor(self.INACTIVE_COLOR:get())
		end

		love.graphics.circle('fill', x, y, radius)
		x = x + radius * 2 + self.PADDING
	end
	love.graphics.setColor(1, 1, 1, 1)
end

function VideoTutorial:new(id, index, ui)
	Interface.new(self, id, index, ui)

	local w, h = love.graphics.getScaledMode()
	self:setSize(w, h)

	self.panel = Panel()
	self.panel:setSize(w, h)
	self.panel:setStyle(PanelStyle({
		image = "Resources/Renderers/Widget/Panel/TipNotification.9.png"
	}, ui:getResources()))
	self:addChild(self.panel)

	self:setZDepth(math.huge)

	local videoWidth = w / 2
	local textWidth = w - videoWidth - VideoTutorial.BUTTON_HEIGHT - VideoTutorial.PADDING
	self.text = Label()
	self.text:setStyle(LabelStyle(
		VideoTutorial.TEXT_STYLE(textWidth - VideoTutorial.PADDING),
		ui:getResources()))
	self.text:setText("Lorem ipsum...")
	self.text:setSize(textWidth - VideoTutorial.PADDING, h)
	self.text:setPosition(videoWidth, VideoTutorial.PADDING)
	self.text:setZDepth(10)
	self.panel:addChild(self.text)

	self.pageinator = VideoTutorial.Pageinator()
	self.pageinator:setPosition(
		VideoTutorial.PADDING,
		h - VideoTutorial.BUTTON_HEIGHT - VideoTutorial.PADDING)
	self.pageinator:setSize(
		w - VideoTutorial.PADDING * 2,
		VideoTutorial.BUTTON_HEIGHT)
	self.panel:addChild(self.pageinator)

	self.video = Video()
	self.video.onVideoFinished:register(function()
		self.video:rewind()
	end)

	local mesh = StaticMesh("Resources/Game/Props/TV/Model.lstatic")
	local texture = TextureResource()
	do
		texture:loadFromFile("Resources/Game/Props/TV/Texture.png")
	end

	self.tvButton = Button()
	self.tvButton:setStyle(ButtonStyle(VideoTutorial.INVISIBLE_BUTTON_STYLE, ui:getResources()))
	self.tvButton:setSize(videoWidth, h)
	self.tvButton.onClick:register(self.showVideo, self, true)
	self.tvButton:setToolTip(
		ToolTip.Text("Click on the TV to see the video full screen."))
	self.panel:addChild(self.tvButton)

	self.tv = SceneSnippet()
	self.tv:setSize(videoWidth, videoWidth)
	self.tv:setPosition(0, h / 2 - videoWidth / 2)
	self.tvButton:addChild(self.tv)

	self.camera = ThirdPersonCamera()
	self.camera:setDistance(5)
	self.camera:setUp(Vector(0, -1, 0))
	self.camera:setVerticalRotation(-math.pi / 2 + math.pi / 8)
	self.camera:setHorizontalRotation(-math.pi / 6)

	self.tv:setCamera(self.camera)

	self.closeVideoButton = Button()
	self.closeVideoButton:setText("X")
	self.closeVideoButton:setPosition(
		w - VideoTutorial.BUTTON_HEIGHT - VideoTutorial.PADDING,
		VideoTutorial.PADDING)
	self.closeVideoButton:setStyle(ButtonStyle(VideoTutorial.BUTTON_STYLE, ui:getResources()))
	self.closeVideoButton:setSize(VideoTutorial.BUTTON_HEIGHT, VideoTutorial.BUTTON_HEIGHT)
	self.closeVideoButton.onClick:register(self.showVideo, self, false)

	self.fullScreenVideo = Texture()
	self.fullScreenVideo:setSize(w, h)
	self.fullScreenVideo:setZDepth(20)
	self.fullScreenVideo:addChild(self.closeVideoButton)

	self.videoBody = DecorationSceneNode()
	do
		local decoration = Decoration({ { id = "TV" }})
		self.videoBody:fromDecoration(decoration, mesh)
		self.videoBody:getMaterial():setTextures(texture)
		self.videoBody:setParent(self.tv:getRoot())
	end

	self.videoScreen = DecorationSceneNode()
	do
		local decoration = Decoration({ { id = "TVScreen" } })
		self.videoScreen:fromDecoration(decoration, mesh)
		self.videoScreen:setParent(self.tv:getRoot())
	end

	self.closeButton = Button()
	self.closeButton:setZDepth(15)
	self.closeButton:setPosition(
		w - VideoTutorial.BUTTON_HEIGHT - VideoTutorial.PADDING,
		VideoTutorial.PADDING)
	self.closeButton:setText("X")
	self.closeButton:setStyle(ButtonStyle(VideoTutorial.BUTTON_STYLE, ui:getResources()))
	self.closeButton:setSize(VideoTutorial.BUTTON_HEIGHT, VideoTutorial.BUTTON_HEIGHT)
	self.closeButton.onClick:register(function()
		self:sendPoke("close", nil, {})
	end)
	self.panel:addChild(self.closeButton)

	self.nextButton = Button()
	self.nextButton:setZDepth(10)
	self.nextButton:setStyle(ButtonStyle(VideoTutorial.BUTTON_STYLE, ui:getResources()))
	self.nextButton:setText("NEXT >")
	self.nextButton:setSize(VideoTutorial.BUTTON_WIDTH, VideoTutorial.BUTTON_HEIGHT)
	self.nextButton:setPosition(
		w - VideoTutorial.BUTTON_WIDTH - VideoTutorial.PADDING,
		h - VideoTutorial.BUTTON_HEIGHT - VideoTutorial.PADDING)
	self.nextButton.onClick:register(self.next, self, 1)
	self.panel:addChild(self.nextButton)

	self.previousButton = Button()
	self.previousButton:setZDepth(10)
	self.previousButton:setStyle(ButtonStyle(VideoTutorial.BUTTON_STYLE, ui:getResources()))
	self.previousButton:setText("< PREV")
	self.previousButton:setSize(VideoTutorial.BUTTON_WIDTH, VideoTutorial.BUTTON_HEIGHT)
	self.previousButton:setPosition(
		VideoTutorial.PADDING,
		h - VideoTutorial.BUTTON_HEIGHT - VideoTutorial.PADDING)
	self.previousButton.onClick:register(self.next, self, -1)
	self.panel:addChild(self.previousButton)

	self.current = 1
	self:next(0)
end

function VideoTutorial:next(offset)
	local state = self:getState()

	self.current = self.current + offset
	if self.current < 0 then
		self.current = #state.pages
	elseif self.current > #state.pages then
		self.current = 1
	end

	self.pageinator:setCount(#state.pages)
	self.pageinator:setCurrent(self.current)

	local page = state.pages[self.current]
	if page then
		self.video:loadFromFile(page.video)
		self.video:play()

		self.texture = TextureResource(self.video:getSnapshot())
		self.videoScreen:getMaterial():setTextures(self.texture)
		self.text:setText(page.text)
	end
end

function VideoTutorial:getIsFocusable()
	return true
end

function VideoTutorial:showVideo(toggle)
	if toggle then
		self.fullScreenVideo:setTexture(self.texture)
		self.fullScreenVideo:setKeepAspect(false)
		self:addChild(self.fullScreenVideo)
	else
		self:removeChild(self.fullScreenVideo)
	end
end

function VideoTutorial:update(...)
	Interface.update(self, ...)

	self.video:update()
	self.video:makeSnapshot()
end

return VideoTutorial
