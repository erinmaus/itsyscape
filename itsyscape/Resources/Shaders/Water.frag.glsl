#include "Resources/Shaders/GBuffer.common.glsl"
#include "Resources/Shaders/Fresnel.common.glsl"
#include "Resources/Shaders/Blend.common.glsl"
#include "Resources/Shaders/Color.common.glsl"

uniform vec4 scape_SkyColor;

uniform vec2 scape_NearFoamDepth;
uniform vec2 scape_FarFoamDepth;
uniform vec2 scape_WaterDepth;

uniform vec4 scape_FoamColor;
uniform vec4 scape_ShallowWaterColor;
uniform vec4 scape_DeepWaterColor;
uniform vec4 scape_DiffuseColor;

uniform highp vec2 scape_TimeScale;
uniform Image scape_DiffuseTexture;
uniform Image scape_FoamTexture;
uniform Image scape_DepthTexture;

uniform vec2 scape_TextureScale;

varying vec2 frag_ScreenPosition;

void performAdvancedEffect(vec2 textureCoordinate, inout vec4 color, inout vec3 position, inout vec3 normal, out float specular)
{
	float depth = Texel(scape_DepthTexture, frag_ScreenPosition).r;
	vec3 referencePosition = worldPositionFromGBufferDepth(depth, frag_ScreenPosition, scape_InverseProjectionMatrix, scape_InverseViewMatrix);
	float d = distance(referencePosition, position);

	textureCoordinate += sin(scape_Time * scape_TimeScale.y) * scape_TimeScale.x;
	textureCoordinate *= scape_TextureScale;
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
