--------------------------------------------------------------------------------
-- ItsyScape/Graphics/Video.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Color = require "ItsyScape.Graphics.Color"
local Resource = require "ItsyScape.Graphics.Resource"

local PathTexture = Class()

PathTexture.Path = Class()
PathTexture.Path.VERTEX_FORMAT = {
	{ "VertexPosition", "float", 2 },
}

function PathTexture.Path:new(id, color, points, clip)
	self.id = id
	self.color = color

	self.mesh = love.graphics.newMesh(PathTexture.Path.VERTEX_FORMAT, points, 'triangles', 'static')
	self.mesh:setAttributeEnabled("VertexPosition", true)

	self.clip = { unpack(clip) }
end

function PathTexture.Path:getID()
	return self.id
end

function PathTexture.Path:getColor()
	return self.color
end

function PathTexture.Path:getClipPaths()
	return self.clip
end

function PathTexture.Path:draw(color)
	local c = color or self.color or Color()

	love.graphics.setColor(c:get())
	love.graphics.draw(self.mesh)
end

function PathTexture.Path.loadFromTable(path)
	local points = {}
	for _, subpath in ipairs(path) do
		local triangulation = love.math.triangulate(subpath)

		for _, triangle in ipairs(triangulation) do
			table.insert(points, { triangle[1], triangle[2] })
			table.insert(points, { triangle[3], triangle[4] })
			table.insert(points, { triangle[5], triangle[6] })
		end
	end

	local color = Color.fromHexString((path.color and path.color:sub(2)) or "ffffff")

	if coroutine.running() then
		coroutine.yield()
	end

	return PathTexture.Path(path.id, color, points, path.clip or {})
end

function PathTexture:new(width, height)
	self.width = width
	self.height = height

	self.clips = {}
	self.paths = {}
end

function PathTexture:getWidth()
	return self.width
end

function PathTexture:getHeight()
	return self.height
end

function PathTexture:addPath(path)
	table.insert(self.paths, path)
end

function PathTexture:addClip(path)
	self.clips[path:getID()] = path
end

function PathTexture.loadFromTable(t)
	local texture = PathTexture(t.width, t.height)

	for _, path in ipairs(t.paths) do
		local p = PathTexture.Path.loadFromTable(path)
		texture:addPath(p)
	end

	for _, path in ipairs(t.clips) do
		local c = PathTexture.Path.loadFromTable(path)
		texture:addClip(c)
	end

	return texture
end

function PathTexture.loadFromFile(filename)
	local value = Resource.readLua(filename)
	local t = value or { width = 1, height = 1, paths = {}, clips = {} }

	return PathTexture.loadFromTable(t)
end


function PathTexture:draw(canvas, colors)
	colors = colors or {}

	if not canvas or canvas:getWidth() ~= self.width or canvas:getHeight() ~= self.height then
		canvas = love.graphics.newCanvas(self.width, self.height)
	end

	love.graphics.push("all")
	love.graphics.origin()
	love.graphics.setCanvas({ canvas, stencil = true })
	love.graphics.clear(0, 0, 0, 0)

	for _, path in ipairs(self.paths) do
		love.graphics.clear(false, true, false)

		-- local clipPaths = path:getClipPaths()
		-- local compare = 1

		-- if #clipPaths > 0 then
		-- 	compare = 0

		-- 	for i = #clipPaths, 1, -1 do
		-- 		local clipPath = self.clips[clipPaths[i]]
		-- 		if clipPath then
		-- 			love.graphics.stencil(function()
		-- 				clipPath:draw()
		-- 			end, "invert", 0, false)
		-- 		end
		-- 	end
		-- end

		-- love.graphics.stencil(function()
		-- 	path:draw()
		-- end, "invert", 0, false)

		-- love.graphics.setStencilTest("notequal", compare)
		path:draw(colors[path:getID()])
	end
	love.graphics.pop("all")

	return canvas
end

return PathTexture
