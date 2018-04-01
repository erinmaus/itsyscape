--------------------------------------------------------------------------------
-- ItsyScape/Graphics/Light.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
-------------------------------------------------------------------------------

local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Color = require "ItsyScape.Graphics.Color"

-- Light class.
Light = Class()

-- Constructs the light.
--
-- The default values makes a white directional light from above with no
-- ambience.
function Light:new()
	self.position = { 0, 1, 0, 0 }
	self.color = { 1, 1, 1 }
	self.attenuation = 1
	self.ambientCoefficient = 0
	self.coneAngle = 360
	self.coneDirection = { 0, 1, 0 }
end

-- Sets the position of the light.
--
-- position is expected to be Vector-like.
function Light:setPosition(position)
	self.position[1] = position.x
	self.position[2] = position.y
	self.position[3] = position.z
end

-- Returns the position of the light, as a vector.
function Light:getPosition()
	return Vector(self.position[1], self.position[2], self.position[3])
end

-- Returns the direction of the light to 'surface'.
--
-- If the light is directional, this returns the constant direction. Otherwise,
-- this returns a relative direction.
function Light:getDirection(surface)
	if self:isDirectional() then
		return self:getPosition():getNormal()
	else
		return (self.position - surface):getNormal()
	end
end

-- Returns true if the light is directional, false otherwise.
function Light:isDirectional()
	return self.position[4] == 0
end

-- Returns true if the light is a point light, false othewise.
function Light:isPoint()
	return self.position[4] ~= 0
end

-- Sets the light to be directional light.
function Light:setDirectional()
	self.position[4] = 0
end

-- Sets the light to be a point light.
function Light:setPoint()
	self.position[4] = 1
end

-- Sets the color of the light.
--
-- Component values default to r, and r defaults to 1 if not provided. Thus,
-- setColor() sets the light to { 1, 1, 1 }, while setColor(0.5} sets the light
-- to { 0.5, 0.5, 0.5 }.
--
-- If the first argument is a table, it is assumed to be Color-like. This means
-- it's either Vector-like (x/y/z), has r/g/b or red/green/blue components, or
-- is an array with 3 elements.
function Light:setColor(r, g, b)
	if type(r) == 'table' then
		b = r.z or r.b or r.blue or r[3]
		g = r.y or r.g or r.green or r[2]
		r = r.x or r.r or r.red or r[1]
	end

	self.color = { r or 1, g or r or 1, b or r or 1 }
end

-- Gets the color of the light, as a color.
function Light:getColor()
	return Color(self.color[1], self.color[2], self.color[3])
end

-- Sets the attenuation of the light.
--
-- If no value is provided, the current attenuation value is unchanged.
function Light:setAttenuation(value)
	self.attenuation = value or self.attenuation or 1
end

-- Gets the attenuation of the light.
function Light:getAttentuation()
	return self.attenuation
end

-- Sets the ambience of the light.
--
-- value is expected to be between 0 .. 1 inclusive. It is clamped if not.
--
-- If no value is provided, the current ambientCoefficient is subsituted. This
-- means if self.ambientCoefficient was changed directly, it will be clamped if
-- necessary.
function Light:setAmbience(value)
	self.ambientCoefficient = math.min(math.max(value or self.ambientCoefficient, 0), 1)
end

-- Gets the ambience (natural lighting) of the light.
function Light:getAmbience()
	return self.ambientCoefficient
end

-- Sets the cone angle, in degrees. Values are clamped between 0 .. 360
-- inclusive.
--
-- If not provided, the value is unchanged.
function Light:setConeAngle(value)
	self.coneAngle = math.min(math.max(value, 0), 360)
end

-- Gets the cone angle, in degrees.
function Light:getConeAngle()
	return self.coneAngle
end

-- Sets the cone direction.
--
-- value is normalized. If not provided, the value is unchanged.
function Light:setConeDirection(value)
	self.coneDirection = (value or self.coneDirection):getNormal()
end

return Light
