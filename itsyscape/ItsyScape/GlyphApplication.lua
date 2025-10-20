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
local PostProcessPass = require "ItsyScape.Graphics.PostProcessPass"
local ProjectedOldOneGlyph = require "ItsyScape.Graphics.ProjectedOldOneGlyph"
local QuadSceneNode = require "ItsyScape.Graphics.QuadSceneNode"
local SceneNode = require "ItsyScape.Graphics.SceneNode"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"

local GlyphApplication = Class(EditorApplication)

function GlyphApplication:new()
	EditorApplication.new(self)

	self.glyphSphere = self:getGameView():getResourceManager():load(StaticMeshResource, "ItsyScape/Graphics/Resources/OldOneGlyphSphere.lstatic")

	self.planeNode = QuadSceneNode()
	self.planeNode:getMaterial():setColor(Color(1, 0, 0, 0.5))
	self.planeNode:getTransform():setLocalRotation(Quaternion.X_90)
	self.planeNode:getTransform():setLocalScale(Vector(30))
	self.planeNode:setParent(self:getGameView():getScene())

	self:getCamera():setVerticalRotation(0)
	self:getCamera():setHorizontalRotation(0)

	self.glyphManager = GlyphManager(nil, self:getGameView())
	self.rootGlyph = self.glyphManager:tokenize([[
		Harken back to when Yendor tore through the walls of the Realm,
		and in Her image, render the earthen shell of the Realm Itself asunder.
	]])

	self:updateGlyph(self.rootGlyph)

	self.shaderCache = PostProcessPass(self:getGameView():getRenderer(), 0)
	self.shaderCache:load(self:getGameView():getResourceManager())

	self.shakyShader = self.shaderCache:loadPostProcessShader("ShakyVertex")
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

	self.planeAxis = Vector(math.cos((self.planeRotationTime or 0) / math.pi / 8), 1, math.sin((self.planeRotationTime or 0) / math.pi / 8))
	self.planeRotation = Quaternion.fromAxisAngle(self.planeAxis:getNormal(), math.sin((self.planeRotationTime or 0) / math.pi / 8) * math.pi / 8)
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

	self.rootGlyph:update(delta)
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
	love.graphics.setColor(Color.fromHexString("463779"):get())

	local projections = self.glyphManager:projectAll(self.rootGlyph, planeNormal, planeD)
	self.glyphManager:draw(self.rootGlyph, projections, width / 4, 0, width, height, 200, love.timer.getTime() % 0.25)

	love.graphics.pop()
end

return GlyphApplication
