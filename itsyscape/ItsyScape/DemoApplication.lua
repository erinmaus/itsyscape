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
local Actor = require "ItsyScape.Game.Model.Actor"
local Prop = require "ItsyScape.Game.Model.Prop"
local Color = require "ItsyScape.Graphics.Color"
local OutlinePostProcessPass = require "ItsyScape.Graphics.OutlinePostProcessPass"
local TitleScreen = require "ItsyScape.Graphics.TitleScreen"
local CameraController = require "ItsyScape.Graphics.CameraController"
local DefaultCameraController = require "ItsyScape.Graphics.DefaultCameraController"
local Renderer = require "ItsyScape.Graphics.Renderer"
local SceneNode = require "ItsyScape.Graphics.SceneNode"
local ThirdPersonCamera = require "ItsyScape.Graphics.ThirdPersonCamera"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local Button = require "ItsyScape.UI.Button"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local GamepadGridLayout = require "ItsyScape.UI.GamepadGridLayout"
local GamepadSink = require "ItsyScape.UI.GamepadSink"
local GamepadToolTip = require "ItsyScape.UI.GamepadToolTip"
local GyroButtons = require "ItsyScape.UI.GyroButtons"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local Interface = require "ItsyScape.UI.Interface"
local Keybinds = require "ItsyScape.UI.Keybinds"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local ToolTip = require "ItsyScape.UI.ToolTip"
local Widget = require "ItsyScape.UI.Widget"
local UIView = require "ItsyScape.UI.UIView"
local Controls = require "ItsyScape.UI.Client.Controls"
local GraphicsOptions = require "ItsyScape.UI.Client.GraphicsOptions2"
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

DemoApplication.GAMEPAD_TOGGLE_INTERFACES = {
	"GamepadRibbon",
	"GamepadCombatHUD"
}

DemoApplication.SHIMMER_CURRENT_OBJECT_LABEL_STYLE = function(color)
	return {
		color = { color:get() },
		font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Regular.ttf",
		fontSize = 26,
		textShadow = true
	}
end

function DemoApplication:new()
	Application.new(self, true)

	self.previousPlayerPosition = false
	self.currentPlayerPosition = false
	self.currentPlayerDirection = Vector(1, 0, 0):keep()
	self.shimmeringObjects = {}
	self.pendingObjectID = false
	self.pendingObjectType = false
	self.currentShimmerToolTip = GamepadToolTip()
	self.currentShimmerToolTip:setZDepth(-900)
	self.currentShimmerToolTip:setRowSize(math.huge)
	self.nextShimmerToolTip = GamepadToolTip()
	self.nextShimmerToolTip:setZDepth(-900)
	self.nextShimmerToolTip:setRowSize(math.huge)

	self._sortShimmerObjects = function(a, b)
		if a.objectType ~= b.objectType then
			if a.objectType == "item" then
				return false
			end

			if b.objectType == "item" then
				return true
			end
		end

		local nodeA = self:_getShimmerNodeObject(a)
		local nodeB = self:_getShimmerNodeObject(b)
		local player = self:getGame():getPlayer()

		if nodeA and nodeB then
			if a.objectType == "actor" and b.objectType == "actor" then
				local aHasAttackAction = false
				local bHasAttackAction = false

				for _, action in ipairs(a.actions) do
					if action.type == "Attack" then
						aHasAttackAction = true
						break
					end
				end

				for _, action in ipairs(b.actions) do
					if action.type == "Attack" then
						bHasAttackAction = true
						break
					end
				end

				if aHasAttackAction ~= bHasAttackAction then
					if aHasAttackAction then
						return true
					end

					return false
				else
					local aIsAgressor = false
					local bIsAggressor = false

					local combatHUD = self:getUIView():getInterface("GamepadCombatHUD")
					local state = combatHUD and combatHUD:getState()
					if state and #state.combatants > 1 then
						for _, combatant in ipairs(state.combatants) do
							if combatant.targetID == player:getActor():getID() and combatant.id == a.objectID then
								aIsAgressor = true
							end

							if combatant.targetID == player:getActor():getID() and combatant.id == b.objectID then
								bIsAgressor = true
							end
						end
					end

					if aIsAgressor ~= bIsAgressor then
						if aIsAgressor then
							return true
						end

						return false
					end
				end
			end

			local relativePosition
			do
				player = player and player:getActor()
				player = player and self:getGameView():getActor(player)

				if player then
					relativePosition = Vector.ZERO:transform(player:getSceneNode():getTransform():getGlobalDeltaTransform(0))
				else
					relativePosition = Vector.ZERO
				end
			end

			local positionA = Vector.ZERO:transform(nodeA:getTransform():getGlobalDeltaTransform(0))
			local distanceA = (relativePosition - positionA):getLengthSquared()
			local directionA = relativePosition:direction(positionA):getNormal()
			local dotA = directionA:dot(self.currentPlayerDirection)

			local positionB = Vector.ZERO:transform(nodeB:getTransform():getGlobalDeltaTransform(0))
			local distanceB = (relativePosition - positionB):getLengthSquared()
			local directionB = relativePosition:direction(positionB):getNormal()
			local dotB = directionB:dot(self.currentPlayerDirection)

			local angleA = math.deg(math.acos(math.clamp(dotA, -1, 1)))
			local angleB = math.deg(math.acos(math.clamp(dotB, -1, 1)))

			if math.abs(angleA - angleB) < 8 then
				return distanceA < distanceB
			end

			return dotA < dotB
		end

		if nodeA then
			return true
		end

		return false
	end

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

	--Pool():makeCurrent()
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
	Log.info("Player loaded new map '%s'.", map)

	self:updateMemoryLabel(map)
