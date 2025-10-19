--------------------------------------------------------------------------------
-- ItsyScape/GlyphApplication.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Ray = require "ItsyScape.Common.Math.Ray"
local Vector = require "ItsyScape.Common.Math.Vector"
local EditorApplication = require "ItsyScape.Editor.EditorApplication"
local Color = require "ItsyScape.Graphics.Color"
local Decoration = require "ItsyScape.Graphics.Decoration"
local DecorationSceneNode = require "ItsyScape.Graphics.DecorationSceneNode"
local GlyphManager = require "ItsyScape.Graphics.GlyphManager"
local OldOneGlyph = require "ItsyScape.Graphics.OldOneGlyph"
local QuadSceneNode = require "ItsyScape.Graphics.QuadSceneNode"
local ProjectedOldOneGlyph = require "ItsyScape.Graphics.ProjectedOldOneGlyph"
local SceneNode = require "ItsyScape.Graphics.SceneNode"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"

local GlyphApplication = Class(EditorApplication)

function GlyphApplication:new()
	EditorApplication.new(self)

	self.glyphSphere = self:getGameView():getResourceManager():load(StaticMeshResource, "ItsyScape/Graphics/Resources/OldOneGlyphSphere.lstatic")

	self.planeNode = QuadSceneNode()
	self.planeNode:getMaterial():setColor(Color(1, 0, 0, 0.5))
	self.planeNode:getTransform():setLocalRotation(Quaternion.X_90)
	self.planeNode:getTransform():setLocalScale(Vector(5))
	self.planeNode:setParent(self:getGameView():getScene())

	self:getCamera():setVerticalRotation(0)
	self:getCamera():setHorizontalRotation(0)

	self.glyphManager = GlyphManager()
	self.rootGlyph = self.glyphManager:tokenize([[
		Harken back to when Yendor tore through the walls of the Realm,
		and in Her image, render the earthen shell of the Realm Itself asunder.
	]])

	self:updateGlyph(self.rootGlyph)
end

function GlyphApplication:_updateGlyph(node, glyph)
	local decoration = Decoration()
	for _, point in glyph:getGlyph():iterate() do
		decoration:add("glyph", point:getPosition(), Quaternion.IDENTITY, Vector(point:getRadius()))
	end

	local childNode = DecorationSceneNode()
	childNode:fromDecoration(decoration, self.glyphSphere)
	childNode:setParent(node)
	childNode:getMaterial():setColor(Color(0.3))
	childNode:getTransform():setLocalTranslation(glyph:getPosition())

	for _, child in glyph:iterate() do
		self:_updateGlyph(childNode, child)
	end
end

function GlyphApplication:updateGlyph(root)
	if self.currentRootNode then
		self.currentRootNode:setParent()
	end

	self.currentRootNode = SceneNode()
	self.currentRootNode:setParent(self:getGameView():getScene())

	self:_updateGlyph(self.currentRootNode, root)
end

function GlyphApplication:updatePlane(delta)
	self.planeTranslationTime = (self.planeTranslationTime or 0) + delta
	self.planeTranslationY = -(math.sin(self.planeTranslationTime / math.pi / 8) * 2 - 1)

	if love.keyboard.isDown("space") then
		self.planeRotationTime = (self.planeRotationTime or 0) + delta
	end

	self.planeAxis = Vector(math.cos((self.planeRotationTime or 0) / math.pi), 1, math.sin((self.planeRotationTime or 0) / math.pi))
	self.planeRotation = Quaternion.fromAxisAngle(self.planeAxis, math.sin((self.planeRotationTime or 0)) / math.pi)
	--self.planeRotation = Quaternion.fromAxisAngle(Vector.UNIT_Z, math.rad(45 / 2))
	self.planeNormal = self.planeRotation:getNormal():transformVector(Vector.UNIT_Y)

	if love.keyboard.isDown("tab") then
		self:getCamera():setVerticalRotation(0)
		self:getCamera():setHorizontalRotation(0)
		self:getCamera():setRotation(Quaternion.Y_90 * Quaternion.fromVectors(self.planeNormal, Vector.UNIT_Z))
	end

	self.planeNode:getTransform():setLocalTranslation(self.planeRotation:transformVector(Vector(0, -self.planeTranslationY, 0)))
	self.planeNode:getTransform():setLocalRotation(Quaternion.fromVectors(Vector.UNIT_Z, self.planeNormal))
	self.planeNode:tick(1)
end

function GlyphApplication:update(delta)
	EditorApplication.update(self, delta)
	self:updatePlane(delta)
end

