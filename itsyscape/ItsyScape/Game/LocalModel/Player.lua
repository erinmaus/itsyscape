--------------------------------------------------------------------------------
-- ItsyScape/Game/LocalModel/Player.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Callback = require "ItsyScape.Common.Callback"
local Vector = require "ItsyScape.Common.Math.Vector"
local Ray = require "ItsyScape.Common.Math.Ray"
local Utility = require "ItsyScape.Game.Utility"
local LocalActor = require "ItsyScape.Game.LocalModel.Actor"
local LocalProp = require "ItsyScape.Game.LocalModel.Prop"
local Player = require "ItsyScape.Game.Model.Player"
local Mapp = require "ItsyScape.GameDB.Mapp"
local Color = require "ItsyScape.Graphics.Color"
local PlayerBehavior = require "ItsyScape.Peep.Behaviors.PlayerBehavior"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local DisabledBehavior = require "ItsyScape.Peep.Behaviors.DisabledBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local PropReferenceBehavior = require "ItsyScape.Peep.Behaviors.PropReferenceBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local TargetTileBehavior = require "ItsyScape.Peep.Behaviors.TargetTileBehavior"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local StanceBehavior = require "ItsyScape.Peep.Behaviors.StanceBehavior"
local ActiveSpellBehavior = require "ItsyScape.Peep.Behaviors.ActiveSpellBehavior"
local CombatCortex = require "ItsyScape.Peep.Cortexes.CombatCortex"
local SmartPathFinder = require "ItsyScape.World.SmartPathFinder"
local PathNode = require "ItsyScape.World.PathNode"
local ExecutePathCommand = require "ItsyScape.World.ExecutePathCommand"

local LocalPlayer = Class(Player)
LocalPlayer.MOVEMENT_STOP_THRESHOLD = 10
LocalPlayer.MAX_MESSAGES = 50
LocalPlayer.MAX_MESSAGE_DURATION_SECONDS = 60 * 2 -- 2 minutes
LocalPlayer.POKE_GRACE_PERIOD = 0.45

-- Constructs a new player.
--
-- The Actor isn't created until Player.spawn is called.
function LocalPlayer:new(id, game, stage)
	Player.new(self)

	self.game = game
	self.stage = stage
	self.actor = false
	self.direction = Vector.UNIT_X
	self.id = id
	self.isPlayable = false

	self.onPoof = Callback()
	self.onForceDisconnect = Callback()

	self.messages = { received = 0 }
end

function LocalPlayer:setInstance(previousLayerName, newLayerName, instance)
	self:onMove(previousLayerName, newLayerName)
	self.instance = instance
end

function LocalPlayer:getInstance()
	return self.instance
end

function LocalPlayer:getID()
	return self.id
end

function LocalPlayer:setClientID(value)
	self.clientID = value
end

function LocalPlayer:getClientID()
	return self.clientID
end

function LocalPlayer:getTemporaryStorage()
	return self.game:getDirector():getPlayerStorage(self.id):getRoot():getSection("Temporary")
end

function LocalPlayer:saveLocation()
	if not self.instance or not self.actor or not self.actor:getPeep() then
		return
	end

	local storage = self.game:getDirector():getPlayerStorage(self.id)
	local root = storage:getRoot()

	local locationStorage = root:getSection("Location")
	if self.instance:getIsGlobal() then
		Log.info("Saving player location at '%s'.", self.instance:getFilename())

		local position = Utility.Peep.getPosition(self.actor:getPeep())
		locationStorage:set({
			name = self.instance:getFilename(),
			x = position.x,
			y = position.y,
			z = position.z
		})
	end

	local statusStorage = root:getSection("Status")
	local status = self.actor:getPeep():getBehavior(CombatStatusBehavior)
	local stance = self.actor:getPeep():getBehavior(StanceBehavior)

	statusStorage:set({
		currentHitpoints = status and status.currentHitpoints or nil,
		currentPrayer = status and status.currentPrayer or nil,
		stance = stance and stance.stance or nil
	})
end

