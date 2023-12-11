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
local PlayerStorage = require "ItsyScape.Game.PlayerStorage"
local Utility = require "ItsyScape.Game.Utility"
local Color = require "ItsyScape.Graphics.Color"
local TitleScreen = require "ItsyScape.Graphics.TitleScreen"
local CameraController = require "ItsyScape.Graphics.CameraController"
local DefaultCameraController = require "ItsyScape.Graphics.DefaultCameraController"
local Renderer = require "ItsyScape.Graphics.Renderer"
local ThirdPersonCamera = require "ItsyScape.Graphics.ThirdPersonCamera"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local Button = require "ItsyScape.UI.Button"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local Keybinds = require "ItsyScape.UI.Keybinds"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local ToolTip = require "ItsyScape.UI.ToolTip"
local Widget = require "ItsyScape.UI.Widget"
local Controls = require "ItsyScape.UI.Client.Controls"
local GraphicsOptions = require "ItsyScape.UI.Client.GraphicsOptions"
local Screenshot = require "ItsyScape.UI.Client.Screenshot"
local Network = require "ItsyScape.UI.Client.Network"
local PlayerSelect = require "ItsyScape.UI.Client.PlayerSelect"
local Update = require "ItsyScape.UI.Client.Update"
local AlertWindow = require "ItsyScape.Editor.Common.AlertWindow"

local DemoApplication = Class(Application)
DemoApplication.CAMERA_HORIZONTAL_ROTATION = -math.pi / 6
DemoApplication.CAMERA_VERTICAL_ROTATION = -math.pi / 2
DemoApplication.MAX_CAMERA_VERTICAL_ROTATION_OFFSET = math.pi / 4
DemoApplication.MAX_CAMERA_HORIZONTAL_ROTATION_OFFSET = math.pi / 6 - math.pi / 12
DemoApplication.PROBE_TICK = 1 / 10
DemoApplication.TITLE_SCREENS = {
	"TitleScreen_EmptyRuins",
	"TitleScreen_RuinsOfRhysilk",
	"TitleScreen_ViziersRock",
	"TitleScreen_IsabelleIsland",
}

function DemoApplication:new()
	Application.new(self, true)

	self.previousPlayerPosition = false
	self.currentPlayerPosition = false

	self.showingToolTip = false
	self.lastToolTipObject = false
	self.toolTipTick = math.huge
	self.mouseMoved = false
	self.mouseX, self.mouseY = math.huge, math.huge

	self.patchNotesServiceInputChannel = love.thread.newChannel()
	self.patchNotesServiceOutputChannel = love.thread.newChannel()
	self.patchNotesServiceThread = love.thread.newThread("ItsyScape/Analytics/Threads/PatchNotesService.lua")
	self.patchNotesServiceThread:start(self.patchNotesServiceInputChannel, self.patchNotesServiceOutputChannel)

	self.touches = { current = {}, n = 1 }

	self.cameraController = DefaultCameraController(self)

	self:getGame().onReady:register(function(_, player)
		Log.info("Ready to play with player ID %d!", player:getID())

		player.onChangeCamera:register(self.changeCamera, self)
		player.onPokeCamera:register(self.pokeCamera, self)
		player.onSave:register(self.savePlayer, self)
		player.onMove:register(self.setMapName, self)

		if _MOBILE then
			player.onMove:register(self.requestSave, self)
		end

		self:setPlayerFilename(nil)

		self:getGameView():reset()
		self:tryOpenTitleScreen()

		self:play(player)
		self:setAdmin(player:getID())
	end)

	self:getGame().onQuit:register(function()
		self:quitPlayer(player)
	end)

	self:getGame()

	self:disconnect()

	if not _MOBILE then
		self.defaultCursor = love.mouse.newCursor("Resources/Game/UI/Cursor.png", 0, 0)

		local _, blankCursorImageData = self:getGameView():getTranslucentTexture()
		self.blankCursor = love.mouse.newCursor(blankCursorImageData, 0, 0)

		love.mouse.setCursor(self.defaultCursor)
	else
		self.mobileCursor = love.graphics.newImage("Resources/Game/UI/Cursor_Mobile.png")
	end

	self:initTitleScreen()
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

function DemoApplication:pokeCamera(_, event, ...)
	self.cameraController:poke(event, ...)
end

function DemoApplication:setPlayerFilename(value)
	self.playerFilename = value
end

function DemoApplication:savePlayer(_, storage, isError)
	Application.savePlayer(self, _, storage, isError)

	if not self.playerFilename then
		Log.info("Can't save player storage to file, player filename not set.")
		return
	end

	if isError then
		local backupFilename = self.playerFilename .. "." .. os.date("%Y%m%d_%H%M%S") .. ".bak"
		Log.info("Making a back up of existing save file to '%s'...", backupFilename)

		local backupData, e = love.filesystem.read(self.playerFilename)
		if not backupData then
			Log.warn("Couldn't read existing save file: %s", e)
		else
			local success, e = love.filesystem.write(backupFilename, backupData)
			if not success then
				Log.warn("Couldn't save back up of existing save file: %s", e)
			else
				Log.info("Back up success!")
			end
		end
	end

	love.filesystem.createDirectory("Player")
	Log.info("Saving player data to '%s'...", self.playerFilename)

	local result = storage:toString()
	love.filesystem.write(self.playerFilename, result)
	Log.info("Successfully saved player data.")
