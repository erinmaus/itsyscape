--------------------------------------------------------------------------------
-- ItsyScape/Game/RPC/RPCService.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"

local RPCService = Class()

function RPCService:new()
	-- Nothing.
end

function RPCService:connect(gameManager)
	self.gameManager = gameManager
end

function RPCService:getIsConnected()
	return self.gameManager ~= nil
end

function RPCService:getGameManager()
	return self.gameManager
end

function RPCService:send(channel, e)
	Class.ABSTRACT()
end

function RPCService:receive()
	return Class.ABSTRACT()
end

return RPCService