function LocalPlayer:spawn(storage, newGame, password)
	if not self.game:verifyPassword(password) then
		Log.warn("Player %d (client %d) did not say the right password.", self:getID(), self:getClientID() or -1)
		self:onForceDisconnect()
		return
	end

	Log.info("Spawning player (%d).", self:getID())

	local previousLayerName = self.actor and self.actor:getPeep():getLayerName()

	if self.instance then
		self:onMove(previousLayerName, "::orphan")
		self.instance = nil
	end

	self:unload()

	self.game:getDirector():setPlayerStorage(self.id, storage)
	storage:getRoot():removeSection("Temporary")

	local success, actor = self.stage:spawnActor("Resources.Game.Peeps.Player.One", 1, previousLayerName or "::orphan")
	if success then
		self.actor = actor
		actor:getPeep():addBehavior(PlayerBehavior)

		actor:getPeep():listen('actionPerformed', self.onPlayerActionPerformed, self)

		local p = actor:getPeep():getBehavior(PlayerBehavior)
		p.playerID = self.id

		actor:getPeep():listen('finalize', function()
			local storage = self.game:getDirector():getPlayerStorage(self.id)
			local root = storage:getRoot()

			self.isPlayable = not root:hasSection("Location") or not root:getSection("Location"):get("isTitleScreen")

			if newGame then
				self.stage:movePeep(
					actor:getPeep(),
					"NewGame",
					"Anchor_Spawn")
				actor:getPeep():pushPoke('bootstrapComplete')
				Analytics:startGame(actor:getPeep())
			else
				if root:hasSection("Location") then
					local location = root:getSection("Location")
					if location:get("name") then
						local mapName
						if location:get("instance") then
							mapName = "@" .. location:get("name")
						else
							mapName = location:get("name")
						end

						self.stage:movePeep(
							actor:getPeep(),
							mapName,
							Vector(
								location:get("x"),
								location:get("y"),
								location:get("z")),
							true)

						local statusStorage = root:getSection("Status")
						local status = actor:getPeep():getBehavior(CombatStatusBehavior)
						status.currentHitpoints = statusStorage:get("currentHitpoints") or status.currentHitpoints
						status.currentPrayer = statusStorage:get("currentPrayer") or status.currentPrayer

						local stance = actor:getPeep():getBehavior(StanceBehavior)
						stance.stance = statusStorage:get("stance") or stance.stance

						if not location:get("isTitleScreen") then
							actor:getPeep():pushPoke('bootstrapComplete')
							Analytics:startGame(actor:getPeep())
						else
							local x, y, z = Utility.Map.getAnchorPosition(self.game, location:get("name"), "Anchor_Spawn")
							Utility.Peep.setPosition(actor:getPeep(), Vector(x, y, z))
						end
					end
				end
			end
		end)

		self.currentAction = nil
	else
		self.actor = false
	end

	self:changeCamera("Default")
end

function Player:_updateLastLocation(storage)
	local playerActor = self.actor
	local playerPeep = playerActor and playerActor:getPeep()

	if not playerPeep then
		Log.info("Couldn't update last location, player (%d) not ready.", self.id)
		return false
	end

	local finishedQuest = playerPeep:getState():has('Quest', "PreTutorial")

	local map, anchor, isInstance
	if finishedQuest then
		map = "IsabelleIsland_Tower_Floor5"
		anchor = "Anchor_StartGame"
		isInstance = nil
	else
		map = "Sailing_WhalingTemple"
		anchor = "Anchor_Spawn"
		isInstance = true
	end

	if map and anchor then
		local root = storage:getRoot()
		local x, y, z = Utility.Map.getAnchorPosition(self.game, map, anchor)
		local locationSection = root:getSection("Location")
		local spawnSection = root:getSection("Spawn")

		locationSection:set({
			name = map,
			x = x,
			y = y,
			z = z,
			instance = isInstance
		})

		spawnSection:set({
			name = map,
			x = x,
			y = y,
			z = z,
		})
	end

	return true
end

function Player:save()
	local playerActor = self.actor
	local playerPeep = playerActor and playerActor:getPeep()
	if playerPeep then
		self:saveLocation()

		local storage = self.game:getDirector():getPlayerStorage(playerPeep)
		local root = storage:getRoot()

		local hasLocation = root:hasSection("Location")
		if not hasLocation then
			self:_updateLastLocation(storage)
		end

		hasLocation = root:hasSection("Location")
		if hasLocation then
			Utility.save(playerPeep, false)
		end
	end
end

function LocalPlayer:onPlayerActionPerformed(_, p)
	self.currentAction = p.action:getXProgressiveVerb()
end

function LocalPlayer:unload()
	if self.actor then
		local ui = self.game:getUI()

		local pendingInterfaces = {}
		for interfaceID, interfaceIndex in ui:getInterfacesForPeep(self.actor:getPeep()) do
			table.insert(pendingInterfaces, { interfaceID, interfaceIndex })
		end

		for i = 1, #pendingInterfaces do
			interfaceID, interfaceIndex = unpack(pendingInterfaces[i])
			Log.info(
				"Closing interface '%s' (index = %d) for player '%s' (%d).",
				interfaceID, interfaceIndex, self.actor:getName(), self:getID())

			ui:close(interfaceID, interfaceIndex)
		end

		self.stage:removePlayer(self)

		if self.isPlayable then
			self.actor:getPeep():poke('endGame')
			Analytics:endGame(self.actor:getPeep())
		end

		self.stage:killActor(self.actor)
	end

	self.actor = false
