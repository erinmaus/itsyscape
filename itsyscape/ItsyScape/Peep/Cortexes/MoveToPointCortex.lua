--------------------------------------------------------------------------------
-- ItsyScape/Peep/Cortexes/MoveToPointCortex.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local slick = require "slick"
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Utility = require "ItsyScape.Game.Utility"
local Cortex = require "ItsyScape.Peep.Cortex"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local PropReferenceBehavior = require "ItsyScape.Peep.Behaviors.PropReferenceBehavior"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"
local StaticBehavior = require "ItsyScape.Peep.Behaviors.StaticBehavior"
local TargetPointBehavior = require "ItsyScape.Peep.Behaviors.TargetPointBehavior"

local MoveToPointCortex = Class(Cortex)
MoveToPointCortex.DISTANCE_THRESHOLD = 0

MoveToPointCortex.OFFSETS = {
	{ -1,  0 },
	{  1,  0 },
	{  0, -1 },
	{  0,  1 }
}

MoveToPointCortex.FLOOR = slick.newEnum("FLOOR")
MoveToPointCortex.WALL = slick.newEnum("WALL")

local function _isPassable(map, i, j, s, t)
	return not map:getTile(s, t):hasStaticFlag("impassable")
end

function MoveToPointCortex:new()
	Cortex.new(self)

	self:require(MovementBehavior)
	self:require(PositionBehavior)
	self:require(TargetPointBehavior)

	self.speed = {}
	self.previousPointCenter = {}

	self.worlds = {}
	self.props = {}
	self.propsByLayer = {}
end

function MoveToPointCortex:attach(director)
	Cortex.attach(self, director)

	self.ready = true
end

function MoveToPointCortex:detach()
	self:silence()
	Cortex.detach(self)
end

function MoveToPointCortex:listen()
	local stage = self:getDirector():getGameInstance():getStage()

	self._onLoadMap = function(_, _, layer)
		self:addWorld(layer)
	end
	stage.onLoadMap:register(self._onLoadMap)

	self._onMapModified = function(_, _, layer)
		self:updateWorld(layer)
	end
	stage.onMapModified:register(self._onMapModified)

	self._onUnloadMap = function(_, layer)
		self:unloadWorld(layer)
	end
	stage.onUnloadMap:register(self._onUnloadMap)
end

function MoveToPointCortex:silence()
	local stage = self:getDirector():getGameInstance():getStage()
	stage.onLoadMap:unregister(self._onLoadMap)
	stage.onMapModified:unregister(self._onMapModified)
	stage.onUnloadMap:unregister(self._onUnloadMap)
end

function MoveToPointCortex:_getPropTransform(prop)
	local position = Utility.Peep.getPosition(prop)
	local _, rotation, _ = Utility.Peep.getRotation(prop):getEulerXYZ()
	local scale = Utility.Peep.getScale(prop)
	local size = Utility.Peep.getSize(prop)
	local static = prop:getBehavior(StaticBehavior)

	return {
		position = position,
		rotation = rotation,
		scale = scale,
		size = size,
		impassable = (not static or static.type == StaticBehavior.IMPASSABLE) and (size.x > 0 and size.z > 0),
		shape = static and static.shape or StaticBehavior.SHAPE_RECTANGLE
	}
end

function MoveToPointCortex:_isPropTransformDifferent(a, b)
	return a.new or b.new or
		   a.position ~= b.position or
		   a.rotation ~= b.rotation or
		   a.scale ~= b.scale or
		   a.size ~= b.size or
		   a.impassable ~= b.impassable or
		   a.shape ~= b.shape
end

function MoveToPointCortex:previewPeep(peep)
	Cortex.previewPeep(self, peep)

	if peep:hasBehavior(StaticBehavior) and peep:hasBehavior(PropReferenceBehavior) then
		if not self.props[peep] then
			self:addPropToWorld(Utility.Peep.getLayer(peep), peep)
		end
	elseif self.props[peep] then
		self:removePropFromWorld(self.propsByLayer[peep], peep)
	end
end

function MoveToPointCortex:addPeep(peep)
	Cortex.addPeep(self, peep)

	self.speed[peep] = self.speed[peep] or 0
end

function MoveToPointCortex:reovePeep(peep)
	Cortex.removePeep(self, peep)

	self.speed[peep] = nil
end

function MoveToPointCortex:addPropToWorld(layer, prop)
	self:removePropFromWorld(self.propsByLayer[prop], prop)

	local w = self.worlds[layer]
	if w then
		local t = self:_getPropTransform(prop)
		t.new = true

		w.props[prop] = t
		w.isDirty = w.isDirty or t.impassable
	end

	self.propsByLayer[prop] = Utility.Peep.getLayer(prop)
	self.props[prop] = true
