--------------------------------------------------------------------------------
-- ItsyScape/DemoApplication.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Application = require "ItsyScape.Application"
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Color = require "ItsyScape.Graphics.Color"
local Renderer = require "ItsyScape.Graphics.Renderer"
local ThirdPersonCamera = require "ItsyScape.Graphics.ThirdPersonCamera"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local ToolTip = require "ItsyScape.UI.ToolTip"
local Widget = require "ItsyScape.UI.Widget"
local PlayerSelect = require "ItsyScape.UI.Client.PlayerSelect"

local DemoApplication = Class(Application)
DemoApplication.CAMERA_HORIZONTAL_ROTATION = -math.pi / 6
DemoApplication.CAMERA_VERTICAL_ROTATION = -math.pi / 2
DemoApplication.MAX_CAMERA_VERTICAL_ROTATION_OFFSET = math.pi / 4
DemoApplication.MAX_CAMERA_HORIZONTAL_ROTATION_OFFSET = math.pi / 6 - math.pi / 12
DemoApplication.PROBE_TICK = 1 / 10

function DemoApplication:new()
	Application.new(self)

	self.isCameraDragging = false
	self.cameraVerticalRotationOffset = 0
	self.cameraHorizontalRotationOffset = 0

	self.previousPlayerPosition = false
	self.currentPlayerPosition = false

	self:getCamera():setHorizontalRotation(DemoApplication.CAMERA_HORIZONTAL_ROTATION)
	self:getCamera():setVerticalRotation(DemoApplication.CAMERA_VERTICAL_ROTATION)

	self.showingToolTip = false
	self.toolTipTick = math.huge
	self.mouseMoved = false
	self.mouseX, self.mouseY = math.huge, math.huge
end

function DemoApplication:getPlayerPosition(delta)
	local position
	do
		local gameView = self:getGameView()
		local actor = gameView:getActor(self:getGame():getPlayer():getActor())
		if actor then
			local node = actor:getSceneNode()
			local transform = node:getTransform():getGlobalDeltaTransform(delta or 0)
			position = Vector(transform:transformPoint(0, 1, 0))
		end
	end

	return position
end

function DemoApplication:initialize()
	Application.initialize(self)

	self:openTitleScreen()
end

function DemoApplication:closeTitleScreen()
	self:setIsPaused(false)

	if self.mainMenu then
		self.mainMenu:getParent():removeChild(self.mainMenu)
		self.mainMenu = nil
	end

	if self.titleScreen then
		self.titleScreen = nil
	end

	local playerPeep = self:getGame():getPlayer():getActor():getPeep()
	self:getGame():getUI():open(playerPeep, "Ribbon")
	self:getGame():getUI():open(playerPeep, "CombatStatusHUD")
end

function DemoApplication:openTitleScreen()
	self:setIsPaused(true)
	local TitleScreen = require "Resources.Game.TitleScreens.IsabelleIsland.Title"
	self.titleScreen = TitleScreen(self:getGameView(), "IsabelleIsland")
end

function DemoApplication:quitGame()
	self:openTitleScreen()
end

function DemoApplication:mousePress(x, y, button)
	if self.titleScreen and not self.mainMenu then
		local mainMenu = Widget()
		mainMenu:setSize(love.window.getMode())

		self.mainMenu = mainMenu
		self.mainMenu:addChild(PlayerSelect(self))

		self.titleScreen:suppressTitle()

		self:getUIView():getRoot():addChild(self.mainMenu)
	else
		if not Application.mousePress(self, x, y, button) then
			if button == 1 then
				self:probe(x, y, true)
			elseif button == 2 then
				self:probe(x, y, false, function(probe) self.uiView:probe(probe:toArray()) end)
			elseif button == 3 then
				self.isCameraDragging = true
			end
		end
	end
end

function DemoApplication:mouseRelease(x, y, button)
	Application.mouseRelease(self, x, y, button)

	if button == 3 then
		self.isCameraDragging = false
	end
end

function DemoApplication:mouseScroll(x, y)
	if not Application.mouseScroll(self, x, y) then
		local distance = self.camera:getDistance() - y * 0.5

		if not _DEBUG then
			self:getCamera():setDistance(math.min(math.max(distance, 1), 40))
		else
			self:getCamera():setDistance(distance)
		end
	end
end

function DemoApplication:mouseMove(x, y, dx, dy)
	Application.mouseMove(self, x, y, dx, dy)

	self.mouseX = x
	self.mouseY = y

	if not self:getUIView():getInputProvider():isBlocking(love.mouse.getPosition()) then
		self.mouseMoved = true
		self.toolTipTick = math.min(self.toolTipTick, DemoApplication.PROBE_TICK)
	else
		if self.showingToolTip then
			self.showingToolTip = false
			local renderer = self:getUIView():getRenderManager()
			renderer:unsetToolTip()
		end
	end

	if self.isCameraDragging then
		local angle1 = self.cameraVerticalRotationOffset + dx / 128
		local angle2 = self.cameraHorizontalRotationOffset + -dy / 128

		if not _DEBUG then
			angle1 = math.max(
				angle1,
				-DemoApplication.MAX_CAMERA_VERTICAL_ROTATION_OFFSET)
			angle1 = math.min(
				angle1,
				DemoApplication.MAX_CAMERA_VERTICAL_ROTATION_OFFSET)
			angle2 = math.max(
				angle2,
				-DemoApplication.MAX_CAMERA_HORIZONTAL_ROTATION_OFFSET)
			angle2 = math.min(
				angle2,
				DemoApplication.MAX_CAMERA_HORIZONTAL_ROTATION_OFFSET)
		end

		self:getCamera():setVerticalRotation(
			DemoApplication.CAMERA_VERTICAL_ROTATION + angle1)
		self:getCamera():setHorizontalRotation(
			DemoApplication.CAMERA_HORIZONTAL_ROTATION + angle2)

		self.cameraVerticalRotationOffset = angle1
		self.cameraHorizontalRotationOffset = angle2
	end
