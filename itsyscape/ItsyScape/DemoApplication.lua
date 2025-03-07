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
local Function = require "ItsyScape.Common.Function"
local Pool = require "ItsyScape.Common.Math.Pool"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Ray = require "ItsyScape.Common.Math.Ray"
local Vector = require "ItsyScape.Common.Math.Vector"
local PlayerStorage = require "ItsyScape.Game.PlayerStorage"
local Config = require "ItsyScape.Game.Config"
local Probe = require "ItsyScape.Game.Probe"
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
local GyroButtons = require "ItsyScape.UI.GyroButtons"
local Interface = require "ItsyScape.UI.Interface"
local Keybinds = require "ItsyScape.UI.Keybinds"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local ToolTip = require "ItsyScape.UI.ToolTip"
local Widget = require "ItsyScape.UI.Widget"
local UIView = require "ItsyScape.UI.UIView"
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
--	"TitleScreen_EmptyRuins",
--	"TitleScreen_RuinsOfRhysilk",
--	"TitleScreen_ViziersRock",
	"TitleScreen_IsabelleIsland",
}
DemoApplication.GYRO_RADIUS = 1
DemoApplication.SHIMMER_DURATION = 0.25

function DemoApplication:new()
	Application.new(self, true)

	self.previousPlayerPosition = false
	self.currentPlayerPosition = false
	self.currentPlayerDirection = Vector(1, 0, 0):keep()
	self.shimmeringObjects = {}

	self.showingToolTip = false
	self.lastToolTipObject = false
	self.toolTipTick = math.huge
	self.mouseMoved = false
	self.mouseX, self.mouseY = math.huge, math.huge
	self.cursors = {}

	self.patchNotesServiceInputChannel = love.thread.newChannel()
	self.patchNotesServiceOutputChannel = love.thread.newChannel()
	self.patchNotesServiceThread = love.thread.newThread("ItsyScape/Analytics/Threads/PatchNotesService.lua")
	self.patchNotesServiceThread:start(self.patchNotesServiceInputChannel, self.patchNotesServiceOutputChannel)

	if _ARGS["gyro"] then
		self.gyroInputChannel = love.thread.newChannel()
		self.gyroOutputChannel = love.thread.newChannel()
		self.gyroThread = love.thread.newThread("ItsyScape/UI/Threads/Gyro.lua")
		self.gyroThread:start(self.gyroInputChannel, self.gyroOutputChannel)
	end

	self.touches = { current = {}, n = 1 }

	self.cameraController = DefaultCameraController(self)
	self.cameraControllers = { self.cameraController }

	self:getGame().onReady:register(function(_, player)
		Log.info("Ready to play with player ID %d!", player:getID())

		player.onChangeCamera:register(self.changeCamera, self)
		player.onPushCamera:register(self.pushCamera, self)
		player.onPopCamera:register(self.popCamera, self)
		player.onPokeCamera:register(self.pokeCamera, self)
		player.onSave:register(self.savePlayer, self)
		player.onMove:register(self.setMapName, self)
		player.onMove:register(self.clearResourceManagerCache, self)

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
		self.defaultCursor = love.mouse.newCursor("Resources/Game/UI/Cursor.png", 8, 4)
		self.highDPICursor = love.mouse.newCursor("Resources/Game/UI/Cursor@2x.png", 16, 8)

		local _, blankCursorImageData = self:getGameView():getTranslucentTexture()
		self.blankCursor = love.mouse.newCursor(blankCursorImageData, 0, 0)

		love.mouse.setCursor(self.defaultCursor)
	else
		self.mobileCursor = love.graphics.newImage("Resources/Game/UI/Cursor_Mobile.png")
	end

	self:initTitleScreen()

	Pool():makeCurrent()
end

function DemoApplication:changeCamera(_, cameraType)
	local typeName = string.format("ItsyScape.Graphics.%sCameraController", cameraType)
	local s, r = pcall(require, typeName)

	if not s then
		Log.error("Could not load camera type '%s': %s", s, r)
	else
		self.cameraController = r(self)
		self.cameraControllers[#self.cameraControllers] = self.cameraController
	end
end

function DemoApplication:pushCamera(_, cameraType)
	local typeName = string.format("ItsyScape.Graphics.%sCameraController", cameraType)
	local s, r = pcall(require, typeName)

	if not s then
		Log.error("Could not load camera type '%s': %s", s, r)
	else
		self.cameraController = r(self)
		table.insert(self.cameraControllers, self.cameraController)
	end
end

function DemoApplication:popCamera()
	if #self.cameraControllers <= 1 then
		Log.warn("Trying to pop last camera!")
		return
	end

	table.remove(self.cameraControllers)
	self.cameraController = self.cameraControllers[#self.cameraControllers]
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

function DemoApplication:clearResourceManagerCache()
	self:getGameView():getResourceManager():clear()
end

function DemoApplication:quitPlayer()
	Log.info("Player quit their session.")

	local gameManager = self:getGameManager()
	if gameManager then
		gameManager:removeAllInstances("ItsyScape.Game.Model.Actor")
		gameManager:removeAllInstances("ItsyScape.Game.Model.Prop")
	end

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

function DemoApplication:joystickAdd(...)
	Application.joystickAdd(self, ...)

	if self.gyroInputChannel then
		self.gyroInputChannel:push({ type = "calibrate" })
	end
end

function DemoApplication:joystickRemove(...)
	Application.joystickRemove(self, ...)

	if self.gyroInputChannel then
		self.gyroInputChannel:push({ type = "calibrate" })
	end
end

function DemoApplication:quit(isError)
	if not _DEBUG and not _MOBILE and not self:getIsPaused() and (_ANALYTICS_ENABLED and self:tryQuit()) then
		return true
	end

	self.patchNotesServiceInputChannel:push({ type = "quit" })

	if self.gyroInputChannel then
		self.gyroInputChannel:push({ type = "quit" })
	end

	Application.quit(self, isError)

	return false
end

function DemoApplication:quitGame()
	if self:getIsQutting() then
		self:quit()
		love.event.quit()
	else
		self:openTitleScreen()
	end
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

	local INACTIVE_BUTTON_STYLE = {}

	local ACTIVE_BUTTON_STYLE = {
		pressed = "Resources/Renderers/Widget/Button/ActiveDefault-Pressed.9.png",
		inactive = "Resources/Renderers/Widget/Button/ActiveDefault-Inactive.9.png",
		hover = "Resources/Renderers/Widget/Button/ActiveDefault-Hover.9.png"
	}

	do
		local SpiralLayout = require "ItsyScape.UI.SpiralLayout"
		local Icon = require "ItsyScape.UI.Icon"
		local Widget = require "ItsyScape.UI.Widget"
		local RichTextLabel = require "ItsyScape.UI.RichTextLabel"
		local spiral = SpiralLayout()
		spiral:setRadius(160, 196)

		local label = RichTextLabel()
		label:setPosition(32, 32)
		label:setSize(128, 96)

		local Drawable = require "ItsyScape.UI.Drawable"

		local Circle = Class(Drawable)
		function Circle:new()
			Drawable.new(self)

			self.enabled = false
			self.outline = Color(1, 0.8, 0, 1)
			self.outlineThickness = 8
			self.fill = Color(0, 0, 0, 0.5)
		end

		function Circle:draw(...)
			Drawable.draw(self, ...)

			local x, y = self:getPosition()

			local target = self:getParent() or self

			local w, h = target:getSize()
			x = x + w / 2
			y = y + h / 2

			local radius = math.min(w, h) / 2

			love.graphics.push("all")

			love.graphics.setColor(self.fill:get())
			itsyrealm.graphics.circle("fill", x, y, radius)

			if self.enabled then
				love.graphics.setColor(self.outline:get())
				love.graphics.setLineWidth(self.outlineThickness)
				itsyrealm.graphics.circle("line", x, y, radius)
			end

			love.graphics.pop()
		end

		local active
		spiral.onChildSelected:register(function(_, currentChild, previousChild)
			if previousChild then
				previousChild:getData("circle").enabled = false
				previousChild:getData("circle").fill = Color(0, 0, 0, 0.5)
				previousChild:removeChild(previousChild:getData("action"))
			end

			if currentChild then
				currentChild:getData("circle").enabled = true
				currentChild:getData("circle").fill = Color(1, 0.8, 0, 0.5)
				currentChild:addChild(currentChild:getData("action"))
				
				label:setText({
					{ t = "header", currentChild:getData("name") },
					currentChild:getData("description")
				})

			end

			active = currentChild
		end)

		local SELECTED_SIZE = 64
		local DEFAULT_SIZE = 48
		local MIN_SIZE = 24

		spiral.onChildVisible:register(function(_, child, delta)
			delta = math.min(math.sin(delta * (math.pi / 2)) * 1.1, 1)

			local alpha = math.lerp(0.25, 1, delta)
			child:getData("icon"):setColor(Color(1, 1, 1, alpha))

			local size = math.lerp(MIN_SIZE, active == child and SELECTED_SIZE or DEFAULT_SIZE, delta)
			child:getData("icon"):setSize(size, size)
			child:setSize(size, size)
		end)

		local gameDB = self:getGameDB()
		for power in gameDB:getResources("Power") do
			local button = Button()
			button:setStyle(ButtonStyle(
				INACTIVE_BUTTON_STYLE,
				self:getUIView():getResources()))
			button:setToolTip(power.name)
			button:setSize(DEFAULT_SIZE, DEFAULT_SIZE)

			local name = gameDB:getRecord("ResourceName", { Resource = power })
			name = name and name:get("Value") or "???"
			local description = gameDB:getRecord("ResourceDescription", { Resource = power })
			description = description and description:get("Value") or "IDK"

			local icon = Icon()
			icon:setIcon(string.format("Resources/Game/Powers/%s/Icon.png", power.name))

			local actionIcon = Icon()
			actionIcon:setIcon("Resources/Game/UI/Icons/Controllers/NintendoSwitch/switch_button_a.png")
			actionIcon:setSize(48, 48)
			actionIcon:setColor(Color(0.4, 0.8, 0.4, 1))
			actionIcon:setPosition(SELECTED_SIZE - 24, SELECTED_SIZE - 24)

			local circle = Circle()
			circle.enabled = false

			button:addChild(circle)
			button:addChild(icon)
			button:setData("name", name)
			button:setData("description", description)
			button:setData("circle", circle)
			button:setData("icon", icon)
			button:setData("action", actionIcon)

			spiral:addChild(button)
		end

		local w, h = love.graphics.getScaledMode()
		spiral:setPosition(w / 2, h / 2)

		local circle = Circle()
		circle.enabled = true

		spiral:getInnerPanel():setSize(192, 192)
		spiral:getInnerPanel():setPosition(-96, -96)
		spiral:getInnerPanel():addChild(circle)
		spiral:getInnerPanel():addChild(label)

		self.mainMenu:addChild(spiral)
		self:getUIView():getInputProvider():setFocusedWidget(spiral)
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
		_DEBUG = _DEBUG or (_CONF and _CONF.debug),
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
	if self.cameraController:getIsMouseCaptured() then
		self:mouseProbePress(x, y, button, false)
	else
		local isUIActive = Application.mousePress(self, x, y, button)
		self:mouseProbePress(x, y, button, isUIActive)
	end
end

function DemoApplication:mouseProbePress(x, y, button, isUIActive)
	local probeAction = self.cameraController:mousePress(isUIActive, x, y, button)
	if probeAction == CameraController.PROBE_SELECT_DEFAULT then
		self:probe(x, y, true, function(probe) self.uiView:probe(probe:toArray()) end, nil, self.hasGyroInput and DemoApplication.GYRO_RADIUS or 0)
	elseif probeAction == CameraController.PROBE_CHOOSE_OPTION then
		self:probe(x, y, false, function(probe) self.uiView:probe(probe:toArray()) end, nil, self.hasGyroInput and DemoApplication.GYRO_RADIUS or 0)
	end
end

function DemoApplication:mouseRelease(x, y, button)
	if self.cameraController:getIsMouseCaptured() then
		return self:mouseProbeRelease(x, y, button, false)
	else
		local isUIActive = Application.mouseRelease(self, x, y, button)
		self:mouseProbeRelease(x, y, button, isUIActive)
	end
end

function DemoApplication:mouseProbeRelease(x, y, button, isUIActive)
	local probeAction = self.cameraController:mouseRelease(isUIActive, x, y, button)
	if probeAction == CameraController.PROBE_SELECT_DEFAULT then
		self:probe(x, y, true, function(probe) self.uiView:probe(probe:toArray()) end, nil, self.hasGyroInput and DemoApplication.GYRO_RADIUS or 0)
	elseif probeAction == CameraController.PROBE_CHOOSE_OPTION then
		self:probe(x, y, false, function(probe) self.uiView:probe(probe:toArray()) end, nil, self.hasGyroInput and DemoApplication.GYRO_RADIUS or 0)
	end
end

function DemoApplication:mouseScroll(x, y)
	local isUIActive = Application.mouseScroll(self, x, y)

	self.cameraController:mouseScroll(isUIActive, x, y)
end

function DemoApplication:mouseMove(x, y, dx, dy)
	self.mouseX = x
	self.mouseY = y

	if self.cameraController:getIsMouseCaptured() then
		self.cameraController:mouseMove(false, x, y, dx, dy)
	else
		local isUIActive = Application.mouseMove(self, x, y, dx, dy)
		self.cameraController:mouseMove(isUIActive, x, y, dx, dy)
	end
end

function DemoApplication:gamepadAxis(joystick, axis, value)
	Application.gamepadAxis(self, joystick, axis, value)

	local inputProvider = self:getUIView():getInputProvider()
	if not inputProvider:isCurrentJoystick(joystick) then
		return
	end

	local isUIActive = not not inputProvider:getFocusedWidget()
	self.cameraController:gamepadAxis(isUIActive, axis, value)
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

DemoApplication.TOUCH_MODE_NONE             = "NONE"
DemoApplication.TOUCH_MODE_LEFT_CLICK_UI    = "LEFT_CLICK_UI"
DemoApplication.TOUCH_MODE_RIGHT_CLICK_UI   = "RIGHT_CLICK_UI"
DemoApplication.TOUCH_MODE_LEFT_CLICK_GAME  = "LEFT_CLICK_GAME"
DemoApplication.TOUCH_MODE_RIGHT_CLICK_GAME = "RIGHT_CLICK_GAME"
DemoApplication.TOUCH_MODE_DRAG_CAMERA      = "DRAG_CAMERA"
DemoApplication.TOUCH_MODE_ZOOM_CAMERA      = "ZOOM_CAMERA"

DemoApplication.TOUCH_LEFT_MOUSE_BUTTON    = 1
DemoApplication.TOUCH_RIGHT_MOUSE_BUTTON   = 2
DemoApplication.TOUCH_MIDDLE_MOUSE_BUTTON  = 3

DemoApplication.TOUCH_SCROLL_DENOMINATOR_UI   = 64
DemoApplication.TOUCH_SCROLL_DENOMINATOR_GAME = 24

function DemoApplication:getMousePosition()
	if self.currentGyroState and self.currentGyroMouseDeviceID and self.currentGyroState[self.currentGyroMouseDeviceID] then
		local gyroState = self.currentGyroState[self.currentGyroMouseDeviceID]

		return gyroState.quasiX or gyroState.currentX, gyroState.quasiY or gyroState.currentY
	end

	return Application.getMousePosition(self)
end

function DemoApplication:pumpGyroMouse(delta)
	if self.gyroOutputChannel then
		local event
		repeat
			event = self.gyroOutputChannel:pop()

			local eventType = type(event) == "table" and event.type
			if eventType == "beginConnect" then
				self.isGyroConnecting = true
			elseif eventType == "endConnect" then
				self.isGyroConnecting = false

				self.currentGyroState = {}
				if event.count >= 2 then
					self.hasGyroInput = true
					self.gyroDeviceIDs = event.deviceIDs
					self:getUIView():enableInputScheme(UIView.INPUT_SCHEME_GYRO)

					itsyrealm.graphics.setUIScale(2)
				else
					self.hasGyroInput = false
					self.gyroDeviceIDs = nil
					self:getUIView():disableInputScheme(UIView.INPUT_SCHEME_GYRO)

					itsyrealm.graphics.setUIScale(1)
				end
			elseif eventType == "update" then
				self:updateGyroMouse(delta, event.deviceID, event.state)
			end
		until not event
	end
end

function DemoApplication:updateGyroMouse(delta, deviceID, nextGyroState)
	local width, height = love.window.getMode()

	if not self.currentGyroState[deviceID] then
		nextGyroState.currentX = math.floor(width / 2)
		nextGyroState.currentY = math.floor(height / 2)

		self.currentGyroState[deviceID] = nextGyroState
		return
	end

	local currentGyroState = self.currentGyroState[deviceID]
	local currentX, currentY = self:getMousePosition()

	-- Left click / right click
	do
		local isLeftClickPress = not currentGyroState.buttons["a"] and nextGyroState.buttons["a"]
		local isRightClickPress = not currentGyroState.buttons["x"] and nextGyroState.buttons["x"]

		if isRightClickPress then
			self:mousePress(currentX, currentY, DemoApplication.TOUCH_RIGHT_MOUSE_BUTTON)
			self:mouseRelease(currentX, currentY, DemoApplication.TOUCH_RIGHT_MOUSE_BUTTON)
		end

		if isLeftClickPress then
			self:mousePress(currentX, currentY, DemoApplication.TOUCH_LEFT_MOUSE_BUTTON)
			self:mouseRelease(currentX, currentY, DemoApplication.TOUCH_LEFT_MOUSE_BUTTON)
		end
	end

	-- Reset mouse position
	local isCenterPress = not currentGyroState.buttons["d-pad down"] and nextGyroState.buttons["d-pad down"] or love.keyboard.isDown("space")
	if isCenterPress then
		if self.currentGyroMouseDeviceID and self.currentGyroState[self.currentGyroMouseDeviceID] then
			self.currentGyroState[self.currentGyroMouseDeviceID].currentX = math.floor(width / 2)
			self.currentGyroState[self.currentGyroMouseDeviceID].currentY = math.floor(height / 2)
		end
	end

	-- Mouse movement
	if self.currentGyroMouseDeviceID == deviceID then
		local deltaX = -(nextGyroState.gyro[2] / math.deg(math.pi / 3))
		local deltaY = -(nextGyroState.gyro[1] / math.deg(math.pi / 7))

		if math.abs(deltaX) < 0.125 then
			deltaX = 0
		end

		if math.abs(deltaY) < 0.125 then
			deltaY = 0
		end

		deltaX = math.rad(deltaX)
		deltaY = math.rad(deltaY)

		local offsetX = deltaX * width
		local offsetY = deltaY * height

		nextGyroState.currentX = math.floor(currentGyroState.currentX + offsetX)
		nextGyroState.currentY = math.floor(currentGyroState.currentY + offsetY)

		nextGyroState.currentX = math.clamp(nextGyroState.currentX, -32, width + 32)
		nextGyroState.currentY = math.clamp(nextGyroState.currentY, -32, height + 32)

		local px, py = itsyrealm.graphics.getScaledPoint(
			currentGyroState.quasiX or currentGyroState.currentX,
			currentGyroState.quasiY or currentGyroState.currentY)
		local previousWidget = self:getUIView():getInputProvider():getWidgetUnderPoint(
			px, py,
			nil, nil, nil,
			function(w)
				return w:getIsFocusable()
			end,
			true)
		local nx, ny = itsyrealm.graphics.getScaledPoint(
			nextGyroState.currentX,
			nextGyroState.currentY)
		local currentWidget = self:getUIView():getInputProvider():getWidgetUnderPoint(
			nx, ny,
			nil, nil, nil,
			function(w)
				return w:getIsFocusable()
			end,
			true)

		local currentInterface = previousWidget
		while currentWidget and Class.isCompatibleType(currentWidget, Interface) do
			currentInterface = currentWidget:getParent()
		end

		local targetWidget = currentInterface or previousWidget
		if targetWidget then
			local targetX, targetY = targetWidget:getAbsolutePosition()
			local targetWidth, targetHeight = targetWidget:getSize()

			local offset = currentInterface ~= nil and 16 or 8

			targetX = targetX - offset
			targetY = targetY - offset
			targetWidth = targetWidth + offset * 2
			targetHeight = targetHeight + offset * 2

			if nx > targetX and nx <= targetX + targetWidth and
			   ny > targetY and ny <= targetY + targetHeight
			then
				nextGyroState.isInterfaceBlocking = true
			end
		end

		if previousWidget then
			local snappedWidget
			do
				local previousX, previousY = previousWidget:getAbsolutePosition()
				local previousWidth, previousHeight = previousWidget:getSize()

				previousX = previousX - 8
				previousY = previousY - 8
				previousWidth = previousWidth + 16
				previousHeight = previousHeight + 16

				if nx > previousX and nx <= previousX + previousWidth and
				   ny > previousY and ny <= previousY + previousHeight
				then
					nextGyroState.isInterfaceBlocking = true
					snappedWidget = previousWidget
				end
			end
			snappedWidget = snappedWidget or targetWidget

			if snappedWidget and nextGyroState.isInterfaceBlocking then
				local snappedX, snappedY = snappedWidget:getAbsolutePosition()
				local snappedWidth, snappedHeight = snappedWidget:getSize()

				local sx, sy = itsyrealm.graphics.inverseGetScaledPoint(
					snappedX + snappedWidth / 2,
					snappedY + snappedHeight / 2)

				nextGyroState.quasiX = sx
				nextGyroState.quasiY = sy
			end
		end

		local mouseX = nextGyroState.quasiX or nextGyroState.currentX
		local mouseY = nextGyroState.quasiY or nextGyroState.currentY

		if mouseX ~= currentX or mouseY ~= currentY then
			self:mouseMove(
				mouseX,
				mouseY,
				mouseX - currentGyroState.currentX,
				mouseY - currentGyroState.currentY)
		end
	end

	-- Mouse assignment
	if self.currentGyroMouseDeviceID ~= deviceID then
		local acceleration = Vector(unpack(nextGyroState.acceleration))

		if acceleration:getLength() > 3 then
			nextGyroState.shakingTime = (currentGyroState.shakingTime or 0) + delta
		else
			nextGyroState.shakingTime = math.max((currentGyroState.shakingTime or 0) - delta, 0)
		end

		if nextGyroState.shakingTime > 0.1 then
			self.currentGyroMouseDeviceID = deviceID
			nextGyroState.shakingTime = 0
		end
	end

	-- Camera movement
	do
		local rotationX = -nextGyroState.right[1]
		local rotationY = -nextGyroState.right[2]

		if math.abs(rotationX) < 0.1 then
			rotationX = 0
		end

		if math.abs(rotationY) < 0.1 then
			rotationY = 0
		end

		self.cameraController:rotate(
			rotationX * 8,
			rotationY * 8)
	end

	nextGyroState.currentX = nextGyroState.currentX or currentX
	nextGyroState.currentY = nextGyroState.currentY or currentY
	self.currentGyroState[deviceID] = nextGyroState
end

function DemoApplication:updateMobileMouse()
	local touches = self:getTouches()
	if #touches >= 1 then
		self:getUIView():enableInputScheme(UIView.INPUT_SCHEME_TOUCH)
	end

	local currentTouchMode = self.currentTouchMode or DemoApplication.TOUCH_MODE_NONE

	if #touches == 1 then
		local touch = touches[1]
		local currentTime = love.timer.getTime() - touch.startTime

		local isMoving, isScrolling, isDragging
		do
			local totalMovement = math.sqrt(touch.differenceX ^ 2 + touch.differenceY ^ 2)
			isMoving = touch.isMoving or totalMovement > DemoApplication.TOUCH_STILL_MAX
			touch.isMoving = isMoving

			local sx, sy = love.graphics.getScaledPoint(touch.startX, touch.startY)
			local cx, cy = love.graphics.getScaledPoint(touch.currentX, touch.currentY)

			local startingWidget = self:getUIView():getInputProvider():getWidgetUnderPoint(
				sx,
				sy,
				nil, nil, nil,
				function(w)
					return w:getIsFocusable()
				end,
				true)
			local currentWidget = self:getUIView():getInputProvider():getWidgetUnderPoint(
				cx,
				cy,
				nil, nil, nil,
				function(w)
					return w:getIsFocusable()
				end,
				true)
			local scrollingWidget = self:getUIView():getInputProvider():getWidgetUnderPoint(
					sx,
					sy,
					nil, nil, nil,
					function(w)
						local width, height = w:getSize()
						local scrollWidth, scrollHeight = w:getScrollSize()

						return scrollWidth > width or scrollHeight > height
					end,
					true)

			isMoving = isMoving or (startingWidget and startingWidget ~= currentWidget)
			isDragging = startingWidget and startingWidget:getIsDraggable()
			isScrolling = scrollingWidget ~= nil
		end

		local isUIActive = self:getUIView():getInputProvider():isBlocking(touch.currentX, touch.currentY)
		local hasFullscreenUI = self:getUIView():getIsFullscreen()

		if not touch.released then
			if currentTouchMode == DemoApplication.TOUCH_MODE_NONE then
				if isUIActive or hasFullscreenUI then
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
		end

		if touch.released then
			if currentTouchMode == DemoApplication.TOUCH_MODE_LEFT_CLICK_UI or
			   currentTouchMode == DemoApplication.TOUCH_MODE_LEFT_CLICK_GAME
			then
				if not touch.pressed then
					if currentTime < DemoApplication.TOUCH_RIGHT_CLICK_TIME_SECONDS or isMoving then
						if currentTouchMode == DemoApplication.TOUCH_MODE_LEFT_CLICK_UI then
							if not (isScrolling and isMoving) or isDragging then
								Application.mousePress(self, touch.currentX, touch.currentY, DemoApplication.TOUCH_LEFT_MOUSE_BUTTON)
							end
						elseif currentTouchMode == DemoApplication.TOUCH_MODE_LEFT_CLICK_GAME then
							self:getUIView():closePokeMenu()
							self:mouseProbePress(touch.currentX, touch.currentY, DemoApplication.TOUCH_LEFT_MOUSE_BUTTON, false)
						end
					end
				end

				if currentTouchMode == DemoApplication.TOUCH_MODE_LEFT_CLICK_UI then
					if not (isScrolling and isMoving) or isDragging then
						Application.mouseRelease(self, touch.currentX, touch.currentY, DemoApplication.TOUCH_LEFT_MOUSE_BUTTON)
					end
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
					if not (isScrolling and isMoving) or isDragging then
						Application.mousePress(self, touch.startX, touch.startY, DemoApplication.TOUCH_LEFT_MOUSE_BUTTON)
						touch.pressed = true
					end
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

				currentTouchMode = DemoApplication.TOUCH_MODE_NONE
			elseif currentTouchMode == DemoApplication.TOUCH_MODE_RIGHT_CLICK_GAME then
				self:mouseProbePress(touch.currentX, touch.currentY, DemoApplication.TOUCH_RIGHT_MOUSE_BUTTON, false)
				self:mouseProbeRelease(touch.currentX, touch.currentY, DemoApplication.TOUCH_RIGHT_MOUSE_BUTTON, false)
				touch.pressed = true
				touch.released = true

				currentTouchMode = DemoApplication.TOUCH_MODE_NONE
			elseif currentTouchMode == DemoApplication.TOUCH_MODE_DRAG_CAMERA then
				self.cameraController:mousePress(
					false,
					touch.currentX, touch.currentY,
					DemoApplication.TOUCH_MIDDLE_MOUSE_BUTTON)
				touch.pressed = true
			end
		end

		if touch.moved then
			if isMoving and currentTouchMode == DemoApplication.TOUCH_MODE_LEFT_CLICK_UI then
				if isScrolling and not isDragging then
					Application.mouseScroll(
						self,
						-(touch.currentX - touch.previousX),
						(touch.currentY - touch.previousY))

					touch.moved = false
				end
			end

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
		if currentTouchMode == DemoApplication.TOUCH_MODE_LEFT_CLICK_GAME or
		   currentTouchMode == DemoApplication.TOUCH_MODE_DRAG_CAMERA
		then
			currentTouchMode = DemoApplication.TOUCH_MODE_ZOOM_CAMERA
		elseif currentTouchMode == DemoApplication.TOUCH_MODE_ZOOM_CAMERA then
			local touch1 = touches[1]
			local touch2 = touches[2]

			local distanceCurrent = math.sqrt((touch1.currentX - touch2.currentX) ^ 2 + (touch1.currentY - touch2.currentY) ^ 2)
			local distancePrevious = math.sqrt((touch1.previousX - touch2.previousX) ^ 2 + (touch1.previousY - touch2.previousY) ^ 2)

			self.cameraController:mouseScroll(false, 0, (distanceCurrent - distancePrevious) / DemoApplication.TOUCH_SCROLL_DENOMINATOR_GAME)
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
			if self:getGameView():getActor(actor) then
				table.insert(actors, actor)
			end
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
				zoom = gameCamera:getDistance()

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

function DemoApplication:updatePositionProbe()
	local gameView = self:getGameView()

	local player = self:getGame():getPlayer()
	local playerActor = player and player:getActor()
	local playerActorView = playerActor and gameView:getActor(playerActor)
	if not playerActorView then
		return
	end

	local i, j, layer = playerActor:getTile()
	local position = Vector(playerActorView:getSceneNode():getTransform():getGlobalDeltaTransform(0):transformPoint(0, 0, 0))
	local direction = self.currentPlayerDirection

	local a = position + Vector(-2, 0, -2) * direction
	local b = position + Vector(4, 0, 4) * direction

	local probe = Probe(self:getGame(), gameView, self:getGameDB())
	probe:init(Ray(position, direction))
	probe:setBounds(a, b)
	probe:setTile(i, j, layer)
	probe:run()

	local results = probe:toArray()

	for _, shimmeringObject in ipairs(self.shimmeringObjects) do
		shimmeringObject.isPending = true
	end

	for _, result in ipairs(results) do
		local currentShimmeringObject

		for i, shimmeringObject in ipairs(self.shimmeringObjects) do
			if shimmeringObject.objectID == result.objectID and
			   shimmeringObject.objectType == result.objectType
			then
				currentShimmeringObject = shimmeringObject
				break
			end
		end

		if not currentShimmeringObject then
			currentShimmeringObject = {
				objectID = result.objectID,
				objectType = result.objectType,
				time = 0,
				isPending = false,
				isActive = true,
				actions = {}
			}

			table.insert(self.shimmeringObjects, currentShimmeringObject)
		end

		if not currentShimmeringObject.isActive then
			currentShimmeringObject.isActive = true
			currentShimmeringObject.time = DemoApplication.SHIMMER_DURATION - currentShimmeringObject.time
		end

		currentShimmeringObject.actions[result.id] = result
		currentShimmeringObject.isPending = false
	end

	for _, shimmeringObject in ipairs(self.shimmeringObjects) do
		if shimmeringObject.isPending then
			if shimmeringObject.isActive then
				shimmeringObject.isActive = false
				shimmeringObject.time = DemoApplication.SHIMMER_DURATION - shimmeringObject.time
			end
		end
	end
end

function DemoApplication:updateNearbyShimmer(delta)
	local gameView = self:getGameView()

	local playerActorID = self:getGame():getPlayer()
	playerActorID = playerActorID and playerActorID:getActor()
	playerActorID = playerActorID and playerActorID:getID()

	local black = Color(0)
	local attackable = Color.fromHexString(Config.get("Config", "COLOR", "color", "world.shimmer.attackable"))
	local interactive = Color.fromHexString(Config.get("Config", "COLOR", "color", "world.shimmer.interactive"))

	for i = #self.shimmeringObjects, 1, -1 do
		local shimmeringObject = self.shimmeringObjects[i]

		shimmeringObject.time = math.min(shimmeringObject.time + delta, DemoApplication.SHIMMER_DURATION)

		local delta = shimmeringObject.time / DemoApplication.SHIMMER_DURATION
		if not shimmeringObject.isActive then
			delta = 1 - delta
		end

		local node
		if shimmeringObject.objectType == "prop" then
			local prop = gameView:getProp(gameView:getPropByID(shimmeringObject.objectID))
			node = prop and prop:getRoot()
		elseif shimmeringObject.objectType == "actor" then
			local actor = gameView:getActor(gameView:getActorByID(shimmeringObject.objectID))
			node = actor and actor:getSceneNode()
		elseif shimmeringObject.objectType == "item" then
			node = gameView:getItem(shimmeringObject.objectID)
		end

		local isAttackable
		local isOnlyExaminable = true
		for _, action in pairs(shimmeringObject.actions) do
			if action.type:lower() ~= "examine" then
				isOnlyExaminable = false
			end

			if action.type:lower() == "attack" then
				isAttackable = true
			end
		end

		local isShimmering = true
		if shimmeringObject.objectID == playerActorID and shimmeringObject.objectType == "actor" then
			isShimmering = false
		elseif isOnlyExaminable then
			isShimmering = false
		end

		local color
		if isAttackable then
			color = attackable
		else
			color = interactive
		end

		if not shimmeringObject.isActive and shimmeringObject.time == DemoApplication.SHIMMER_DURATION then
			table.remove(self.shimmeringObjects, i)
			isShimmering = false
		elseif isShimmering then
			if node then
				local material = node:getMaterial()
				material:setIsShimmerEnabled(not isOnlyExaminable)
				material:setShimmerColor(black:lerp(color, delta))
			end
		end

		if not isShimmering then
			if node then
				local material = node:getMaterial()
				material:setIsShimmerEnabled(false)
				material:setShimmerColor(Color(1))
			end
		end
	end
end

function DemoApplication:updatePlayerMovement()
	local player = self:getGame():getPlayer()
	if not player then
		return
	end

	local x, z = 0, 0
	if self.hasGyroInput then
		for _, gyroState in pairs(self.currentGyroState) do
			if math.abs(gyroState.left[1]) > x and math.abs(gyroState.left[1]) > 0.1 then
				x = -gyroState.left[1]
			end

			if math.abs(gyroState.left[2]) > z and math.abs(gyroState.left[2]) > 0.1 then
				z = gyroState.left[2]
			end
		end
	else
		local up = Keybinds['PLAYER_1_MOVE_UP']:isDown()
		local down = Keybinds['PLAYER_1_MOVE_DOWN']:isDown()
		local left = Keybinds['PLAYER_1_MOVE_LEFT']:isDown()
		local right = Keybinds['PLAYER_1_MOVE_RIGHT']:isDown()

		if up then
			z = z + 1
		end

		if down then
			z = z - 1
		end

		if left then
			x = x + 1
		end

		if right then
			x = x - 1
		end
	end

	do
		local xAxisKeybind = Config.get("Input", "KEYBIND", "type", "world", "name", "gamepadMoveXAxis")
		local yAxisKeybind = Config.get("Input", "KEYBIND", "type", "world", "name", "gamepadMoveYAxis")
		local axisSensitivity = Config.get("Input", "KEYBIND", "type", "world", "name", "axisSensitivity")

		local inputProvider = self:getUIView():getInputProvider()
		local currentJoystick = inputProvider:getCurrentJoystick()
		if currentJoystick then
			local xAxis = inputProvider:getGamepadAxis(currentJoystick, xAxisKeybind)
			local yAxis = inputProvider:getGamepadAxis(currentJoystick, yAxisKeybind)

			if math.abs(xAxis) > axisSensitivity then
				x = x + -math.sign(xAxis)
			end

			if math.abs(yAxis) > axisSensitivity then
				z = z + -math.sign(yAxis)
			end
		end
	end

	x = math.clamp(x, -1, 1)
	z = math.clamp(z, -1, 1)

	local isMoving = math.abs(x) > 0 or math.abs(z) > 0
	if isMoving then
		local rotation = self:getCamera():getLocalRotation()
		local forward = rotation:getNormal():transformVector(Vector.UNIT_Z):getNormal()
		if forward.z < 0 then
			x = -x
			z = -z
		end

		local focusedWidget = self:getUIView():getInputProvider():getFocusedWidget()
		if not focusedWidget or
		   not focusedWidget:isCompatibleType(require "ItsyScape.UI.TextInput")
		then
			player:move(x, z)
		else
			player:move(0, 0)
		end

		self.currentPlayerDirection = Vector(x, 0, z):getNormal():keep()
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

function DemoApplication:_updateToolTip(probe)
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

	self:updatePositionProbe()
end

function DemoApplication:updateToolTip(delta)
	if _MOBILE or (self.cameraController and not self.cameraController:isCompatibleType(DefaultCameraController)) then
		self:hideToolTip()
		return
	end

	local isUIBlocking = self:getUIView():getInputProvider():isBlocking(itsyrealm.mouse.getPosition())

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
			local mouseX, mouseY = self:getMousePosition()
			self:probe(mouseX, mouseY, false, Function(self._updateToolTip, self), { ['actors'] = true, ['props'] = true, ['loot'] = true }, self.hasGyroInput and DemoApplication.GYRO_RADIUS or 0)

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
				self.toolTipWidget:setPosition(love.graphics.getScaledPoint(itsyrealm.mouse.getPosition()))
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

	Pool.getCurrent():update()

	self:pumpGyroMouse(delta)
	self:updateMobileMouse()

	self:updatePlayerMovement()
	self:updateToolTip(delta)

	self:updateNearbyShimmer(delta)

	self.cameraController:update(delta)

	if self.titleScreen then
		self.titleScreen:update(delta)

		if not self.mainMenu and self.titleScreen:isReady() then
			self:openMainMenu()
		end
	end

	if not _MOBILE then
		local currentCursor = love.mouse.getCursor()
		if self.hasGyroInput or (_DEBUG and (love.keyboard.isDown("rshift") or love.keyboard.isDown("lshift"))) then
			if currentCursor ~= self.blankCursor then
				love.mouse.setCursor(self.blankCursor)
			end
		else
			local _, _, scale = love.graphics.getScaledMode()

			if scale > 1 and currentCursor ~= self.highDPICursor then
				love.mouse.setCursor(self.highDPICursor)
			elseif scale <= 1 and currentCursor ~= self.defaultCursor then
				love.mouse.setCursor(self.defaultCursor)
			end
		end
	end

	self:updatePatchNotes()
end

function DemoApplication:draw(delta)
	self.cameraController:draw()

	Application.draw(self, delta)

	if self.titleScreen then
		self.titleScreen:draw()
	end

	if self.cameraController:getIsDemoing() then
		self.cameraController:demo()
	end

	if self.isScreenshotPending or self.hasGyroInput then
		local _, _, scaleX, scaleY = love.graphics.getScaledMode()
		local cursor, realX, realY
		do
			local cursorFilename
			if self.hasGyroInput and self.currentGyroState and self.currentGyroMouseDeviceID and self.currentGyroState[self.currentGyroMouseDeviceID].isInterfaceBlocking then
				cursorFilename = "Cursor_Mobile"
				realX = self.currentGyroState[self.currentGyroMouseDeviceID].currentX
				realY = self.currentGyroState[self.currentGyroMouseDeviceID].currentY
			else
				cursorFilename = "Cursor"
			end

			local suffix
			if scaleX > 1 then
				suffix = "@2x"
			else
				suffix = ""
			end

			local fullFilename = string.format("Resources/Game/UI/%s%s.png", cursorFilename, suffix)
			if not self.cursors[fullFilename] then
				self.cursors[fullFilename] = love.graphics.newImage(fullFilename)
			end

			cursor = self.cursors[fullFilename]
		end

		local mouseX, mouseY = itsyrealm.mouse.getPosition()
		if realX and realY and (realX ~= mouseX or realY ~= mouseY) then
			love.graphics.push("all")

			love.graphics.setLineWidth(6)
			love.graphics.setColor(0, 0, 0, 0.5)

			love.graphics.line(mouseX, mouseY, realX, realY)
			love.graphics.circle("line", mouseX, mouseY, 12)

			love.graphics.pop()
			mouseY = mouseY - cursor:getHeight() / 2
		end

		love.graphics.draw(cursor, realX or mouseX, realY or mouseY, 0, scaleX, scaleY)

		self.isScreenshotPending = false
	end

	if _DEBUG and _MOBILE then
		local touches = self:getTouches()

		for i = 1, #touches do
			love.graphics.draw(self.mobileCursor, touches[i].currentX, touches[i].currentY)
		end
	end

	if self.isGyroConnecting == true then
		self.gyroIcon = self.gyroIcon or love.graphics.newImage("Resources/Game/UI/Icons/Controllers/NintendoSwitch/switch_joycon.png")

		local delta = love.timer.getTime() * (math.pi / 4)
		local angle = math.cos(delta) * math.sin(delta * 1.5) * (math.pi / 4)
		local offset = math.sin(delta * 0.75) * (self.gyroIcon:getHeight() / 8)

		local width, height = love.window.getMode()
		love.graphics.draw(
			self.gyroIcon,
			width - self.gyroIcon:getWidth() / 2,
			self.gyroIcon:getHeight() / 2 + offset,
			angle,
			0.5,
			0.5,
			self.gyroIcon:getWidth() / 2,
			self.gyroIcon:getHeight() / 2)
	end
end

return DemoApplication