end

function DemoApplication:clearResourceManagerCache()
	self:getGameView():getResourceManager():clear()
end

function DemoApplication:playItemSoundEffect(player, item)
	self:getUIView():playItemSoundEffect(item, { id = -1, type = "Take" })
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

	love.audio.setDistanceModel('linearclamped')

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
	if _ITSYREALM_DEMO then
		self:openDemoMainMenu()
	else
		self:openFullMainMenu()
	end
end

function DemoApplication:_newDemoPlayer(_, buttonIndex)
	if buttonIndex ~= 1 then
		return
	end

	local filename = "Player/Demo.dat"

	local storage = PlayerStorage()
	storage:getRoot():set("filename", filename)

	self:setPlayerFilename(filename)

	local player = self:getGame():getPlayer()
	player:spawn(storage, true)

	self:closeTitleScreen()
end

function DemoApplication:_loadDemoPlayer(_, buttonIndex)
	if buttonIndex ~= 1 then
		return
	end

	local filename = "Player/Demo.dat"
	local data = love.filesystem.read(filename)

	local storage = PlayerStorage()
	storage:deserialize(data)

	self:setPlayerFilename(filename)

	local player = self:getGame():getPlayer()
	player:spawn(storage, not data)

	self:closeTitleScreen()
end

function DemoApplication:_openGraphicsOptions(_, buttonIndex)
	if buttonIndex ~= 1 then
		return
	end

	self:openOptionsScreen(GraphicsOptions, function(value)
		if value then
			self:_updateGraphicsOptions()
			love.audio.setVolume(_CONF.volume or love.audio.getVolume())
		end

		self:closeMainMenu()
		self:openMainMenu()
	end)
end

function DemoApplication:_layoutDemoButton(button)
	local child = button:getChildAt(1)
	child:update(0)

	local childWidth, childHeight = child:getSize()
	local buttonWidth, buttonHeight = button:getSize()

	child:setPosition(buttonWidth / 2 - childWidth / 2, buttonHeight / 2 - childHeight / 2)
end

function DemoApplication:_quitDemo(_, buttonIndex)
	if buttonIndex ~= 1 then
		return
	end

	love.event.quit()
end

function DemoApplication:_focusDemoButton(button)
	local child = button:getChildAt(1)
	if self:getUIView():getInputProvider():getCurrentJoystick() then
		child:setButtonID("a")
	else
		child:setButtonID("none")
	end

	self:_layoutDemoButton(button)
end

function DemoApplication:_blurDemoButton(button)
	local child = button:getChildAt(1)
	child:setButtonID("none")
	self:_layoutDemoButton(button)
end

