--------------------------------------------------------------------------------
-- ItsyScape/TalkingTinkererApplication.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Application = require "ItsyScape.Application"
local LipSync = require "ItsyScape.Audio.LipSync"
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local CacheRef = require "ItsyScape.Game.CacheRef"
local Equipment = require "ItsyScape.Game.Equipment"
local ActorView = require "ItsyScape.Graphics.ActorView"
local Color = require "ItsyScape.Graphics.Color"
local DefaultCameraController = require "ItsyScape.Graphics.DefaultCameraController"
local Renderer = require "ItsyScape.Graphics.Renderer"
local ResourceManager = require "ItsyScape.Graphics.ResourceManager"
local ThirdPersonCamera = require "ItsyScape.Graphics.ThirdPersonCamera"
local ModelSkin = require "ItsyScape.Game.Skin.ModelSkin"

local TalkingTinkererApplication = Class(Application)

TalkingTinkererApplication.FPS = 60
TalkingTinkererApplication.END_DELAY_SECONDS = 1
TalkingTinkererApplication.HEIGHT = 1920
TalkingTinkererApplication.WIDTH = 1080

TalkingTinkererApplication.VOWEL_TO_SHAPE = {
	a = "d",
	e = "b",
	i = "d",
	o = "f",
	u = "e",
	space = "a"
}

function TalkingTinkererApplication:new()
	Application.new(self)

	local gameView = self:getGameView()
	gameView:getResourceManager():setFrameDuration(math.huge)

	self.cameraController = DefaultCameraController(self)

	self.targetRenderer = Renderer()

	self:initTinkerer()
	self:loadTranscript()

	self.cameraController.cameraOffset = Vector(0, 5, 0)

	self.config = setfenv(loadstring("return " .. love.filesystem.read("voice.cfg") or "{}"), {})()
	self.lipSync = LipSync()
	self:updatePhonemes()
	self:loadCamera()

	self.recordingDevice = love.audio.getRecordingDevices()[1]
	if self.recordingDevice then
		local success = self.recordingDevice:start(1024)
		if not success then
			Log.error("Couldn't record from recording device '%s'.", self.recordingDevice:getName())
			love.event.quit(1)
		end
	else
		Log.error("No recording devices.")
		love.event.quit(1)
	end

	self.lipSync.onResult:register(self.onLipSyncAnimation, self)
end