end

function MoveToPointCortex:removePropFromWorld(layer, prop)
	if not layer then
		return
	end

	local w = self.worlds[layer]
	if w then
		w.props[prop] = nil
	end

	self.props[prop] = nil

	w.isDirty = true
end

function MoveToPointCortex:updateProp(prop)
	local layer = Utility.Peep.getLayer(prop)
	if layer ~= self.propsByLayer[prop] then
		self:removePropFromWorld(self.propsByLayer[prop], prop)
		self:addPropToWorld(layer, prop)
	end

	local w = self.worlds[layer]
	if w then
		local t = self:_getPropTransform(prop)
		if self:_isPropTransformDifferent(t, w.props[prop]) then
			w.isDirty = true
		end
	end
end

function MoveToPointCortex:addWorld(layer)
	local map = self:getDirector():getMap(layer)

	self.worlds[layer] = {
		isDirty = true,
		points = {
			0, 0,
			map:getWidth() * map:getCellSize(), 0,
			map:getWidth() * map:getCellSize(), map:getHeight() * map:getCellSize(),
			0, map:getHeight() * map:getCellSize(),
		},
		edges = {
			1, 2,
			2, 3,
			3, 4,
			4, 1
		},
		userdata = {},
		props = {},
		propTransforms = {},
		layer = layer
	}
end

function MoveToPointCortex:updateWorld(layer)
	local map = self:getDirector():getMap(layer)

	local w = self.worlds[layer]
	if not w then
		return
	end

	w.isDirty = true

	table.clear(w.points)
	table.clear(w.userdata)

	table.insert(w.points, 0) -- top left
	table.insert(w.points, 0)
	table.insert(w.points, map:getWidth() * map:getCellSize()) -- top right
	table.insert(w.points, 0)
	table.insert(w.points, map:getWidth() * map:getCellSize()) -- bottom right
	table.insert(w.points, map:getHeight() * map:getCellSize())
	table.insert(w.points, 0) -- bottom left
	table.insert(w.points, map:getHeight() * map:getCellSize())

	for i = 1, map:getWidth() do
		for j = 1, map:getHeight() do
			local tile = map:getTile(i, j)
			local tileCenter = map:getTileCenter(i, j)
			local min = tileCenter - Vector(map:getCellSize() / 2)

			if not tile:hasStaticFlag("impassable") then
				for k = 1, #MoveToPointCortex.OFFSETS do
					local offsetI, offsetJ = unpack(MoveToPointCortex.OFFSETS[k])

					if not map:canMove(i, j, offsetI, offsetJ, false, _isPassable) then
						if offsetI < 0 then
							table.insert(w.points, min.x)
							table.insert(w.points, min.z)
							table.insert(w.points, min.x)
							table.insert(w.points, min.z + map:getCellSize())
						elseif offsetI > 0 then
							table.insert(w.points, min.x + map:getCellSize())
							table.insert(w.points, min.z)
							table.insert(w.points, min.x + map:getCellSize())
							table.insert(w.points, min.z + map:getCellSize())
						end

						if offsetJ < 0 then
							table.insert(w.points, min.x)
							table.insert(w.points, min.z)
							table.insert(w.points, min.x + map:getCellSize())
							table.insert(w.points, min.z)
						elseif offsetJ > 0 then
							table.insert(w.points, min.x)
							table.insert(w.points, min.z + map:getCellSize())
							table.insert(w.points, min.x + map:getCellSize())
							table.insert(w.points, min.z + map:getCellSize())
						end

						local index = #w.points / 2

						local u1 = {
							index = index - 1,
							impassable = true,
							others = {}
						}

						local u2 = {
							index = index,
							impassable = true,
							others = {}
						}

						u1.others[u2] = true
						u2.others[u1] = true

						w.userdata[index - 1] = u1
						w.userdata[index] = u2
					end
				end
			end
		end
	end
end

function MoveToPointCortex:unloadWorld(layer)
	if self.worlds[layer] then
		self.worlds[layer] = nil
	end
end