function DemoApplication:openDemoMainMenu()
	local w, h = itsyrealm.graphics.getScaledMode()

	local mainMenu = Widget()
	mainMenu:setSize(w, h)

	self.mainMenu = mainMenu

	local gridLayout = GamepadGridLayout()
	gridLayout:setSize(256, 0)
	gridLayout:setUniformSize(true, 256, 64)
	gridLayout:setWrapContents(true)
	gridLayout:setPadding(0, 8)
	gridLayout:setWrapFocus(true)

	local resumeButton = Button()
	resumeButton:setSize(256, 64)
	resumeButton.onClick:register(self._loadDemoPlayer, self)
	resumeButton.onFocus:register(self._focusDemoButton, self)
	resumeButton.onBlur:register(self._blurDemoButton, self)

	local resumeText = GamepadToolTip()
	resumeText:setHasBackground(false)
	resumeText:setRowSize(256, 48)
	resumeText:setText("Resume")
	resumeText:setButtonID("none")
	resumeButton:addChild(resumeText)

	local playButton = Button()
	playButton:setSize(256, 64)
	playButton.onClick:register(self._newDemoPlayer, self)
	playButton.onFocus:register(self._focusDemoButton, self)
	playButton.onBlur:register(self._blurDemoButton, self)

	local playText = GamepadToolTip()
	playText:setHasBackground(false)
	playText:setRowSize(256, 48)
	playText:setText("New Game")
	playText:setButtonID("none")
	playButton:addChild(playText)

	local settingsButton = Button()
	settingsButton:setSize(256, 64)
	settingsButton.onClick:register(self._openGraphicsOptions, self)
	settingsButton.onFocus:register(self._focusDemoButton, self)
	settingsButton.onBlur:register(self._blurDemoButton, self)

	local settingsText = GamepadToolTip()
	settingsText:setHasBackground(false)
	settingsText:setRowSize(256, 48)
	settingsText:setText("Settings")
	settingsText:setButtonID("none")
	settingsButton:addChild(settingsText)

	local quitButton = Button()
	quitButton:setSize(256, 64)
	quitButton.onClick:register(self._quitDemo, self)
	quitButton.onFocus:register(self._focusDemoButton, self)
	quitButton.onBlur:register(self._blurDemoButton, self)

	local quitText = GamepadToolTip()
	quitText:setHasBackground(false)
	quitText:setRowSize(256, 48)
	quitText:setText("Quit")
	quitText:setButtonID("none")
	quitButton:addChild(quitText)

	if love.filesystem.getInfo("Player/Demo.dat") then
		gridLayout:addChild(resumeButton)
	end
	gridLayout:addChild(playButton)
	gridLayout:addChild(settingsButton)

	if not _MOBILE then
		gridLayout:addChild(quitButton)
	end

	self.mainMenu:addChild(gridLayout)
	self:getUIView():getRoot():addChild(self.mainMenu)
	self:getUIView():getInputProvider():setFocusedWidget(gridLayout)

	local gridWidth, gridHeight = gridLayout:getSize()
	gridLayout:setPosition(w / 2 - gridWidth / 2, h - gridHeight - 32)

	gridLayout:update(0)

	local playTextWidth, playTextHeight = playText:getSize()
	playText:setPosition(128 - playTextWidth / 2, 32 - playTextHeight / 2)

	local resumeTextWidth, resumeTextHeight = resumeText:getSize()
	resumeText:setPosition(128 - resumeTextWidth / 2, 32 - resumeTextHeight / 2)

	local settingsTextWidth, settingsTextHeight = settingsText:getSize()
	settingsText:setPosition(128 - settingsTextWidth / 2, 32 - settingsTextHeight / 2)

	local quitTextWidth, quitTextHeight = quitText:getSize()
	quitText:setPosition(128 - quitTextWidth / 2, 32 - quitTextHeight / 2)

	if self.titleScreen then
		self.titleScreen:enableLogo()
	end

	self:setConf({
		_DEBUG = _DEBUG or (_CONF and _CONF.debug),
		_CONF = _CONF
	})
end

