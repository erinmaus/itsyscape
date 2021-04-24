#line 1
uniform ArrayImage scape_DiffuseTexture;
uniform float scape_NumLayers;
uniform float scape_Time;

varying vec3 frag_CubeNormal;
varying vec3 frag_CubePosition;

const float POSITIVE_X = 0;
const float POSITIVE_Y = 1;
const float POSITIVE_Z = 2;
const float NEGATIVE_X = 3;
const float NEGATIVE_Y = 4;
const float NEGATIVE_Z = 5;
const float NUM_CUBE_MAP_TEXTURES = 6;

#define PI 3.1415926535898

const vec4[] NORMAL_COLORS = vec4[](
	vec4(1.0, 0.0, 0.0, 1.0),
	vec4(0.0, 1.0, 0.0, 1.0),
	vec4(0.0, 0.0, 1.0, 1.0),
	vec4(1.0, 1.0, 0.0, 1.0),
	vec4(1.0, 0.0, 1.0, 1.0),
	vec4(0.0, 1.0, 1.0, 1.0)
);

vec3 toCubemap(vec3 normal, vec3 position)
{
	vec3 absUnitPosition = abs(normal);
	vec3 axisSigns = sign(normal);
	bvec3 isPositive = greaterThan(normal, vec3(0.0));
	bvec3 absX = greaterThanEqual(vec3(absUnitPosition.x), absUnitPosition);
	bvec3 absY = greaterThanEqual(vec3(absUnitPosition.y), absUnitPosition);
	bvec3 absZ = greaterThanEqual(vec3(absUnitPosition.z), absUnitPosition);

	float maxAxis;
	float u, v, index;
	if (absX.y && absX.z)
	{
		// Pointing towards X axis
		maxAxis = absUnitPosition.x;
		u = -axisSigns.x * position.z;
		v = position.y;
		index = axisSigns.x >= 0 ? POSITIVE_X : NEGATIVE_X;
	}
	else if (absY.x && absY.z)
	{
		// Pointing towards Y axis
		maxAxis = absUnitPosition.y;
		u = position.x;
		v = -axisSigns.y * position.z;
		index = axisSigns.y >= 0 ? POSITIVE_Y : NEGATIVE_Y;
	}
	else if (absZ.x && absZ.y)
	{
		// Pointing towards Z axis
		maxAxis = absUnitPosition.z;
		u = axisSigns.z * position.x;
		v = position.y;
		index = axisSigns.z >= 0 ? POSITIVE_Z : NEGATIVE_Z;
	}
	else
	{
		// This is an error condition.
		discard;
	}

	return vec3(
		0.5 * (u / maxAxis + 1.0),
		0.5 * (v / maxAxis + 1.0),
		index);
}

vec4 sampleTexture(vec3 textureCoordinate, vec3 cubePosition)
{
	float numCubeMapTextures = scape_NumLayers / NUM_CUBE_MAP_TEXTURES;
	float cubePositionLength = length(cubePosition);
	float fractionalIndex = cubePositionLength * numCubeMapTextures;

	float cubeMapTexture1 = floor(fractionalIndex);
	float cubeMapTexture2 = min(cubeMapTexture1 + 1, numCubeMapTextures);

	float texture1 = cubeMapTexture1 * NUM_CUBE_MAP_TEXTURES + textureCoordinate.z;
	float texture2 = cubeMapTexture2 * NUM_CUBE_MAP_TEXTURES + textureCoordinate.z;
	float textureDelta = fractionalIndex - floor(fractionalIndex);

	vec4 sample1 = Texel(
		scape_DiffuseTexture,
		vec3(textureCoordinate.st, texture1));
	vec4 sample2 = Texel(
		scape_DiffuseTexture,
		vec3(textureCoordinate.st, texture2));

	return mix(sample1, sample2, textureDelta);
}

vec4 performEffect(vec4 color, vec2 textureCoordinate)
{
	vec3 cubeMapTextureCoords = toCubemap(frag_CubeNormal, frag_CubePosition);
	vec4 texture = sampleTexture(cubeMapTextureCoords, frag_CubePosition);
	return texture * color;
}
