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

local MASK_SHADER = love.graphics.newShader([[
	uniform Image scape_ClipMask;

	vec4 effect(
		vec4 color,
		Image texture,
		vec2 textureCoordinate,
		vec2 screenCoordinate)
	{
		float shapeMaskSample = Texel(texture, textureCoordinate).r;
		float clipMaskSample = Texel(scape_ClipMask, textureCoordinate).r;

		return vec4(color.rgb, step(0.5, shapeMaskSample) * step(0.5, clipMaskSample));
	}
]])

PathTexture.Path = Class()

function PathTexture.Path:new(id, color, points, clip)
	self.id = id
	self.color = color

	self.mesh = love.graphics.newMesh(points, 'triangles', 'static')

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

function PathTexture.Path.loadFromTable(path, index)
	local points = {}
	for i, subpath in ipairs(path) do
		local success, result = pcall(love.math.triangulate, subpath)
		if not success then
			Log.warn("Could not triangulate subpath %d for path %s: %s", i, path.id or index, result)
		else
			local triangulation = love.math.triangulate(subpath)

			for _, triangle in ipairs(triangulation) do
				table.insert(points, { triangle[1], triangle[2] })
				table.insert(points, { triangle[3], triangle[4] })
				table.insert(points, { triangle[5], triangle[6] })
			end
		end
	end

	local color = Color.fromHexString((path.fill and path.fill:sub(2)) or "ffffff")

	if coroutine.running() then
		coroutine.yield()
	end

	if #points == 0 then
		Log.warn("Couldn't triangulate path %s! No points.", path.id or index)
		return nil
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

	for i, path in ipairs(t.paths) do
		local p = PathTexture.Path.loadFromTable(path, i)
		if p then
			texture:addPath(p)
		end
	end

	for i, path in ipairs(t.clips) do
		local c = PathTexture.Path.loadFromTable(path, i)
		if c then
			texture:addClip(c)
		end
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
	
	local maskCanvas = love.graphics.newCanvas(self.width, self.height)
	local shapeCanvas = love.graphics.newCanvas(self.width, self.height)

	love.graphics.push("all")
	love.graphics.setMeshCullMode("none")
	love.graphics.origin()

	love.graphics.setCanvas(canvas)
	love.graphics.clear(0, 0, 0, 0)

	for _, path in ipairs(self.paths) do
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.setShader()
		love.graphics.setStencilTest()

		local clipPaths = path:getClipPaths()
		if #clipPaths > 0 then
			love.graphics.setCanvas({ maskCanvas, stencil = true })
			love.graphics.clear(0, 0, 0, 1, 0, false)

			for i = #clipPaths, 1, -1 do
				local clipPath = self.clips[clipPaths[i]]
				if clipPath then
					love.graphics.stencil(function()
						clipPath:draw()
					end, "invert", 0, true)
				end
			end

			love.graphics.setStencilTest("notequal", 0)
			love.graphics.rectangle("fill", 0, 0, self.width, self.height)
		else
			love.graphics.setCanvas(maskCanvas)
			love.graphics.clear(1, 1, 1, 1)
		end

		love.graphics.setCanvas({ shapeCanvas, stencil = true })
		love.graphics.clear(0, 0, 0, 1, 0, false)
		love.graphics.setStencilTest()
		love.graphics.stencil(function()
			path:draw()
		end, "invert", 0, true)
		love.graphics.setStencilTest("notequal", 0)
		love.graphics.rectangle("fill", 0, 0, self.width, self.height)
		
		love.graphics.setCanvas(canvas)
		love.graphics.setStencilTest()
		love.graphics.setColor((colors[path:getID()] or path:getColor()):get())
		love.graphics.setShader(MASK_SHADER)
		MASK_SHADER:send("scape_ClipMask", maskCanvas)
		love.graphics.draw(shapeCanvas)

		if path.id == "left-eye" then
			maskCanvas:newImageData():encode("png", "left-eye.mask.png")
			shapeCanvas:newImageData():encode("png", "left-eye.shape.png")
		end
	end
	love.graphics.pop("all")

	shapeCanvas:release()
	maskCanvas:release()

	return canvas
end

return PathTexture
