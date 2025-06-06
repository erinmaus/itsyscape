--------------------------------------------------------------------------------
-- ItsyScape/UI/DialogBoxController.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Callback = require "ItsyScape.Common.Callback"
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local BackgroundPacket = require "ItsyScape.Game.Dialog.BackgroundPacket"
local Dialog = require "ItsyScape.Game.Dialog.Dialog"
local InkDialog = require "ItsyScape.Game.Dialog.InkDialog"
local InputPacket = require "ItsyScape.Game.Dialog.InputPacket"
local MessagePacket = require "ItsyScape.Game.Dialog.MessagePacket"
local SelectPacket = require "ItsyScape.Game.Dialog.SelectPacket"
local SpeakerPacket = require "ItsyScape.Game.Dialog.SpeakerPacket"
local Color = require "ItsyScape.Graphics.Color"
local Probe = require "ItsyScape.Peep.Probe"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local PropReferenceBehavior = require "ItsyScape.Peep.Behaviors.PropReferenceBehavior"
local Controller = require "ItsyScape.UI.Controller"

local DialogBoxController = Class(Controller)

function DialogBoxController:new(peep, director, action, target, overrideEntryPoint)
	Controller.new(self, peep, director)

	Analytics:talkedToNPC(peep, target, action)

	self.action = action
	self.target = target
	self.hidRibbonTab = false
	self.talkCharacter = false

	if target then
		target:poke('talkingStart')
	end

	self.state = {}
	do
		-- TODO: respect language
		local gameDB = director:getGameDB()
		local dialogRecord = gameDB:getRecord("TalkDialog", { Action = self.action:getAction(), Language = "en-US" })
		local characterRecord = gameDB:getRecord("TalkCharacter", { Action = self.action:getAction() })

		if dialogRecord or characterRecord then
			if dialogRecord then
				local filename = dialogRecord:get("Script")
				if overrideEntryPoint and overrideEntryPoint ~= "" then
					self.dialog = Dialog(overrideEntryPoint)
				else
					self.dialog = Dialog(filename)
				end
			elseif characterRecord then
				self.talkCharacter = characterRecord:get("Character")

				local characterName = self.talkCharacter.name
				local filename = string.format("Resources/Game/Dialog/%s/Dialog.json", characterName)
				self.dialog = InkDialog(filename, self:getVariables())
				self.dialog.onSetVariable:register(self.saveVariable, self)

				Utility.Text.bind(self.dialog, nil, "en-US")

				local commonPath = string.format("Resources.Game.Dialog.%s.Common", characterName)
				local s, r = pcall(require, commonPath)
				if s then
					Utility.Text.bind(self.dialog, r, "en-US")
				else
					if love.filesystem.getInfo(string.format("Resources/Game/Dialog/%s/Common.lua", characterName)) or
					   love.filesystem.getInfo(string.format("Resources/Game/Dialog/%s/Common/init.lua", characterName))
				   	then
				   		Log.warn("Couldn't load common dialog '%s' for '%s': %s", commonPath, characterName, r)
				   	end
				end

				if overrideEntryPoint and overrideEntryPoint ~= "" then
					self.dialog:jump(overrideEntryPoint)
				elseif characterRecord:get("Main") ~= "" then
					self.dialog:jump(characterRecord:get("Main"))
				end
			end

			if self.dialog then
				self.dialog:setTarget(peep)
				self.dialog:setSpeaker("_SELF", self.target)
				self.dialog:setDirector(director)

				local speakers = gameDB:getRecords("TalkSpeaker", { Action = self.action:getAction() })
				for i = 1, #speakers do
					local speaker = speakers[i]
					local peeps = director:probe(
						peep:getLayerName(),
						Probe.mapObject(speaker:get("Resource")),
						Probe.instance(Utility.Peep.getPlayerModel(peep), true))

					local s = peeps[1]
					if not s then
						Log.info("Speaker '%s' not found as map object.", speaker:get("Name"))

						local r = speaker:get("Resource")
						peeps = director:probe(
							peep:getLayerName(),
							Probe.resource(r),
							Probe.instance(Utility.Peep.getPlayerModel(peep), true))
						s = peeps[1]

						if not s then
							Log.info("Speaker '%s' not found as resource on same layer as player.", speaker:get("Name"))
							peeps = director:probe(
								peep:getLayerName(),
								Probe.resource(r))
							s = peeps[1]

							if not s then
								Log.info("Speaker '%s' not found as resource in same instance as player.", speaker:get("Name"))
							end
						end
					end

					if s then
						self.dialog:setSpeaker(speaker:get("Name"), s)
					else
						Log.warn("Speaker '%s' not found at all.", speaker:get("Name"))
					end
				end

				self:pump()
			end
		end
	end

	self.needsPump = true

	self.onClose = Callback()
	self.isClosing = false
end

function DialogBoxController:getStorage()
	return self:getDirector():getPlayerStorage(self:getPeep()):getRoot():getSection("Player"):getSection("Dialog")
end

function DialogBoxController:saveVariable(_, name, value)
	if not self.talkCharacter then
		return
	end

	local storage = self:getStorage()
	local characterDialogStorage = storage:getSection(self.talkCharacter.name)

	characterDialogStorage:unset(name)
	characterDialogStorage:set(name, value)
end

function DialogBoxController:getDefaultVariables()
	return {
		player_name = string.format("%%person(%s)", self:getPeep():getName())
	}
end

function DialogBoxController:getVariables()
	local args = self:getDefaultVariables()

	if not self.talkCharacter then
		return args
	end

	local storage = self:getStorage()
	local characterDialogStorage = storage:getSection(self.talkCharacter.name)

	local result = characterDialogStorage:get()
	for k, v in pairs(args) do
		result[k] = v
	end
	return result
