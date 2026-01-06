--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/DebugManipulate.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local utf8 = require "utf8"
local Class = require "ItsyScape.Common.Class"
local MathCommon = require "ItsyScape.Common.Math.Common"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Vector = require "ItsyScape.Common.Math.Vector"
local Gizmo = require "ItsyScape.Editor.Map.Gizmo"
local Probe = require "ItsyScape.Game.Probe"
local Utility = require "ItsyScape.Game.Utility"
local Actor = require "ItsyScape.Game.Model.Actor"
local Prop = require "ItsyScape.Game.Model.Prop"
local Color = require "ItsyScape.Graphics.Color"
local SceneNode = require "ItsyScape.Graphics.SceneNode"
local Button = require "ItsyScape.UI.Button"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local CloseButton = require "ItsyScape.UI.CloseButton"
local Drawable = require "ItsyScape.UI.Drawable"
local FocusBoundary = require "ItsyScape.UI.FocusBoundary"
local GamepadGridLayout = require "ItsyScape.UI.GamepadGridLayout"
local GridLayout = require "ItsyScape.UI.GridLayout"
local Interface = require "ItsyScape.UI.Interface"
local ItemIcon = require "ItsyScape.UI.ItemIcon"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local ScrollablePanel = require "ItsyScape.UI.ScrollablePanel"
local Theme = require "ItsyScape.UI.Interfaces.Theme"
local SearchPrompt = require "ItsyScape.UI.Interfaces.Components.SearchPrompt"
local PropertiesPrompt = require "ItsyScape.UI.Interfaces.Components.PropertiesPrompt"
local Widget = require "ItsyScape.UI.Widget"

local function camelCaseToTitleCase(t)
	t = t or "???"
	t = t:gsub("[A-Z]", " %1")
	t = t:gsub("[^A-Za-z0-9 ]", "-")
	t = t:gsub("-+", " - ")
	t = t:gsub("%s+", " ")
	t = t:gsub("^[a-z]", function(s) return s:upper() end)

	return t
end

local DebugManipulate = Class(Interface)

DebugManipulate.Action = Class()

function DebugManipulate.Action:new(interface, object, hit)
	self.interface = interface
	self.object = object
	self.hit = hit
end

function DebugManipulate.Action:getInterface()
	return self.interface
end

function DebugManipulate.Action:getUIView()
	return self.interface:getView()
end

function DebugManipulate.Action:getGameView()
	return self.interface:getView():getGameView()
end

function DebugManipulate.Action:getGame()
	return self.interface:getView():getGameView():getGame()
end

function DebugManipulate.Action:getGameDB()
	return self.interface:getView():getGameView():getGame():getGameDB()
end

function DebugManipulate.Action:getObject()
	return self.object
end

function DebugManipulate.Action:getHit()
	return self.hit
end

function DebugManipulate.Action:addPopup(widget)
	self:removePopup()

	self.interface:addPopup(widget)
	self.popup = widget
end

function DebugManipulate.Action:removePopup()
	if self.popup then
		self.interface:removePopup(self.popup)
		self.popup = nil
	end
end

function DebugManipulate.Action:close()
	self.interface:cancelAction()
end

function DebugManipulate.Action:update(delta)
	-- Nothing.
end

function DebugManipulate.Action:start()
	-- Nothing.
end

function DebugManipulate.Action:cancel()
	self:done()
end

function DebugManipulate.Action:stop()
	self:done()
end

function DebugManipulate.Action:done()
	self:removePopup()
end

function DebugManipulate.Action:searchAllResourcesOfType(resourceType)
	local gameDB = self:getGameDB()

	local result = {}
	for resource in gameDB:getResources(resourceType) do
		local name = Utility.getName(resource, gameDB)
		local description = Utility.getDescription(resource, gameDB)

		table.insert(result, {
			id = resource.name,
			name = name,
			description = description
		})
	end

	return function(value)
		if utf8.len(value) <= 3 then
			return {}
		end

		local pattern = value:gsub("%W", "%%%1.*"):gsub("%w", function(s)
			return string.format("[%s%s].*", s:upper(), s:lower())
		end)

		local suggestions = {}
		for _, resource in ipairs(result) do
			if resource.id:match(pattern) or (resource.name and resource.name:match(pattern)) then
				local description
				if resource.name and resource.description then
					description = string.format("%s: %s", resource.name, resource.description)
				else
					description = resource.name or resource.description
				end

				table.insert(suggestions, SearchPrompt.Suggestion(resource.id, resource.id, description))
			end
		end

		return suggestions
	end
end

DebugManipulate.SpawnPropAction = Class(DebugManipulate.Action)

function DebugManipulate.SpawnPropAction:new(...)
	DebugManipulate.Action.new(self, ...)
end

function DebugManipulate.SpawnPropAction:start()
	DebugManipulate.Action.start(self)

	local searchPrompt = SearchPrompt()
	searchPrompt:setText("Find Prop")
	searchPrompt:setSuggestionsGenerator(self:searchAllResourcesOfType("Prop"))
	searchPrompt.onSubmit:register(self._spawn, self)
	searchPrompt.onCancel:register(self.close, self)

	self:addPopup(searchPrompt)
end

function DebugManipulate.SpawnPropAction:_spawn(_, value, suggestion)
	local id = suggestion and suggestion:getID() or value

	local _, _, layer = self:getObject():getTile()
	local x, y, z = self:getObject():getPosition():get()
	self:getInterface():sendPoke(
		"spawnProp",
		nil, {
			id = id,
			layer = layer,
			positionX = x,
			positionY = y,
			positionZ = z,
		})

	self:getInterface():stopAction()
end

DebugManipulate.SpawnGlyphCircleAction = Class(DebugManipulate.Action)

function DebugManipulate.SpawnGlyphCircleAction:new(...)
	DebugManipulate.Action.new(self, ...)
end

function DebugManipulate.SpawnGlyphCircleAction:start()
	DebugManipulate.Action.start(self)

	local propertiesPrompt = PropertiesPrompt()
	propertiesPrompt.onSubmit:register(self._spawn, self)
	propertiesPrompt.onCancel:register(self.close, self)
	propertiesPrompt:setText("Spawn Glyph Circle")
	propertiesPrompt:setProperties({
		PropertiesPrompt.Property("fadeDelay", "Fade Delay", "number", 1000),
		PropertiesPrompt.Property("fadeDuration", "Fade Duration", "number", 5000),
		PropertiesPrompt.Property("glyphDescription", "Glyph Description", "string", "Lorem ipsum."),
		PropertiesPrompt.Property("glyphHeight", "Glyph Height", "number", 8),
		PropertiesPrompt.Property("glyphWidth", "Glyph Width", "number", 8)
	})

	self:addPopup(propertiesPrompt)
end

function DebugManipulate.SpawnGlyphCircleAction:_spawn(_, properties, form)
	local id = suggestion and suggestion:getID() or value

	local _, _, layer = self:getObject():getTile()
	local x, y, z = self:getObject():getPosition():get()
	self:getInterface():sendPoke(
		"spawnGlyphCircle",
		nil, {
			id = id,
			layer = layer,
			positionX = x,
			positionY = y,
			positionZ = z,
			fadeDuration = form["Fade Duration"],
			fadeDelay = form["Fade Delay"],
			glyphDescription = form["Glyph Description"],
			glyphHeight = form["Glyph Height"],
			glyphWidth = form["Glyph Width"],
		})

	self:getInterface():stopAction()
end

DebugManipulate.SpawnActorAction = Class(DebugManipulate.Action)

function DebugManipulate.SpawnActorAction:new(...)
	DebugManipulate.Action.new(self, ...)
end

function DebugManipulate.SpawnActorAction:start()
	DebugManipulate.Action.start(self)

	local searchPrompt = SearchPrompt()
	searchPrompt:setText("Find Actor")
	searchPrompt:setSuggestionsGenerator(self:searchAllResourcesOfType("Peep"))
	searchPrompt.onSubmit:register(self._spawn, self)
	searchPrompt.onCancel:register(self.close, self)

	self:addPopup(searchPrompt)
end

function DebugManipulate.SpawnActorAction:_spawn(_, value, suggestion)
	local id = suggestion and suggestion:getID() or value

	local _, _, layer = self:getObject():getTile()
	local x, y, z = self:getObject():getPosition():get()
	self:getInterface():sendPoke(
		"spawnActor",
		nil, {
			id = id,
			layer = layer,
			positionX = x,
			positionY = y,
			positionZ = z,
		})

	self:getInterface():stopAction()
end

DebugManipulate.PlayAnimationAction = Class(DebugManipulate.Action)

function DebugManipulate.PlayAnimationAction:new(...)
	DebugManipulate.Action.new(self, ...)
end

function DebugManipulate.PlayAnimationAction:start()
	DebugManipulate.Action.start(self)

	local propertiesPrompt = PropertiesPrompt()
	propertiesPrompt.onSubmit:register(self._playAnimation, self)
	propertiesPrompt.onCancel:register(self.close, self)
	propertiesPrompt:setText("Play Animation")
	propertiesPrompt:setProperties({
		PropertiesPrompt.Property("animation", "Animation", "string", ""),
		PropertiesPrompt.Property("priority", "Priority", "number", 1000),
		PropertiesPrompt.Property("slot", "Slot", "string", "x-debug")
	})

	self:addPopup(propertiesPrompt)
