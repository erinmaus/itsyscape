--------------------------------------------------------------------------------
-- ItsyScape/Graphics/SceneNode.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local SceneNode = require "ItsyScape.Graphics.SceneNode"
local Decoration = require "ItsyScape.Graphics.Decoration"
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"
local StaticMesh = require "ItsyScape.Graphics.StaticMesh"
local NDecorationSceneNode = require "nbunny.optimaus.scenenode.decorationscenenode"

local DecorationSceneNode = Class(SceneNode)
DecorationSceneNode.DEFAULT_SHADER = ShaderResource()
do
	DecorationSceneNode.DEFAULT_SHADER:loadFromFile("Resources/Shaders/StaticModel")
end

DecorationSceneNode._MIN_INDEX = 1
DecorationSceneNode._MAX_INDEX = 2
DecorationSceneNode._VERTICES_INDEX = 3

function DecorationSceneNode:new()
	SceneNode.new(self, NDecorationSceneNode)

	self:getMaterial():setShader(DecorationSceneNode.DEFAULT_SHADER)
end

function DecorationSceneNode:fromGroup(staticMesh, group)
	self:getHandle():fromGroup(group, staticMesh:getHandle())
end

function DecorationSceneNode:canLerp()
	return self:getHandle():canLerp()
end

-- Note: 'a' and 'b' must already be drawable (e.g., any of the fromX calls).
-- You can call 'canLerp' on 'a' or 'b' to see if they are drawable
function DecorationSceneNode:lerp(a, b, delta)
	self:getHandle():lerp(a:getHandle(), b:getHandle(), delta)
end

function DecorationSceneNode:fromLerp(staticMesh, from, to, delta)
	self:getHandle():fromLerp(staticMesh:getHandle(), from, to, delta)
end

function DecorationSceneNode:fromDecoration(decoration, staticMesh)
	self:getHandle():fromDecoration(decoration:getHandle(), staticMesh:getHandle())
end

return DecorationSceneNode
