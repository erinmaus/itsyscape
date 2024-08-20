#include "Resources/Shaders/Depth.common.glsl"

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

float getDepthEdge(Image image, vec2 textureCoordinate, vec2 texelSize, float includeCenter)
{
	mat3 I;
	float convulation[9];

	float center = linearDepth(Texel(image, textureCoordinate).r) * includeCenter;

	for (int x = 0; x < 3; x += 1)
	{
		for (int y = 0; y < 3; y += 1)
		{
			float currentSample = linearDepth(Texel(image, textureCoordinate + vec2(float(x - 1), float(y - 1)) * texelSize).r);
			I[x][y] = abs(currentSample - center);
		}
	}
	
	for (int i = 0; i < 9; i++)
	{
		float dotProduct = dot(G[i][0], I[0]) + dot(G[i][1], I[1]) + dot(G[i][2], I[2]);
		convulation[i] = dotProduct * dotProduct; 
	}

	float M = (convulation[0] + convulation[1]) + (convulation[2] + convulation[3]);
	float S = (convulation[4] + convulation[5]) + (convulation[6] + convulation[7]) + (convulation[8] + M);

	return sqrt(M / max(S, 0.001));
}

float getGreyEdge(sampler2D image, vec2 textureCoordinate, vec2 texelSize, float includeCenter)
{
	mat3 I;
	float convulation[9];

	float center = Texel(image, textureCoordinate).r * includeCenter;

	for (int x = 0; x < 3; x += 1)
	{
		for (int y = 0; y < 3; y += 1)
		{
			float currentSample = Texel(image, textureCoordinate + vec2(float(x - 1), float(y - 1)) * texelSize).r;
			I[x][y] = abs(currentSample - center);
		}
	}
	
	for (int i = 0; i < 9; i++)
	{
		float dotProduct = dot(G[i][0], I[0]) + dot(G[i][1], I[1]) + dot(G[i][2], I[2]);
		convulation[i] = dotProduct * dotProduct; 
	}

	float M = (convulation[0] + convulation[1]) + (convulation[2] + convulation[3]);
	float S = (convulation[4] + convulation[5]) + (convulation[6] + convulation[7]) + (convulation[8] + M);

	return sqrt(M / max(S, 0.001));
}

float getNormalEdge(sampler2D image, vec2 textureCoordinate, vec2 texelSize)
{
	mat3 I;
	float convulation[9];

	vec3 center = Texel(image, textureCoordinate).xyz;

	for (int x = 0; x < 3; x += 1)
	{
		for (int y = 0; y < 3; y += 1)
		{
			vec3 currentSample = Texel(image, textureCoordinate + vec2(float(x - 1), float(y - 1)) * texelSize).xyz;
			float centerDotCurrentSample = dot(center, currentSample);

			I[x][y] = centerDotCurrentSample;
		}
	}
	
	for (int i = 0; i < 9; i++)
	{
		float dotProduct = dot(G[i][0], I[0]) + dot(G[i][1], I[1]) + dot(G[i][2], I[2]);
		convulation[i] = dotProduct * dotProduct; 
	}

	float M = (convulation[0] + convulation[1]) + (convulation[2] + convulation[3]);
	float S = (convulation[4] + convulation[5]) + (convulation[6] + convulation[7]) + (convulation[8] + M);

	return sqrt(M / max(S, 0.001));
}
