--------------------------------------------------------------------------------
-- ItsyScape/Game/Animation/Animatable.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"

local Animatable = Class()
function Animatable:new()
	-- Nothing.
end

-- Sets the color of the animatable.
function Animatable:setColor(value)
	return Class.ABSTRACT()
end

-- Plays a sound.
function Animatable:playSound(filename)
	Class.ABSTRACT()
end

-- Gets the target skeleton of the the animatable.
function Animatable:getSkeleton()
	return Class.ABSTRACT()
end

-- Sets a skin.
function Animatable:setSkin(slot, priority, skin)
	Class.ABSTRACT()
end

-- Adds a scene node of the of the provided type and returns it.
function Animatable:addSceneNode(SceneNodeType, ...)
	return Class.ABSTRACT()
end

-- Removes a scene node previously added.
--
-- If sceneNode was not added, does nothing.
function Animatable:removeSceneNode(sceneNode)
	Class.ABSTRACT()
end

-- Gets the resource manager.
function Animatable:getResourceManager()
	return Class.ABSTRACT()
end

-- Gets the array of transforms.
function Animatable:getTransforms()
	return Class.ABSTRACT()
end

-- Gets the composed transform of a bone with the given name.
function Animatable:getComposedTransform(attach)
	local transform = love.math.newTransform()

	do
		local transforms = self:getTransforms()
		local skeleton = self:getSkeleton()
		local boneIndex = skeleton:getBoneIndex(attach)

		local parents = {}
		local bone
		repeat
			bone = skeleton:getBoneByIndex(boneIndex)
			if bone then
				table.insert(parents, boneIndex)

				boneIndex = bone:getParentIndex()
				bone = skeleton:getBoneByIndex(boneIndex)
			end
		until not bone

		for i = 1, #parents do
			transform:apply(transforms[parents[i]])
		end
	end

	return transform
end

-- Sets the array of transforms.
--
-- 'transforms' can be a sparse array.
function Animatable:setTransforms(transforms, animation, time)
	Class.ABSTRACT()
end

-- Sets a transform at the specified index.
function Animatable:setTransform(index, transform, animation, time)
	Class.ABSTRACT()
end

return Animatable