end

function DebugManipulate.PlayAnimationAction:_playAnimation(_, _, form)
	local id = self:getObject():getID()

	self:getInterface():sendPoke(
		"playAnimation",
		nil, {
			actorID = id,
			animation = form.Animation,
			slot = form.Slot,
			priority = form.Priority
		})

	self:getInterface():stopAction()
end

DebugManipulate.ChangeSkinAction = Class(DebugManipulate.Action)

function DebugManipulate.ChangeSkinAction:new(...)
	DebugManipulate.Action.new(self, ...)
end

function DebugManipulate.ChangeSkinAction:start()
	DebugManipulate.Action.start(self)

	local propertiesPrompt = PropertiesPrompt()
	propertiesPrompt.onSubmit:register(self._changeSkin, self)
	propertiesPrompt.onCancel:register(self.close, self)
	propertiesPrompt:setText("Change Skin")
	propertiesPrompt:setProperties({
		PropertiesPrompt.Property("filename", "Filename", "string", ""),
		PropertiesPrompt.Property("priority", "Priority", "integer", 1000),
		PropertiesPrompt.Property("slot", "Slot", "string", "x-debug"),
	})

	self:addPopup(propertiesPrompt)
end

function DebugManipulate.ChangeSkinAction:_changeSkin(_, _, form)
	local id = self:getObject():getID()

	self:getInterface():sendPoke(
		"changeSkin",
		nil, {
			actorID = id,
			filename = form.Filename,
			slot = form.Slot,
			priority = form.Priority
		})

	self:getInterface():stopAction()
end

DebugManipulate.TransformAction = Class(DebugManipulate.Action)

function DebugManipulate.TransformAction:new(...)
	DebugManipulate.Action.new(self, ...)
end

function DebugManipulate.TransformAction:start()
	DebugManipulate.Action.start(self)

	local root = self:getUIView():getRoot()
	self.gizmoFacade = DebugManipulate.GizmoFacade(self:getInterface(), self:getObject())
	self:getInterface():addFacade(self.gizmoFacade)
end

function DebugManipulate.TransformAction:done()
	DebugManipulate.Action.done(self)
	self:getInterface():removeFacade(self.gizmoFacade)
end

DebugManipulate.OrientateAction = Class(DebugManipulate.Action)

function DebugManipulate.OrientateAction:new(...)
	DebugManipulate.Action.new(self, ...)
end

function DebugManipulate.OrientateAction:start()
	DebugManipulate.Action.start(self)

	local root = self:getUIView():getRoot()
	self.interactFacade = DebugManipulate.InteractFacade(self:getInterface())
	self.interactFacade:setActionGenerator(function(interface, probe, actions)
		for _, hit in probe:hits() do
			local object = hit:getObject()

			if Class.isCompatibleType(object, Actor) then
				interface:buildActorAction(actions, object, {
					verb = "Orientate-At",
					callback = function()
						self:getInterface():orientateCamera(self:getObject(), object)
						self:getInterface():stopAction()
					end
				})
			end
		end

		table.insert(actions, {
			id = #actions + 1,
			verb = "Orientate-At",
			objectID = self:getObject():getID(),
			objectType = "actor",
			object = "Self",
			callback = function()
				self:getInterface():orientateCamera(self:getObject())
				self:getInterface():stopAction()
			end
		})

		table.insert(actions, {
			id = #actions + 1,
			verb = "Cancel",
			objectID = -1,
			objectType = "action",
			object = "Orientation",
			callback = function()
				self:close()
			end
		})
	end)

	self:getInterface():addFacade(self.interactFacade)
end

function DebugManipulate.OrientateAction:done()
	DebugManipulate.Action.done(self)
	self:getInterface():removeFacade(self.interactFacade)
end

DebugManipulate.LookAtAction = Class(DebugManipulate.Action)

function DebugManipulate.LookAtAction:new(...)
	DebugManipulate.Action.new(self, ...)
end

function DebugManipulate.LookAtAction:start()
	DebugManipulate.Action.start(self)

	local root = self:getUIView():getRoot()
	self.interactFacade = DebugManipulate.InteractFacade(self:getInterface())
	self.interactFacade:setActionGenerator(function(interface, probe, actions)
		for _, hit in probe:hits() do
			local object = hit:getObject()

			if Class.isCompatibleType(object, Actor) then
				interface:buildActorAction(actions, object, {
					verb = "Look-At",
					callback = function()
						interface:pokeAction("lookAt", object)
					end
				})
			elseif Class.isCompatibleType(object, Prop) then
				interface:buildPropAction(actions, object, {
					verb = "Look-At",
					callback = function()
						interface:pokeAction("lookAt", object)
					end
				})
			end
		end

		table.insert(actions, {
			id = #actions + 1,
			verb = "Cancel",
			objectID = -1,
			objectType = "action",
			object = "Look at action",
			callback = function()
				self:close()
			end
		})
	end)

	self:getInterface():addFacade(self.interactFacade)
end

function DebugManipulate.LookAtAction:lookAt(otherObject)
	local objectView = self:getGameView():getView(self:getObject())
	local otherView = self:getGameView():getView(otherObject)

	local objectSceneNode
	if Class.isCompatibleType(self:getObject(), Actor) then
		objectSceneNode = objectView:getSceneNode()
	elseif Class.isCompatibleType(self:getObject(), Prop) then
		objectSceneNode = objectView:getRoot()
	end

	local otherSceneNode
	if Class.isCompatibleType(otherObject, Actor) then
		otherSceneNode = otherView:getSceneNode()
	elseif Class.isCompatibleType(otherObject, Prop) then
		otherSceneNode = otherView:getRoot()
	end

	if not (objectSceneNode and otherSceneNode) then
		return
	end

	local objectTransform = objectSceneNode:getTransform():getGlobalDeltaTransform(1)
	local objectTranslation = MathCommon.decomposeTransform(objectTransform)

	local otherTransform = otherSceneNode:getTransform():getGlobalDeltaTransform(1)
	local otherTranslation = MathCommon.decomposeTransform(otherTransform)

	local rotation = Quaternion.lookAt(objectTranslation, otherTranslation, Vector.UNIT_Y)
	self:getInterface():rotateObject(self:getObject(), rotation)
	self:getInterface():stopAction()
end

function DebugManipulate.LookAtAction:done()
	DebugManipulate.Action.done(self)
	self:getInterface():removeFacade(self.interactFacade)
end

DebugManipulate.PreviewOrientateAction = Class(DebugManipulate.Action)

function DebugManipulate.PreviewOrientateAction:new(...)
	DebugManipulate.Action.new(self, ...)

	local view = self:getGameView():getView(self:getObject())
	local sceneNode = view and view:getSceneNode()
	if sceneNode then
		self.previousTranslation = sceneNode:getTransform():getLocalTranslation()
		self.previousRotation = sceneNode:getTransform():getLocalRotation()
	end

	self.currentDuration = 2
	self.currentElapsed = 0

	self.interactionLock = 0
	self.isInteractive = false
end

function DebugManipulate.PreviewOrientateAction:startCameraInteraction()
	self.interactionLock = self.interactionLock + 1
	self.isInteractive = self.interactionLock > 0

	if self.isInteractive then
		self.currentElapsed = 0
	end
end

function DebugManipulate.PreviewOrientateAction:stopCameraInteraction()
	self.interactionLock = self.interactionLock - 1
	self.isInteractive = self.interactionLock > 0
end

function DebugManipulate.PreviewOrientateAction:updateCameraTranslation(translation)
	local view = self:getGameView():getView(self:getObject())
	local sceneNode = view and view:getSceneNode()

	if not sceneNode then
		return
	end

	local parentSceneNode = sceneNode:getTransform()
	if parentSceneNode then
		local parentTransform = parentSceneNode:getGlobalDeltaTransform(1)
		self.targetTranslation = translation:inverseTransform(transform)
	else
		self.targetTranslation = translation
	end

	sceneNode:getTransform():setLocalTranslation(self.targetTranslation)
end

function DebugManipulate.PreviewOrientateAction:updateCameraRotation(rotation)
	local view = self:getGameView():getView(self:getObject())
	local sceneNode = view and view:getSceneNode()

	if not sceneNode then
		return
	end

	local parentSceneNode = sceneNode:getParent()
	if not parentSceneNode then
		return
	end

	local parentTransform = parentSceneNode:getTransform():getGlobalDeltaTransform(1)
	local _, globalRotation = MathCommon.decomposeTransform(parentTransform)

	self.targetRotation = -globalRotation * rotation
	sceneNode:getTransform():setLocalRotation(self.targetRotation)
end

function DebugManipulate.PreviewOrientateAction:start()
	DebugManipulate.Action.start(self)

	local player = self:getGame():getPlayer()
	player:onPushCamera("DebugManipulate")
	player:onPokeCamera("enableInteraction")
	player:onPokeCamera("copyActorTransforms", self:getObject():getID())

	self.facade = DebugManipulate.ThirdsFacade()
	self:getInterface():addFacade(self.facade)
end

