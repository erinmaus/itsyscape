#define SCAPE_MAX_CASCADES 8

uniform ArrayImage scape_ShadowMap;
uniform Image scape_PositionTexture;
uniform Image scape_NormalOutlineTexture;
uniform vec2 scape_TexelSize;
uniform vec3 scape_LightDirection;
uniform mat4 scape_CascadeLightSpaceMatrices[SCAPE_MAX_CASCADES];
uniform vec2 scape_CascadePlanes[SCAPE_MAX_CASCADES];
uniform int scape_NumCascades;
uniform float scape_ShadowAlpha;
uniform mat4 scape_View;

#define SCAPE_PCF_BLUR_START -2
#define SCAPE_PCF_BLUR_END 2

float calculatePCF(int cascadeIndex, vec3 position, float bias)
{
	float layer = float(cascadeIndex);

	float result = 0.0;
	float numSamples = 0.0;
	for (int i = SCAPE_PCF_BLUR_START; i <= SCAPE_PCF_BLUR_END; ++i)
	{
		for (int j = SCAPE_PCF_BLUR_START; j <= SCAPE_PCF_BLUR_END; ++j)
		{
			float x = float(i);
			float y = float(j);
			float comparison = position.z - bias;

			float s = position.x + x * scape_TexelSize.x;
			float t = position.y + y * scape_TexelSize.y;

			float target = Texel(scape_ShadowMap, vec3(s, t, layer)).r;

			result += step(target, comparison);
			numSamples += 1.0;
		}
	}

	return result /= numSamples;
}

float calculateBiasDelta(vec3 lightPositionDerivativeX, vec3 lightPositionDerivativeY)
{
	// mat2 screenToShadow = mat2(lightPositionDerivativeX.xy, lightPositionDerivativeY.xy);
	// float d = determinant(screenToShadow);
	
	// float inverseD = 1.0 / d;
	
	// mat2 shadowToScreen = mat2(
	// 	screenToShadow[1][1] * inverseD, screenToShadow[0][1] * -inverseD, 
	// 	screenToShadow[1][0] * -inverseD, screenToShadow[0][1] * inverseD
	// );

	// vec2 rightTexel = vec2(scape_TexelSize.x, 0.0);
	// vec2 upTexel = vec2(0.0, scape_TexelSize.y);  

	// vec2 rightTexelDepthRatio = shadowToScreen * rightTexel;
	// vec2 upTexelDepthRatio = shadowToScreen * upTexel;

	// return vec2(
	// 	upTexelDepthRatio.x * lightPositionDerivativeX.z + upTexelDepthRatio.y * lightPositionDerivativeY.z,
	// 	rightTexelDepthRatio.x * lightPositionDerivativeX.z + rightTexelDepthRatio.y * lightPositionDerivativeY.z
	// );
	return (lightPositionDerivativeX.z * lightPositionDerivativeX.z + lightPositionDerivativeY.z * lightPositionDerivativeY.z);
	//return length(lightPositionDerivativeX) + length(lightPositionDerivativeY);
}

vec4 effect(
	vec4 color,
	Image depth,
	vec2 textureCoordinate,
	vec2 screenCoordinate)
{
	vec3 worldPosition = Texel(scape_PositionTexture, textureCoordinate).xyz;
	vec3 viewPosition = (scape_View * vec4(worldPosition, 1.0)).xyz;

	int cascadeIndex = 0;
	for (int i = 0; i < scape_NumCascades; ++i)
	{
		float near = scape_CascadePlanes[i].x;
		if (viewPosition.z >= near)
		{
			cascadeIndex = i;
		}
	}

	vec3 normal = normalize(Texel(scape_NormalOutlineTexture, textureCoordinate).xyz);
	vec4 lightPosition = scape_CascadeLightSpaceMatrices[cascadeIndex] * vec4(worldPosition, 1.0);
	vec3 projectedLightPosition = lightPosition.xyz / lightPosition.w;
	projectedLightPosition = (projectedLightPosition + vec3(1.0)) / vec3(2.0);

	float delta = float(cascadeIndex) / ((float(scape_NumCascades - 1) + step(float(scape_NumCascades), 1.0)));
	float bias = max(0.05 * (1.0 - dot(normal, scape_LightDirection)), 0.05) / (scape_CascadePlanes[cascadeIndex].y * mix(0.125, 0.05, delta));

	if (projectedLightPosition.z < 0.0 || projectedLightPosition.z > 1.0)
	{
		return vec4(0.0);
	}

	float shadow = calculatePCF(cascadeIndex, projectedLightPosition, bias);
	return vec4(vec3(0.0), scape_ShadowAlpha * shadow);
}
