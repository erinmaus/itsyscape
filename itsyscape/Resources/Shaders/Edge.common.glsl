#include "Resources/Shaders/Depth.common.glsl"
#include "Resources/Shaders/GBuffer.common.glsl"

#define SOBEL_LENGTH 2

const mat3 SOBEL[2] = mat3[](
	mat3(1, 0, -1, 2, 0, -2, 1, 0, -1),
    mat3(1, 2, 1, 0, 0, 0, -1, -2, -1)
);

float sobel(float convulation[SOBEL_LENGTH])
{
	return sqrt(convulation[0] + convulation[1]);
}

#ifdef EDGE_USE_SOBEL

#define G_LENGTH 2

const mat3 G[2] = mat3[](
	mat3(1, 0, -1, 2, 0, -2, 1, 0, -1),
    mat3(1, 2, 1, 0, 0, 0, -1, -2, -1)
);

float edgeCombineConvulations(float convulation[G_LENGTH])
{
	return sqrt(convulation[0] + convulation[1]);
}

#else

#define G_LENGTH 9

const mat3 G[9] = mat3[](
	1.0/(2.0*sqrt(2.0)) * mat3( 1.0, sqrt(2.0), 1.0, 0.0, 0.0, 0.0, -1.0, -sqrt(2.0), -1.0 ),
	1.0/(2.0*sqrt(2.0)) * mat3( 1.0, 0.0, -1.0, sqrt(2.0), 0.0, -sqrt(2.0), 1.0, 0.0, -1.0 ),
	1.0/(2.0*sqrt(2.0)) * mat3( 0.0, -1.0, sqrt(2.0), 1.0, 0.0, -1.0, -sqrt(2.0), 1.0, 0.0 ),
	1.0/(2.0*sqrt(2.0)) * mat3( sqrt(2.0), -1.0, 0.0, -1.0, 0.0, 1.0, 0.0, 1.0, -sqrt(2.0) ),
	1.0/2.0 * mat3( 0.0, 1.0, 0.0, -1.0, 0.0, -1.0, 0.0, 1.0, 0.0 ),
	1.0/2.0 * mat3( -1.0, 0.0, 1.0, 0.0, 0.0, 0.0, 1.0, 0.0, -1.0 ),
	1.0/6.0 * mat3( 1.0, -2.0, 1.0, -2.0, 4.0, -2.0, 1.0, -2.0, 1.0 ),
	1.0/6.0 * mat3( -2.0, 1.0, -2.0, 1.0, 4.0, 1.0, -2.0, 1.0, -2.0 ),
	1.0/3.0 * mat3( 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0 )
);

float edgeCombineConvulations(float convulation[G_LENGTH])
{
	float M = (convulation[0] + convulation[1]) + (convulation[2] + convulation[3]);
	float S = (convulation[4] + convulation[5]) + (convulation[6] + convulation[7]) + (convulation[8] + M);

	return sqrt(M / max(S, 0.001));
}

#endif

float getDepthEdge(Image image, vec2 textureCoordinate, vec2 texelSize, float includeCenter)
{
	mat3 I;
	float convulation[G_LENGTH];

	float center = linearDepth(Texel(image, textureCoordinate).r) * includeCenter;

	for (int x = 0; x < 3; x += 1)
	{
		for (int y = 0; y < 3; y += 1)
		{
			float currentSample = linearDepth(Texel(image, textureCoordinate + vec2(float(x - 1), float(y - 1)) * texelSize).r);
			I[x][y] = abs(currentSample - center);
		}
	}
	
	for (int i = 0; i < G_LENGTH; i++)
	{
		float dotProduct = dot(G[i][0], I[0]) + dot(G[i][1], I[1]) + dot(G[i][2], I[2]);
		convulation[i] = dotProduct * dotProduct; 
	}

	return edgeCombineConvulations(convulation);
}

float getGreyEdge(sampler2D image, vec2 textureCoordinate, vec2 texelSize, float includeCenter)
{
	mat3 I;
	float convulation[G_LENGTH];

	float center = Texel(image, textureCoordinate).r * includeCenter;

	for (int x = 0; x < 3; x += 1)
	{
		for (int y = 0; y < 3; y += 1)
		{
			float currentSample = Texel(image, textureCoordinate + vec2(float(x - 1), float(y - 1)) * texelSize).r;
			I[x][y] = abs(currentSample - center);
		}
	}
	
	for (int i = 0; i < G_LENGTH; i++)
	{
		float dotProduct = dot(G[i][0], I[0]) + dot(G[i][1], I[1]) + dot(G[i][2], I[2]);
		convulation[i] = dotProduct * dotProduct; 
	}

	return edgeCombineConvulations(convulation);
}

float getNormalEdge(sampler2D image, vec2 textureCoordinate, vec2 texelSize)
{
	mat3 I;
	float convulation[SOBEL_LENGTH];

	vec3 center = decodeGBufferNormal(Texel(image, textureCoordinate).xy);

	for (int x = 0; x < 3; x += 1)
	{
		for (int y = 0; y < 3; y += 1)
		{
			vec2 currentSample = Texel(image, textureCoordinate + vec2(float(x - 1), float(y - 1)) * texelSize).xy;
			vec3 currentNormal = decodeGBufferNormal(currentSample);
			vec3 scaledNormal = (currentNormal + vec3(1.0)) / vec3(2.0);
			float value = (scaledNormal.x + scaledNormal.y + scaledNormal.z) / 3.0;

			I[x][y] = value;
		}
	}
	
	for (int i = 0; i < SOBEL_LENGTH; i++)
	{
		float dotProduct = dot(SOBEL[i][0], I[0]) + dot(SOBEL[i][1], I[1]) + dot(SOBEL[i][2], I[2]);
		convulation[i] = dotProduct * dotProduct; 
	}

	return sobel(convulation);
}