end

function DialogBoxController:poke(actionID, actionIndex, e)
	if actionID == "select" then
		self:select(e)
	elseif actionID == "next" then
		self:next(e)
	elseif actionID == "submit" then
		self:submit(e)
	elseif actionID == "close" then
		if Utility.Peep.isEnabled(self:getPeep()) then
			self:getGame():getUI():closeInstance(self)
		end
	else
		Controller.poke(self, actionID, actionIndex, e)
	end
end

function DialogBoxController:select(e)
	assert(self.currentPacket:isType(SelectPacket), "current packet not select packet")
	assert(type(e.index) == "number", "index must be number")
	assert(e.index > 0 and e.index <= self.currentPacket:getNumOptions(), "option out-of-bounds")

	Analytics:selectedDialogueOption(
		self:getPeep(),
		self.target,
		self.action,
		table.concat(self.currentPacket:getOptionAtIndex(e.index).message, "\n"))

	self:pump(self.currentPacket, e.index)
end

function DialogBoxController:submit(e)
	assert(type(e.value) == "string", "input must be string")

	self:pump(self.currentPacket, e.value or "")
end

function DialogBoxController:next(e)
	if self.currentPacket:isType(MessagePacket) then
		self:pump(self.currentPacket)
	end
end

function DialogBoxController:pump(e, ...)
	if e then
		self.currentPacket = e:step(...)
	else
		self.currentPacket = self.dialog:start()
	end

	if self.currentPacket then
		if self.currentPacket:isType(InputPacket) then
			self.state = {
				speaker = self.state.speaker,
				actor = self.state.actor,
				prop = self.state.prop,
				background = self.state.background,
				input = self.currentPacket:getQuestion():inflate()
			}
		elseif self.currentPacket:isType(MessagePacket) then
			self.state = {
				speaker = self.state.speaker or "",
				actor = self.state.actor,
				prop = self.state.prop,
				background = self.state.background,
				content = { self.currentPacket:getMessage()[1]:inflate() }
			}
		elseif self.currentPacket:isType(SelectPacket) then
			local options = {}
			for i = 1, self.currentPacket:getNumOptions() do
				options[i] = self.currentPacket:getOptionAtIndex(i):inflate()
			end

			self.state = {
				speaker = self.state.speaker or "",
				actor = self.state.actor,
				prop = self.state.prop,
				background = self.state.background,
				options = options
			}
		elseif self.currentPacket:isType(SpeakerPacket) then
			local gameDB = self:getDirector():getGameDB()
			local speakerRecord = gameDB:getRecord("TalkSpeaker", { Action = self.action:getAction(), Name = self.currentPacket:getSpeaker() })
			local speakerName = speakerRecord and Utility.getName(speakerRecord:get("Resource"), gameDB)
			if speakerName then
				self.state.speaker = speakerName
			elseif self.currentPacket:getSpeaker():upper() == "_TARGET" then
				self.state.speaker = self:getPeep():getName()
			else
				local speaker = self.dialog:getSpeaker(self.currentPacket:getSpeaker())
				if speaker then
					self.state.speaker = speaker:getName()
				elseif speakerRecord then
					self.state.speaker = "*" .. speakerRecord:get("Name")
				else
					self.state.speaker = "*" .. self.currentPacket:getSpeaker()
				end
			end

			local peep = self.dialog:getSpeaker(self.currentPacket:getSpeaker())
			if peep then
				local actor = peep:getBehavior(ActorReferenceBehavior)
				if actor and actor.actor then
					self.state.actor = actor.actor:getID()
				else
					self.state.actor = nil
				end

				local prop = peep:getBehavior(PropReferenceBehavior)
				if prop and prop.prop then
					self.state.prop = prop.prop:getID()
				else
					self.state.prop = nil
				end
			end

			-- Pump again. We want a Packet that requires us to wait.
			self:pump()
		elseif self.currentPacket:isType(BackgroundPacket) then
			local background = self.currentPacket:getBackground()
			if background:lower() == "none" then
				self.state.background = nil
			else
				self.state.background = { Color.fromHexString(background):get() }
			end

			self:pump()
		end

		if not self.hidRibbonTab then
			Utility.UI.broadcast(
				self:getDirector():getGameInstance():getUI(),
				self:getPeep(),
				"Ribbon",
				"hide",
				nil,
				{ interface = self })
			self.hidRibbonTab = true
		end
	else
		self.state = { done = true }
	end

	if not self.currentPacket or
	   self.currentPacket:isType(InputPacket) or
	   self.currentPacket:isType(SelectPacket) or
	   self.currentPacket:isType(MessagePacket)
	then
		self.needsPump = true
	end

	self.state.canClose = Utility.Peep.isEnabled(self:getPeep())
end

function DialogBoxController:pull()
	return self.state
end

function DialogBoxController:close()
	if self.isClosing then
		return
	end
	self.isClosing = true

	self:onClose()

	if self.target then
		self.target:poke('talkingStop')
	end

	if self.hidRibbonTab then
		Utility.UI.broadcast(
			self:getDirector():getGameInstance():getUI(),
			self:getPeep(),
			"Ribbon",
			"show",
			nil,
			{ interface = self })
	end
end

function DialogBoxController:update(...)
	Controller.update(self, ...)

	if self.needsPump then
		self:getDirector():getGameInstance():getUI():sendPoke(
			self,
			"next",
			nil,
			{})
		self.needsPump = false
	end

	if not self.currentPacket then
		self:getDirector():getGameInstance():getUI():closeInstance(self)
	end
end

return DialogBoxController
