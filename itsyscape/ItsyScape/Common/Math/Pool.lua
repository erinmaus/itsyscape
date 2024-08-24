--------------------------------------------------------------------------------
-- ItsyScape/Common/Math/Pool.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Pool = Class()

Pool.TypePool = Class()

function Pool.TypePool:new(WrappedType, parent)
	self.WrappedType = WrappedType
	self.parent = pool

	self.pools = {}

	self.top = 0
end

function Pool.TypePool:get(...)
	self.top = self.top + 1

	local v
	if self.top < #self.pool then
		v = self.WrappedType(self, self.top, ...)
		self.pool[self.top] = v
	else
		v = self.pool[self.top]
		v:new(self, self.top, ...)
	end

	return v
end

function Pool.TypePool:getGeneration()
	return self.parent:getGeneration()
end

function Pool.TypePool:update()
	local i = ((self:getGeneration() - 1) % self.parent:getNumFrames()) + 1

	local pool = self.pools[i]
	if not pool then
		pool = {}
		self.pools[i] = pool
	end

	self.pool = pool
	self.top = 0
end

function Pool.TypePool:add(value)
	assert(Class.isType(value, WrappedType), "type mismatch for pool")
	assert(value._pool, "value is not pooled")
	assert(value._pool == self, "value does not belong to this pool")
	assert(value._n and value._generation, "value is malformed")
	assert(value._generation == self:getGeneration(), "value is from a different generation")

	table.insert(self.pool, value)
end

function Pool.TypePool:free(value)
	assert(Class.isType(value, WrappedType), "type mismatch for pool")
	assert(value._pool, "value is not pooled")
	assert(value._pool == self, "value does not belong to this pool")
	assert(value._n and value._generation, "value is malformed")
	assert(value._generation == self:getGeneration(), "value is from a different generation")

	self.pool[value._n] = self.WrappedType(self, value._n)
end

function Pool:new(options)
	self.options = options or {}
	self.poolsByType = {}
	self.pools = {}
	self.currentPool 
	self.generation = 0
end

function Pool:getGeneration()
	return self.generation
end

function Pool:getNumFrames()
	local numFrames = self.options and self.options.numFrames
	return numFrames or (_DEBUG and 60 or 1)
end

function Pool:update()
	self.generation = self.generation + 1

	for _, pool in ipairs(self.pools) do
		pool:update()
	end
end

function Pool:get()

end

function Pool:makeCurrent()
	if Pool._CURRENT or Pool._CURRENT ~= self then
		error("another pool is current")
	end

	Pool._CURRENT = self
end

function Pool:unsetCurrent()
	if Pool._CURRENT ~= self then
		error("this pool is not current")
	end

	Pool._CURRENT = nil
end

function Pool.getCurrent()
	return Pool._CURRENT
end

function Pool:getPool(WrappedType)
	local pool = self.poolsByType[WrappedType]
	if not pool then
		pool = Pool.TypePool(WrappedType, self)
		self.poolsByType[WrappedType] = pool
	end

	return pool
end

function Pool.wrap(Type)
	local WrappedType, Metatable = Class(Type, 2)
	
	function WrappedType:new(pool, n, ...)
		Type.new(self, ...)

		self._pool = pool
		self._n = n
		self._generation = pool and pool:getGeneration()
	end

	function WrappedType:keep(other)
		if other then
			assert(Class.isType(other, WrappedType), "other is not same type")

			self:copy(other)
			return other
		end

		if self._pool and self._n and self._generation then
			self._pool:free(self)

			self._pool = nil
			self._n = nil
			self._generation = nil
		end

		return self
	end

	function WrappedType:compatible(other)
		if not _DEBUG then
			return true
		end

		if not other and and self._generation then
			local current = Pool.getCurrent()
			if current then
				return self._generation == current:getGeneration()
			end

			return true
		end

		if self._generation and other._generation then
			return self._generation == other._generation
		end

		return true
	end

	function WrappedType:getIsPooled()
		return self._pool and self._n and self._generation
	end

	Metatable.__add = Type._METATABLE.__add and function(...)
		return Type._METATABLE.__add(...)
	end

	Metatable.__sub = Type._METATABLE.__sub and function(...)
		return Type._METATABLE.__sub(...)
	end

	Metatable.__mul = Type._METATABLE.__mul and function(...)
		return Type._METATABLE.__mul(...)
	end

	Metatable.__div = Type._METATABLE.__div and function(...)
		return Type._METATABLE.__div(...)
	end

	Metatable.__unm = Type._METATABLE.__unm and function(...)
		return Type._METATABLE.__unm(...)
	end

	Metatable.__pow = Type._METATABLE.__pow and function(...)
		return Type._METATABLE.__pow(...)
	end

	Metatable.__eq = Type._METATABLE.__eq and function(...)
		return Type._METATABLE.__eq(...)
	end

	local C = getmetatable(WrappedType)
	local constructor = C.__call
	function C.__call(self, a, ...)
		local pool, n
		if Class.isCompatibleType(a, Pool.TypePool) then
			return constructor(a, b, ...)
		end

		local current = Pool.getCurrent()
		if not current then
			return constructor(nil, nil, a, ...)
		end

		pool = Pool.getCurrent():getPool(WrappedType)
		return pool:get(a, ...)
	end

	return WrappedType
end

return Pool
