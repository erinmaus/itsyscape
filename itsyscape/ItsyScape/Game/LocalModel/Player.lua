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
local PlayerBehavior = require "ItsyScape.Peep.Behaviors.PlayerBehavior"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local DisabledBehavior = require "ItsyScape.Peep.Behaviors.DisabledBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local PropReferenceBehavior = require "ItsyScape.Peep.Behaviors.PropReferenceBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local TargetTileBehavior = require "ItsyScape.Peep.Behaviors.TargetTileBehavior"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"
local CombatCortex = require "ItsyScape.Peep.Cortexes.CombatCortex"
local SmartPathFinder = require "ItsyScape.World.SmartPathFinder"
local PathNode = require "ItsyScape.World.PathNode"
local ExecutePathCommand = require "ItsyScape.World.ExecutePathCommand"

local LocalPlayer = Class(Player)
LocalPlayer.MOVEMENT_STOP_THRESHOLD = 10

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

	self.onPoof = Callback()
	self.onMove = Callback()
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

function LocalPlayer:spawn(storage, newGame)
	self.game:getDirector():setPlayerStorage(self.id, storage)

	local success, actor = self.stage:spawnActor("Resources.Game.Peeps.Player.One", 1, "::orphan")
	if success then
		self.actor = actor
		actor:getPeep():addBehavior(PlayerBehavior)

		actor:getPeep():listen('actionPerformed', self.onPlayerActionPerformed, self)

		local p = actor:getPeep():getBehavior(PlayerBehavior)
		p.id = self.id

		actor:getPeep():listen('finalize', function()
			if newGame then
				self.stage:movePeep(
					actor:getPeep(),
					"Ship_IsabelleIsland_PortmasterJenkins?map=IsabelleIsland_FarOcean," ..
					"jenkins_state=1," ..
					"i=16," ..
					"j=16," ..
					"shore=IsabelleIsland_FarOcean_Cutscene," ..
					"shoreAnchor=Anchor_Spawn",
					"Anchor_Spawn")
				actor:getPeep():pushPoke('bootstrapComplete')
			else
				local storage = self.game:getDirector():getPlayerStorage(self.id):getRoot()
				if storage:hasSection("Location") then
					local location = storage:getSection("Location")
					if location:get("name") then
						self.stage:movePeep(
							actor:getPeep(),
							location:get("name"),
							Vector(
								location:get("x"),
								location:get("y"),
								location:get("z")),
							true)

						if not location:get("isTitleScreen") then
							actor:getPeep():pushPoke('bootstrapComplete')
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

function Player:save()
	local playerActor = self.actor
	local playerPeep = playerActor and playerActor:getPeep()
	if playerPeep then
		local storage = self.game:getDirector():getPlayerStorage(playerPeep)
		local root = storage:getRoot()

		local hasLocation = root:hasSection("Location")
		if not hasLocation then
			local finishedQuest = playerPeep:getState():has('Quest', "PreTutorial")
			local startedQuest = playerPeep:getState():has('KeyItem', "PreTutorial_Start")

			local map, anchor
			if finishedQuest then
				map = "IsabelleIsland_Tower_Floor5"
				anchor = "Anchor_StartGame"
			elseif startedQuest then
				map = "PreTutorial_MansionFloor1"
				anchor = "Anchor_Spawn"
			end

			if map and anchor then
				local x, y, z = Utility.Map.getAnchorPosition(self.game, map, anchor)
				local locationSection = root:getSection("Location")
				locationSection:set({
					name = map,
					x = x,
					y = y,
					z = z,
					layer = 1
				})
			end
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

function LocalPlayer:poof()
	self:onPoof()

	if self.actor then
		self.stage:killActor(self.actor)
	end

	self.actor = false

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

	-- TODO LAYER CHECK
	if Class.isCompatibleType(obj, LocalProp) or Class.isCompatibleType(obj, LocalActor) then
		obj:poke(id, scope, self.actor:getPeep())
	elseif Class.isType(obj) then
		Log.warn("Can't poke action '%d' on object of type '%s'", id, obj:getDebugInfo().shortName)
	end
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
	if not self:isReady() then
		return false
	end

	local direction = Vector(x, 0, z):getNormal()
	local length = direction:getLength()
	local peep = self.actor:getPeep()
	local movement = peep:getBehavior(MovementBehavior)
	if length == 0 or peep:hasBehavior(DisabledBehavior) then
		local currentAccceleration = movement.acceleration:getLength()
		if currentAccceleration < LocalPlayer.MOVEMENT_STOP_THRESHOLD then
			movement.acceleration = Vector(0, movement.acceleration.y, 0)
			movement.velocity = Vector(0, movement.velocity.y, 0)
			movement.isStopping = true
		end
	else
		if peep:getCommandQueue():clear() then
			movement.acceleration = movement.maxAcceleration * direction
			movement.isStopping = false

			local i, j, k = Utility.Peep.getTile(peep)

			self.direction = direction
			peep:poke('walk', { i = i, j = j, k = k })
		end
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

return LocalPlayer
