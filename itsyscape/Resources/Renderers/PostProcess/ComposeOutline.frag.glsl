#define MAX_JUMP_DISTANCE 64

#include "Resources/Shaders/Depth.common.glsl"
#include "Resources/Shaders/Dilate.common.glsl"

uniform sampler2D scape_DepthTexture;
uniform vec2 scape_TexelSize;
uniform vec2 scape_TexelScale;
uniform float scape_NearOutlineDistance;
uniform float scape_FarOutlineDistance;
uniform float scape_MinOutlineThickness;
uniform float scape_MaxOutlineThickness;
uniform float scape_MinOutlineDepthAlpha;
uniform float scape_MaxOutlineDepthAlpha;
uniform float scape_OutlineFadeDepth;

vec4 effect(vec4 color, Image image, vec2 textureCoordinate, vec2 screenCoordinates)
{
	float depth = linearDepth(Texel(scape_DepthTexture, textureCoordinate).r);
	float remappedDepth = smoothstep(scape_NearOutlineDistance, scape_FarOutlineDistance, depth);
	float thickness = mix(scape_MinOutlineThickness, scape_MaxOutlineThickness, 1.0 - remappedDepth);
	float alphaMultiplier = 1.0 - smoothstep(scape_FarOutlineDistance, scape_FarOutlineDistance + scape_OutlineFadeDepth, depth);
	alphaMultiplier = mix(scape_MinOutlineDepthAlpha, scape_MaxOutlineDepthAlpha, alphaMultiplier);

	vec4 outlineColor = dilateMin(thickness, image, textureCoordinate, scape_TexelSize, vec4(1.0));
	vec4 result;
	result.rgb = mix(vec3(1.0), outlineColor.rgb, alphaMultiplier);
	result.a = 1.0;

	return result;
}