end

function DemoApplication:keyDown(key, ...)
	Application.keyDown(self, key, ...)

	local isShiftDown = love.keyboard.isDown('lshift') or
	                    love.keyboard.isDown('rshift')

	local isCtrlDown = love.keyboard.isDown('lctrl') or
	                    love.keyboard.isDown('rctrl')

	if key == 'printscreen' and isCtrlDown then
		self:snapshotPlayerPeep()
	elseif key == 'printscreen' and isShiftDown then
		self:snapshotGame()
	end
end

function DemoApplication:getScreenshotName(prefix, index)
	local suffix = os.date("%Y-%m-%d %H%M%S")

	local filename
	if index then
		filename = string.format("%s %s %03d.png", prefix, suffix, index)
	else
		filename = string.format("%s %s.png", prefix, suffix)
	end

	return filename
end

function DemoApplication:snapshotPlayerPeep()
	local actors
	if _DEBUG then
		actors = {}
		for actor in self:getGame():getStage():iterateActors() do
			table.insert(actors, actor)
		end
	else
		actors = { self:getGame():getPlayer():getActor() }
	end

	local renderer = Renderer()
	love.graphics.push('all')
	do
		local camera = ThirdPersonCamera()
		local gameCamera = self:getCamera()
		camera:setHorizontalRotation(gameCamera:getHorizontalRotation())
		camera:setVerticalRotation(gameCamera:getVerticalRotation())
		camera:setWidth(1024)
		camera:setHeight(1024)

		local renderer = Renderer()
		love.graphics.setScissor()
		renderer:setClearColor(Color(0, 0, 0, 0))
		renderer:setCullEnabled(false)
		renderer:setCamera(camera)

		for index, actor in ipairs(actors) do
			local view = self:getGameView():getActor(actor)
			local zoom, position
			do
				local min, max = actor:getBounds()
				local offset = (max.y - min.y) / 2
				zoom = (max.z - min.z) + math.max((max.y - min.y), (max.x - min.x)) + 4

				local transform = view:getSceneNode():getTransform():getGlobalTransform()
				position = Vector(transform:transformPoint(0, offset, 0))
			end

			camera:setPosition(position)
			camera:setDistance(zoom)

			renderer:draw(view:getSceneNode(), self:getFrameDelta(), 1024, 1024)
			love.graphics.setCanvas()

			local imageData = renderer:getOutputBuffer():getColor():newImageData()
			imageData:encode('png', self:getScreenshotName("Peep", index))
		end
	end
	love.graphics.pop()
end

function DemoApplication:snapshotGame()
	love.graphics.push('all')
	do
		local camera = self:getCamera()
		local w, h = camera:getWidth(), camera:getHeight()

		camera:setWidth(1920)
		camera:setHeight(1080)

		local renderer = Renderer()

		love.graphics.setScissor()
		renderer:setClearColor(Color(0, 0, 0, 0))
		renderer:setCullEnabled(false)
		renderer:setCamera(camera)
		renderer:draw(self:getGameView():getScene(), self:getFrameDelta(), 1920, 1080)
		love.graphics.setCanvas()

		local imageData = renderer:getOutputBuffer():getColor():newImageData()
		imageData:encode('png', self:getScreenshotName("Screenshot"))

		camera:setWidth(w)
		camera:setHeight(h)
	end
	love.graphics.pop()
end

function DemoApplication:update(delta)
	Application.update(self, delta)

	self.toolTipTick = self.toolTipTick - delta
	if self.mouseMoved and self.toolTipTick < 0 then
		self:probe(self.mouseX, self.mouseY, false, function(probe)
			local action = probe:toArray()[1]
			local renderer = self:getUIView():getRenderManager()
			if action and action.type ~= 'examine' then
				local text = string.format("%s %s", action.verb, action.object)
				self.showingToolTip = true
				self.toolTip = {
					ToolTip.Header(text),
					ToolTip.Text(action.description)
				}
			else
				renderer:unsetToolTip()
				self.toolTip = nil
				self.showingToolTip = false
			end
		end, { ['actors'] = true, ['props'] = true })

		self.mouseMoved = false
		self.toolTipTick = DemoApplication.PROBE_TICK
	end

	if self.showingToolTip then
		local renderer = self:getUIView():getRenderManager()
		renderer:setToolTip(
			math.huge,
			unpack(self.toolTip))
	end

	if self.titleScreen then
		self.titleScreen:update(delta)
	end
end

function DemoApplication:draw(delta)
	local previous = self.previousPlayerPosition
	local current = self.currentPlayerPosition
	self:getCamera():setPosition(self:getPlayerPosition(self:getFrameDelta()))

	if self.titleScreen then
		self.titleScreen:draw()

		self:getUIView():draw()
	else
		Application.draw(self, delta)
	end
end

return DemoApplication