end

function DemoApplication:setMapName(_, _, map)
	self:updateMemoryLabel(map)
end

function DemoApplication:quitPlayer()
	Log.info("Player quit their session.")

	self:disconnect()
end

function DemoApplication:initialize()
	Application.initialize(self)

	love.audio.setDistanceModel('linear')

	self.pendingTitleScreenOpen = true
end

function DemoApplication:tickSingleThread()
	Application.tickSingleThread(self)
end

function DemoApplication:tickMultiThread()
	Application.tickMultiThread(self)
end

function DemoApplication:closeTitleScreen()
	self:setIsPaused(false)
	self.titleScreen = nil
	self.pendingTitleScreenOpen = true

	self:closeMainMenu()

	self:getGameView():playMusic('main', false)
	self:getGameView():playMusic('ambience', false)
end

function DemoApplication:tryOpenTitleScreen()
	if self.pendingTitleScreenOpen then
		self:openTitleScreen()
		self.pendingTitleScreenOpen = false
	end
end

function DemoApplication:initTitleScreen()
	if not self.titleScreen then
		self.titleScreen = TitleScreen(self:getGameView())
		self.titleScreen:load()
	end
end

function DemoApplication:openTitleScreen()
	self:setIsPaused(true)
	self:initTitleScreen()
	self.titleScreen:setIsApplicationReady(true)

	local mapName = DemoApplication.TITLE_SCREENS[math.random(#DemoApplication.TITLE_SCREENS)]

	local storage = PlayerStorage()
	storage:getRoot():set({
		Location = {
			x = 1,
			y = 0,
			z = 1,
			name = mapName or "TitleScreen_EmptyRuins",
			isTitleScreen = true
		}
	})

	self:getGame():getPlayer():spawn(storage, false, self:getPassword())

	self.patchNotesServiceInputChannel:push({ type = "update" })
end

function DemoApplication:quit(isError)
	local Resource = require "ItsyScape.Graphics.Resource"
	Resource.quit()

	self.patchNotesServiceInputChannel:push({ type = "quit" })
	self.patchNotesServiceThread:wait()

	local e = self.patchNotesServiceThread:getError()
	if e then
		Log.warn("Error quitting patch notes thread: %s", e)
	end

	Application.quit(self, isError)

	return false
end

function DemoApplication:quitGame()
	self:openTitleScreen()
end

function DemoApplication:closeMainMenu()
	if self.mainMenu then
		self.mainMenu:getParent():removeChild(self.mainMenu)
		self.mainMenu = nil
	end
end

function DemoApplication:openMainMenu()
	local mainMenu = Widget()
	mainMenu:setSize(love.graphics.getScaledMode())

	self.mainMenu = mainMenu
	self.mainMenu:addChild(PlayerSelect(self))

	local function BUTTON_STYLE(icon)
		return {
			pressed = "Resources/Renderers/Widget/Button/Default-Pressed.9.png",
			inactive = "Resources/Renderers/Widget/Button/Default-Inactive.9.png",
			hover = "Resources/Renderers/Widget/Button/Default-Hover.9.png",
			icon = {
				filename = icon,
				x = 0.5,
				y = 0.5
			}
		}
	end

	local BUTTON_SIZE = 64
	local PADDING = 8

	local w, h = love.graphics.getScaledMode()

	local graphicsOptionsButton = Button()
	graphicsOptionsButton:setStyle(ButtonStyle(
		BUTTON_STYLE("Resources/Game/UI/Icons/Concepts/Settings.png"),
		self:getUIView():getResources()))
	graphicsOptionsButton.onClick:register(function()
		self:openOptionsScreen(GraphicsOptions, function(value)
			if value then
				love.window.setMode(_CONF.width, _CONF.height, {
					fullscreen = _CONF.fullscreen,
					vsync = _CONF.vsync,
					display = _CONF.display
				})

				_DEBUG = _CONF.debug

				if _CONF.analytics ~= _ANALYTICS_ENABLED then
					if _CONF.analytics then
						Log.info("Analytics enabled.")
					else
						Log.info("Analytics disabled.")
					end

					self.inputAdminChannel:push({
						type = 'analytics',
						enable = _CONF.analytics
					})

					_ANALYTICS_ENABLED = _CONF.analytics
				end
				_CONF.analytics = nil

				itsyrealm.graphics.dirty()
				self:getGameView():dirty()
			end

			self:closeMainMenu()
			self:openMainMenu()
		end)
	end)
	graphicsOptionsButton:setPosition(
		w - BUTTON_SIZE - PADDING,
		h - BUTTON_SIZE - PADDING)
	graphicsOptionsButton:setSize(BUTTON_SIZE, BUTTON_SIZE)
	graphicsOptionsButton:setToolTip(ToolTip.Text("Configure graphics options."))
	self.mainMenu:addChild(graphicsOptionsButton)

	local controlsButton = Button()
	controlsButton:setStyle(ButtonStyle(
		BUTTON_STYLE("Resources/Game/UI/Icons/Concepts/Keyboard.png"),
		self:getUIView():getResources()))
	controlsButton.onClick:register(function()
		if _MOBILE then
			local error = AlertWindow(self)
			error:open(
				"Controls aren't currently customizable!",
				"Whoops...",
				480,
				320)
		else
			self:openOptionsScreen(Controls, function(value)
				self:closeMainMenu()
				self:openMainMenu()
			end)
		end
	end)
	controlsButton:setPosition(
		w - BUTTON_SIZE - PADDING,
		h - BUTTON_SIZE * 2 - PADDING * 3)
	controlsButton:setSize(BUTTON_SIZE, BUTTON_SIZE)
	controlsButton:setToolTip(ToolTip.Text("Configure controls."))
	self.mainMenu:addChild(controlsButton)

	local soundButton = Button()
	if _CONF.volume == 0 then
		soundButton:setStyle(ButtonStyle(
			BUTTON_STYLE("Resources/Game/UI/Icons/Concepts/Mute.png"),
			self:getUIView():getResources()))
	else
		soundButton:setStyle(ButtonStyle(
			BUTTON_STYLE("Resources/Game/UI/Icons/Concepts/Music.png"),
			self:getUIView():getResources()))
	end

	soundButton.onClick:register(function()
		if _CONF.volume == 0 then
			_CONF.volume = 1
			soundButton:setStyle(ButtonStyle(
				BUTTON_STYLE("Resources/Game/UI/Icons/Concepts/Music.png"),
				self:getUIView():getResources()))
		else
			_CONF.volume = 0
			soundButton:setStyle(ButtonStyle(
				BUTTON_STYLE("Resources/Game/UI/Icons/Concepts/Mute.png"),
				self:getUIView():getResources()))
		end

		love.audio.setVolume(_CONF.volume)
	end)
	soundButton:setPosition(
		w - BUTTON_SIZE - PADDING,
		h - BUTTON_SIZE * 3 - PADDING * 5)
	soundButton:setSize(BUTTON_SIZE, BUTTON_SIZE)
	soundButton:setToolTip(ToolTip.Text("Toggle sound and music on/off."))
	self.mainMenu:addChild(soundButton)

	local networkButton = Button()
	networkButton:setStyle(ButtonStyle(
		BUTTON_STYLE("Resources/Game/UI/Icons/Things/Compass.png"),
		self:getUIView():getResources()))
	networkButton.onClick:register(function()
		self:openOptionsScreen(Network, function(type, ...)
			if type == Network.ACTION_CONNECT then
				self:connect(...)
			elseif type == Network.ACTION_HOST then
				self:host(...)
			else
				self:disconnect()
			end

			self:closeMainMenu()
			self:openMainMenu()
		end)
	end)
	networkButton:setPosition(
		w - BUTTON_SIZE - PADDING,
		h - BUTTON_SIZE * 4 - PADDING * 6)
	networkButton:setSize(BUTTON_SIZE, BUTTON_SIZE)
	networkButton:setToolTip(ToolTip.Text("Play online or on the local network."))
	self.mainMenu:addChild(networkButton)


	if not _MOBILE then
		local closeButton = Button()
		closeButton:setStyle(ButtonStyle({
			pressed = "Resources/Renderers/Widget/Button/ActiveDefault-Pressed.9.png",
			inactive = "Resources/Renderers/Widget/Button/ActiveDefault-Inactive.9.png",
			hover = "Resources/Renderers/Widget/Button/ActiveDefault-Hover.9.png",
			color = { 1, 1, 1, 1 },
			font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Bold.ttf",
			fontSize = 24,
			textShadow = true,
		}, self:getUIView():getResources()))
		closeButton:setText("X")
		closeButton.onClick:register(function()
			love.event.quit()
		end)
		closeButton:setPosition(
			w - BUTTON_SIZE - PADDING,
			PADDING)
		closeButton:setSize(BUTTON_SIZE, BUTTON_SIZE)
		closeButton:setToolTip(ToolTip.Text("Quit the game."))
		self.mainMenu:addChild(closeButton)
	end

	self:addPatchNotesUI()

	self:getUIView():getRoot():addChild(self.mainMenu)

	if self.titleScreen then
		self.titleScreen:enableLogo()
	end

	self:setConf({
		_DEBUG = _CONF.debug or _DEBUG,
		_CONF = _CONF
	})
end

function DemoApplication:addPatchNotesUI()
	if self.updateButton then
		self.updateButton:getParent():removeChild(self.updateButton)
		self.updateButton = nil
	end

	if self.patchNotesWindow then
		self.patchNotesWindow:updatePatchNotes(self.patchNotes.patchNotes)
	end

	local updateButton = Button()
	if not self.patchNotes then
		updateButton:setStyle(ButtonStyle({
			inactive = "Resources/Renderers/Widget/Button/Disabled-Inactive.9.png",
			hover = "Resources/Renderers/Widget/Button/Disabled-Hover.9.png",
			pressed = "Resources/Renderers/Widget/Button/Disabled-Pressed.9.png",
			color = { 1, 1, 1, 1 },
			font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Regular.ttf",
			fontSize = 24,
			textShadow = true,
			padding = 4
		}, self:getUIView():getResources()))
		updateButton:setText("Checking updates...")
	elseif self.patchNotes.hasNewVersion then
		updateButton:setStyle(ButtonStyle({
			pressed = "Resources/Renderers/Widget/Button/Purple-Pressed.9.png",
			inactive = "Resources/Renderers/Widget/Button/Purple-Inactive.9.png",
			hover = "Resources/Renderers/Widget/Button/Purple-Hover.9.png",
			color = { 1, 1, 1, 1 },
			font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Regular.ttf",
			fontSize = 24,
			textShadow = true,
			padding = 4
		}, self:getUIView():getResources()))
		updateButton:setText("New update available!")
	else
		updateButton:setText("View patch notes")
	end

	local w, h = love.graphics.getScaledMode()
	local BUTTON_WIDTH = 256
	local BUTTON_HEIGHT = 48
	updateButton:setZDepth(0)
	updateButton:setSize(BUTTON_WIDTH, BUTTON_HEIGHT)
	updateButton:setPosition(w / 2 - BUTTON_WIDTH / 2, h - BUTTON_HEIGHT - 8)
	updateButton.onClick:register(function()
		if self.patchNotes then
			self.patchNotesWindow = self:openOptionsScreen(Update, function(w)
				self.mainMenu:removeChild(w:getParent())
				self.titleScreen:enableLogo()
			end)
		end
	end)

	self.mainMenu:addChild(updateButton)
end

function DemoApplication:onNetworkError(client, message)
	self.titleScreen:disableLogo()

	local error = AlertWindow(self)
	error:open(
		"A network error ocurred: " .. message,
		"Error Connecting",
		480,
		320)
	error.onSubmit:register(function()
		self.titleScreen:enableLogo()
	end)

	Application.onNetworkError(self, client, message)
end

function DemoApplication:openOptionsScreen(Type, callback)
	if self.optionsScreen then
		self.mainMenu:removeChild(self.optionsScreen)
	end

	local parent = Panel()

	local width, height, _, _, paddingX, paddingY = love.graphics.getScaledMode()
	parent:setPosition(-paddingX, -paddingY)
	parent:setSize(width + paddingX * 2, height + paddingY * 2)
	parent:setStyle(PanelStyle({ color = { 0, 0, 0, 0.5 }, radius = 0 }, self:getUIView():getResources()))

	local optionsScreen = Type(self)
	optionsScreen.onClose:register(callback)

	parent:addChild(optionsScreen)

	self.mainMenu:addChild(parent)
	self.optionsScreen = parent

	self.titleScreen:disableLogo()

	return optionsScreen
end

function DemoApplication:mousePress(x, y, button)
	local isUIActive = Application.mousePress(self, x, y, button)
	self:mouseProbePress(x, y, button, isUIActive)
end

function DemoApplication:mouseProbePress(x, y, button, isUIActive)
	local probeAction = self.cameraController:mousePress(isUIActive, x, y, button)
	if probeAction == CameraController.PROBE_SELECT_DEFAULT then
		self:probe(x, y, true)
	elseif probeAction == CameraController.PROBE_CHOOSE_OPTION then
		self:probe(x, y, false, function(probe) self.uiView:probe(probe:toArray()) end)
	end
end

function DemoApplication:mouseRelease(x, y, button)
	local isUIActive = Application.mouseRelease(self, x, y, button)
	self:mouseProbeRelease(x, y, button, isUIActive)
end

function DemoApplication:mouseProbeRelease(x, y, button, isUIActive)
	local probeAction = self.cameraController:mouseRelease(isUIActive, x, y, button)
	if probeAction == CameraController.PROBE_SELECT_DEFAULT then
		self:probe(x, y, true)
	elseif probeAction == CameraController.PROBE_CHOOSE_OPTION then
		self:probe(x, y, false, function(probe) self.uiView:probe(probe:toArray()) end)
	end
end

function DemoApplication:mouseScroll(x, y)
	local isUIActive = Application.mouseScroll(self, x, y)

	self.cameraController:mouseScroll(isUIActive, x, y)
end

function DemoApplication:mouseMove(x, y, dx, dy)
	self.mouseX = x
	self.mouseY = y

	local isUIActive = Application.mouseMove(self, x, y, dx, dy)
	self.cameraController:mouseMove(isUIActive, x, y, dx, dy)
end

function DemoApplication:getTouches()
	local result = {}
	for _, touch in pairs(self.touches.current) do
		table.insert(result, touch)
	end

	table.sort(result, function(a, b)
		return a.n < b.n
	end)

	return result
end

DemoApplication.TOUCH_STILL_MAX = 12
DemoApplication.TOUCH_RIGHT_CLICK_TIME_SECONDS = 0.35

DemoApplication.TOUCH_MODE_NONE             = 0
DemoApplication.TOUCH_MODE_LEFT_CLICK_UI    = 1
DemoApplication.TOUCH_MODE_RIGHT_CLICK_UI   = 2
DemoApplication.TOUCH_MODE_LEFT_CLICK_GAME  = 3
DemoApplication.TOUCH_MODE_RIGHT_CLICK_GAME = 4
DemoApplication.TOUCH_MODE_DRAG_CAMERA      = 5
DemoApplication.TOUCH_MODE_ZOOM_CAMERA      = 6

DemoApplication.TOUCH_LEFT_MOUSE_BUTTON    = 1
DemoApplication.TOUCH_RIGHT_MOUSE_BUTTON   = 2
DemoApplication.TOUCH_MIDDLE_MOUSE_BUTTON  = 3

DemoApplication.TOUCH_CAMERA_DENOMINATOR = 24

function DemoApplication:updateMobileMouse()
	local touches = self:getTouches()

	local currentTouchMode = self.currentTouchMode or DemoApplication.TOUCH_MODE_NONE

	if #touches == 1 then
		local touch = touches[1]
		local currentTime = love.timer.getTime() - touch.startTime

		local isMoving
		do
			local totalMovement = math.sqrt(touch.differenceX ^ 2 + touch.differenceY ^ 2)
			isMoving = totalMovement > DemoApplication.TOUCH_STILL_MAX

			local startingWidget = self:getUIView():getInputProvider():getWidgetUnderPoint(
				touch.startX,
				touch.startY,
				nil, nil, nil,
				function(w)
					return w:getIsFocusable()
				end,
				true)
			local currentWidget = self:getUIView():getInputProvider():getWidgetUnderPoint(
				touch.currentX,
				touch.currentY,
				nil, nil, nil,
				function(w)
					return w:getIsFocusable()
				end,
				true)

			isMoving = isMoving or (startingWidget and startingWidget ~= currentWidget)
		end

		local isUIActive = self:getUIView():getInputProvider():isBlocking(touch.currentX, touch.currentY)
		if currentTouchMode == DemoApplication.TOUCH_MODE_NONE then
			if isUIActive then
				currentTouchMode = DemoApplication.TOUCH_MODE_LEFT_CLICK_UI
			else
				currentTouchMode = DemoApplication.TOUCH_MODE_LEFT_CLICK_GAME
			end
		elseif currentTouchMode == DemoApplication.TOUCH_MODE_ZOOM_CAMERA then
			currentTouchMode = DemoApplication.TOUCH_MODE_NONE
		end

		if currentTouchMode == DemoApplication.TOUCH_MODE_LEFT_CLICK_UI or
		   currentTouchMode == DemoApplication.TOUCH_MODE_LEFT_CLICK_GAME
		then
			if not isMoving and currentTime > DemoApplication.TOUCH_RIGHT_CLICK_TIME_SECONDS then
				if currentTouchMode == DemoApplication.TOUCH_MODE_LEFT_CLICK_UI then
					currentTouchMode = DemoApplication.TOUCH_MODE_RIGHT_CLICK_UI
				elseif currentTouchMode == DemoApplication.TOUCH_MODE_LEFT_CLICK_GAME then
					currentTouchMode = DemoApplication.TOUCH_MODE_RIGHT_CLICK_GAME
				end
			end
		end

		if touch.released then
			if currentTouchMode == DemoApplication.TOUCH_MODE_LEFT_CLICK_UI or
			   currentTouchMode == DemoApplication.TOUCH_MODE_LEFT_CLICK_GAME
			then
				if not touch.pressed then
					if currentTime < DemoApplication.TOUCH_RIGHT_CLICK_TIME_SECONDS or isMoving then
						if currentTouchMode == DemoApplication.TOUCH_MODE_LEFT_CLICK_UI then
							Application.mousePress(self, touch.currentX, touch.currentY, DemoApplication.TOUCH_LEFT_MOUSE_BUTTON)
						elseif currentTouchMode == DemoApplication.TOUCH_MODE_LEFT_CLICK_GAME then
							self:getUIView():closePokeMenu()
							self:mouseProbePress(touch.currentX, touch.currentY, DemoApplication.TOUCH_LEFT_MOUSE_BUTTON, false)
						end
					end
				end

				if currentTouchMode == DemoApplication.TOUCH_MODE_LEFT_CLICK_UI then
					Application.mouseRelease(self, touch.currentX, touch.currentY, DemoApplication.TOUCH_LEFT_MOUSE_BUTTON)
				elseif currentTouchMode == DemoApplication.TOUCH_MODE_LEFT_CLICK_GAME then
					self:mouseProbeRelease(touch.currentX, touch.currentY, DemoApplication.TOUCH_LEFT_MOUSE_BUTTON, false)
				end

				currentTouchMode = DemoApplication.TOUCH_MODE_NONE
			elseif currentTouchMode == DemoApplication.TOUCH_MODE_RIGHT_CLICK_UI or
			       currentTouchMode == DemoApplication.TOUCH_MODE_RIGHT_CLICK_GAME
			then
				if currentTouchMode == DemoApplication.TOUCH_MODE_RIGHT_CLICK_UI then
					Application.mouseRelease(self, touch.currentX, touch.currentY, DemoApplication.TOUCH_RIGHT_MOUSE_BUTTON)
				elseif currentTouchMode == DemoApplication.TOUCH_MODE_RIGHT_CLICK_GAME then
					self:mouseProbeRelease(touch.currentX, touch.currentY, DemoApplication.TOUCH_RIGHT_MOUSE_BUTTON, false)
				end

				currentTouchMode = DemoApplication.TOUCH_MODE_NONE
			elseif currentTouchMode == DemoApplication.TOUCH_MODE_DRAG_CAMERA then
				self.cameraController:mouseRelease(
					false,
					touch.currentX, touch.currentY,
					DemoApplication.TOUCH_MIDDLE_MOUSE_BUTTON)
				currentTouchMode = DemoApplication.TOUCH_MODE_NONE
			end
		elseif not touch.pressed then
			if currentTouchMode == DemoApplication.TOUCH_MODE_LEFT_CLICK_UI or
			   currentTouchMode == DemoApplication.TOUCH_MODE_RIGHT_CLICK_UI
			then
				Application.mouseMove(
					self,
					touch.currentX,
					touch.currentY,
					touch.currentX - touch.previousX,
					touch.currentY - touch.previousY)
			end

			if currentTouchMode == DemoApplication.TOUCH_MODE_LEFT_CLICK_UI then
				if isMoving then
					Application.mousePress(self, touch.startX, touch.startY, DemoApplication.TOUCH_LEFT_MOUSE_BUTTON)
					touch.pressed = true
				end
			elseif currentTouchMode == DemoApplication.TOUCH_MODE_LEFT_CLICK_GAME then
				if isMoving then
					self.cameraController:mousePress(
						false,
						touch.currentX,
						touch.currentY,
						DemoApplication.TOUCH_MIDDLE_MOUSE_BUTTON)
					currentTouchMode = DemoApplication.TOUCH_MODE_DRAG_CAMERA
					touch.pressed = true
				end
			elseif currentTouchMode == DemoApplication.TOUCH_MODE_RIGHT_CLICK_UI then
				Application.mousePress(self, touch.currentX, touch.currentY, DemoApplication.TOUCH_RIGHT_MOUSE_BUTTON)
				Application.mouseRelease(self, touch.currentX, touch.currentY, DemoApplication.TOUCH_RIGHT_MOUSE_BUTTON)
				touch.pressed = true
				touch.released = true
			elseif currentTouchMode == DemoApplication.TOUCH_MODE_RIGHT_CLICK_GAME then
				self:mouseProbePress(touch.currentX, touch.currentY, DemoApplication.TOUCH_RIGHT_MOUSE_BUTTON, false)
				self:mouseProbeRelease(touch.currentX, touch.currentY, DemoApplication.TOUCH_RIGHT_MOUSE_BUTTON, false)
				touch.pressed = true
				touch.released = true
			elseif currentTouchMode == DemoApplication.TOUCH_MODE_DRAG_CAMERA then
				self.cameraController:mousePress(
					false,
					touch.currentX, touch.currentY,
					DemoApplication.TOUCH_MIDDLE_MOUSE_BUTTON)
				touch.pressed = true
			end
		elseif touch.moved then
			if isMoving and currentTouchMode == DemoApplication.TOUCH_MODE_LEFT_CLICK_UI then
				Application.mouseMove(
					self,
					touch.currentX,
					touch.currentY,
					touch.currentX - touch.previousX,
					touch.currentY - touch.previousY)
			elseif currentTouchMode == DemoApplication.TOUCH_MODE_DRAG_CAMERA then
				self.cameraController:mouseMove(
					false,
					touch.currentX,
					touch.currentY,
					touch.currentX - touch.previousX,
					touch.currentY - touch.previousY)
				touch.moved = false
			end
		end
	elseif #touches == 2 then
		if currentTouchMode == DemoApplication.TOUCH_MODE_LEFT_CLICK_GAME then
			currentTouchMode = DemoApplication.TOUCH_MODE_ZOOM_CAMERA
		elseif currentTouchMode == DemoApplication.TOUCH_MODE_ZOOM_CAMERA then
			local touch1 = touches[1]
			local touch2 = touches[2]

			local distanceCurrent = math.sqrt((touch1.currentX - touch2.currentX) ^ 2 + (touch1.currentY - touch2.currentY) ^ 2)
			local distancePrevious = math.sqrt((touch1.previousX - touch2.previousX) ^ 2 + (touch1.previousY - touch2.previousY) ^ 2)

			self.cameraController:mouseScroll(false, 0, (distanceCurrent - distancePrevious) / DemoApplication.TOUCH_CAMERA_DENOMINATOR)
		end
	end

	self.currentTouchMode = currentTouchMode
end

function DemoApplication:touchPress(id, x, y, pressure)
	self.touches.current[id] = {
		id = id,
		startTime = love.timer.getTime(),
		currentTime = love.timer.getTime(),
		startX = x,
		startY = y,
		previousX = x,
		previousY = y,
		currentX = x,
		currentY = y,
		differenceX = 0,
		differenceY = 0,
		released = false,
		n = self.touches.n
	}

	self.touches.n = self.touches.n + 1

	self:updateMobileMouse()
end

function DemoApplication:touchRelease(id, x, y, pressure)
	if self.touches.current[id] and not self.touches.current[id].released then
		local touch = self.touches.current[id]
		touch.currentTime = love.timer.getTime()
		touch.previousX = touch.currentX
		touch.previousY = touch.currentY
		touch.currentX = x
		touch.currentY = y
		touch.released = true

		self:updateMobileMouse()
	end

	self.touches.current[id] = nil
end

function DemoApplication:touchMove(id, x, y, dx, dy)
	local touch = self.touches.current[id]
	if touch then
		touch.currentTime = love.timer.getTime()
		touch.previousX = touch.currentX
		touch.previousY = touch.currentY
		touch.currentX = x
		touch.currentY = y
		touch.differenceX = touch.differenceX + dx
		touch.differenceY = touch.differenceY + dy
		touch.moved = true
	end

	self:updateMobileMouse()
end

function DemoApplication:keyDown(key, ...)
	Application.keyDown(self, key, ...)

	local isShiftDown = love.keyboard.isDown('lshift') or
	                    love.keyboard.isDown('rshift')

	local isCtrlDown = love.keyboard.isDown('lctrl') or
	                   love.keyboard.isDown('rctrl')

	if key == 'printscreen' or key == 'f10' then
		self:prepareScreenshot()

		if isCtrlDown then
			self:snapshotPlayerPeep()
		elseif isShiftDown then
			self:snapshotGame()
		else
			local filename = self:getScreenshotName("Screenshot")

			local url = string.format("%s/%s", love.filesystem.getSaveDirectory(), filename)
			local isWindows = love.system.getOS() == "Windows"
			if isWindows then
				url = url:gsub("/", "\\")
			end
			Log.info("Captured \"%s\".", url)

			love.graphics.captureScreenshot(function(imageData)
				imageData:encode('png', filename)

				self:showScreenShot(filename)
			end)

			self.isScreenshotPending = true
		end
	end
end

function DemoApplication:prepareScreenshot()
	if self.screenshot then
		local parent = self.screenshot:getParent()
		if parent then
			parent:removeChild(self.screenshot)
		end

		self.screenshot = nil
	end
end

function DemoApplication:showScreenShot(filename)
	local screenshot = Screenshot(self:getUIView(), filename)

	if screenshot:isReady() then
		screenshot:setZDepth(math.huge)
		self:getUIView():getRoot():addChild(screenshot)

		self.screenshot = screenshot
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
		camera:setUp(Vector(0, -1, 0))

		local renderer = Renderer()
		love.graphics.setScissor()
		renderer:setClearColor(Color(0, 0, 0, 0))
		renderer:setCullEnabled(false)
		renderer:setCamera(camera)

		for index, actor in ipairs(actors) do
			love.graphics.push("all")
			local view = self:getGameView():getActor(actor)
			local zoom, position
			do
				local min, max = actor:getBounds()
				local offset = (max.y - min.y) / 2
				zoom = (max.z - min.z) + math.max((max.y - min.y), (max.x - min.x)) + 4

				local transform = view:getSceneNode():getTransform():getGlobalTransform(self:getFrameDelta())
				position = Vector(transform:transformPoint(0, offset, 0))
			end

			camera:setPosition(position)
			camera:setDistance(zoom)

			renderer:draw(view:getSceneNode(), self:getFrameDelta(), 1024, 1024)
			love.graphics.setCanvas()

			local imageData = renderer:getOutputBuffer():getColor():newImageData()
			local filename = self:getScreenshotName("Peep", index)
			imageData:encode('png', filename)

			if actor == self:getGame():getPlayer():getActor() then
				self:showScreenShot(filename)
			end

			love.graphics.pop()
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


	love.graphics.push('all')
	do
		local w, h = love.window.getMode()
		local canvas = love.graphics.newCanvas(w, h)

		love.graphics.setCanvas(canvas)
		self:getUIView():draw()
		love.graphics.setCanvas()

		local imageData = canvas:newImageData()
		imageData:encode('png', self:getScreenshotName("UI"))
	end
	love.graphics.pop()
end

function DemoApplication:updatePlayerMovement()
	local player = self:getGame():getPlayer()
	if not player then
		return
	end

	local up = Keybinds['PLAYER_1_MOVE_UP']:isDown()
	local down = Keybinds['PLAYER_1_MOVE_DOWN']:isDown()
	local left = Keybinds['PLAYER_1_MOVE_LEFT']:isDown()
	local right = Keybinds['PLAYER_1_MOVE_RIGHT']:isDown()

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

function DemoApplication:hideToolTip()
	if self.toolTipWidget then
		local renderer = self:getUIView():getRenderManager()
		renderer:unsetToolTip(self.toolTipWidget)
		self.toolTipWidget = nil
		self.toolTip = nil
		self.showingToolTip = false
		self.lastToolTipObject = false
	end
end

function DemoApplication:updateToolTip(delta)
	local isUIBlocking = self:getUIView():getInputProvider():isBlocking(love.mouse.getPosition())

	if not isUIBlocking then
		self.mouseMoved = true
		self.toolTipTick = math.min(self.toolTipTick, DemoApplication.PROBE_TICK)
	else
		self:hideToolTip()
	end

	self.toolTipTick = self.toolTipTick - delta
	if self.mouseMoved and self.toolTipTick < 0 then
		if isUIBlocking or (_DEBUG and (love.keyboard.isDown("rshift") or love.keyboard.isDown("lshift"))) then
			self:hideToolTip()
		else
			self:probe(self.mouseX, self.mouseY, false, function(probe)
				local action = probe:toArray()[1]
				local renderer = self:getUIView():getRenderManager()
				if action and (action.type ~= 'examine' and action.type ~= 'walk' and not action.suppress) then
					local text = string.format("%s %s", action.verb, action.object)
					self.showingToolTip = true
					if (not self.lastToolTipObject or (self.lastToolTipObject.type ~= action.type or self.lastToolTipObject.id ~= action.id)) or not self.showingToolTip then
						self.toolTip = {
							ToolTip.Header(text),
							ToolTip.Text(action.description)
						}
						self.lastToolTipObject = action

						renderer:unsetToolTip(self.toolTipWidget)
						self.toolTipWidget = nil
					end
				else
					self:hideToolTip()
				end
			end, { ['actors'] = true, ['props'] = true, ['loot'] = true })

			self.mouseMoved = false
			self.toolTipTick = DemoApplication.PROBE_TICK
		end
	end

	if self.showingToolTip then
		local renderer = self:getUIView():getRenderManager()
		if not isUIBlocking then
			if not self.toolTipWidget then
				self.toolTipWidget = renderer:setToolTip(math.huge, unpack(self.toolTip))
			else
				self.toolTipWidget:setPosition(love.graphics.getScaledPoint(love.mouse.getPosition()))
			end
		end
	end
end

function DemoApplication:setPatchNotes(event)
	self.patchNotes = event

	if self.mainMenu then
		self:addPatchNotesUI()
	end
end

function DemoApplication:updatePatchNotes()
	local event = self.patchNotesServiceOutputChannel:pop()
	if event and type(event) == "table" then
		if event.type == "update" and event.success then
			self:setPatchNotes(event)
		end
	end
end

function DemoApplication:update(delta)
	Application.update(self, delta)

	if _MOBILE then
		self:updateMobileMouse()
	end

	self:updatePlayerMovement()
	self:updateToolTip(delta)

	self.cameraController:update(delta)

	if self.titleScreen then
		self.titleScreen:update(delta)

		if not self.mainMenu and self.titleScreen:isReady() then
			self:openMainMenu()
		end
	end

	if not _MOBILE then
		local currentCursor = love.mouse.getCursor()
		if (_DEBUG and (love.keyboard.isDown("rshift") or love.keyboard.isDown("lshift"))) then
			if currentCursor ~= self.blankCursor then
				love.mouse.setCursor(self.blankCursor)
			end
		else
			if currentCursor ~= self.defaultCursor then
				love.mouse.setCursor(self.defaultCursor)
			end
		end
	end

	self:updatePatchNotes()
end

function DemoApplication:draw(delta)
	self.cameraController:draw()

	Application.draw(self, delta)

	if self.isScreenshotPending then
		local cursor = love.graphics.newImage("Resources/Game/UI/Cursor.png")
		love.graphics.draw(cursor, love.mouse.getPosition())

		self.isScreenshotPending = false
	end

	if _DEBUG and _MOBILE then
		local touches = self:getTouches()

		for i = 1, #touches do
			love.graphics.draw(self.mobileCursor, touches[i].currentX, touches[i].currentY)
		end
	end

	if self.titleScreen then
		self.titleScreen:draw()
	end
end

return DemoApplication
