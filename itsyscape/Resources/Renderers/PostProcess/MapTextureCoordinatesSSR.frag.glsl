#include "Resources/Shaders/GBuffer.common.glsl"

uniform Image scape_NormalTexture;
uniform Image scape_DepthTexture;
uniform Image scape_ReflectionPropertiesTexture;
uniform Image scape_ColorTexture;
uniform vec2 scape_TexelSize;
uniform mat4 scape_ProjectionMatrix;
uniform mat4 scape_InverseProjectionMatrix;
uniform mat4 scape_ViewMatrix;
uniform mat4 scape_InverseViewMatrix;
uniform vec3 scape_CameraDirection;

uniform float scape_MaxDistanceViewSpace;
uniform float scape_Resolution;
uniform float scape_MinSecondPassSteps;
uniform float scape_MaxSecondPassSteps;
uniform float scape_MaxFirstPassSteps;

//const float THICKNESS = 1.0; // boats in water
const float THICKNESS = 0.11; // players / flat npcs
const float CLIP_PLANE_Z = 2.0;

vec4 toPixel(vec4 viewPosition)
{
	vec4 result = scape_ProjectionMatrix * viewPosition;
	result.xyz /= result.w;
	result.xy += vec2(1.0);
	result.xy /= vec2(2.0);
	result.xy /= scape_TexelSize;

	return result;
}

vec4 getWorldPosition(vec2 textureCoordinate)
{
	float depth = texture(scape_DepthTexture, textureCoordinate).x;
	vec3 worldPosition = worldPositionFromGBufferDepth(depth, textureCoordinate, scape_InverseProjectionMatrix, scape_InverseViewMatrix);
	return vec4(worldPosition, 1.0);
}

vec4 toViewSpace(vec4 worldPosition)
{
	return scape_ViewMatrix * worldPosition;
}

