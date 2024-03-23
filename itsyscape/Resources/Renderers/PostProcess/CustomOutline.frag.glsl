uniform vec2 scape_TexelSize;
uniform float scape_OutlineThickness;

vec4 effect(vec4 color, Image texture, vec2 textureCoordinate, vec2 screenCoordinates)
{
	float halfOutlineThickness = scape_OutlineThickness / 2.0;

	float numSamples = 0.0;
	for (float x = -halfOutlineThickness; x <= halfOutlineThickness; x += 1.0)
	{
		for (float y = -halfOutlineThickness; y <= halfOutlineThickness; y += 1.0)
		{
			vec2 localTextureCoordinate = textureCoordinate + vec2(x, y) * scape_TexelSize;
			float localSample = Texel(texture, localTextureCoordinate).r;

			if (localSample < 1.0)
			{
				numSamples += 1.0;
			}
		}
	}

	if (numSamples > scape_OutlineThickness * scape_OutlineThickness || numSamples < 1.0)
	{
		if (numSamples > scape_OutlineThickness * scape_OutlineThickness)
		{
			discard;
			//return vec4(1.0, 0.0, 0.0, Texel(texture, textureCoordinate).a);
		}
		else
		{
			discard;
			return vec4(1.0, 1.0, 0.0, Texel(texture, textureCoordinate).a);
		}
	}

	return vec4(color.rgb, Texel(texture, textureCoordinate).a);
}