function DebugManipulate.PreviewOrientateAction:update(delta)
	DebugManipulate.Action.update(self, delta)

	if not self.isInteractive then
		self.currentElapsed = math.min(self.currentElapsed + delta, self.currentDuration)
		if self.currentElapsed >= self.currentDuration then
			self:getInterface():stopAction()
		end
	end
end

function DebugManipulate.PreviewOrientateAction:done()
	local player = self:getGame():getPlayer()
	player:onPopCamera()

	local view = self:getGameView():getView(self:getObject())
	local sceneNode = view and view:getSceneNode()
	local parentSceneNode = sceneNode and sceneNode:getParent()
	local parentTransform = parentSceneNode and parentSceneNode:getTransform():getGlobalDeltaTransform(1)

	if self.targetTranslation then
		local translation = self.targetTranslation
		if parentTransform then
			translation = translation:inverseTransform(parentTransform)
		end

		self:getInterface():translateObject(self:getObject(), translation)
	end

	if self.targetRotation then
		local rotation = self.targetRotation
		if parentTransform then
			local _, parentRotation = MathCommon.decomposeTransform(parentTransform)
			rotation = -parentRotation * rotation
		end

		self:getInterface():rotateObject(self:getObject(), rotation)
	end

	if sceneNode then
		if self.previousRotation then
			sceneNode:getTransform():setLocalRotation(self.previousRotation)
		end

		if self.previousTranslation then
			sceneNode:getTransform():setLocalTranslation(self.previousTranslation)
		end
	end

	if self.facade then
		self:getInterface():removeFacade(self.facade)
	end
end

DebugManipulate.FireProjectileAction = Class(DebugManipulate.Action)

function DebugManipulate.FireProjectileAction:new(...)
	DebugManipulate.Action.new(self, ...)
end

function DebugManipulate.FireProjectileAction:start()
	DebugManipulate.Action.start(self)

	local root = self:getUIView():getRoot()
	self.interactFacade = DebugManipulate.InteractFacade(self:getInterface())
	self.interactFacade:setActionGenerator(function(interface, probe, actions)
		for _, hit in probe:hits() do
			local object = hit:getObject()

			if Class.isCompatibleType(object, Actor) then
				interface:buildActorAction(actions, object, {
					verb = "Fire-Projectile-At",
					callback = function()
						interface:pokeAction("fireProjectileAt", object)
					end
				})
			elseif Class.isCompatibleType(object, Prop) then
				interface:buildPropAction(actions, object, {
					verb = "Fire-Projectile-At",
					callback = function()
						interface:pokeAction("fireProjectileAt", object)
					end
				})
			end
		end

		table.insert(actions, {
			id = #actions + 1,
			verb = "Cancel",
			objectID = -1,
			objectType = "action",
			object = "Fire projectile action",
			callback = function()
				self:close()
			end
		})
	end)

	self:getInterface():addFacade(self.interactFacade)
end

function DebugManipulate.FireProjectileAction:searchAllProjectiles()
	local projectiles = {}

	local pathName = "Resources/Game/Projectiles"
	for _, item in ipairs(love.filesystem.getDirectoryItems(pathName)) do
		local filename = string.format("%s/%s/Projectile.lua", pathName, item)
		if love.filesystem.getInfo(filename) then
			table.insert(projectiles, item)
		end
	end

	return function(value)
		if utf8.len(value) == 0 then
			return {}
		end

		local pattern = value:gsub("%W", "%%%1.*"):gsub("%w", function(s)
			return string.format("[%s%s].*", s:upper(), s:lower())
		end)

		local suggestions = {}
		for _, projectile in ipairs(projectiles) do
			if projectile:match(pattern) or projectile:match(value) then
				table.insert(suggestions, SearchPrompt.Suggestion(projectile, projectile, camelCaseToTitleCase(projectile)))
			end
		end

		return suggestions
	end
end

function DebugManipulate.FireProjectileAction:fireProjectileAt(otherObject)
	self:getInterface():removeFacade(self.interactFacade)
	self.interactFacade = nil

	local searchPrompt = SearchPrompt()
	searchPrompt:setText("Find Projectile")
	searchPrompt:setSuggestionsGenerator(self:searchAllProjectiles())
	searchPrompt.onSubmit:register(self._fireProjectile, self, otherObject)
	searchPrompt.onCancel:register(self.close, self)

	self:addPopup(searchPrompt)
end

function DebugManipulate.FireProjectileAction:_fireProjectile(otherObject, _, value)
	self:getInterface():fireProjectileAt(self:getObject(), otherObject, value)
	self:getInterface():stopAction()
end

function DebugManipulate.FireProjectileAction:done()
	DebugManipulate.Action.done(self)

	if self.interactFacade then
		self:getInterface():removeFacade(self.interactFacade)
	end
end

DebugManipulate.SimulateAttackAction = Class(DebugManipulate.Action)

function DebugManipulate.SimulateAttackAction:new(...)
	DebugManipulate.Action.new(self, ...)
end

function DebugManipulate.SimulateAttackAction:start()
	DebugManipulate.Action.start(self)

	local root = self:getUIView():getRoot()
	self.interactFacade = DebugManipulate.InteractFacade(self:getInterface())
	self.interactFacade:setActionGenerator(function(interface, probe, actions)
		for _, hit in probe:hits() do
			local object = hit:getObject()

			if Class.isCompatibleType(object, Actor) then
				interface:buildActorAction(actions, object, {
					verb = "Simulate-Attack-Vs",
					callback = function()
						self:getInterface():simulateAttack(self:getObject(), object)
						self:getInterface():stopAction()
					end
				})
			end
		end

		table.insert(actions, {
			id = #actions + 1,
			verb = "Cancel",
			objectID = -1,
			objectType = "action",
			object = "Simulate attack action",
			callback = function()
				self:close()
			end
		})
	end)

	self:getInterface():addFacade(self.interactFacade)
end

function DebugManipulate.SimulateAttackAction:done()
	DebugManipulate.Action.done(self)

	if self.interactFacade then
		self:getInterface():removeFacade(self.interactFacade)
	end
end

DebugManipulate.WalkAction = Class(DebugManipulate.Action)

function DebugManipulate.WalkAction:new(...)
	DebugManipulate.Action.new(self, ...)
end

function DebugManipulate.WalkAction:start()
	DebugManipulate.Action.start(self)

	local root = self:getUIView():getRoot()
	self.interactFacade = DebugManipulate.InteractFacade(self:getInterface())
	self.interactFacade:setActionGenerator(function(interface, probe, actions)
		for _, hit in probe:hits() do
			local object = hit:getObject()

			if Class.isCompatibleType(object, Probe.Tile) then
				interface:buildTileAction(actions, object, {
					verb = "Walk-To",
					callback = function()
						self:getInterface():walk(self:getObject(), object)
						self:getInterface():stopAction()
					end
				})
			end
		end

		table.insert(actions, {
			id = #actions + 1,
			verb = "Cancel",
			objectID = -1,
			objectType = "action",
			object = "walk",
			callback = function()
				self:close()
			end
		})
	end)

	self:getInterface():addFacade(self.interactFacade)
end

function DebugManipulate.WalkAction:done()
	DebugManipulate.Action.done(self)

	if self.interactFacade then
		self:getInterface():removeFacade(self.interactFacade)
	end
end

DebugManipulate.TalkAction = Class(DebugManipulate.Action)

function DebugManipulate.TalkAction:new(...)
	DebugManipulate.Action.new(self, ...)
end

function DebugManipulate.TalkAction:start()
	DebugManipulate.Action.start(self)

	local propertiesPrompt = PropertiesPrompt()
	propertiesPrompt.onSubmit:register(self._playAnimation, self)
	propertiesPrompt.onCancel:register(self.close, self)
	propertiesPrompt:setText("Play Animation")
	propertiesPrompt:setProperties({
		PropertiesPrompt.Property("message", "Message", "string", ""),
		PropertiesPrompt.Property("color", "Color", "number", "ffff00"),
	})

	self:addPopup(propertiesPrompt)
end

function DebugManipulate.TalkAction:_playAnimation(_, _, form)
	local id = self:getObject():getID()

	self:getInterface():sendPoke(
		"talk",
		nil, {
			actorID = id,
			message = form.Message,
			color = form.Color
		})

	self:getInterface():stopAction()
end

DebugManipulate.WIDTH  = 800
DebugManipulate.HEIGHT = 600
DebugManipulate.TITLE_HEIGHT = 48

DebugManipulate.Root = Class(Widget)

function DebugManipulate.Root:getOverflow()
	return true
end

DebugManipulate.ThirdsFacade = Class(Drawable)

function DebugManipulate.ThirdsFacade:new()
	Drawable.new(self)

	self:setIsSelfClickThrough(true)
end

function DebugManipulate.ThirdsFacade:draw()
	local width, height = self:getSize()

	love.graphics.setLineWidth(2)
	love.graphics.setColor(1, 1, 1, 1)
	for i = 1, 2 do
		local x = width * (i / 3)
		itsyrealm.graphics.line(x, 0, x, height)
	end

	for i = 1, 2 do
		local y = height * (i / 3)
		itsyrealm.graphics.line(0, y, width, y)
	end

	love.graphics.setLineWidth(1)
	love.graphics.setColor(1, 1, 1, 0.5)
	itsyrealm.graphics.line(0.5 * width, 0, 0.5 * width, height)
	itsyrealm.graphics.line(0, 0.5 * height, width, 0.5 * height)

	love.graphics.setLineWidth(1)
	love.graphics.setColor(1, 1, 1, 1)
