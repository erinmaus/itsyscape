uniform vec2 scape_TexelSize;
uniform sampler2D scape_AlphaMaskTexture;

void makeKernel(inout vec4 n[9], sampler2D texture, vec2 textureCoordinate)
{
	float x = scape_TexelSize.x;
    float y = scape_TexelSize.y;

	n[0] = Texel(texture, textureCoordinate + vec2( -x, -y));
	n[1] = Texel(texture, textureCoordinate + vec2(0.0, -y));
	n[2] = Texel(texture, textureCoordinate + vec2(  x, -y));
	n[3] = Texel(texture, textureCoordinate + vec2( -x, 0.0));
	n[4] = Texel(texture, textureCoordinate);
	n[5] = Texel(texture, textureCoordinate + vec2(  x, 0.0));
	n[6] = Texel(texture, textureCoordinate + vec2( -x, y));
	n[7] = Texel(texture, textureCoordinate + vec2(0.0, y));
	n[8] = Texel(texture, textureCoordinate + vec2(  x, y));
}

float getMinAlpha(Image texture, vec2 textureCoordinate)
{
	float minAlpha = 1.0;

	for (float x = -1.0; x <= 1; x += 1.0)
	{
		for (float y = -1.0; y <= 1; y += 1.0)
		{
			float alpha = Texel(texture, textureCoordinate + vec2(x, y) * scape_TexelSize).r;
			minAlpha = min(alpha, minAlpha);
		}
	}

	return minAlpha;
}

vec4 effect(vec4 color, Image texture, vec2 textureCoordinate, vec2 screenCoordinates)
{
	float alpha = getMinAlpha(scape_AlphaMaskTexture, textureCoordinate);
	if (alpha <= 0.0 || alpha >= 1.0)
	{
		discard;
	}

	alpha = Texel(scape_AlphaMaskTexture, textureCoordinate).r;

	vec4 n[9];
	makeKernel(n, texture, textureCoordinate);

	vec4 horizontalEdge = n[2] + (2.0 * n[5]) + n[8] - (n[0] + (2.0 * n[3]) + n[6]);
  	vec4 verticalEdge = n[0] + (2.0 * n[1]) + n[2] - (n[6] + (2.0 * n[7]) + n[8]);
	vec4 sobel = sqrt((horizontalEdge * horizontalEdge) + (verticalEdge * verticalEdge));
	float outline = 1.0 - step(1.0, sobel.r);

	if (outline >= 1.0)
	{
		alpha = 1.0;
	}
    
    return vec4(vec3(outline), alpha);
	//return vec4(sobel.rgb, 1.0);
}