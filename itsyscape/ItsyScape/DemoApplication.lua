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
local Utility = require "ItsyScape.Game.Utility"
local Color = require "ItsyScape.Graphics.Color"
local CameraController = require "ItsyScape.Graphics.CameraController"
local DefaultCameraController = require "ItsyScape.Graphics.DefaultCameraController"
local Renderer = require "ItsyScape.Graphics.Renderer"
local ThirdPersonCamera = require "ItsyScape.Graphics.ThirdPersonCamera"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local ToolTip = require "ItsyScape.UI.ToolTip"
local Widget = require "ItsyScape.UI.Widget"
local PlayerSelect = require "ItsyScape.UI.Client.PlayerSelect"
local AlertWindow = require "ItsyScape.Editor.Common.AlertWindow"

local DemoApplication = Class(Application)
DemoApplication.CAMERA_HORIZONTAL_ROTATION = -math.pi / 6
DemoApplication.CAMERA_VERTICAL_ROTATION = -math.pi / 2
DemoApplication.MAX_CAMERA_VERTICAL_ROTATION_OFFSET = math.pi / 4
DemoApplication.MAX_CAMERA_HORIZONTAL_ROTATION_OFFSET = math.pi / 6 - math.pi / 12
DemoApplication.PROBE_TICK = 1 / 10

function DemoApplication:new()
	Application.new(self)

	self.previousPlayerPosition = false
	self.currentPlayerPosition = false

	self.showingToolTip = false
	self.lastToolTipObject = false
	self.toolTipTick = math.huge
	self.mouseMoved = false
	self.mouseX, self.mouseY = math.huge, math.huge

	self.cameraController = DefaultCameraController(self)
	self:getGame():getPlayer().onChangeCamera:register(self.changeCamera, self)
end

function DemoApplication:changeCamera(_, cameraType)
	local typeName = string.format("ItsyScape.Graphics.%sCameraController", cameraType)
	local s, r = pcall(require, typeName)

	if not s then
		Log.error("Could not load camera type '%s': %s", s, r)
	else
		self.cameraController = r(self)
	end
end

function DemoApplication:initialize()
	Application.initialize(self)

	love.audio.setDistanceModel('linear')

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
	Utility.UI.openGroup(playerPeep, Utility.UI.Groups.WORLD)
end

function DemoApplication:openTitleScreen()
	self:setIsPaused(true)
	local TitleScreen = require "Resources.Game.TitleScreens.IsabelleIsland.Title"
	self.titleScreen = TitleScreen(self:getGameView(), "IsabelleIsland")

	self:getGameView():playMusic('main', "IsabelleIsland")
end

function DemoApplication:quit()
	if not self.titleScreen then
		self:getGame():quit()
		return true
	else
		return false
	end
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

		if _ANALYTICS and not _ANALYTICS:getAcked() then
			local WIDTH = 480
			local HEIGHT = 240
			local alertWindow = AlertWindow(self)
			alertWindow:open(
				"ItsyRealm collects anonymous analytics about things like how far you progress. " ..
				"You can opt-out any time by using the Configure ItsyRealm shortcut created by the launcher. " ..
				"Any analytics collected, assuming you opt-out, will be deleted.",
				"A Boring Disclaimer",
				WIDTH,
				HEIGHT)
			alertWindow.onSubmit:register(function()
				if _ANALYTICS then
					_ANALYTICS:ack()
				end
			end)
		end
	else
		local isUIACtive = Application.mousePress(self, x, y, button)
		local probeAction = self.cameraController:mousePress(isUIACtive, x, y, button)
		if probeAction == CameraController.PROBE_SELECT_DEFAULT then
			self:probe(x, y, true)
		elseif probeAction == CameraController.PROBE_CHOOSE_OPTION then
			self:probe(x, y, false, function(probe) self.uiView:probe(probe:toArray()) end)
		end
	end
end

function DemoApplication:mouseRelease(x, y, button)
	local isUIActive = Application.mouseRelease(self, x, y, button)

	local probeAction = self.cameraController:mouseRelease(isUIACtive, x, y, button)
	if probeAction == CameraController.PROBE_SELECT_DEFAULT then
		self:probe(x, y, true)
	elseif probeAction == CameraController.PROBE_CHOOSE_OPTION then
		self:probe(x, y, false, function(probe) self.uiView:probe(probe:toArray()) end)
	end
end

function DemoApplication:mouseScroll(x, y)
	local isUIACtive = Application.mouseScroll(self, x, y)

	self.cameraController:mouseScroll(isUIACtive, x, y)
end

function DemoApplication:mouseMove(x, y, dx, dy)
	local isUIACtive = Application.mouseMove(self, x, y, dx, dy)

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

	self.cameraController:mouseMove(isUIACtive, x, y, dx, dy)
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

function DemoApplication:updatePlayerMovement()
	local player = self:getGame():getPlayer()
	local up = love.keyboard.isDown('w')
	local down = love.keyboard.isDown('s')
	local left = love.keyboard.isDown('a')
	local right = love.keyboard.isDown('d')

	local x, z = 0, 0
	do
		if up then
			z = z - 1
		end

		if down then
			z = z + 1
		end

		if left then
			x = x - 1
		end

		if right then
			x = x + 1
		end
	end

	local focusedWidget = self:getUIView():getInputProvider():getFocusedWidget()
	if not focusedWidget or
	   not focusedWidget:isCompatibleType(require "ItsyScape.UI.TextInput")
	then
		player:move(x, z)
	else
		player:move(0, 0)
	end
end

function DemoApplication:update(delta)
	Application.update(self, delta)

	self:updatePlayerMovement()

	self.toolTipTick = self.toolTipTick - delta
	if self.mouseMoved and self.toolTipTick < 0 then
		self:probe(self.mouseX, self.mouseY, false, function(probe)
			local action = probe:toArray()[1]
			local renderer = self:getUIView():getRenderManager()
			if action and (action.type ~= 'examine' and not action.suppress) then
				local text = string.format("%s %s", action.verb, action.object)
				self.showingToolTip = true
				if self.lastToolTipObject ~= action.id then
					self.toolTip = {
						ToolTip.Header(text),
						ToolTip.Text(action.description)
					}
					self.lastToolTipObject = action.id
				end
			else
				if renderer:getToolTip() == self.toolTipWidget then
					renderer:unsetToolTip()
					self.toolTip = nil
					self.showingToolTip = false
					self.lastToolTipObject = false
				end
			end
		end, { ['actors'] = true, ['props'] = true })

		self.mouseMoved = false
		self.toolTipTick = DemoApplication.PROBE_TICK
	end

	if self.showingToolTip then
		local renderer = self:getUIView():getRenderManager()
		self.toolTipWidget = renderer:setToolTip(
			math.huge,
			unpack(self.toolTip))
	end

	if self.titleScreen then
		self.titleScreen:update(delta)
	end

	self.cameraController:update(delta)
end

function DemoApplication:draw(delta)
	self.cameraController:draw()

	if self.titleScreen then
		self.titleScreen:draw()

		self:getUIView():draw()
	else
		Application.draw(self, delta)
	end
end

return DemoApplication
