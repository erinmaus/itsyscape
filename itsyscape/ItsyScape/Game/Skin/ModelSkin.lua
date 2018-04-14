--------------------------------------------------------------------------------
-- ItsyScape/Game/Skin/ModelSkin.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Skin = require "ItsyScape.Game.Skin.Skin"
local Model = require "ItsyScape.Graphics.Model"

local ModelSkin = Class(Skin)

function ModelSkin.loadFromFile(filename, skeleton)
	return ModelSkin(filename, skeleton)
end

function ModelSkin:new(filename, skeleton)
	self.model = Model(filename, skeleton)
end

function ModelSkin:getModel()
	return self.model
end

return ModelSkin
