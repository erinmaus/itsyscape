--------------------------------------------------------------------------------
-- ItsyScape/Graphics/SkyboxSceneNode.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local SceneNode = require "ItsyScape.Graphics.SceneNode"
local Color = require "ItsyScape.Graphics.Color"
local Light = require "ItsyScape.Graphics.Light"
local NSkyboxSceneNode = require "nbunny.optimaus.scenenode.skyboxscenenode"

local SkyboxSceneNode = Class(SceneNode)

function SkyboxSceneNode:new()
	SceneNode.new(self, NSkyboxSceneNode)
end

return SkyboxSceneNode