end

function LocalPlayer:poof()
	self:onPoof()

	self:unload()

	self.game:getDirector():setPlayerStorage(self.id, nil)
end

-- Gets the Actor this Player is represented by.
function LocalPlayer:getActor()
	return self.actor
end

function LocalPlayer:isReady()
	return self.actor ~= false
end

function LocalPlayer:flee()
	if not self:isReady() then
		return false
	end

	local peep = self.actor:getPeep()
	peep:removeBehavior(CombatTargetBehavior)
	peep:getCommandQueue(CombatCortex.QUEUE):clear()
end

function LocalPlayer:getIsEngaged()
	if not self:isReady() then
		return false
	end

	local peep = self.actor:getPeep()
	return peep:hasBehavior(CombatTargetBehavior)
end

function LocalPlayer:getTarget()
	if not self:isReady() then
		return nil
	end

	local peep = self.actor:getPeep()
	local target = peep:getBehavior(CombatTargetBehavior)
	if target and target.actor then
		return target.actor
	else
		return nil
	end
end

function LocalPlayer:poke(id, obj, scope)
	if not self:isReady() then
		return
	end

	self.nextObject = obj
	self.nextActionID = id
	self.nextActionScope = scope
	self.lastPokeTime = love.timer.getTime()
end

function LocalPlayer:takeItem(i, j, layer, ref)
	-- TODO LAYER CHECK
	self.stage:takeItem(i, j, layer, ref, self)
end

function LocalPlayer:findPath(i, j, k)
	if not self:isReady() then
		return nil
	end

	local peep = self.actor:getPeep()
	local position = peep:getBehavior(PositionBehavior).position
	local map = self.game:getDirector():getMap(k)
	local _, playerI, playerJ = map:getTileAt(position.x, position.z)
	local pathFinder = SmartPathFinder(map, peep)
	return pathFinder:find(
		{ i = playerI, j = playerJ },
		{ i = i, j = j },
		0)
end

function LocalPlayer:move(x, z)
	if not self:isReady() or not self:getActor():getPeep():getIsReady() then
		return false
	end

	local direction = Vector(x, 0, z):getNormal()
	local length = direction:getLength()
	local peep = self.actor:getPeep()
	local movement = peep:getBehavior(MovementBehavior)
	if length == 0 or peep:hasBehavior(DisabledBehavior) then
		movement.isStopping = true
	else
		if peep:hasBehavior(CombatTargetBehavior) or peep:getCommandQueue():clear() then
			local targetTile = peep:getBehavior(TargetTileBehavior)
			if targetTile and targetTile.pathNode then
				targetTile.pathNode:interrupt(peep)
			end

			movement.velocity = movement.maxSpeed * direction
			movement.isStopping = false

			local i, j, k = Utility.Peep.getTile(peep)

			self.direction = direction
			peep:poke('walk', { i = i, j = j, k = k })
		end
	end
end

function LocalPlayer:isPendingActionMovement()
	local action = Mapp.Action()
	local id = self.nextActionID and Mapp.ID(self.nextActionID)
	if id and self.game:getGameDB():getBrochure():tryGetAction(id, action) then
		local a = Utility.getAction(self.game, action)
		return a and a.instance and a.instance.WHILE_MOVING
	end

	return false
end

function LocalPlayer:tryPerformPoke()
	local movement = self:getActor():getPeep():getBehavior(MovementBehavior)
	if not movement or movement.velocity:getLength() == 0 or self:isPendingActionMovement() then
		if self.lastPokeTime and self.lastPokeTime + LocalPlayer.POKE_GRACE_PERIOD > love.timer.getTime() then
			local obj = self.nextObject
			local id = self.nextActionID
			local scope = self.nextActionScope

			if obj and id and scope then
				if Class.isCompatibleType(obj, LocalProp) or Class.isCompatibleType(obj, LocalActor) then
					local layer = Utility.Peep.getLayer(obj:getPeep())
					if not self.instance:hasLayer(layer) then
						Log.warn(
							"Player '%s' (%d) is not in instance with layer %d! Cannot poke actor or peep %s '%s' (%d).",
							self:getActor():getName(), self:getID(), layer, obj:getPeepID(), obj:getName(), obj:getID())
					else
						obj:poke(id, scope, self.actor:getPeep())
					end
				elseif Class.isClass(obj) then
					Log.warn("Can't poke action '%d' on object of type '%s'", id, obj:getDebugInfo().shortName)
				end

				self.nextObject = nil
				self.nextActionID = nil
				self.nextActionScope = nil
				self.lastPokeTime = nil
			end
		end
	end