function MoveToPointCortex:_getPolygonMesh(prop, transform)
	-- TODO: support circles

	local size = transform.size
	local offset = -size / 2

	local points = {
		offset.x, offset.z,
		size.x, offset.z,
		size.x, size.z,
		offset.x, size.z
	}

	local userdata = {
		{ index = 1, impassable = true, others = {}, props = { [prop] = true } },
		{ index = 2, impassable = true, others = {}, props = { [prop] = true } },
		{ index = 3, impassable = true, others = {}, props = { [prop] = true } },
		{ index = 4, impassable = true, others = {}, props = { [prop] = true } }
	}

	for i = 1, #userdata do
		local j = (i % #userdata) + 1

		userdata[i].others[userdata[j]] = true
		userdata[j].others[userdata[i]] = true
	end

	local edges = {
		1, 2,
		2, 3,
		3, 4,
		4, 1
	}

	local t = slick.newTransform(
		transform.position.x,
		transform.position.z,
		transform.rotation,
		transform.scale.x,
		transform.scale.z)

	for i = 1, #points, 2 do
		points[i], points[i + 1] = t:transformPoint(points[i], points[i + 1])
	end

	return slick.navigation.mesh.new(points, userdata, edges)
end

local function _collapse(...)
	local result

	for i = 1, select("#", ...) do
		local userdata = select(i, ...)
		if userdata then
			result = result or { impassable = false, props = {}, other = {} }

			result.impassable = result.impassable or userdata.impassable == true
			if userdata.props then
				for p in pairs(userdata.props) do
					result.props[p] = true
				end
			end

			if userdata.other then
			end
		end
	end

	return result
end

local function _dissolve(dissolve)
	if true then
		return
	end

	if not (dissolve.userdata or dissolve.otherUserdata) then
		return
	end

	if dissolve.userdata and dissolve.otherUserdata then
		dissolve.resultUserdata = {
			index = dissolve.index,
			impassable = dissolve.userdata.impassable == true or dissolve.otherUserdata.impassable == true,
			other = {}
		}

		if dissolve.userdata.other then
			for o in pairs(dissolve.userdata.other) do
				if o.other[dissolve.userdata] then
					o.other[dissolve.userdata] = nil
					o.other[dissolve.resultUserdata] = true

					dissolve.resultUserdata.other[o] = true
				end

			end
		end

		if dissolve.otherUserdata.other then
			for o in pairs(dissolve.otherUserdata.other) do
				if o.other[dissolve.otherUserdata] then
					o.other[dissolve.otherUserdata] = nil
					o.other[dissolve.resultUserdata] = true

					dissolve.resultUserdata.other[o] = true
				end
			end
		end
	elseif dissolve.otherUserdata then
		dissolve.resultUserdata = {
			index = dissolve.index,
			impassable = not not dissolve.otherUserdata.impassable,
			other = {}
		}

		if dissolve.otherUserdata.other then
			for o in pairs(dissolve.otherUserdata.other) do
				if o.other[dissolve.otherUserdata] then
					o.other[dissolve.otherUserdata] = nil
					o.other[dissolve.resultUserdata] = true

					dissolve.resultUserdata.other[o] = true
				end
			end
		end
	else
		dissolve.resultUserdata = dissolve.userdata
	end

	if dissolve.userdata and dissolve.userdata.props then
		for prop in pairs(dissolve.userdata.props) do
			if not dissolve.resultUserdata.props then
				dissolve.resultUserdata.props = {}
			end

			dissolve.resultUserdata.props[prop] = true
		end
	end

	if dissolve.otherUserdata and dissolve.otherUserdata.props then
		for prop in pairs(dissolve.otherUserdata.props) do
			if not dissolve.resultUserdata.props then
				dissolve.resultUserdata.props = {}
			end

			dissolve.resultUserdata.props[prop] = true
		end
	end
end

local function _intersect(intersect)
	--intersect.resultUserdata = _collapse(intersect.a1Userdata, intersect.a2Userdata, intersect.b1Userdata, intersect.b2Userdata)
end

function MoveToPointCortex:rebuild(layer)
	local w = self.worlds[layer]
	if not (w and w.isDirty) then
		return
	end

	local meshBuilder = slick.navigation.meshBuilder.new()

	meshBuilder:addLayer(MoveToPointCortex.FLOOR)
	meshBuilder:addLayer(MoveToPointCortex.WALL)

	local r = {}
	local function _add(key, prop, points, userdata, edges)
		local shapes = r[key] or {}
		r[key] = shapes

		local n = prop and prop:getName() or "<world>"

		local shape = { points = {}, edges = {}, userdata = {} }
		for _, p in ipairs(points) do
			table.insert(shape.points, p * 2)
		end
		for i = 1, #points / 2 do
			local u = userdata[i]
			if u then
				local others = {}
				for o in pairs(u.others or {}) do
					table.insert(others, o.index)
				end

				table.insert(shape.userdata, {
					index = i,
					value = { door = u.impassable, others = others, names = { [n] = true } }
				})
			end
		end
		for _, p in ipairs(edges) do
			table.insert(shape.edges, p)
		end

		table.insert(shapes, shape)
	end

	meshBuilder:addMesh(MoveToPointCortex.FLOOR, slick.navigation.mesh.new(w.points, w.userdata, w.edges))
	_add("background", nil, w.points, w.userdata, w.edges)

	for prop, transform in pairs(w.props) do
		if transform.impassable then
			local mesh = self:_getPolygonMesh(prop, transform)
			_add("wall", prop, mesh.inputPoints, mesh.inputUserdata, mesh.inputEdges)
			meshBuilder:addMesh(MoveToPointCortex.WALL, mesh)
		end
	end

	Log.info("B4")
	w.mesh = meshBuilder:build({
		dissolve = _dissolve,
		intersect = _intersect
	})
	Log.info("AFTR")

	local j = require("json").encode(r)
	Log.info(">>> J %s", j)
	love.filesystem.write(
		string.format("%d.json", layer),
		j)

	w.isDirty = false
end

function MoveToPointCortex:accumulateVelocity(peep, value)
	for effect in peep:getEffects(require "ItsyScape.Peep.Effects.MovementEffect") do
		value = effect:applyToVelocity(value)
	end

	return value
end

function MoveToPointCortex:update(delta)
	if self.ready then
		self:listen()
		self.ready = false
	end

	for layer in pairs(self.worlds) do
		self:rebuild(layer)
	end

	local game = self:getDirector():getGameInstance()
	local finished = {}

	for peep in self:iterate() do
		-- local position = peep:getBehavior(PositionBehavior)
		-- local targetPoint = peep:getBehavior(TargetPointBehavior)
		-- local movement = peep:getBehavior(MovementBehavior)
		-- if movement.maxSpeed == 0 or movement.maxAcceleration == 0 or
		--    movement.velocityMultiplier == 0 or movement.accelerationMultiplier == 0
		-- then
		-- 	peep:removeBehavior(TargetPointBehavior)
		-- elseif targetPoint and movement and position and targetPoint.pathNode then
		-- 	local speed = math.min(self.speed[peep] + movement.maxSpeed * delta, movement.maxSpeed)
		-- 	local map = game:getDirector():getMap(peep:getBehavior(PositionBehavior).layer or 1)
		-- 	if map then
		-- 		local currentDelta = delta
		-- 		while currentDelta > 0 do
		-- 			local currentPoint, currentPointI, currentPointJ = map:getPointAt(position.position.x, position.position.z)
		-- 			local nextPoint, nextPointI, nextPointJ = map:getPoint(targetPoint.pathNode.i, targetPoint.pathNode.j)
		-- 			local previousPointCenter = self.previousPointCenter[peep]
		-- 			local currentPosition = position.position
		-- 			local targetPosition = map:getPointCenter(nextPointI, nextPointJ) + Vector.UNIT_Y * movement.float
		-- 			local direction = (targetPosition - currentPosition):getNormal()
		-- 			local offset = direction * speed

		-- 			if not peep:hasBehavior(RotationBehavior) then
		-- 				if direction.x < 0 then
		-- 					movement.facing = MovementBehavior.FACING_LEFT
		-- 				elseif direction.x > 0 then
		-- 					movement.facing = MovementBehavior.FACING_RIGHT
		-- 				end
		-- 			end

		-- 			local velocity = offset
		-- 			velocity = self:accumulateVelocity(peep, velocity)

		-- 			local velocitySlice = velocity * currentDelta
		-- 			local velocitySliceLength = velocitySlice:getLength()

		-- 			local didOvershoot = false
		-- 			local distance = ((targetPosition - currentPosition) * Vector.PLANE_XZ):getLength()
		-- 			if distance < velocitySliceLength and distance > MoveToPointCortex.DISTANCE_THRESHOLD then
		-- 				currentDelta = currentDelta - (delta * (distance / velocitySliceLength))
		-- 				velocitySlice = direction * distance
		-- 				didOvershoot = true
		-- 			else
		-- 				currentDelta = 0
		-- 				didOvershoot = false
		-- 			end

		-- 			position.position = position.position + velocitySlice

		-- 			if (didOvershoot or distance == 0) and not targetPoint.pathNode:getIsPending() then
		-- 				peep:removeBehavior(TargetPointBehavior)

		-- 				if targetPoint.nextPathNode then
		-- 					targetPoint.nextPathNode:activate(peep)
		-- 				else
		-- 					movement.isStopping = true
		-- 				end
		-- 			end
		-- 		end

		-- 		self.speed[peep] = speed
		-- 	end
		-- end
	end
end

return MoveToPointCortex
