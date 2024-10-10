#define MAX_JUMP_DISTANCE 64

#include "Resources/Shaders/Depth.common.glsl"

uniform sampler2D scape_DepthTexture;
uniform sampler2D scape_OutlineTexture;
uniform sampler2D scape_OutlineColorTexture;
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
	vec4 outlineSample = Texel(image, textureCoordinate);
	vec2 outlineSampleTextureCoordinate = mix(vec2(-1.0), vec2(1.0), outlineSample.xy) * vec2(MAX_JUMP_DISTANCE) * scape_TexelScale * scape_TexelSize + textureCoordinate;

	float depth = linearDepth(Texel(scape_DepthTexture, textureCoordinate).r);
	float remappedDepth = smoothstep(scape_NearOutlineDistance, scape_FarOutlineDistance, depth);
	float thickness = mix(scape_MinOutlineThickness, scape_MaxOutlineThickness, 1.0 - remappedDepth);
	float alphaMultiplier = 1.0 - smoothstep(scape_FarOutlineDistance, scape_FarOutlineDistance + scape_OutlineFadeDepth, depth);
	alphaMultiplier = mix(scape_MinOutlineDepthAlpha, scape_MaxOutlineDepthAlpha, alphaMultiplier);

	float halfThickness = thickness / 2.0;
	float d = step(halfThickness, outlineSample.z * MAX_JUMP_DISTANCE);
	float a = smoothstep(0.0, halfThickness, outlineSample.z * MAX_JUMP_DISTANCE);

	float alpha = 1.0;
	for (float x = -1.0; x <= 1.0; x += 1.0)
	{
		for (float y = -1.0; y <= 1.0; y += 1.0)
		{
			alpha = min(alpha, Texel(scape_OutlineTexture, (outlineSample.xy + vec2(x, y)) * scape_TexelSize).a);
		}
	}

	if (a >= 1.0)
	{
		alpha = 1.0;
	}

	vec3 outlineColor1 = Texel(scape_OutlineTexture, outlineSampleTextureCoordinate).rgb;
	float outlineColor1Luma = length(outlineColor1);
	vec3 outlineColor2 = vec3(Texel(scape_OutlineColorTexture, textureCoordinate).y);
	float outlineColor2Luma = length(outlineColor2);
	vec3 outlineColor = outlineColor1Luma <= outlineColor2Luma ? outlineColor1 : outlineColor2;
	outlineColor = mix(outlineColor, vec3(1.0), a);
	float outlineAlpha = alpha * a;
	if (outlineSample.z >= halfThickness || outlineSample.z < 0.0)
	{
		outlineColor = vec3(1.0);
		outlineAlpha = 1.0;
	}

	return vec4(mix(vec3(1.0), mix(outlineColor, vec3(1.0), outlineAlpha), alphaMultiplier), 1.0);
}
