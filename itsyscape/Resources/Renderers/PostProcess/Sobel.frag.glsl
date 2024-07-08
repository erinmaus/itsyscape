uniform vec2 scape_TexelSize;
uniform sampler2D scape_AlphaMaskTexture;
uniform sampler2D scape_OutlineColorTexture;

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

float getDepthSobel(sampler2D image, vec2 textureCoordinate)
{
	mat3 I;
	float cnv[9];

	float center = Texel(image, textureCoordinate).r;

	for (int x = 0; x < 3; x += 1)
	{
		for (int y = 0; y < 3; y += 1)
		{
			float sample = Texel(image, textureCoordinate + vec2(float(x - 1), float(y - 1)) * scape_TexelSize).r;
			I[x][y] = abs(sample - center);
			//I[x][y] = sample;
		}
	}
	
	for (int i = 0; i < 9; i++)
	{
		float dp3 = dot(G[i][0], I[0]) + dot(G[i][1], I[1]) + dot(G[i][2], I[2]);
		cnv[i] = dp3 * dp3; 
	}

	float M = (cnv[0] + cnv[1]) + (cnv[2] + cnv[3]);
	float S = (cnv[4] + cnv[5]) + (cnv[6] + cnv[7]) + (cnv[8] + M);

	return sqrt(M / max(S, 0.001));
}

float getMinAlpha(Image image, vec2 textureCoordinate)
{
	float minAlpha = 1.0;

	for (float x = -1.0; x <= 1; x += 1.0)
	{
		for (float y = -1.0; y <= 1; y += 1.0)
		{
			float alpha = Texel(image, textureCoordinate + vec2(x, y) * scape_TexelSize).a;
			minAlpha = min(alpha, minAlpha);
		}
	}

	return minAlpha;
}

vec4 effect(vec4 color, Image image, vec2 textureCoordinate, vec2 screenCoordinates)
{
	float alpha = getMinAlpha(scape_AlphaMaskTexture, textureCoordinate);
	if (alpha >= 1.0)
	{
		//discard;
	}

	alpha = Texel(scape_AlphaMaskTexture, textureCoordinate).a;

	float sobel = getDepthSobel(image, textureCoordinate);
	float outline = step(0.5, sobel);

	if (outline >= 1.0 && alpha == 0.0)
	{
		alpha = 1.0;
	}

	vec3 outlineColor = Texel(scape_OutlineColorTexture, textureCoordinate).rgb;
    return vec4(vec3(1.0 - outline) * outlineColor, alpha);
}