function TalkingTinkererApplication:initTinkerer()
	local resource = _ARGS[#_ARGS - 1]

	local stage = self:getGame():getStage()
	local success, actor = stage:spawnActor("resource://" .. resource, 1, "::orphan")

	if not success then
		Log.error("Couldn't spawn Tinkerer.")

		love.event.quit(1)
	end

	self.target = resource
	self.targetActor = actor
	self.targetPeep = actor:getPeep()
	self.targetView = ActorView(self.targetActor)
	self.targetView:attach(self:getGameView())

	self.targetPeep:listen("finalize", function()
		self:playAnimation({ animation = "Idle" }, "idle", 0)
	end)
end

function TalkingTinkererApplication:loadTranscript()
	local filename = _ARGS[#_ARGS]

	self.animations = {}
	self.maxTime = 0

	local success, error
	do
		success, error = pcall(function()
			for line in io.lines(filename) do
				local time, animation = line:match("(%d*%.%d*)%s*(%w*)")

				table.insert(self.animations, {
					time = tonumber(time),
					animation = animation
				})

				Log.info("At '%f' seconds, animation '%s' plays.", time or -1, animation or "<BAD>")

				self.maxTime = math.max(self.maxTime, time)
			end
		end)

		if success then
			Log.info("Loaded animations.")
		else
			Log.warn("Couldn't load animations: %s", error)
		end
	end
	do
		success, error = pcall(function()
			for line in io.lines(filename .. ".anim") do
				local time, animation = line:match("(%d*%.%d*)%s*([%w%d_]*)")

				table.insert(self.animations, {
					time = tonumber(time),
					animation = animation
				})

				Log.info("At '%f' seconds, animation '%s' plays.", time or -1, animation or "<BAD>")

				self.maxTime = math.max(self.maxTime, time)
			end

			table.sort(self.animations, function(a, b) return a.time < b.time end)
		end)

		if success then
			Log.info("Loaded animation supplement.")
		else
			Log.warn("Couldn't load animation supplement: %s", error)
		end
	end
end

function TalkingTinkererApplication:getCurrentFrame(currentTime)
	local animation = self.animations[0]
	for i = 2, #self.animations do
		local a = self.animations[i]

		if a.time and a.time < currentTime then
			animation = a
		else
			break
		end
	end

	return animation
end

function TalkingTinkererApplication:playAnimation(nextFrame, channel, priority)
	local animation = nextFrame.animation or "<BAD>"

	local skinFilename = string.format("Resources/Game/Skins/%s/%s_%s.lua", self.target, self.target, animation)
	local animationFilename = string.format("Resources/Game/Animations/%s_%s/Script.lua", self.target, animation)

	if love.filesystem.getInfo(skinFilename) then
		local body = CacheRef("ItsyScape.Game.Skin.ModelSkin", skinFilename)
		self.targetView:changeSkin(Equipment.PLAYER_SLOT_BODY, 0, body)
		Log.info("Changed skin to '%s'", skinFilename)
	elseif love.filesystem.getInfo(animationFilename) then
		local animation = CacheRef("ItsyScape.Graphics.AnimationResource", animationFilename)

		if animationFilename:match(".*Idle.*") then
			Log.info("Changed idle animation to '%s'", animationFilename)
			self.targetView:playAnimation(channel or 'idle', animation, priority or 0, 0)
		else
			Log.info("Changed animation to '%s'", animationFilename)
			self.targetView:playAnimation(channel or 'main', animation, priority or 1, 0)
		end

	end

	local gameView = self:getGameView()
	gameView:getResourceManager():update()
end

function TalkingTinkererApplication:onLipSyncAnimation(_, event)
	local updatedPhonemes = false
	for vowel, shape in pairs(self.VOWEL_TO_SHAPE) do
		if love.keyboard.isDown(vowel) then
			local foundPhoneme = false
			for i = 1, #self.config do
				if self.config[i].vowel == vowel then
					self.config[i].mfcc = event.mfcc
					foundPhoneme = true
					break
				end
			end

			if not foundPhoneme then
				table.insert(self.config, {
					vowel = vowel,
					mfcc = event.mfcc
				})
			end

			updatedPhonemes = true
		end
	end

	if updatedPhonemes then
		self:updatePhonemes()
	end

	if event.phonemeIndex then
		local phoneme = self.config[event.phonemeIndex]
		local vowel = phoneme.vowel
		local shape = self.VOWEL_TO_SHAPE[vowel]

		if event.phonemeIndex ~= self.lastPhonemeIndex then
			self:playAnimation({ animation = shape:upper() })
			self.lastPhonemeIndex = event.phonemeIndex
		end
	end
end

function TalkingTinkererApplication:updatePhonemes()
	local phonemes = {}
	for i = 1, #self.config do
		phonemes[i] = self.config[i].mfcc
	end

	self.lipSync:updatePhonemes(phonemes)
end

function TalkingTinkererApplication:loadCamera()
	local cameraConfig = self.config.camera or {}

	self.cameraController.cameraOffset = Vector(unpack(cameraConfig.position or { 0, 0, 0 }))
	self.cameraController.targetDistance = cameraConfig.distance or self.cameraController.targetDistance

	local gameCamera = self:getCamera()
	gameCamera:setHorizontalRotation(cameraConfig.horizontalRotation or gameCamera:getHorizontalRotation())
	gameCamera:setVerticalRotation(cameraConfig.verticalRotation or gameCamera:getVerticalRotation())
	gameCamera:setDistance(cameraConfig.distance or gameCamera:getDistance())
end

function TalkingTinkererApplication:renderTick()
	local gameCamera = self:getCamera()
	gameCamera:setWidth(self.WIDTH)
	gameCamera:setHeight(self.HEIGHT)

	self.targetRenderer:setClearColor(Color(0, 0, 0, 0))
	self.targetRenderer:setCullEnabled(true)
	self.targetRenderer:setCamera(gameCamera)

	love.graphics.push('all')
	self.targetRenderer:draw(
		self.targetView:getSceneNode(),
		0,
		self.WIDTH,
		self.HEIGHT)
	love.graphics.pop()

	return self.targetRenderer:getOutputBuffer():getColor():newImageData()
end

function TalkingTinkererApplication:drawTinkerer()
	self.recordingDevice:stop(1024)

	local suffix = os.date("%Y-%m-%d %H%M%S")
	directory = string.format("Tinkerer %s", suffix)

	love.filesystem.createDirectory(directory)

	local endTime = self.maxTime + self.END_DELAY_SECONDS
	local currentTime = 0
	local deltaPerTick = 1 / self.FPS

	local currentFrame = nil

	self:playAnimation({ animation = "Idle" }, "idle", 0)
	self:playAnimation({ animation = "A" })

	local index = 0
	while currentTime <= endTime do
		local nextFrame = self:getCurrentFrame(currentTime)

		if currentFrame ~= nextFrame then
			self:playAnimation(nextFrame)

			currentFrame = nextFrame
		end

		self:getGameView():update(deltaPerTick)
		self.targetView:update(deltaPerTick)

		local image = self:renderTick()
		image:encode('png', string.format("%s/%05d.png", directory, index))

		currentTime = currentTime + deltaPerTick
		index = index + 1
	end

	local url = string.format("%s/%s", love.filesystem.getSaveDirectory(), directory)
	Log.info("Saved Tinkerer animation to directory '%s'", url)

	love.filesystem.write("tinkerer.txt", url)
end

function TalkingTinkererApplication:keyDown(key, ...)
	if key == "r" then
		self:drawTinkerer()
	end

	return Application.keyDown(self, key, ...)
end

function TalkingTinkererApplication:mousePress(x, y, button)
	Application.mousePress(self, x, y, button)
	self.cameraController:mousePress(false, x, y, button)
end

function TalkingTinkererApplication:mouseRelease(x, y, button)
	Application.mouseRelease(self, x, y, button)
	self.cameraController:mouseRelease(false, x, y, button)
end

function TalkingTinkererApplication:mouseScroll(x, y)
	Application.mouseScroll(self, x, y)
	self.cameraController:mouseScroll(false, x, y)
end

function TalkingTinkererApplication:mouseMove(x, y, dx, dy)
	Application.mouseMove(self, x, y, dx, dy)
	self.cameraController:mouseMove(false, x, y, dx, dy)
end

function TalkingTinkererApplication:update(delta)
	Application.update(self, delta)
	self.cameraController:update(delta)
	self.targetView:update(delta)

	self.lipSync:update(self.recordingDevice:getData())
end

function TalkingTinkererApplication:draw()
	local w, h = love.window.getMode()

	self.cameraController:draw()
	local gameCamera = self:getCamera()
	gameCamera:setWidth(w)
	gameCamera:setHeight(h)

	self.targetRenderer:setClearColor(Color(0, 1, 0, 1))
	self.targetRenderer:setCullEnabled(true)
	self.targetRenderer:setCamera(gameCamera)

	love.graphics.push('all')
	self.targetRenderer:draw(
		self.targetView:getSceneNode(),
		self:getFrameDelta(),
		w, h)
	love.graphics.pop()

	love.graphics.draw(self.targetRenderer:getOutputBuffer():getColor())
end

function TalkingTinkererApplication:quit()
	Application.quit(self)

	local gameCamera = self:getCamera()
	self.config.camera = {
		position = { self.cameraController.cameraOffset:get() },
		horizontalRotation = gameCamera:getHorizontalRotation(),
		verticalRotation= gameCamera:getVerticalRotation(),
		distance = gameCamera:getDistance()
	}

	local serpent = require "serpent"
	local phonemes = serpent.block(self.config, { comment = false })
	love.filesystem.write("voice.cfg", phonemes)
end

return TalkingTinkererApplication
