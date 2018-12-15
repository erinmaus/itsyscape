--------------------------------------------------------------------------------
-- ItsyScape/Editor/EditorApplication.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Application = require "ItsyScape.Application"
local Class = require "ItsyScape.Common.Class"
local StringBuilder = require "ItsyScape.Common.StringBuilder"
local AlertWindow = require "ItsyScape.Editor.Common.AlertWindow"
local AmbientLightSceneNode = require "ItsyScape.Graphics.AmbientLightSceneNode"
local DirectionalLightSceneNode = require "ItsyScape.Graphics.DirectionalLightSceneNode"

local EditorApplication = Class(Application)
function EditorApplication:new()
	Application.new(self)

	self.isCameraDragging = false
	self.dragButton = 1

	self.light = DirectionalLightSceneNode()
	do
		self.light:setIsGlobal(true)
		self.light:setDirection(-self:getCamera():getForward())
		self.light:setParent(self:getGameView():getScene())
		
		local ambient = AmbientLightSceneNode()
		ambient:setAmbience(0.4)
		ambient:setParent(self:getGameView():getScene())
	end

	self:getGameView():getRenderer():setCullEnabled(false)
end

function EditorApplication:getOutputDirectoryName(category, resource)
	return string.format(".editor/Resources/Game/%s/%s/", category, resource)
end

function EditorApplication:getOutputFilename(category, resource, ...)
	local r = {
		".editor",
		"Resources",
		"Game",
		category,
		resource,
		...
	}

	return table.concat(r, "/")
end

function EditorApplication:getDirectoryName(category, resource)
	return string.format("Resources/Game/%s/%s/", category, resource)
end

function EditorApplication:fromLocalToOutput(filename)
	local category, resource = filename:match("^Resources%/Game%/([%w_%-]+)%/([%w_%-]+)")
	if category and resource then
		return self:getOutputDirectoryName(category, resource)
	else
		return nil
	end
end

function EditorApplication:isResourceNameValid(resource)
	resource = resource or ""
	resource = StringBuilder.stringify(resource)

	local valid = resource:match("^([%w_%-]+)$")
	if valid then
		return true
	else
		return false
	end
end

function EditorApplication:makeOutputSubdirectory(category, resource, ...)
	local path = self:getOutputFilename(category, resource, ...)
	if not love.filesystem.createDirectory(path) then
		Log.warn("Couldn't create output subdirectory: %s", path)
		return false
	else
		return true
	end
end

function EditorApplication:makeOutputDirectory(category, resource)
	local function remove(path)
		local items = love.filesystem.getDirectoryItems(path)
		for i = 1, #items do
			if love.filesystem.getInfo(items[i], 'directory') then
				remove(items[i])
			else
				love.filesystem.remove(path .. "/" .. items[i])
			end
		end

		love.filesystem.remove(path)
	end

	if not self:isResourceNameValid(resource) then
		Log.warn("Resource name %q invalid.", StringBuilder.stringify(resource))
		local alert = AlertWindow(self)
		alert:open(string.format("Resource name '%s' invalid.", StringBuilder.stringify(resource)))

		return false
	end

	if not self:isResourceNameValid(category) then
		Log.error("Category name %q invalid.", StringBuilder.stringify(category))

		local alert = AlertWindow(self)
		alert:open(string.format("Uh-oh! Category name '%s' invalid.", StringBuilder.stringify(category)))

		return false
	end

	local outputDirectory = self:getOutputDirectoryName(category, resource)
	remove(outputDirectory)

	if love.filesystem.createDirectory(outputDirectory) then
		Log.info("Created game resource %s/%s.", category, resource)
		return true
	else
		Log.warn("Couldn't created output directory '%s'", outputDirectory)
		return false
	end
end

function EditorApplication:tick()
	Application.tick(self)
	
	self.light:setDirection(-self:getCamera():getForward())
end

function EditorApplication:mousePress(x, y, button)
	if not Application.mousePress(self, x, y, button) then
		local isShiftDown = love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift")
		if button == 1 and isShiftDown then
			self:probe(x, y, true)
			return true
		elseif button == 2 and isShiftDown then
			self:probe(x, y, false)
			return true
		elseif button ~= 1 and not isShiftDown then
			self.isCameraDragging = true
			self.dragButton = button
			return false
		end
	else
		return true
	end

	return false
end

function EditorApplication:mouseRelease(x, y, button)
	Application.mouseRelease(self, x, y, button)

	if button ~= 1 then
		self.isCameraDragging = false
	end

	return false
end

function EditorApplication:mouseScroll(x, y)
	Application.mouseScroll(self, x, y)
	local distance = self.camera:getDistance() - y * 0.5
	self:getCamera():setDistance(math.max(distance, 1))

	return false
end

function EditorApplication:mouseMove(x, y, dx, dy)
	Application.mouseMove(self, x, y, dx, dy)

	if self.isCameraDragging then
		local camera = self:getCamera()
		if self.dragButton == 2 then
			local offsetX = dx / 32 * camera:getStrafeLeft()
			local offsetZ = dy / 32 * camera:getStrafeForward()
			local position = camera:getPosition() + offsetX + offsetZ
			camera:setPosition(position)
		elseif self.dragButton == 3 then
			local angle1 = dx / 128
			local angle2 = -dy / 128
			camera:setVerticalRotation(
				camera:getVerticalRotation() + angle1)
			camera:setHorizontalRotation(
				camera:getHorizontalRotation() + angle2)
		end
	end
end

return EditorApplication