end

function DebugManipulate.ThirdsFacade:performLayout()
	Drawable.performLayout(self)

	local w, h = itsyrealm.graphics.getScaledMode()
	self:setSize(w, h)
	self:setPosition(0, 0)
	self:setZDepth(-1000)
end

DebugManipulate.GizmoFacade = Class(Drawable)
function DebugManipulate.GizmoFacade:new(interface, object)
	Drawable.new(self)

	self.interface = interface
	self.object = object

	self.gizmo = Gizmo(object, Gizmo.BoundingBoxOperation())
	self.gizmo:setHoverDistance(-math.huge)
	self.gizmoOperation = Gizmo.OPERATION_BOUNDS
	self.isGizmoGrabbed = false
end

function DebugManipulate.GizmoFacade:performLayout()
	Drawable.performLayout(self)

	local w, h = itsyrealm.graphics.getScaledMode()
	self:setSize(w, h)
	self:setPosition(0, 0)
	self:setZDepth(-1000)
end

function DebugManipulate.GizmoFacade:getIsFocusable()
	return true
end

function DebugManipulate.GizmoFacade:getProxySceneNode()
	local gameView = self.interface:getView():getGameView()
	local view = gameView:getView(self.object)

	local baseSceneNode
	if Class.isCompatibleType(self.object, Actor) then
		baseSceneNode = view:getSceneNode()
	elseif Class.isCompatibleType(self.object, Prop) then
		baseSceneNode = view:getRoot()
	end

	if not baseSceneNode then
		return SceneNode()
	end

	local result = SceneNode()
	result:setParent(baseSceneNode:getParent())

	local baseTransform = baseSceneNode:getTransform()
	local resultTransform = result:getTransform()

	local t, r, s = baseTransform:getPreviousTransform()
	resultTransform:setPreviousTransform(t, r, s)
	resultTransform:setLocalTranslation(baseTransform:getLocalTranslation())
	resultTransform:setLocalRotation(baseTransform:getLocalRotation())
	resultTransform:setLocalScale(baseTransform:getLocalScale())

	return result
end

function DebugManipulate.GizmoFacade:keyUp(key, ...)
	Drawable.keyUp(self, key, ...)

	if key == "g" then
		self.gizmo = Gizmo(self.object,
			Gizmo.TranslationAxisOperation(Vector.UNIT_X),
			Gizmo.TranslationAxisOperation(Vector.UNIT_Y),
			Gizmo.TranslationAxisOperation(Vector.UNIT_Z))
		self.gizmoOperation = Gizmo.OPERATION_TRANSLATION
		self.isGizmoGrabbed = false
	elseif key == "r" then
		self.gizmo = Gizmo(
			target,
			Gizmo.RotationAxisOperation(Vector.UNIT_X),
			Gizmo.RotationAxisOperation(Vector.UNIT_Y),
			Gizmo.RotationAxisOperation(Vector.UNIT_Z))
		self.gizmoOperation = Gizmo.OPERATION_ROTATION
		self.isGizmoGrabbed = false
	elseif key == "s" then
		self.gizmo = Gizmo(
			target,
			Gizmo.ScaleAxisOperation(Vector.UNIT_X),
			Gizmo.ScaleAxisOperation(Vector.UNIT_Y),
			Gizmo.ScaleAxisOperation(Vector.UNIT_Z),
			Gizmo.ScaleAxisOperation(Vector.ONE))
		self.gizmoOperation = Gizmo.OPERATION_SCALE
		self.isGizmoGrabbed = false
	elseif key == "return" then
		self.interface:stopAction()
	elseif key == "escape" then
		self.interface:cancelAction()
	end
end

function DebugManipulate.GizmoFacade:mousePress(x, y, button)
	Drawable.mousePress(self, x, y, button)

	if button == 1 then
		local gameView = self.interface:getView():getGameView()
		local sceneNode = self:getProxySceneNode()

		local x, y = love.mouse.getPosition()
		self.isGizmoGrabbed = self.gizmo:hover(x, y, gameView:getCamera(), sceneNode)
		if self.isGizmoGrabbed then
			self.gizmoGrabX = x
			self.gizmoGrabY = y
		end

		sceneNode:setParent()
	elseif button == 2 then
		_APP:probe(x, y, false, function(probe)
			local actions = {}

			for _, hit in probe:hits() do
				local object = hit:getObject()
				if Class.isCompatibleType(object, Probe.Tile) then
					self.interface:buildTileAction(actions, object, {
						verb = "Set-Layer",
						callback = function()
							self.interface:setLayer(self.object, object)
						end
					})
				end
			end

			table.insert(actions, {
				id = #actions + 1,
				verb = "Finish-Transform",
				objectID = self.object:getID(),
				objectType = (Class.isCompatibleType(self.object, Actor) and "actor") or (Class.isCompatibleType(self.object, Actor) and "prop"),
				object = self.object:getName(),
				callback = function()
					self.interface:stopAction()
				end
			})

			local ui = self:getUIView()
			ui:probe(actions, x, y)
		end)
	end

	_APP.cameraController:mousePress(self.isGizmoGrabbed, _x, _y, button)
end

function DebugManipulate.GizmoFacade:mouseRelease(x, y, button)
	Drawable.mouseRelease(self, x, y, button)

	local wasGizmoGrabbed = self.isGizmoGrabbed

	if button == 1 then
		self.isGizmoGrabbed = false
	end

	_APP.cameraController:mouseRelease(self.isGizmoGrabbed, _x, _y, button)
end

function DebugManipulate.GizmoFacade:mouseMove(rx, ry, dx, dy, ...)
	Drawable.mouseMove(self, rx, ry, dx, dy, ...)

	local gameView = self.interface:getView():getGameView()
	local sceneNode = self:getProxySceneNode()

	local x, y = love.mouse.getPosition()
	if self.isGizmoGrabbed then
		local isSnapped = love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift")
		local isUpdated = false

		if isSnapped then
			if self.gizmo:move(x, y, self.gizmoGrabX, self.gizmoGrabY, gameView:getCamera(), sceneNode, true) then
				isUpdated = true
				self.gizmoGrabX = x
				self.gizmoGrabY = y
			end
		else
			isUpdated = self.gizmo:move(x, y, x + dx, y + dy, gameView:getCamera(), sceneNode, false)
		end

		if isUpdated then
			if self.gizmoOperation == Gizmo.OPERATION_TRANSLATION then
				self.interface:translateObject(self.object, sceneNode:getTransform():getLocalTranslation())
			elseif self.gizmoOperation == Gizmo.OPERATION_ROTATION then
				self.interface:rotateObject(self.object, sceneNode:getTransform():getLocalRotation())
			elseif self.gizmoOperation == Gizmo.OPERATION_SCALE then
				self.interface:scaleObject(self.object, sceneNode:getTransform():getLocalScale())
			end
		end
	else
		self.gizmo:hover(x, y, gameView:getCamera(), sceneNode)
	end

	sceneNode:setParent()

	_APP.cameraController:mouseMove(self.isGizmoGrabbed, rx, ry, dx, dy, ...)
end

function DebugManipulate.GizmoFacade:mouseScroll(...)
	Drawable.mouseScroll(self, ...)

	_APP.cameraController:mouseScroll(self.isGizmoGrabbed, ...)
end

function DebugManipulate.GizmoFacade:_draw()
	local gameView = self.interface:getView():getGameView()

	local sceneNode = self:getProxySceneNode()
	local min, max = self.object:getBounds()
	local size = ((max - min):max(Vector.ONE) / sceneNode:getTransform():getLocalScale())

	self.gizmo:update(sceneNode, size)
	self.gizmo:draw(gameView:getCamera(), sceneNode)

	sceneNode:setParent()
end

function DebugManipulate.GizmoFacade:draw(...)
	Drawable.draw(self, ...)

	itsyrealm.graphics.pushCallback(self._draw, self)
end

DebugManipulate.InteractFacade = Class(Widget)
function DebugManipulate.InteractFacade:new(interface)
	Widget.new(self)

	self.interface = interface

	self:performLayout()
end

function DebugManipulate.InteractFacade:performLayout()
	Widget.performLayout(self)

	local w, h = itsyrealm.graphics.getScaledMode()
	self:setSize(w, h)
	self:setPosition(0, 0)
	self:setZDepth(-1000)
end

function DebugManipulate.InteractFacade:getIsFocusable()
	return true
end

function DebugManipulate.InteractFacade:setActionGenerator(value)
	self.actionGenerator = value
end

function DebugManipulate.InteractFacade:getActionGenerator()
	return self.actionGenerator
end

function DebugManipulate.InteractFacade._generateDefaultActions(interface, probe, actions)
	for _, hit in probe:hits() do
		local object = hit:getObject()

		if Class.isCompatibleType(object, Actor) then
			interface:buildActorActions(object, hit, actions)
		elseif Class.isCompatibleType(object, Prop) then
			interface:buildPropActions(object, hit, actions)
		elseif Class.isCompatibleType(object, Probe.Tile) then
			interface:buildTileActions(object, hit, actions)
		end
	end

	for _, action in probe:iterate() do
		table.insert(actions, action)
	end
