--------------------------------------------------------------------------------
-- ItsyScape/Graphics/Shaders/ForwardForwardLitModelShader.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
-------------------------------------------------------------------------------

local Class = require "ItsyScape.Common.Class"

-- https://www.tomdalling.com/blog/modern-opengl/08-even-more-lighting-directional-lights-spotlights-multiple-lights/
local Fragment = [[
	#line 15

	#define SCAPE_MAX_LIGHTS 16

	varying vec3 frag_Position;
	varying vec3 frag_Normal;

	extern int scape_NumLights;

	extern struct Light {
		vec4 position;
		vec3 color;
		float attenuation;
		float ambientCoefficient;
		float coneAngle;
		vec3 coneDirection;
	} scape_Lights[SCAPE_MAX_LIGHTS];

	vec3 scapeApplyLight(
		Light light,
		vec3 position,
		vec3 normal,
		vec3 color)
	{
		vec3 direction;
		float attenuation = 1.0;
		if (light.position.w == 0.0)
		{
			direction = normalize(light.position.xyz);
			attenuation = 1.0;
		}
		else
		{
			vec3 lightSurfaceDifference = light.position.xyz - position;
			direction = normalize(lightSurfaceDifference);
			float lightSurfaceDistance = length(lightSurfaceDifference);
			attenuation = light.attenuation / lightSurfaceDistance;

			float dot = dot(-direction, normalize(light.coneDirection));
			float lightToSurfaceAngle = degrees(acos(dot));
			if (lightToSurfaceAngle > light.coneAngle)
			{
				attenuation = 0.0;
			}
		}

		vec3 ambient = light.ambientCoefficient * color * light.color;
		float diffuseCoefficient = max(0.0, dot(normal, direction));
		vec3 diffuse = diffuseCoefficient * color * light.color;

		return attenuation * diffuse + ambient;
	}

	vec4 effect(
		vec4 color,
		Image texture,
		vec2 textureCoordinate,
		vec2 screenCoordinate)
	{
    	vec4 textureSample = Texel(texture, textureCoordinate);
    	vec3 diffuseColor = textureSample.rgb * color.rgb;

    	vec3 result = vec3(0.0);
    	for (int i = 0; i < scape_NumLights; ++i)
    	{
    		result += scapeApplyLight(
				scape_Lights[i],
				frag_Position,
				frag_Normal,
				diffuseColor);
    	}

    	vec3 normal = (frag_Normal + vec3(1)) / vec3(2);

    	return vec4(result, textureSample.a * color.a);
	}
]]

local Vertex = [[
	#line 92

	attribute vec3 VertexNormal;

	varying vec3 frag_Position;
	varying vec3 frag_Normal;

	vec4 position(mat4 modelViewProjection, vec4 vertexPosition)
	{
		frag_Position = (TransformMatrix * vertexPosition).xyz;
		frag_Normal = normalize(NormalMatrix * VertexNormal);

		return modelViewProjection * vertexPosition;
	}
]]

local ForwardLitModelShader = Class()
ForwardLitModelShader.MAX_LIGHTS = 16

function ForwardLitModelShader:new()
	self.shader = love.graphics.newShader(Fragment, Vertex)

	for i = 1, ForwardLitModelShader.MAX_LIGHTS do
		self:resetLight(i)
	end
end

-- Sets a light's properties from the provided table.
--
-- Valid properties are:
-- * position, in the form of { x, y, z, w }: position of light. If w is zero,
--   then the light is considered a directional light.
-- * color, in the form of { r, g, b }: color of the light, with values in the
--   range of 0-1 inclusive.
-- * attentuation: attenutation of the light
-- * ambientCoefficient: ambient coefficient of the light
-- * coneAngle: angle of cone, in degrees
-- * coneDirection in the form of { x, y, z }: direction of cone, as a
--   normalized vector
--
-- Indices go from 1 to MAX_LIGHTS, inclusive.
function ForwardLitModelShader:setLight(index, properties)
	index = index - 1

	for key, value in pairs(properties) do
		if type(key) == 'string' then
			local uniform = string.format("scape_Lights[%d].%s", index, key)

			if self.shader:hasUniform(uniform) then
				self.shader:send(uniform, value)
			end
		end
	end
end

-- Resets all of a light's properties at the provided index.
function ForwardLitModelShader:resetLight(index)
	self:setLight(index, {
		position = { 0, 0, 0, 0 },
		color = { 1, 1, 1 },
		attenuation = 0,
		ambientCoefficient = 0,
		coneAngle = 360,
		coneDirection = { 0, 0, 0 }
	})
end

-- Sets the number of lights enabled.
function ForwardLitModelShader:setNumLights(value)
	value = math.max(math.min(ForwardLitModelShader.MAX_LIGHTS, value), 0)
	self.shader:send("scape_NumLights", value)
end

-- Uses the shader.
function ForwardLitModelShader:use()
	love.graphics.setShader(self.shader)
end

return ForwardLitModelShader