function DemoApplication:_updateGraphicsOptions()
	local w, h, flags = love.window.getMode()
	love.window.setMode(_CONF.width or w, _CONF.height or h, {
		fullscreen = _CONF.fullscreen == nil and flags.fullscreen or not not _CONF.fullscreen,
		vsync = _CONF.vsync == nil and flags.vsync or _CONF.vsync,
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

function DemoApplication:openFullMainMenu()
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
				self:_updateGraphicsOptions()
			end
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

	if _ITSYREALM_DEMO then
		return
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

	self:getUIView():getInputProvider():setFocusedWidget(optionsScreen, "open")
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

function DemoApplication:toggleUI(hud)
	for _, interfaceID in ipairs(DemoApplication.GAMEPAD_TOGGLE_INTERFACES) do
		if interfaceID ~= hud then
			local interface = self:getUIView():getInterface(interfaceID)
			if interface and interface:getIsShowing() then
				interface:toggle()
			end
		end
	end

	local interface = self:getUIView():getInterface(hud)
	if interface then
		interface:toggle()
	end
end

function DemoApplication:gamepadRelease(joystick, button)
	Application.gamepadRelease(self, joystick, button)

	local inputProvider = self:getUIView():getInputProvider()
	if not inputProvider:isCurrentJoystick(joystick) then
		return
	end

	local cycleTargetButton = Config.get("Input", "KEYBIND", "type", "world", "name", "gamepadCycleTarget")
	local gamepadProbe = Config.get("Input", "KEYBIND", "type", "world", "name", "gamepadProbe")
	local gamepadAction = Config.get("Input", "KEYBIND", "type", "world", "name", "gamepadAction")

	local focusedWidget = inputProvider:getFocusedWidget()
	if not focusedWidget then
		if button == cycleTargetButton then
			self:nextShimmer()
		elseif button == gamepadProbe then
			self:probeCurrentShimmer(false)
		elseif button == gamepadAction then
			self:probeCurrentShimmer(true)
		end
	end

	local combatRing = self:getUIView():getInterface("GamepadCombatHUD")
	local ribbon = self:getUIView():getInterface("GamepadRibbon")

	if combatRing and combatRing:getIsShowing() and button == inputProvider:getKeybind("gamepadOpenCombatRing") then
		self:toggleUI("GamepadCombatHUD")
		return
	elseif ribbon and ribbon:getIsShowing() and button == inputProvider:getKeybind("gamepadOpenRibbon") then
		self:toggleUI("GamepadRibbon")
		return
	end

	if focusedWidget and self:isInterfaceBlockingGamepadMovement() then
		if focusedWidget:hasParent(combatRing) or focusedWidget:hasParent(ribbon) then
			return
		end
	end

	if button == inputProvider:getKeybind("gamepadOpenCombatRing") then
		self:toggleUI("GamepadCombatHUD")
	elseif button == inputProvider:getKeybind("gamepadOpenRibbon") then
		self:toggleUI("GamepadRibbon")
	elseif button == inputProvider:getKeybind("gamepadToggleTargetCamera") then
		_CONF.targetCameraMode = not _CONF.targetCameraMode
	end
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

			local sx, sy = itsyrealm.graphics.getScaledPoint(touch.startX, touch.startY)
			local cx, cy = itsyrealm.graphics.getScaledPoint(touch.currentX, touch.currentY)

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

		local outlinePostProcessPass = OutlinePostProcessPass(renderer)
		outlinePostProcessPass:load(self:getGameView():getResourceManager())

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

			renderer:draw(view:getSceneNode(), self:getFrameDelta(), 1024, 1024, { outlinePostProcessPass })
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

function DemoApplication:_getObjectUIPosition(object, y, padding)
	local gameView = self:getGameView()

	local min, max
	local layer

	if Class.isCompatibleType(object, Prop) then
		local i, j, k = object:getTile()
		layer = k
		min, max = object:getBounds()

		local propView = gameView:getProp(object)
		if propView then
			local position = Vector.ZERO:transform(propView:getRoot():getTransform():getGlobalDeltaTransform(self:getFrameDelta()))
			local size = max - min
			local halfSize = size / 2
			min, max = position - halfSize, position + Vector(halfSize.x, 1.5, halfSize.z)
		end
	elseif Class.isCompatibleType(object, Actor) then
		local i, j, k = object:getTile()
		layer = k
		min, max = object:getBounds()

		local actorView = gameView:getActor(object)
		if actorView then
			local position = Vector.ZERO:transform(actorView:getSceneNode():getTransform():getGlobalDeltaTransform(self:getFrameDelta()))
			local size = max - min
			local halfSize = size / 2
			min, max = position - halfSize, position + Vector(halfSize.x, 1.5, halfSize.z)
		end
	elseif Class.isCompatibleType(object, Vector) then
		min = object
		max = object
	elseif Class.isCompatibleType(object, Probe.Item) then
		local i, j, k = object:getTile()
		layer = k
		min = object:getPosition() - Vector(0.25, 0, 0.25)
		max = object:getPosition() + Vector(0.25, 1, 0.25)

		if layer then
			local node = gameView:getMapSceneNode(layer)
			local transform = node and node:getTransform():getGlobalDeltaTransform(self:getFrameDelta())
			if transform then
				min, max = Vector.transformBounds(min, max, transform)
			end
		end
	end

	local size = max - min
	local halfSize = size / 2

	local top = Vector(min.x, min.y, min.z) + Vector(halfSize.x, size.y, halfSize.z)
	local bottom = Vector(min.x, min.y, min.z) + Vector(halfSize.x, 0, halfSize.z)

	local camera = self:getCamera()

	local uiTop = camera:project(top)
	local uiBottom = camera:project(bottom)

	padding = padding or 0
	local x = uiBottom.x + (uiTop.x - uiBottom.x) / 2
	local y = math.lerp(uiBottom.y + padding, uiTop.y - padding, y)

	return itsyrealm.graphics.getScaledPoint(x, y)
end

function DemoApplication:_getShimmerNodeObject(shimmeringObject)
	local gameView = self:getGameView()
	local stage = self:getGame():getStage()

	local node, object
	if shimmeringObject.objectType == "prop" then
		object = gameView:getPropByID(shimmeringObject.objectID)

		local propView = gameView:getProp(object)
		node = propView and propView:getRoot()
	elseif shimmeringObject.objectType == "actor" then
		object = gameView:getActorByID(shimmeringObject.objectID)

		local actorView = gameView:getActor(object)
		node = actorView and actorView:getSceneNode()
	elseif shimmeringObject.objectType == "item" then
		local item = stage:getItem(shimmeringObject.objectID)
		if not item then
			return nil, nil
		end

		object = Probe.Item(item)
		node = gameView:getItem(shimmeringObject.objectID)
	end

	return node, object
end

function DemoApplication:layoutShimmerExamine(x, y, toolTip)
	local toolTipWidth, toolTipHeight = toolTip:getSize()
	toolTip:setPosition(x - toolTipWidth / 2, y - toolTipHeight / 2)
end

function DemoApplication:examineShimmer(name, description, object)
	local toolTip = self:getUIView():examine(name, description)
	local x, y = self:_getObjectUIPosition(object, 0.5)
	toolTip.onLayout:register(self.layoutShimmerExamine, self, x, y)
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
	local position = Vector.ZERO:transform(playerActorView:getSceneNode():getTransform():getGlobalDeltaTransform(0))
	local direction = self.currentPlayerDirection

	local probe = Probe(self:getGame(), gameView, self:getGameDB())
	local coneLength = 10
	local coneRadius = 6
	probe.onExamine:register(self.examineShimmer, self)
	probe:conecast(Ray(position - direction * 1.5, direction), coneLength, coneRadius)
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
				object = result.object,
				objectID = result.objectID,
				objectType = result.objectType,
				time = 0,
				isPending = false,
				isActive = true,
				actions = {}
			}

			table.insert(self.shimmeringObjects, currentShimmeringObject)
		elseif currentShimmeringObject.isPending then
			table.clear(currentShimmeringObject.actions)
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

	table.sort(self.shimmeringObjects, self._sortShimmerObjects)

	if self.pendingObjectID and self.pendingObjectType then
		local hasPendingObject = false
		for _, shimmeringObject in ipairs(self.shimmeringObjects) do
			if self.pendingObjectID == shimmeringObject.objectID and self.pendingObjectType == shimmeringObject.objectType and shimmeringObject.isActive then
				hasPendingObject = true
				break
			end
		end

		if not hasPendingObject then
			self:nextShimmer()
		end
	end
end

function DemoApplication:getNextShimmer(pendingObjectID, pendingObjectType)
	local currentIndex

	local shimmerCandidates = {}
	for i, shimmeringObject in ipairs(self.shimmeringObjects) do
		local isOnlyExaminable = true
		for _, action in pairs(shimmeringObject.actions) do
			if (action.type:lower() ~= "examine" and action.type:lower() ~= "walk") and not action.suppress then
				isOnlyExaminable = false
			end
		end

		if not isOnlyExaminable and shimmeringObject.isActive then
			table.insert(shimmerCandidates, shimmeringObject)
			if pendingObjectID == shimmeringObject.objectID and pendingObjectType == shimmeringObject.objectType then
				currentIndex = #shimmerCandidates
			end
		end
	end

	if not currentIndex and #shimmerCandidates > 0 then
		if self.pendingObjectType == "item" then
			for i = #shimmerCandidates, 1, -1 do
				local shimmerCandidate = shimmerCandidates[i]

				if shimmerCandidate.objectType == "item" then
					return shimmerCandidate.objectID, shimmerCandidate.objectType
				end
			end
		end

		return shimmerCandidates[1].objectID, shimmerCandidates[1].objectType
	end

	if #shimmerCandidates == 0 then
		return false, false
	end

	local nextIndex = math.wrapIndex(currentIndex, 1, #shimmerCandidates)
	local candidate = shimmerCandidates[nextIndex]
	if candidate and not (candidate.objectID == pendingObjectID and candidate.objectType == pendingObjectType ) then
		return candidate.objectID, candidate.objectType
	end

	return false, false
end

function DemoApplication:nextShimmer()
	self.pendingObjectID, self.pendingObjectType = self:getNextShimmer(self.pendingObjectID, self.pendingObjectType)
	self.nextObjectID, self.nextObjectType = self:getNextShimmer(self.pendingObjectID, self.pendingObjectType)
end

local function _sortActions(a, b)
	return a.depth < b.depth
end

function DemoApplication:getShimmerActions(shimmeringObject)
	local actions = {}

	for _, action in pairs(shimmeringObject.actions) do
		table.insert(actions, action)
	end

	table.sort(actions, _sortActions)

	return actions
end

function DemoApplication:probeCurrentShimmer(performDefault)
	local actions

	local node, object
	for i, shimmeringObject in ipairs(self.shimmeringObjects) do
		if self.pendingObjectID == shimmeringObject.objectID and self.pendingObjectType == shimmeringObject.objectType then
			actions = self:getShimmerActions(shimmeringObject)
			node, object = self:_getShimmerNodeObject(shimmeringObject)
		end
	end

	if not (node and object and actions) then
		return
	end

	if performDefault then
		for _, action in ipairs(actions) do
			if action.type:lower() ~= "examine" and not action.suppress then
				local x, y = self:_getObjectUIPosition(object, 0.5)
				self.clickActionType = Application.CLICK_ACTION
				self.clickActionTime = Application.CLICK_DURATION
				self.clickX, self.clickY = x, y

				local s, r = pcall(action.callback)
				if not s then
					Log.warn("Couldn't perform action: %s", r)
				end

				break
			end
		end
	else
		local x, y = self:_getObjectUIPosition(object, 0.25)
		self:getUIView():probe(actions, x, y, true, false)
	end
end

function DemoApplication:updateNearbyShimmer(delta)
	local isShimmerEnabled = not not self:getUIView():getInputProvider():getCurrentJoystick()

	local playerActorID = self:getGame():getPlayer()
	playerActorID = playerActorID and playerActorID:getActor()
	playerActorID = playerActorID and playerActorID:getID()

	local attackable = Color.fromHexString(Config.get("Config", "COLOR", "color", "world.shimmer.attackable"))
	local interactive = Color.fromHexString(Config.get("Config", "COLOR", "color", "world.shimmer.interactive"))
	local unselected = Color.fromHexString(Config.get("Config", "COLOR", "color", "world.shimmer.unselected"))

	local hasActive = false
	local hasNext = false
	for i = #self.shimmeringObjects, 1, -1 do
		local shimmeringObject = self.shimmeringObjects[i]

		shimmeringObject.time = math.min(shimmeringObject.time + delta, DemoApplication.SHIMMER_DURATION)

		local delta = shimmeringObject.time / DemoApplication.SHIMMER_DURATION
		if not shimmeringObject.isActive then
			delta = 1 - delta
		end

		local node, object = self:_getShimmerNodeObject(shimmeringObject)

		local isAttackable
		local isOnlyExaminable = true
		for _, action in pairs(shimmeringObject.actions) do
			if (action.type:lower() ~= "examine" and action.type:lower() ~= "walk") and not action.suppress then
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

		if isShimmering and not (self.pendingObjectID and self.pendingObjectType) and shimmeringObject.isActive then
			self.pendingObjectID = shimmeringObject.objectID
			self.pendingObjectType = shimmeringObject.objectType
			self.nextObjectID, self.nextObjectType = self:getNextShimmer(self.pendingObjectID, self.pendingObjectType)
		end

		local isActive = self.pendingObjectID == shimmeringObject.objectID and self.pendingObjectType == shimmeringObject.objectType and not isOnlyExaminable
		local isNext = self.nextObjectID == shimmeringObject.objectID and self.nextObjectType == shimmeringObject.objectType

		local color
		if isActive then
			if isAttackable then
				color = Color(attackable:get())
			else
				color = Color(interactive:get())
			end

			local toolTipTextColor
			if shimmeringObject.objectType == "actor" then
				toolTipTextColor = "ui.poke.actor"
			elseif shimmeringObject.objectType == "prop" then
				toolTipTextColor = "ui.poke.prop"
			elseif shimmeringObject.objectType == "item" then
				toolTipTextColor = "ui.poke.item"
			else
				toolTipTextColor = "ui.poke.misc"
			end

			if node then
				local action = self:getShimmerActions(shimmeringObject)[1]
				if action and isShimmerEnabled then
					local toolTipX, toolTipY = self:_getObjectUIPosition(object, 0)
					self.currentShimmerToolTip:setPosition(toolTipX, toolTipY)
					self.currentShimmerToolTip:setText(
						{
							"ui.text",
							action.verb,
							"ui.text",
							" ",
							toolTipTextColor,
							shimmeringObject.object
						})
					self:getUIView():getRoot():addChild(self.currentShimmerToolTip)
				else
					self:getUIView():getRoot():removeChild(self.currentShimmerToolTip)
				end

				hasActive = true
			end
		else
			color = Color(unselected:get())
		end

		if isNext then
			hasNext = true

			local toolTipTextColor
			if shimmeringObject.objectType == "actor" then
				toolTipTextColor = "ui.poke.actor"
			elseif shimmeringObject.objectType == "prop" then
				toolTipTextColor = "ui.poke.prop"
			elseif shimmeringObject.objectType == "item" then
				toolTipTextColor = "ui.poke.item"
			else
				toolTipTextColor = "ui.poke.misc"
			end

			self.nextShimmerToolTip:setText({
				"ui.text",
				"Switch",
				"ui.text",
				" ",
				toolTipTextColor,
				shimmeringObject.object
			})

			self.nextShimmerToolTip:setButtonID("x")
		end

		if not shimmeringObject.isActive and shimmeringObject.time == DemoApplication.SHIMMER_DURATION then
			table.remove(self.shimmeringObjects, i)
			isShimmering = false
		elseif isShimmering then
			if node then
				color.a = delta

				local material = node:getMaterial()
				material:setIsShimmerEnabled(isShimmerEnabled and not isOnlyExaminable)
				material:setShimmerColor(color)
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

	if not hasActive then
		self:getUIView():getRoot():removeChild(self.currentShimmerToolTip)
		self:getUIView():getRoot():removeChild(self.nextShimmerToolTip)
	else
		if hasNext and isShimmerEnabled then
			self:getUIView():getRoot():addChild(self.nextShimmerToolTip)

			local currentX, currentY = self.currentShimmerToolTip:getPosition()
			local currentWidth, currentHeight = self.currentShimmerToolTip:getSize()

			self.nextShimmerToolTip:setPosition(currentX, currentY + currentHeight + 4)
		else
			self:getUIView():getRoot():removeChild(self.nextShimmerToolTip)
		end
	end
end

function DemoApplication:isInterfaceBlockingGamepadMovement()
	local inputProvider = self:getUIView():getInputProvider()
	local focusedWidget = inputProvider:getFocusedWidget()

	if not focusedWidget then
		return false
	end

	local interfaceParent = focusedWidget:getParentOfType(Interface)
	local gamepadSink = interfaceParent and interfaceParent:getData(GamepadSink)
	gamepadSink = gamepadSink or focusedWidget:getParentData(GamepadSink)

	return gamepadSink and gamepadSink:getIsBlocking()
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
		if currentJoystick and not self:isInterfaceBlockingGamepadMovement() then
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
		if (not self.lastToolTipObject or (self.lastToolTipObject.objectType ~= action.objectType or self.lastToolTipObject.objectID ~= action.objectID)) or not self.showingToolTip then
			self.toolTip = {
				ToolTip.Header(text),
				ToolTip.Text(action.description)
			}
			self.lastToolTipObject = {
				objectType = action.objectType,
				objectID = action.objectID
			}

			renderer:unsetToolTip(self.toolTipWidget)
			self.toolTipWidget = nil
		end
	else
		self:hideToolTip()
	end
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

	self:updatePositionProbe()
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

	--Pool.getCurrent():update()

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
