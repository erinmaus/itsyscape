--------------------------------------------------------------------------------
-- ItsyScape/GameDB/GameDB.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

-- Creates a safe sandbox.
local function Sandbox()

	local S = {
		assert = assert,
		error = error,
		getmetatable = getmetatable,
		ipairs = ipairs,
		next = next,
		pairs = pairs,
		pcall = pcall,
		print = print,
		rawequal = rawqual,
		rawget = rawget,
		rawset = rawset,
		select = select,
		setmetatable = setmetatable,
		tonumber = tonumber,
		tostring = tostring,
		type = type,
		unpack = unpack,
		xpcall = xpcall,
		coroutine = {
			create = coroutine.create,
			resume = coroutine.resume, 
			running = coroutine.running,
			status = coroutine.status, 
			wrap = coroutine.wrap
		},
		string = {
			byte = string.byte,
			char = string.char,
			find = string.find,
			format = string.format,
			gmatch = string.gmatch,
			gsub = string.gsub,
			len = string.len,
			lower = string.lower,
			match = string.match,
			rep = string.rep,
			reverse = string.reverse,
			sub = string.sub,
			upper = string.upper
		},
		table = {
			insert = table.insert,
			maxn = table.maxn,
			remove = table.remove,
			sort = table.sort,
			concat = table.concat
		},
		math = {
			abs = math.abs,
			acos = math.acos,
			asin = math.asin,
			atan = math.atan,
			atan2 = math.atan2,
			ceil = math.ceil,
			cos = math.cos,
			cosh = math.cosh,
			deg = math.deg,
			exp = math.exp,
			floor = math.floor,
			fmod = math.fmod,
			frexp = math.frexp,
			huge = math.huge,
			ldexp = math.ldexp,
			log = math.log,
			log10 = math.log10,
			max = math.max,
			min = math.min,
			modf = math.modf,
			pi = math.pi,
			pow = math.pow,
			rad = math.rad,
			random = math.random,
			sin = math.sin,
			sinh = math.sinh,
			sqrt = math.sqrt,
			tan = math.tan,
			tanh = math.tanh 
		},
		os = {
			clock = os.clock,
			difftime = os.difftime,
			time = os.time
		},

		Action = require "ItsyScape.GameDB.Commands.Action",
		ActionCategory = require "ItsyScape.GameDB.Commands.ActionCategory",
		ActionType = require "ItsyScape.GameDB.Commands.ActionType",
		--Builder = require "ItsyScape.GameDB.Commands.Builder",
		Game = require "ItsyScape.GameDB.Commands.Game",
		Input = require "ItsyScape.GameDB.Commands.Input",
		Meta = require "ItsyScape.GameDB.Commands.Meta",
		Output = require "ItsyScape.GameDB.Commands.Output",
		Requirement = require "ItsyScape.GameDB.Commands.Requirement",
		Resource = require "ItsyScape.GameDB.Commands.Resource",
		ResourceType = require "ItsyScape.GameDB.Commands.ResourceType"
	}

	S._G = S

	return S
end

return Sandbox