vec4 ssr(vec3 surfacePosition, vec3 surfaceViewSpaceNormal, vec3 pivot, float maxViewSpaceDistance)
{
	if (length(surfacePosition) < 0.001)
	{
		return vec4(0.0);
	}

	vec4 startViewSpace = vec4(surfacePosition, 1.0);
	vec4 endViewSpace = vec4(surfacePosition + pivot * vec3(maxViewSpaceDistance), 1.0);

	vec4 startPixel = toPixel(startViewSpace);
	vec4 endPixel = toPixel(endViewSpace);

	if (endViewSpace.z < CLIP_PLANE_Z)
	{
		return vec4(0.0);
	}

	if (startPixel.z < -1.0 || startPixel.z > 1.0 || endPixel.z < -1.0 || endPixel.z > 1.0)
	{
		return vec4(0.0);
	}

	vec2 delta = endPixel.xy - startPixel.xy;
	float useX = abs(delta.x) >= abs(delta.y) ? 1.0 : 0.0;
	float currentDelta = min((useX * abs(delta.x) + (1.0 - useX) * abs(delta.y)) * scape_Resolution, scape_MaxFirstPassSteps);
	vec2 increment = delta / max(currentDelta, 0.001);

	float searchMiss = 0.0;
	float searchHit = 0.0;

	float hitFirstPass = 0.0;
	float hitSecondPass = 0.0;

	vec2 localTextureCoordinate;
	vec4 localPosition;

	vec2 currentPixel = startPixel.xy;
	float viewDistance = startViewSpace.z;
	float depth = THICKNESS;
	for (int i = 0; i < int(currentDelta); ++i)
	{
		currentPixel += increment;

		localTextureCoordinate = currentPixel * scape_TexelSize;
		localPosition = toViewSpace(getWorldPosition(localTextureCoordinate));

		vec2 difference = (currentPixel - startPixel.xy) / delta;
		searchHit = clamp(useX * difference.x + (1.0 - useX) * difference.y, 0.0, 1.0);
		viewDistance = (startViewSpace.z * endViewSpace.z) / mix(endViewSpace.z, startViewSpace.z, searchHit);
		depth = viewDistance - localPosition.z;

		if (depth > 0.0 && depth < THICKNESS)
		{
			hitFirstPass = 1.0;
			break;
		}
		else
		{
			searchMiss = searchHit;
		}
	}
	searchHit = searchMiss + ((searchHit - searchMiss) / 2.0);

	float stepsEstimate = mix(scape_MinSecondPassSteps, scape_MaxSecondPassSteps, clamp(length(localPosition.xyz - surfacePosition) / scape_MaxDistanceViewSpace, 0.0, 1.0));
	int steps = int(hitFirstPass * stepsEstimate);
	for(int i = 0; i < steps; ++i)
	{
		vec2 currentFragment = mix(startPixel.xy, endPixel.xy, searchHit);
		localTextureCoordinate = currentFragment * scape_TexelSize;
		localPosition = toViewSpace(getWorldPosition(localTextureCoordinate));
		viewDistance = (startViewSpace.z * endViewSpace.z) / mix(endViewSpace.z, startViewSpace.z, searchHit);
		depth = viewDistance - localPosition.z;

		if (depth > 0.0 && depth < THICKNESS)
		{
			hitSecondPass = 1.0;
			searchHit = searchMiss + ((searchHit - searchMiss) / 2.0);
		}
		else
		{
			float s = searchHit;
			searchHit = searchHit + ((searchHit - searchMiss) / 2.0);
			searchMiss = s;
		}
	}

	if (hitSecondPass >= 1.0 && localTextureCoordinate.x >= 0.0 && localTextureCoordinate.x <= 1.0 && localTextureCoordinate.y >= 0.0 && localTextureCoordinate.y <= 1.0)
	{
		float alpha1 = 1.0 - clamp(depth / THICKNESS, 0.0, 1.0);
		float alpha2 = 1.0 - min(length(localPosition.xyz - surfacePosition) / maxViewSpaceDistance, 1);
		float alpha3 = 1.0 - max(dot(-surfaceViewSpaceNormal, pivot), 0.0);
		float alpha4 = min((1.0 - localTextureCoordinate.x) / (16.0 * scape_TexelSize.x), 1.0);
		float alpha5 = min(localTextureCoordinate.x / (16.0 * scape_TexelSize.x), 1.0);
		float alpha6 = min((1.0 - localTextureCoordinate.y) / (16.0 * scape_TexelSize.y), 1.0);
		float alpha7 = min(localTextureCoordinate.y / (16.0 * scape_TexelSize.y), 1.0);

		return vec4(localTextureCoordinate.xy, 1.0, alpha1 * alpha2 * alpha3 * alpha4 * alpha5 * alpha6 * alpha7);
	}
	else
	{
		return vec4(0.0);
	}
}

void effect()
{
	vec2 textureCoordinate = VaryingTexCoord.xy;

	vec4 reflectionProperties = Texel(scape_ReflectionPropertiesTexture, textureCoordinate);
	if (reflectionProperties.x <= 0.0)
	{
		love_Canvases[0] = vec4(0.0);
		return;
	}

	vec4 worldPosition = getWorldPosition(textureCoordinate);
	vec3 viewPosition = toViewSpace(worldPosition).xyz;
	vec3 surfaceViewSpaceNormal = normalize(viewPosition);
	vec3 normal = normalize(decodeGBufferNormal(Texel(scape_NormalTexture, textureCoordinate).rg));
	normal = normalize(inverse(transpose(mat3(scape_ViewMatrix))) * normal);

	vec3 reflectionPivot = normalize(reflect(surfaceViewSpaceNormal, normal));
	vec4 reflectionResult = ssr(viewPosition, surfaceViewSpaceNormal, reflectionPivot, reflectionProperties.y * scape_MaxDistanceViewSpace);
	float reflectionAlpha = min(min(dFdx(reflectionResult.a) + reflectionResult.a, dFdy(reflectionResult.a) + reflectionResult.a), reflectionResult.a);
	love_Canvases[0] = vec4(reflectionResult.xy, reflectionResult.a * reflectionAlpha * reflectionProperties.x, 1.0);
}
