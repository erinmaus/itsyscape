--------------------------------------------------------------------------------
-- ItsyScape/Analytics/Client.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Phantom = require "phantom"
local PhantomClient = require "phantom.client"
local serpent = require "serpent"

local Client = Class()
Client.API_KEY = "9VTXZX3YTXMRY1H5XO0FZPBK1ZS5D503"
Client.EVENTS = require "ItsyScape.Analytics.Events"

function Client:new(filename, key)
	self.API_KEY = key or Client.API_KEY
	self:load(filename or "phantom.cfg")
end

function Client:load(filename)
	local file = love.filesystem.read(filename)
	if file then
		local r, e = loadstring('return ' .. file)
		if not r then
			Log.warn("Failed to parse analytics: '%s'\n", e)
		else
			r, e = pcall(r)
			if not r then
				Log.warn("Failed to load analytics meta: '%s'\n", e)
			else
				return self:init(filename, e)
			end
		end
	end

	return self:init(filename, nil)
end

function Client:init(filename, t)
	if not t then
		t = { enable = true }
	end

	if t.enable then
		if (not t.key or t.key == "") and not _ARGS["anonymous"] then
			Phantom.initialize()
			local result = Phantom.createUser(self.API_KEY, "Peep")
			local key = Phantom.Future.get(result)
			if not key or key == "" then
				Log.warn("Failed to create analytics user.")
				t.enable = false
			else
				Log.info("Created analytics user: %s", key)
				t.key = key
			end
		elseif _ARGS["anonymous"] then
			t.enable = false

			if t.key and t.key ~= "" then
				Phantom.deleteUser(self.API_KEY, t.key)
				t.key = nil
			end
		end
	end
	
	local file = serpent.block(t, { comment = false })
	love.filesystem.write(filename, file)

	self.isEnabled = t.enable and t.key ~= ""
	self.userKey = t.key or false

	if self.isEnabled and self.userKey then
		self.client = PhantomClient(self.API_KEY, self.userKey)
	end
end

function Client:getIsEnabled()
	return self.isEnabled
end

function Client:push(key, value)
	if self.isEnabled and self.client then
		if key and type(key) == 'string' then
			if not value then
				self.client:pushKey(key)
			else
				if type(value) == 'string' then
					self.client:pushString(key, value)
				elseif type(value) == 'number' then
					self.client:pushNumber(key, value)
				end
			end
		end
	end
end

return Client