end

function DebugManipulate.InteractFacade:mousePress(_x, _y, button)
	Widget.mousePress(self, _x, _y, button)

	_APP.cameraController:mousePress(false, _x, _y, button)

	if button ~= 2 then
		return
	end

	local x, y = love.mouse.getPosition()
	_APP:probe(x, y, false, function(probe)
		local actions = {}

		local func = self.actionGenerator or self._generateDefaultActions
		func(self.interface, probe, actions)

		local ui = self:getUIView()
		if ui and #actions >= 1 then
			ui:probe(actions, x, y)
		end
	end)
end

function DebugManipulate.InteractFacade:mouseMove(...)
	Widget.mouseMove(self, ...)

	_APP.cameraController:mouseMove(false, ...)
end

function DebugManipulate.InteractFacade:mouseRelease(...)
	Widget.mouseRelease(self, ...)

	_APP.cameraController:mouseRelease(false, ...)
end

function DebugManipulate.InteractFacade:mouseScroll(...)
	Widget.mouseScroll(self, ...)

	_APP.cameraController:mouseScroll(false, ...)
end

function DebugManipulate:new(id, index, ui)
	Interface.new(self, id, index, ui)

	self.windowRoot = DebugManipulate.Root()
	self.windowRoot:setSize(self.WIDTH, self.HEIGHT)
	self:addChild(self.windowRoot)

	local titlePanel = Panel()
	titlePanel:setStyle(Theme.WINDOW_TITLE_PANEL_STYLE, PanelStyle)
	titlePanel:setPosition(0, 0)
	titlePanel:setSize(self.WIDTH, self.TITLE_HEIGHT + Theme.DEFAULT_OUTER_PADDING * 2)
	self.windowRoot:addChild(titlePanel)

	self.closeButton = Theme.newCloseButton(titlePanel)

	local titleLabel = Label()
	titleLabel:setStyle(Theme.WINDOW_TITLE_LABEL_STYLE, LabelStyle)
	titleLabel:setText("Reality Manipulator")
	titleLabel:setPosition(Theme.DEFAULT_OUTER_PADDING, Theme.DEFAULT_OUTER_PADDING)
	titlePanel:addChild(titleLabel)

	local contentPanel = Theme.newContentPanel(
		self.windowRoot,
		self.WIDTH,
		self.HEIGHT - self.TITLE_HEIGHT - Theme.DEFAULT_OUTER_PADDING * 2,
		titlePanel)
	local contentWidth, contentHeight = contentPanel:getSize()

	self.presetListGrid = ScrollablePanel(GamepadGridLayout)
	self.presetListGrid:setSize(contentWidth / 3, contentHeight - Theme.DEFAULT_OUTER_PADDING)
	self.presetListGrid:getInnerPanel().onWrapFocus:register(self._wrapPresetGridsFocus, self)
	contentPanel:addChild(self.presetListGrid)

	self.presetGrid = ScrollablePanel(GamepadGridLayout)
	self.presetGrid:setSize(
		Theme.calculateRemainingSizeWithPadding(Theme.DEFAULT_OUTER_PADDING, contentWidth, self.WIDTH / 3),
		Theme.calculateRemainingSizeWithPadding(Theme.DEFAULT_OUTER_PADDING, contentHeight))
	self.presetGrid:setPosition(contentWidth / 3 + Theme.DEFAULT_OUTER_PADDING, Theme.DEFAULT_OUTER_PADDING)
	self.presetGrid:getInnerPanel().onWrapFocus:register(self._wrapPresetGridsFocus, self)

	contentPanel:addChild(self.presetGrid)

	self.popupInterfaces = {}
	self.popupPanel = Panel()
	self.popupPanel:setZDepth(100)
	self.popupPanel:setStyle({
		color = { 0, 0, 0, 0.5 },
		radius = 0
	}, PanelStyle)

	self.facades = {}

	local state = self:getState()
	if state and state.presets then
		self:populatePresets(state.presets)
	end

	self:performLayout()
end

function DebugManipulate:getOverflow()
	return true
end