local function _getPolygons(points, polygons)
    local result = {}

    if not polygons then
        return result
    end

    for _, polygon in ipairs(polygons) do
        local resultPolygon = {}
        for _, vertex in ipairs(polygon) do
            local i = (vertex - 1) * 2 + 1

            table.insert(resultPolygon, points[i])
            table.insert(resultPolygon, points[i + 1])
        end
        table.insert(result, resultPolygon)
    end

    return result
end

local function _toPoint(p)
	local v = Quaternion.fromAxisAngle(Vector.UNIT_X, math.pi / 2):transformVector(p[3]:getPosition()) * Vector(1, -1, 1)
	local width, height = love.graphics.getWidth(), love.graphics.getHeight()
	local position1 = (v + Vector(10)) * (Vector(height, height, 1) / Vector(20, 20, 1))
	return position1.x, position1.y
end

function GlyphApplication:draw()
	love.graphics.clear(1, 1, 1, 1)

	EditorApplication.draw(self)

	local planeNormal = self.planeNormal
	local planeD = self.planeTranslationY

	local width, height = love.graphics.getWidth(), love.graphics.getHeight()

	love.graphics.push("all")
	love.graphics.setColor(0, 0, 0, 1)

	local projections = self.glyphManager:projectAll(self.rootGlyph, planeNormal, planeD)

	--local projection = self.currentGlyph:project(ProjectedOldOneGlyph(3, 4, 0.5), planeNormal, planeD)

	-- love.graphics.setPointSize(5)
	-- local connections = {}
	-- local pointToIsland = {}
	-- local islands = {}
	-- local lines = {}
	-- for _, p1 in ipairs(points) do
	-- 	local p1Position, p1Radius = unpack(p1)
	-- 	love.graphics.points(_toPoint(p1))

	-- 	local p1Min = p1Position - Vector(p1Radius)
	-- 	local p1Max = p1Position + Vector(p1Radius)

	-- 	for _, p2 in ipairs(points) do
	-- 		local p2Position, p2Radius = unpack(p2)
	-- 		local ray = Ray(p1Position, p1Position:direction(p2Position))
	-- 		local distance = p1Position:distance(p2Position)

	-- 		if p1 ~= p2 then
	-- 			local blocked = false
	-- 			for _, p3 in ipairs(points) do
	-- 				local p3Position, p3Radius = unpack(p3)
	-- 				local p3Min = p3Position - Vector(p3Radius)
	-- 				local p3Max = p3Position + Vector(p3Radius)

	-- 				if p3 ~= p1 and p3 ~= p2 then
	-- 					local hit, _, t = ray:hitBounds(p3Min, p3Max)
	-- 					if hit and t < distance then
	-- 						blocked = true
	-- 						break
	-- 					end
	-- 				end
	-- 			end

	-- 			if not blocked then
	-- 				local x1, y1 = _toPoint(p1)
	-- 				local x2, y2 = _toPoint(p2)

	-- 				table.insert(lines, { x1, y1, x2, y2 })
	-- 			end

	-- 			-- local position1, radius1 = unpack(p1)
	-- 			-- local position2, radius2 = unpack(p2)
	-- 			-- local distance = math.sqrt((position1.x - position2.x) ^ 2 + (position1.y - position2.y) ^ 2)

	-- 			-- if distance <= radius1 + radius2 then
	-- 			-- 	local island = pointToIsland[p1] or pointToIsland[p2]
	-- 			-- 	if not island then
	-- 			-- 		island = { p1, p2, min = position1:min(position2), max = position2:max(position2) }

	-- 			-- 		pointToIsland[p1] = island
	-- 			-- 		pointToIsland[p2] = island

	-- 			-- 		table.insert(islands, island)
	-- 			-- 	end

	-- 			-- 	if not pointToIsland[p1] then
	-- 			-- 		island.min = island.min:min(position1)
	-- 			-- 		island.max = island.max:max(position1)

	-- 			-- 		pointToIsland[p1] = island
	-- 			-- 		table.insert(pointToIsland, p1)
	-- 			-- 	end

	-- 			-- 	if not pointToIsland[p2] then
	-- 			-- 		island.max = island.max:max(position2)
	-- 			-- 		island.max = island.max:max(position2)

	-- 			-- 		pointToIsland[p2] = island
	-- 			-- 		table.insert(pointToIsland, p2)
	-- 			-- 	end
	-- 			-- end
	-- 		end
	-- 	end
	-- end

	-- local lines = {}
	-- for _, island in ipairs(islands) do
	-- 	local center = (island.max - island.min) / 2 + island.min
	-- 	for _, otherIsland in ipairs(islands) do
	-- 		local otherCenter = (otherIsland.max - otherIsland.min) / 2 + otherIsland.min

	-- 		local hit = false
	-- 		for _, i in ipairs(islands) do
	-- 			if island ~= i and otherIsland ~= i then
	-- 				local ray = Ray(center, center:direction(otherCenter))

	-- 				if ray:hitBounds(i.min, i.max) then
	-- 					hit = true
	-- 					break
	-- 				end
	-- 			end
	-- 		end

	-- 		if not hit then
	-- 			local x1, y1 = _toPoint({ center })
	-- 			local x2, y2 = _toPoint({ otherCenter })
	-- 			table.insert(lines, { x1, y1, x2, y2 })
	-- 		end
	-- 	end
	-- end

	-- for _, island in ipairs(islands) do
	-- 	print(">>>> island....", _)
	-- 	for i = 1, #island do
	-- 		local p1 = island[i]
	-- 		local p1Position, p1Radius = unpack(p1)

	-- 		for j = i + 1, #island do
	-- 			local p2 = island[j]
	-- 			local p2Position, p2Radius = unpack(p2)

	-- 			local ray = Ray(p1Position, p1Position:direction(p2Position))

	-- 			local p2Min = p2Position - Vector(p2Radius / 2)
	-- 			local p2Max = p2Position + Vector(p2Radius / 2)

	-- 			local isBlocked = false
	-- 			for _, p3 in ipairs(island) do
	-- 				local p3Position, p3Radius = unpack(p3)
	-- 				local p3Min = p3Position - Vector(p3Radius / 2)
	-- 				local p3Max = p3Position + Vector(p3Radius / 2)

	-- 				if p3 ~= p1 and p3 ~= p2 then
	-- 					if ray:hitBounds(p3Min, p3Max) then
	-- 						isBlocked = true
	-- 						break
	-- 					end
	-- 				end
	-- 			end

	-- 			if not isBlocked then
	-- 				local x1, y1 = _toPoint(p1)
	-- 				local x2, y2 = _toPoint(p2)

	-- 				table.insert(lines, { x1, y1, x2, y2 })
	-- 			end
	-- 		end
	-- 	end
	-- end

	-- love.graphics.setLineWidth(5)
	-- for _, line in ipairs(lines) do
	-- 	--love.graphics.line(unpack(line))
	-- end

	-- local slick = require("slick")
	-- local t = slick.geometry.triangulation.delaunay.new()

	-- for c1, c in pairs(connections) do
	-- 	local p = { _toPoint(c1) }

	-- 	for c2 in pairs(c) do
	-- 		local x, y = _toPoint(c2)
	-- 		table.insert(p, x)
	-- 		table.insert(p, y)
	-- 	end

	-- 	if #p < (3 * 2) then
	-- 		love.graphics.line(p[1], p[2], p[3], p[4])
	-- 	else
	-- 		local inputPoints = t:clean(p, {})
	-- 		local triangles = t:triangulate(p, {}, { refine = false, interior = true, exterior = true, polygonization = false })

	-- 		local polygons = _getPolygons(inputPoints, triangles)
	-- 		for _, poly in ipairs(polygons) do
	-- 			love.graphics.polygon("fill", poly)
	-- 		end

	-- 		print("fill", "POLYGON", Log.dump(polygons))
	-- 	end
	-- end

	-- local min, max = Vector(math.huge), Vector(-math.huge)
	-- for i = 1, #points do
	-- 	local v = (Quaternion.fromVectors(_APP.planeNormal, Vector.UNIT_Y)):getNormal():transformVector(points[i][1])
	-- 	min = min:min(v)
	-- 	max = max:max(v)
	-- end

	-- print(">>> p", Log.dump(points))

	-- print(">>> min", min.x, min.y, "size wh", max.x - min.x, max.y - min.y)

	-- for _, p in ipairs(points) do
	-- 	local x, y = _toPoint(p)
	-- 	local _, radius = unpack(p)
	-- 	love.graphics.circle("fill", x, y, radius * (height / 20))
	-- end

	local t = love.math.newTransform()
	t:setTransformation(width / 2, height / 2, d, width / 100, -width / 100)
	love.graphics.applyTransform(t)
	love.graphics.setLineWidth(0)

	for _, p in ipairs(projections) do
		local glyph, projection = unpack(p)
		projection:polygonize()

		if not projection:getIsEmpty() then
			love.graphics.circle("line", projection:getPosition().x, projection:getPosition().y, glyph:getRadius())
			projection:draw()
		end
	end

	love.graphics.pop()
end

return GlyphApplication
