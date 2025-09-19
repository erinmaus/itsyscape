#include "Resources/Shaders/Math.common.glsl"
#include "Resources/Shaders/GBuffer.common.glsl"
#include "Resources/Shaders/Fresnel.common.glsl"
#include "Resources/Shaders/Blend.common.glsl"

// Water uniforms.
uniform vec4 scape_SkyColor;

uniform vec2 scape_NearFoamDepth;
uniform vec2 scape_FarFoamDepth;
uniform vec2 scape_WaterDepth;

uniform vec4 scape_FoamColor;
uniform vec4 scape_ShallowWaterColor;
uniform vec4 scape_DeepWaterColor;
uniform vec4 scape_DiffuseColor;

uniform Image scape_FoamTexture;
uniform Image scape_DepthTexture;

uniform vec2 scape_TextureScale;

// Whirlpool uniforms.
uniform Image scape_MaskTexture;
uniform mat4 scape_BumpProjectionViewMatrix;

uniform float scape_WhirlpoolAlpha;
uniform vec2 scape_WhirlpoolCenter; // Whirlpool center in world coordinates.
uniform float scape_WhirlpoolRadius; // Radius of the whirlpool in world coordinates.
uniform float scape_WhirlpoolRings; // How many rings there are. This should be > 0.
uniform float scape_WhirlpoolRotationSpeed; // Direction and speed of rotation.
uniform float scape_WhirlpoolHoleSpeed; // Other speed value for hole (how fast stuff falls into hole).
uniform float scape_WhirlpoolHoleRadius; // Hole radius.

// Common.
uniform Image scape_DiffuseTexture;

varying vec2 frag_ScreenPosition;

#include "Resources/Shaders/Wind.common.glsl"

vec2 rotate(float theta, vec2 p)
{
	float sinTheta = sin(theta);
	float cosTheta = cos(theta);
	mat2 rotationMatrix = mat2(cosTheta, -sinTheta, sinTheta, cosTheta);
	return p * rotationMatrix;
}

void performWaterEffect(vec2 textureCoordinate, inout vec4 color, inout vec3 position, inout vec3 normal, out float specular)
{
	float depth = Texel(scape_DepthTexture, frag_ScreenPosition).r;
	vec3 referencePosition = worldPositionFromGBufferDepth(depth, frag_ScreenPosition, scape_InverseProjectionMatrix, scape_InverseViewMatrix);
	float d = distance(referencePosition, position);

	vec4 colorSample = Texel(scape_DiffuseTexture, textureCoordinate);
	vec4 foamSample = Texel(scape_FoamTexture, textureCoordinate);

	colorSample.rgb *= scape_DiffuseColor.rgb;
	colorSample.a *= smoothstep(0.0, 2.0, d);

	vec4 foamColor = vec4(scape_FoamColor.rgb, scape_FoamColor.a * (1.0 - smoothstep(scape_NearFoamDepth.x, scape_NearFoamDepth.y, d)));
	foamColor.a *= 1.0 - (foamSample.a * (1.0 - smoothstep(scape_FarFoamDepth.x, scape_FarFoamDepth.y, d)));

	vec4 shallowWaterColor = vec4(
		mix(scape_ShallowWaterColor.rgb, scape_SkyColor.rgb, clamp(calculateFresnel(2.0, normal), 0.0, 1.0)),
		scape_ShallowWaterColor.a);

	float delta = smoothstep(scape_WaterDepth.x, scape_WaterDepth.y, d);
	vec3 waterColor = mix(shallowWaterColor.rgb, scape_DeepWaterColor.rgb, delta);
	float waterAlpha = mix(shallowWaterColor.a, scape_DeepWaterColor.a, delta);
	color *= alphaBlend(alphaBlend(vec4(waterColor, waterAlpha), foamColor), colorSample);
}

void performWhirlpoolEffect(vec2 textureCoordinate, inout vec4 color, inout vec3 position, inout vec3 normal, out float specular)
{
	vec4 relativePosition = scape_BumpProjectionViewMatrix * vec4(frag_Position, 1.0);
	relativePosition /= relativePosition.w;
	relativePosition.xyz += vec3(1.0);
	relativePosition.xyz /= vec3(2.0);

	float outlineAlpha = Texel(scape_MaskTexture, relativePosition.xy).r;

	vec2 relativeWorldPosition = frag_Position.xz - scape_WhirlpoolCenter;
	vec2 whirlpoolCartesianCoordinate = relativeWorldPosition;
	whirlpoolCartesianCoordinate = rotate(scape_WhirlpoolRotationSpeed * scape_Time, whirlpoolCartesianCoordinate);

	float whirlpoolCoordinateAngle = atan(whirlpoolCartesianCoordinate.y, whirlpoolCartesianCoordinate.x) / 2.0;
	float whirlpoolCoordinateDistance = length(whirlpoolCartesianCoordinate) / max(scape_WhirlpoolRings, 1.0);
	vec2 whirlpoolTextureCoordinate = vec2(
		(scape_Time * scape_WhirlpoolHoleSpeed) - (1.0 / whirlpoolCoordinateDistance),
		whirlpoolCoordinateAngle / SCAPE_PI);

	vec4 waterSample = color;

	float distanceFromCenter = length(relativeWorldPosition);
	float foam = smoothstep(scape_WhirlpoolRadius - 4.0, scape_WhirlpoolRadius, distanceFromCenter);
	float shadow = 1.0 - smoothstep(0.0, scape_WhirlpoolHoleRadius, distanceFromCenter);
	vec4 whirlpoolSample = Texel(scape_DiffuseTexture, whirlpoolTextureCoordinate);
	whirlpoolSample.rgb = (1.0 - shadow) * whirlpoolSample.rgb + shadow * scape_DeepWaterColor.rgb;
	whirlpoolSample.rgb = (1.0 - foam) * whirlpoolSample.rgb + foam * scape_FoamColor.rgb;

	float alpha = smoothstep(scape_WhirlpoolRadius - 2.0, scape_WhirlpoolRadius, distanceFromCenter);
	vec4 compositedSample = mix(whirlpoolSample, waterSample, alpha * scape_WhirlpoolAlpha);
	vec4 finalSample = mix(compositedSample, scape_FoamColor, outlineAlpha);

	color *= finalSample;
}

void performAdvancedEffect(vec2 textureCoordinate, inout vec4 color, inout vec3 position, inout vec3 normal, out float specular)
{
	textureCoordinate += normalize(scape_WindDirection.xz) * vec2(scape_WindSpeed * scape_Time / 8.0);
	textureCoordinate /= scape_TextureScale;

	performWaterEffect(textureCoordinate, color, position, normal, specular);
	performWhirlpoolEffect(textureCoordinate, color, position, normal, specular);
}

vec4 performEffect(vec4 color, vec2 textureCoordinate)
{
	vec4 diffuse = color;
	vec3 normal = frag_Normal;
	vec3 position = frag_Position;
	float specular = 0.0;

	performAdvancedEffect(textureCoordinate, diffuse, position, normal, specular);

	return diffuse;
}

#pragma option SCAPE_LIGHT_MODEL_V2
