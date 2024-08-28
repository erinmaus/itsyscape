#line 1
uniform Image scape_NormalTexture;
uniform Image scape_PositionTexture;
uniform Image scape_ReflectionPropertiesTexture;
uniform Image scape_ColorTexture;
uniform vec2 scape_TexelSize;
uniform mat4 scape_Projection;
uniform mat4 scape_View;
uniform vec3 scape_CameraDirection;

const float MAX_DISTANCE_VIEW_SPACE = 14.0;
const float RESOLUTION = 1;
const float MIN_STEPS = 10;
const float MAX_STEPS = 80;
// const float THICKNESS = 0.37;
//const float THICKNESS = 1.0; // boats in water
//uniform float THICKNESS;
const float THICKNESS = 0.11; // players
const float MAX_DISTANCE_PIXELS = 256.0;
const float CLIP_PLANE_Z = 2.0;

vec4 toPixel(vec4 viewPosition)
{
	vec4 result = scape_Projection * viewPosition;
	result.xyz /= result.w;
	result.xy += vec2(1.0);
	result.xy /= vec2(2.0);
	result.xy /= scape_TexelSize;

	return result;
}

vec4 toViewSpace(vec4 worldPosition)
{
	return scape_View * worldPosition;
}

vec4 ssr(vec3 surfacePosition, vec3 surfaceViewSpaceNormal, vec3 pivot)
{
	if (length(surfacePosition) < 0.001)
	{
		return vec4(0.0);
	}

	vec4 startViewSpace = vec4(surfacePosition, 1.0);
	vec4 endViewSpace = vec4(surfacePosition + pivot * vec3(MAX_DISTANCE_VIEW_SPACE), 1.0);

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
	float currentDelta = (useX * abs(delta.x) + (1.0 - useX) * abs(delta.y)) * RESOLUTION;
	vec2 increment = delta / clamp(currentDelta, 0.001, MAX_DISTANCE_PIXELS);

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
		localPosition = toViewSpace(vec4(texture(scape_PositionTexture, localTextureCoordinate).xyz, 1.0));

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

	float stepsEstimate = mix(MIN_STEPS, MAX_STEPS, clamp(length(localPosition.xyz - surfacePosition) / MAX_DISTANCE_VIEW_SPACE, 0.0, 1.0));
	int steps = int(hitFirstPass * stepsEstimate);
	for(int i = 0; i < steps; ++i)
	{
		vec2 currentFragment = mix(startPixel.xy, endPixel.xy, searchHit);
		localTextureCoordinate = currentFragment * scape_TexelSize;
		localPosition = toViewSpace(vec4(texture(scape_PositionTexture, localTextureCoordinate).xyz, 1.0));
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

	love_Canvases[1] = vec4(stepsEstimate, 0.0, 0.0, 1.0);

	if (hitSecondPass >= 1.0 && localTextureCoordinate.x >= 0.0 && localTextureCoordinate.x <= 1.0 && localTextureCoordinate.y >= 0.0 && localTextureCoordinate.y <= 1.0)
	{
		float alpha1 = 1.0 - clamp(depth / THICKNESS, 0.0, 1.0);
		float alpha2 = 1.0 - min(length(localPosition.xyz - surfacePosition) / MAX_DISTANCE_VIEW_SPACE, 1);
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
	vec3 worldPosition = Texel(scape_PositionTexture, textureCoordinate).xyz;
	vec3 viewPosition = toViewSpace(vec4(worldPosition.xyz, 1.0)).xyz;
	vec3 surfaceViewSpaceNormal = normalize(viewPosition);
	vec3 normal = normalize(Texel(scape_NormalTexture, textureCoordinate).xyz);
	normal = normalize(inverse(transpose(mat3(scape_View))) * normal);

	vec3 reflectionPivot = normalize(reflect(surfaceViewSpaceNormal, normal));
	vec4 reflectionResult = ssr(viewPosition, surfaceViewSpaceNormal, reflectionPivot);
	//reflectionResult.a *= 1.0 - max((abs(dot(scape_CameraDirection, surfaceViewSpaceNormal)) - 0.75) / 0.25, 0.0);
	float reflectionAlpha = min(min(dFdx(reflectionResult.a) + reflectionResult.a, dFdy(reflectionResult.a) + reflectionResult.a), reflectionResult.a);
	love_Canvases[0] = vec4(reflectionResult.xy, reflectionResult.a * reflectionAlpha * reflectionProperties.x, 1.0);
	//love_Canvases[1] = vec4(dot(-surfaceViewSpaceNormal, reflectionPivot), dot(surfaceViewSpaceNormal, normal), dot(surfaceViewSpaceNormal, normalize(cross(reflectionPivot, normal))), 1.0);
	//love_Canvases[1] = vec4(dot(scape_CameraDirection, reflectionPivot), dot(scape_CameraDirection, normal), 0.0, 1.0);
	//love_Canvases[1] = vec4(dFdx(reflectionResult.a) + reflectionResult.a, dFdy(reflectionResult.a) + reflectionResult.a, reflectionResult.a, 1.0);
	//love_Canvases[0] = vec4(Texel(scape_ColorTexture, reflectionResult.xy).rgb, reflectionAlpha * reflectionProperties.x);
}