end

function LocalPlayer:tick()
	for i = #self.messages, 1, -1 do
		if love.timer.getTime() > self.messages[i].expires then
			table.remove(self.messages, i)
			self.messages.received = self.messages.received + 1
		end
	end

	if self:isReady() then
		self:tryPerformPoke()
	end
end

function LocalPlayer:updateDiscord()
	local discord = self.game.discord
	if not discord then
		return
	end

	local line1, line2
	if self.actor then
		local playerPeep = self.actor:getPeep()

		if playerPeep then
			local target = playerPeep:getBehavior(CombatTargetBehavior)
			if target and target.actor and target.actor:getPeep() then
				line1 = "Vs " .. target.actor:getName()
			end

			local playerMap = Utility.Peep.getMapResource(playerPeep)
			if playerMap and playerMap.name ~= self.currentPlayerMap then
				line2 = "@ " .. (Utility.getName(playerMap, self.game.gameDB) or playerMap.name .. "*")
			end
		end

		if not line1 then
			line1 = self.currentAction or "Idling"
		end

		if not line2 then
			line2 = "@ Unknown"
		end
	else
		line1 = "@ Lobby"
		line2 = "Idling"
	end

	if self.line1 ~= line1 or self.line2 ~= line2 then
		discord:updateActivity(line1, line2)
		Log.info("Updated activity ('%s', '%s')", line1, line2)
	end

	self.line1 = line1
	self.line2 = line2
end

-- Moves the player to the specified position on the map via walking.
function LocalPlayer:walk(i, j, k)
	local peep = self.actor:getPeep()
	return Utility.Peep.walk(peep, i, j, k, math.huge, { asCloseAsPossible = true })
end

function LocalPlayer:changeCamera(cameraType)
	self.onChangeCamera(self, cameraType)
end

function LocalPlayer:pokeCamera(event, ...)
	self.onPokeCamera(self, event, ...)
end

function LocalPlayer:pushMessage(player, message)
	local m = {
		player = player,
		message = message,
		lastKnownName = Class.isCompatibleType(player, Player) and player:getActor() and player:getActor():getPeep() and player:getActor():getPeep():getName(),
		expires = love.timer.getTime() + LocalPlayer.MAX_MESSAGE_DURATION_SECONDS
	}

	table.insert(self.messages, m)

	while #self.messages > LocalPlayer.MAX_MESSAGES do
		table.remove(self.messages, 1)
	end

	self.messages.received = self.messages.received + 1
end

function LocalPlayer:getMessages()
	return self.messages
end

function LocalPlayer:talk(message)
	message = message:match("^%s*(.*)%s*$") or ""
	local whisper = message:match("^%s*/w%s*(.*)%s*$")

	if message == "" or whisper == "" then
		return
	end

	if whisper then
		Log.info("Player '%s' (%d) whispered: %s", self:getActor():getName(), self:getID(), whisper)

		local instance = Utility.Peep.getInstance(self:getActor():getPeep())
		if not instance then
			Log.info("Player isn't in instance; can't whisper.")
			return
		end

		if instance:hasRaid() then
			for _, player in instance:getRaid():getParty():iteratePlayers() do
				player:pushMessage(self, whisper)
			end
		else
			for _, player in instance:iteratePlayers() do
				player:pushMessage(self, whisper)
			end
		end

		self:getActor():flash("Message", 2, whisper, nil, 2)
	else
		Log.info("Player '%s' (%d) said: %s", self:getActor():getName(), self:getID(), message)

		for _, player in self.game:iteratePlayers() do
			player:pushMessage(self, message)
		end

		self:getActor():flash("Message", 1, message, nil, 2)
	end
end

function LocalPlayer:addExclusiveChatMessage(message, color)
	if Class.isCompatibleType(color, Color) then
		color = { color:get() }
	else
		color = { 1, 1, 1, 1 }
	end

	if type(message) == 'string' then
		self:pushMessage(nil, { color, message })
	else
		Log.warn(
			"Couldn't add exclusive chat message to player '%s' (id = %d) because message was not string.",
			(self:getActor() and self:getActor():getName()) or "<invalid>",
			self.id)
	end
end

return LocalPlayer
