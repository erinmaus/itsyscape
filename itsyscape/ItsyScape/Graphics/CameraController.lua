--------------------------------------------------------------------------------
-- ItsyScape/Graphics/CameraController.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"

local CameraController = Class()
CameraController.PROBE_SELECT_DEFAULT = 1
CameraController.PROBE_CHOOSE_OPTION  = 2
CameraController.PROBE_SUPPRESS       = 3

function CameraController:new(app)
	self.app = app
end

function CameraController:getApp()
	return self.app
end

function CameraController:getGame()
	return self.app:getGame()
end

function CameraController:getGameView()
	return self.app:getGameView()
end

function CameraController:getCamera()
	return self.app:getCamera()
end

function CameraController:mousePress(uiActive, x, y, button)
	return CameraController.PROBE_SUPPRESS
end

function CameraController:mouseRelease(uiActive, x, y, button)
	return CameraController.PROBE_SUPPRESS
end

function CameraController:mouseScroll(uiActive, x, y)
	-- Nothing.
end

function CameraController:mouseMove(uiActive, x, y, dx, dy)
	-- Nothing.
end

function CameraController:update(delta)
	-- Nothing.
end

return CameraController