function DebugManipulate:performLayout()
	Interface.performLayout(self)

	local width, height = itsyrealm.graphics.getScaledMode()
	local windowWidth, windowHeight = self.windowRoot:getSize()
	self.windowRoot:setPosition((width - windowWidth) / 2, (height - windowHeight) / 2)

	local facade = self.facades[#self.facades]
	if facade then
		facade:performLayout()
	end

	local popup = self.popupInterfaces[#self.popupInterfaces]
	if popup then
		popup:performLayout()
	end

	self.popupPanel:setSize(width, height)
end

function DebugManipulate:attach()
	self:focusChild(self.presetListGrid:getInnerPanel())

	self:getView():getGame():getPlayer():onPushCamera("DebugManipulate")
	self:getView():getGame():getPlayer():onPokeCamera("copyTransforms")
end

function DebugManipulate:detach()
	if self.currentAction then
		self:cancelAction()
	end

	local root = self:getView():getRoot()
	if self.revealButton and self.revealButton:getParent() == root then
		root:removeChild(self.revealButton)
		self.revealButton = nil
	end

	local facade = self.facades[#self.facades]
	if facade and facade:getParent() == root then
		root:removeChild(facade)
	end

	self:getView():getGame():getPlayer():onPopCamera()
end

function DebugManipulate:_wrapPresetGridsFocus(grid, widget, directionX, directionY)
	if grid == self.presetListGrid and directionX == 1 then
		self:focusChild(self.presetGrid)
	elseif grid == self.presetGrid and directionX == -1 then
		self:focusChild(self.presetListGrid)
	else
		self:focusSpiralButton(widget)
	end
end

function DebugManipulate:_reveal(_, index)
	if index ~= 1 then
		return
	end

	self:stopRecordOrReplay()
	self:show()
end

function DebugManipulate:restoreFocus()
	if #self.popupInterfaces >= 1 and self.popupInterfaces[#self.popupInterfaces].widget then
		self:focusChild(self.popupInterfaces[#self.popupInterfaces].widget)
	elseif #self.facades >= 1 then
		self:focusChild(self.facades[#self.facades])
	elseif self.selectedPresetResource and self.selectedPresetID then
		self:focusChild(self.presetGrid:getInnerPanel())
	else
		self:focusChild(self.presetListGrid:getInnerPanel())
	end
end

function DebugManipulate:addPopup(widget)
	self:removePopup(widget)

	local nextPopup = { root = widget }

	local currentPopup = self.popupInterfaces[#self.popupInterfaces]
	if currentPopup then
		self:removeChild(currentPopup.root)
	end

	table.insert(self.popupInterfaces, nextPopup)
	self.popupPanel:addChild(widget)

	self:addChild(self.popupPanel)
	widget:performLayout()
	self:focusChild(widget)
end

function DebugManipulate:removePopup(widget)
	for i, popup in ipairs(self.popupInterfaces) do
		if popup.root == widget then
			if i == #self.popupInterfaces then
				self.popupPanel:removeChild(popup.root)

				local previousPopup = self.popupInterfaces[i - 1]
				if previousPopup then
					self.popupPanel:addChild(previousPopup.root)
					previousPopup.root:performLayout()
					self:focusChild(previousPopup.root)
				else
					self:removeChild(self.popupPanel)
				end
			end

			table.remove(self.popupInterfaces, i)
			break
		end
	end
end

function DebugManipulate:addFacade(facade)
	self:removeFacade(facade)

	local currentFacade = self.facades[#self.facades]
	if currentFacade then
		local parent = currentFacade:getParent()
		if parent then
			parent:removeChild(currentFacade)
		end
	end

	table.insert(self.facades, facade)

	self:getView():getRoot():addChild(facade)
	facade:performLayout()

	if #self.popupInterfaces == 0 then
		self:focusChild(facade)
	end
end

function DebugManipulate:removeFacade(facade)
	for i, otherFacade in ipairs(self.facades) do
		if otherFacade == facade then
			if i == #self.facades then
				local parent = facade:getParent()
				if parent then
					parent:removeChild(facade)
				end

				local previousFacade = self.facades[i - 1]
				if previousFacade then
					self:getView():getRoot():addChild(previousFacade)
					previousFacade:performLayout()

					if #self.popupInterfaces == 0 then
						self:focusChild(previousFacade)
					end
				end
			end

			table.remove(self.facades, i)
			break
		end
	end
end

function DebugManipulate:_onFocusPopupChild(_, child)
	for _, popup in ipairs(self.popupInterfaces) do
		if popup.root:isParentOf(child) then
			popup.widget = child
			break
		end
	end
end

function DebugManipulate:_onBlurPopupChild(_, child)
	for _, popup in ipairs(self.popupInterfaces) do
		if popup.root:isParentOf(child) and popup.widget == child then
			popup.widget = nil
			break
		end
	end
end

function DebugManipulate:populatePresets(presets)
	local gridWidth, gridHeight = self.presetListGrid:getSize()

	self.presetListGrid:clearChildren()
	for index, presetInfo in ipairs(presets) do
		local button = Button()

		local label = Label()
		label:setStyle(Theme.BUTTON_LABEL_STYLE, LabelStyle)
		label:setText(string.format("%s@%d", presetInfo.resource, presetInfo.id))
		button:addChild(label)
		button:setData("preset", presetInfo)

		button.onClick:register(self.selectPreset, self, presetInfo)

		self.presetListGrid:addChild(button)
	end

	if self.selectedPresetResource  and self.selectedPresetID then
		self:sendPoke("select", nil, { resource = self.selectedPresetResource, id = self.selectedPresetID })
	end

	local state = self:getState()
	for _, resource in ipairs(state.layers or {}) do
		local newButton = Button()
		newButton:setStyle(Theme.DEFAULT_ALTERNATE_BUTTON_STYLE, ButtonStyle)

		local label = Label()
		label:setStyle(Theme.BUTTON_LABEL_STYLE, LabelStyle)
		label:setText(string.format("New %s", resource))
		newButton:addChild(label)

		newButton.onClick:register(self.newPreset, self, resource)

		self.presetListGrid:addChild(newButton)
	end

	Theme.layoutScrollablePanelWithGridLayout(self.presetListGrid, gridWidth - Theme.DEFAULT_INNER_PADDING * 2, Theme.DEFAULT_BUTTON_SIZE)
end

function DebugManipulate:probePreset(presetInfo, button)
	local object = string.format("%s@%d", presetInfo.resource, presetInfo.id)

	local actions = {
		{
			id = 1,
			verb = "Select",
			object = object,
			callback = function()
				self:selectPreset(presetInfo, button, 1)
			end
		},
		{
			id = 2,
			verb = "Replay-For-Editing",
			object = object,
			callback = function()
				self:replay(presetInfo, true)
			end
		},
		{
			id = 2,
			verb = "Replay",
			object = object,
			callback = function()
				self:replay(presetInfo, false)
			end
		}
	}

	if self.pendingDeleteResource == presetInfo.resource and self.pendingDeleteID == presetInfo.id then
		table.insert(actions, {
			id = #actions + 1,
			verb = "Cancel-Delete",
			object = object,
			callback = function()
				self:_updatePresetListButtonStyle({
					resource = self.pendingDeleteResource,
					id = self.pendingDeleteID,
				}, Theme.DEFAULT_INACTIVE_BUTTON_STYLE, Theme.DEFAULT_ACTIVE_BUTTON_STYLE)

				self.pendingDeleteResource = nil
				self.pendingDeleteID = nil
			end
		})

		table.insert(actions, {
			id = #actions + 1,
			verb = "Confirm-Delete",
			object = object,
			callback = function()
				self:_updatePresetListButtonStyle({
					resource = self.pendingDeleteResource,
					id = self.pendingDeleteID,
				}, Theme.DEFAULT_INACTIVE_BUTTON_STYLE, Theme.DEFAULT_ACTIVE_BUTTON_STYLE)

				self:deletePreset(presetInfo)
			end
		})
	else
		table.insert(actions, {
			id = #actions + 1,
			verb = "Delete",
			object = object,
			callback = function()
				self.pendingDeleteResource = presetInfo.resource
				self.pendingDeleteID = presetInfo.id

				self:_updatePresetListButtonStyle(presetInfo, Theme.DEFAULT_DANGEROUS_BUTTON_STYLE, Theme.DEFAULT_DANGEROUS_BUTTON_STYLE)
			end
		})
	end

	local ui = self:getUIView()
	ui:probe(actions, button:getAbsoluteCenter())
end

function DebugManipulate:newPreset(resource)
	self:sendPoke("new", nil, { resource = resource })

	self.selectedPresetResource = nil
	self.selectedPresetID = nil
end

function DebugManipulate:deletePreset(presetInfo)
	self:sendPoke("delete", nil, { resource = presetInfo.resource, id = presetInfo.id })

	if self.selectedPresetResource == presetInfo.resource and self.selectedPresetID == presetInfo.id then
		self.selectedPresetResource = nil
		self.selectedPresetID = nil

		self:showPreset(nil, nil)
	end
end

function DebugManipulate:hide()
	self:removeChild(self.windowRoot)

	local button = Button()
	button:setStyle(Theme.DEFAULT_INACTIVE_BUTTON_STYLE, ButtonStyle)
	button:setPosition(
		Theme.calculateSizeWithPadding(Theme.DEFAULT_OUTER_PADDING, Theme.DEFAULT_ITEM_SIZE_WITH_PADDING),
		Theme.DEFAULT_OUTER_PADDING * 2)
	button:setSize(Theme.DEFAULT_ITEM_SIZE_WITH_PADDING, Theme.DEFAULT_ITEM_SIZE_WITH_PADDING)
	button:setToolTip("Reveal Amulet of Yendor reality manipulation interface.")
	button.onClick:register(self._reveal, self)

	local itemIcon = ItemIcon()
	itemIcon:setItemID("AmuletOfYendor")
	itemIcon:setPosition(Theme.DEFAULT_INNER_PADDING, Theme.DEFAULT_INNER_PADDING)
	button:addChild(itemIcon)

	local root = self:getView():getRoot()
	root:addChild(button)

	self.revealButton = button
end

function DebugManipulate:show()
	self:addChild(self.windowRoot)

	local root = self:getView():getRoot()
	if self.revealButton and self.revealButton:getParent() == root then
		root:removeChild(self.revealButton)
		self.revealButton = nil
	end
end

function DebugManipulate:_updateActivePresetListButton(presetInfo)
	for _, button in self.presetListGrid:getInnerPanel():iterate() do
		local otherPresetInfo = button:getData("preset")
		if otherPresetInfo and otherPresetInfo.resource == presetInfo.resource and otherPresetInfo.id == presetInfo.id then
			if self.activeButton then
				local activePresetInfo = self.activeButton:getData("preset")
				if not (activePresetInfo.resource == self.pendingDeleteResource and activePresetInfo.id == self.pendingDeleteID) then
					self.activeButton:setStyle(Theme.DEFAULT_INACTIVE_BUTTON_STYLE, ButtonStyle)
				end
			end

			self.activeButton = button
			if not (presetInfo.resource == self.pendingDeleteResource and presetInfo.id == self.pendingDeleteID) then
				button:setStyle(Theme.DEFAULT_ACTIVE_BUTTON_STYLE, ButtonStyle)
			end
		end
	end
end

function DebugManipulate:_updatePresetListButtonStyle(presetInfo, inactiveTheme, activeTheme)
	for _, button in self.presetListGrid:getInnerPanel():iterate() do
		local otherPresetInfo = button:getData("preset")
		if otherPresetInfo and otherPresetInfo.resource == presetInfo.resource and otherPresetInfo.id == presetInfo.id then
			if self.activeButton == button then
				button:setStyle(activeTheme or inactiveTheme or Theme.DEFAULT_ACTIVE_BUTTON_STYLE, ButtonStyle)
			else
				button:setStyle(inactiveTheme or Theme.DEFAULT_INACTIVE_BUTTON_STYLE, ButtonStyle)
			end
		end
	end
end

function DebugManipulate:selectPreset(presetInfo, button, index)
	if index == 2 then
		self:probePreset(presetInfo, button)
		return
	end

	if index ~= 1 then
		return
	end

	self:_updateActivePresetListButton(presetInfo)
	self:sendPoke("select", nil, { resource = presetInfo.resource, id = presetInfo.id })
end

function DebugManipulate:showPreset(presetInfo, preset)
	self.presetGrid:clearChildren()
	self.presetGrid:getInnerPanel():setEdgePadding(true, false)

	if not presetInfo then
		Theme.layoutScrollablePanelWithGridLayout(self.presetGrid, gridWidth - Theme.DEFAULT_INNER_PADDING * 2, Theme.DEFAULT_BUTTON_SIZE)
		return
	end

	self.selectedPresetID = presetInfo.id
	self.selectedPresetResource = presetInfo.resource
	self:_updateActivePresetListButton(presetInfo)

	do
		local recordButton = Button()
		recordButton:setStyle(Theme.DEFAULT_ALTERNATE_BUTTON_STYLE, ButtonStyle)

		local label = Label()
		label:setStyle(Theme.BUTTON_LABEL_STYLE, LabelStyle)
		label:setText("Record")
		recordButton:addChild(label)

		recordButton.onClick:register(self.record, self, presetInfo)

		self.presetGrid:addChild(recordButton)
	end

	local rowWidth = self.presetGrid:getInnerPanel():getSize()
	for i, action in ipairs(preset) do
		local name = camelCaseToTitleCase(action.type)

		local button = Button()
		button:setStyle(Theme.DEFAULT_INACTIVE_BUTTON_STYLE, ButtonStyle)
		button.onClick:register(self._onClickAction, self, presetInfo, preset, i)

		self.presetGrid:addChild(button)

		local row = GridLayout()
		row:setSize(rowWidth, Theme.DEFAULT_BUTTON_SIZE)
		row:setPadding(0, 0)
		row:setUniformSize(true, Theme.calculateTileSizeWithPadding(Theme.DEFAULT_OUTER_PADDING, rowWidth, 2), Theme.DEFAULT_BUTTON_SIZE)
		button:addChild(row)

		local nameLabel = Label()
		nameLabel:setStyle(Theme.BUTTON_LABEL_STYLE, LabelStyle)
		nameLabel:setText(name)
		row:addChild(nameLabel)

		local delayLabel = Label()
		delayLabel:setStyle(Theme.override(Theme.BUTTON_LABEL_STYLE, { fontSize = 16 }), LabelStyle)
		if action.timing then
			delayLabel:setText(string.format("@ %d ms / %d ms (%s)", action.timing.delay * 1000, action.timing.duration * 1000, action.timing.mode:sub(1, 1):upper()))
		else
			delayLabel:setText("@ -- ms / -- ms (X)")
		end
		row:addChild(delayLabel)
	end

	local gridWidth, gridHeight = self.presetGrid:getSize()
	Theme.layoutScrollablePanelWithGridLayout(self.presetGrid, gridWidth - Theme.DEFAULT_INNER_PADDING * 2, Theme.DEFAULT_BUTTON_SIZE)
end

function DebugManipulate:setTiming(presetInfo, preset, actionIndex)
	local action = preset[actionIndex]

	local properties = {
		PropertiesPrompt.Property("duration", "Delay (ms)", "number", (action.timing and action.timing.delay or 0) * 1000),
		PropertiesPrompt.Property("delay", "Duration (ms)", "number", (action.timing and action.timing.duration or 0) * 1000),
		PropertiesPrompt.Property("mode", "Mode (sync/parallel/off)", "string", action.timing and action.timing.mode or "sync"),
		PropertiesPrompt.Property("tween", "Tween", "string", action.timing and action.timing.tween or "sineEaseInOut")
	}

	local propertiesPrompt = PropertiesPrompt()
	propertiesPrompt.onSubmit:register(self._onEditPresetActionTiming, self, presetInfo, preset, actionIndex)
	propertiesPrompt.onCancel:register(self._onCancelEditPresetActionTiming, self, presetInfo, preset, actionIndex)
	propertiesPrompt:setText(camelCaseToTitleCase(action.type))
	propertiesPrompt:setProperties(properties)

	self:addPopup(propertiesPrompt)
end

local VALID_MODES = {
	sync = true,
	parallel = true,
	off = true,
}

function DebugManipulate:_onEditPresetActionTiming(presetInfo, preset, actionIndex, popup, properties, form)
	local action = preset[actionIndex]

	local delay = form["Delay (ms)"] / 1000
	local duration = form["Duration (ms)"] / 1000
	local mode = form["Mode (sync/parallel/off)"]
	local tween = form["Tween"]

	if not VALID_MODES[mode] then
		mode = "off"
	end

	self:sendPoke("editAction", nil, {
		resource = presetInfo.resource,
		id = presetInfo.id,
		index = actionIndex,
		action = {
			target = action.target,
			map = action.map,
			event = action.event,
			type = action.type,
			timing = {
				delay = delay,
				duration = duration,
				mode = mode,
				tween = tween
			}
		}
	})

	self:removePopup(popup)
end

function DebugManipulate:_onCancelEditPresetActionTiming(presetInfo, preset, actionIndex, popup)
	self:removePopup(popup)
end

function DebugManipulate:editPresetAction(presetInfo, preset, actionIndex)
	local action = preset[actionIndex]
	local target = action.target
	local map = action.map

	local properties = {
		PropertiesPrompt.Property("x-mapResource", "Map Resource", "string", map.resource),
		PropertiesPrompt.Property("x-localLayer", "Local Layer", "string", map.localLayer),
		PropertiesPrompt.Property("x-target", target.peepID and "Peep ID" or "Map Object Name", type(target.peepID or target.mapObjectName), target.peepID or target.mapObjectName)
	}

	local otherProperties = {}
	for k, v in pairs(action.event) do
		table.insert(otherProperties, PropertiesPrompt.Property(k, camelCaseToTitleCase(k), type(v), v))
	end

	table.sort(otherProperties, function(a, b)
		return a:getField() < b:getField()
	end)

	for _, otherProperty in ipairs(otherProperties) do
		table.insert(properties, otherProperty)
	end

	local propertiesPrompt = PropertiesPrompt()
	propertiesPrompt.onSubmit:register(self._onEditPresetAction, self, presetInfo, preset, actionIndex)
	propertiesPrompt.onCancel:register(self._onCancelEditPresetAction, self, presetInfo, preset, actionIndex)
	propertiesPrompt:setText(camelCaseToTitleCase(action.type))
	propertiesPrompt:setProperties(properties)

	self:addPopup(propertiesPrompt)
end

function DebugManipulate:_onEditPresetAction(presetInfo, preset, actionIndex, popup, properties, form)
	local target = {
		peepID = form["Peep ID"],
		mapObjectName = form["Map Object Name"]
	}

	local map = {
		resource = form["Map Resource"],
		localLayer = form["Local Layer"]
	}

	local event = {}
	for k, v in pairs(preset[actionIndex].event) do
		event[k] = v
	end

	for _, property in ipairs(properties) do
		if not property:getID():match("^(x%-)") then
			event[property:getID()] = property:getValue()
		end
	end

	self:sendPoke("editAction", nil, {
		resource = presetInfo.resource,
		id = presetInfo.id,
		index = actionIndex,
		action = {
			target = target,
			map = map,
			type = preset[actionIndex].type,
			timing = preset[actionIndex].timing,
			event = event
		}
	})

	self:removePopup(popup)
end

function DebugManipulate:_onCancelEditPresetAction(presetInfo, preset, actionIndex, popup)
	self:removePopup(popup)
end

function DebugManipulate:mergePresetAction(presetInfo, preset, actionIndex)
	self:sendPoke("mergePrevious", nil, {
		resource = presetInfo.resource,
		id = presetInfo.id,
		index = actionIndex
	})
end

function DebugManipulate:shiftPresetAction(presetInfo, preset, actionIndex, nextActionIndex)
	self:sendPoke("shiftAction", nil, {
		resource = presetInfo.resource,
		id = presetInfo.id,
		index = actionIndex,
		nextIndex = nextActionIndex
	})
end

function DebugManipulate:deletePresetAction(presetInfo, preset, actionIndex)
	self:sendPoke("deleteAction", nil, {
		resource = presetInfo.resource,
		id = presetInfo.id,
		index = actionIndex
	})
end

function DebugManipulate:translateObject(object, position)
	local propID = Class.isCompatibleType(object, Prop) and object:getID()
	local actorID = Class.isCompatibleType(object, Actor) and object:getID()

	self:sendPoke("transform", nil, {
		propID = propID,
		actorID = actorID,
		positionX = position.x,
		positionY = position.y,
		positionZ = position.z,
	})
end

function DebugManipulate:rotateObject(object, rotation)
	local propID = Class.isCompatibleType(object, Prop) and object:getID()
	local actorID = Class.isCompatibleType(object, Actor) and object:getID()

	local x, y, z = rotation:getEulerXYZ()
	self:sendPoke("transform", nil, {
		propID = propID,
		actorID = actorID,
		rotationX = math.deg(x),
		rotationY = math.deg(y),
		rotationZ = math.deg(z),
	})
end

function DebugManipulate:scaleObject(object, scale)
	local propID = Class.isCompatibleType(object, Prop) and object:getID()
	local actorID = Class.isCompatibleType(object, Actor) and object:getID()

	self:sendPoke("transform", nil, {
		propID = propID,
		actorID = actorID,
		scaleX = scale.x,
		scaleY = scale.y,
		scaleZ = scale.z,
	})
end

function DebugManipulate:setLayer(object, tileObject)
	local propID = Class.isCompatibleType(object, Prop) and object:getID()
	local actorID = Class.isCompatibleType(object, Actor) and object:getID()

	local _, _, layer = tileObject:getTile()
	self:sendPoke("setLayer", nil, {
		actorID = actorID,
		propID = propID,
		layer = layer
	})
end

function DebugManipulate:fireProjectileAt(sourceObject, destinationObject, projectile)
	local sourcePropID = Class.isCompatibleType(sourceObject, Prop) and sourceObject:getID()
	local sourceActorID = Class.isCompatibleType(sourceObject, Actor) and sourceObject:getID()
	local destinationPropID = Class.isCompatibleType(destinationObject, Prop) and destinationObject:getID()
	local destinationActorID = Class.isCompatibleType(destinationObject, Actor) and destinationObject:getID()

	self:sendPoke("fireProjectile", nil, {
		sourcePropID = sourcePropID,
		sourceActorID = sourceActorID,
		destinationPropID = destinationPropID,
		destinationActorID = destinationActorID,
		projectile = projectile
	})
end

function DebugManipulate:fireSpell(sourceObject, destinationObject, projectile)
	local sourcePeepID = Class.isCompatibleType(sourceObject, Actor) and sourceObject:getID()
	local destinationPeepID = Class.isCompatibleType(destinationObject, Actor) and destinationObject:getID()

	self:sendPoke("fireProjectile", nil, {
		peepID = sourcePeepID,
		targetPeepID = destinationPeepID,
		projectile = projectile
	})
end

function DebugManipulate:simulateAttack(sourceObject, destinationObject)
	local peepID = Class.isCompatibleType(sourceObject, Actor) and sourceObject:getID()
	local targetPeepID = Class.isCompatibleType(destinationObject, Actor) and destinationObject:getID()

	self:sendPoke("simulateAttack", nil, {
		peepID = peepID,
		targetPeepID = targetPeepID
	})
end

function DebugManipulate:walk(object, destinationObject)
	local peepID = Class.isCompatibleType(sourceObject, Actor) and sourceObject:getID()
	local _, _, layer = destinationObject:getTile()
	local position = destinationObject:getPosition()

	self:sendPoke("walk", nil, {
		actorID = peepID,
		layer = layer,
		positionX = position.x,
		positionY = position.y,
		positionZ = position.z,
	})
end

function DebugManipulate:orientateCamera(object, otherObject)
	self:sendPoke("orientateCamera", nil, {
		actorID = object:getID(),
		otherActorID = otherObject and otherObject:getID()
	})
end

function DebugManipulate:_onClickAction(presetInfo, preset, actionIndex, button, index)
	if index == 1 then
		self:editPresetAction(presetInfo, preset, actionIndex)
	elseif index == 2 then
		local name = camelCaseToTitleCase(preset[actionIndex].type)
		local actions = {
			{
				id = 1,
				verb = "Edit",
				object = name,
				callback = function()
					self:editPresetAction(presetInfo, preset, actionIndex)
				end
			},
			{
				id = 2,
				verb = "Edit-Timing",
				object = name,
				callback = function()
					self:setTiming(presetInfo, preset, actionIndex)
				end
			},
			{
				id = 4,
				verb = "Insert-Recording-Before",
				object = name,
				callback = function()
					self:startRecording(presetInfo, actionIndex)
				end
			},
			{
				id = 3,
				verb = "Merge-Previous",
				object = name,
				callback = function()
					self:mergePresetAction(presetInfo, preset, actionIndex)
				end
			},
			{
				id = 4,
				verb = "Shift-Up",
				object = name,
				callback = function()
					self:shiftPresetAction(presetInfo, preset, actionIndex, math.max(actionIndex - 1, 1))
				end
			},
			{
				id = 5,
				verb = "Shift-Down",
				object = name,
				callback = function()
					self:shiftPresetAction(presetInfo, preset, actionIndex, math.min(actionIndex + 1, #preset))
				end
			},
			{
				id = 6,
				verb = "Delete",
				object = name,
				callback = function()
					self:deletePresetAction(presetInfo, preset, actionIndex)
				end
			}
		}

		self:getUIView():probe(actions, button:getAbsoluteCenter())
	end
end

function DebugManipulate:buildActorAction(actions, object, t)
	t = t or {}

	table.insert(actions, {
		id = #actions + 1,
		verb = t.verb or "*Interact",
		objectID = object:getID(),
		objectType = "actor",
		object = object:getName(),
		callback = t.callback or function() end
	})
end

function DebugManipulate:buildActorActions(object, hit, actions)
	self:buildActorAction(actions, object, {
		verb = "Play-Animation",
		callback = function()
			self:beginAction(DebugManipulate.PlayAnimationAction, object, hit)
		end
	})

	self:buildActorAction(actions, object, {
		verb = "Change-Skin",
		callback = function()
			self:beginAction(DebugManipulate.ChangeSkinAction, object, hit)
		end
	})

	self:buildActorAction(actions, object, {
		verb = "Transform",
		callback = function()
			self:beginAction(DebugManipulate.TransformAction, object, hit)
		end
	})

	self:buildActorAction(actions, object, {
		verb = "Preview-Orientate-Camera",
		callback = function()
			self:beginAction(DebugManipulate.PreviewOrientateAction, object, hit)
		end
	})

	self:buildActorAction(actions, object, {
		verb = "Look-At",
		callback = function()
			self:beginAction(DebugManipulate.LookAtAction, object, hit)
		end
	})

	self:buildActorAction(actions, object, {
		verb = "Orientate-Camera",
		callback = function()
			self:beginAction(DebugManipulate.OrientateAction, object, hit)
		end
	})

	self:buildActorAction(actions, object, {
		verb = "Fire-Projectile",
		callback = function()
			self:beginAction(DebugManipulate.FireProjectileAction, object, hit)
		end
	})

	self:buildActorAction(actions, object, {
		verb = "Simulate-Attack",
		callback = function()
			self:beginAction(DebugManipulate.SimulateAttackAction, object, hit)
		end
	})

	self:buildActorAction(actions, object, {
		verb = "Walk",
		callback = function()
			self:beginAction(DebugManipulate.WalkAction, object, hit)
		end
	})

	if object == self:getView():getGame():getPlayer():getActor() then
		self:buildActorAction(actions, object, {
			verb = "Save-Location",
			callback = function()
				self:sendPoke("saveLocation", nil, { id = object:getID() })
			end
		})

		self:buildActorAction(actions, object, {
			verb = "Talk",
			callback = function()
				self:beginAction(DebugManipulate.TalkAction, object, hit)
			end
		})
	end
end

function DebugManipulate:buildPropAction(actions, object, t)
	t = t or {}

	table.insert(actions, {
		id = #actions + 1,
		verb = t.verb or "*Interact",
		objectID = object:getID(),
		objectType = "prop",
		object = object:getName(),
		callback = t.callback or function() end
	})
end

function DebugManipulate:buildPropActions(object, hit, actions)
	self:buildPropAction(actions, object, {
		verb = "Transform",
		callback = function()
			self:beginAction(DebugManipulate.TransformAction, object, hit)
		end
	})
end

function DebugManipulate:buildTileAction(actions, object, t)
	t = t or {}

	local _, _, layer = object:getTile()

	local gameView = self:getView():getGameView()
	local resource = gameView:getMapResourceID(layer)
	local localLayer = gameView:getMapLocalLayer(layer)

	table.insert(actions, {
		id = #actions,
		verb = t.verb or "*Interact",
		objectID = layer,
		objectType = "map",
		object = string.format("%s@%s", resource or "???", localLayer or string.format("*%d", layer)),
		callback = t.callback or function() end
	})
end

function DebugManipulate:buildTileActions(object, hit, actions)
	local _, _, layer = object:getTile()

	local gameView = self:getView():getGameView()
	local resource = gameView:getMapResourceID(layer)
	local localLayer = gameView:getMapLocalLayer(layer)

	self:buildTileAction(actions, object, {
		verb = "Spawn-Actor",
		callback = function()
			self:beginAction(DebugManipulate.SpawnActorAction, object, hit)
		end
	})

	self:buildTileAction(actions, object, {
		verb = "Spawn-Prop",
		callback = function()
			self:beginAction(DebugManipulate.SpawnPropAction, object, hit)
		end
	})

	self:buildTileAction(actions, object, {
		verb = "Spawn-Glyph-Circle",
		callback = function()
			self:beginAction(DebugManipulate.SpawnGlyphCircleAction, object, hit)
		end
	})
end

function DebugManipulate:beginAction(ActionType, object, hit)
	self:cancelAction()

	self.currentAction = ActionType(self, object, hit)
	self.currentAction:start()
end

function DebugManipulate:pokeAction(event, ...)
	if self.currentAction and self.currentAction[event] then
		self.currentAction[event](self.currentAction, ...)
	end
end

function DebugManipulate:cancelAction()
	if self.currentAction then
		self.currentAction:cancel()
		self.currentAction = nil
	end
end

function DebugManipulate:stopAction()
	if self.currentAction then
		self.currentAction:stop()
		self.currentAction = nil
	end
end

function DebugManipulate:record(presetInfo, _, index)
	if index ~= 1 then
		return
	end

	self:startRecording(presetInfo)
end

function DebugManipulate:startRecording(presetInfo, index)
	if self.interactFacade then
		self:removeFacade(self.interactFacade)
	end

	self.interactFacade = DebugManipulate.InteractFacade(self)
	self:addFacade(self.interactFacade)

	self:hide()
	self:sendPoke("startRecording", nil, { resource = presetInfo.resource, id = presetInfo.id, index = index })
end

function DebugManipulate:stopRecordOrReplay()
	local state = self:getState()

	if state.isRecording then
		self:sendPoke("stopRecording", nil, {})
	end

	if state.isReplaying then
		self:sendPoke("stopReplay", nil, {})
	end

	if self.interactFacade then
		self:removeFacade(self.interactFacade)
		self.interactFacade = nil
	end

	return state.isRecording or state.isReplaying
end

function DebugManipulate:replay(presetInfo, isEditing)
	self:hide()
	self:sendPoke("startReplay", nil, { resource = presetInfo.resource, id = presetInfo.id })

	if isEditing then
		self.replayFacade = DebugManipulate.ThirdsFacade()
		self:addFacade(self.replayFacade)
	end
end

function DebugManipulate:finishReplay(presetInfo)
	self:show()
	self:sendPoke("select", nil, { resource = presetInfo.resource, id = presetInfo.id })

	if self.replayFacade then
		self:removeFacade(self.replayFacade)
		self.replayFacade = nil
	end
end

function DebugManipulate:finishRecording(presetInfo)
	self:show()
	self:sendPoke("select", nil, { resource = presetInfo.resource, id = presetInfo.id })
end

function DebugManipulate:update(delta)
	Interface.update(self, delta)

	if self.currentAction then
		self.currentAction:update(delta)
	end
end

return DebugManipulate
