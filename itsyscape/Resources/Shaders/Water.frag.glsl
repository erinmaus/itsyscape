#include "Resources/Shaders/GBuffer.common.glsl"
#include "Resources/Shaders/Fresnel.common.glsl"
#include "Resources/Shaders/Blend.common.glsl"

uniform vec4 scape_SkyColor;

uniform vec2 scape_FoamDepth;
uniform vec2 scape_WaterDepth;
uniform vec4 scape_FoamColor;
uniform vec4 scape_ShallowWaterColor;
uniform vec4 scape_DeepWaterColor;

uniform highp vec4 scape_TimeScale;
uniform Image scape_DiffuseTexture;
uniform Image scape_DepthTexture;

varying vec2 frag_ScreenPosition;

void performAdvancedEffect(vec2 textureCoordinate, inout vec4 color, inout vec3 position, inout vec3 normal, out float specular)
{
	float depth = Texel(scape_DepthTexture, frag_ScreenPosition).r;
	vec3 referencePosition = worldPositionFromGBufferDepth(depth, frag_ScreenPosition, scape_InverseProjectionMatrix, scape_InverseViewMatrix);
	float d = distance(referencePosition, position);

	textureCoordinate += sin(scape_Time * scape_TimeScale.z) * scape_TimeScale.y;
	vec4 colorSample = Texel(scape_DiffuseTexture, textureCoordinate) * color;

	vec4 foamColor = vec4(scape_FoamColor.rgb, scape_FoamColor.a * 1.0 - smoothstep(1.0, 2.0, d));

	vec4 shallowWaterColor = vec4(
		mix(scape_SkyColor.rgb, scape_ShallowWaterColor.rgb, clamp(calculateFresnel(2.0, normal), 0.0, 1.0)),
		scape_ShallowWaterColor.a);

	vec4 waterColor = mix(scape_ShallowWaterColor, scape_DeepWaterColor, smoothstep(2.0, 20.0, d));
	color *= alphaBlend(waterColor, foamColor);
}

vec4 performEffect(vec4 color, vec2 textureCoordinate)
{
	textureCoordinate += sin(scape_Time * scape_TimeScale.z) * scape_TimeScale.y;
	return Texel(scape_DiffuseTexture, textureCoordinate);
}

#pragma option SCAPE_LIGHT_MODEL_V2
