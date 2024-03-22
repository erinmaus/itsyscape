uniform float scape_MaxDistance;
uniform float scape_DiscardDistance;
uniform sampler2D scape_OutlineTexture;
uniform sampler2D scape_DiffuseTexture;

vec4 effect(vec4 color, Image texture, vec2 textureCoordinate, vec2 screenCoordinates)
{
	vec4 sample = Texel(texture, textureCoordinate);
	// if (sample.b == scape_DiscardDistance)
	// {
	// 	discard;
	// }

	if (sample.b == 1.0)
	{
		return vec4(0.0, 1.0, 0.0, 1.0);
	}
	else if (sample.b == 0.0)
	{
		return vec4(1.0, 0.0, 0.0, 1.0);
	}
	else
	{
		return vec4(0.0, 0.0, 0.0, 1.0);
	}

	vec4 diffuse = vec4(0.0);
	if (sample.b > scape_MaxDistance)
	{
		diffuse = Texel(scape_DiffuseTexture, sample.rg);
	}
	else
	{
		diffuse = Texel(scape_OutlineTexture, textureCoordinate);
	}

	return diffuse;
}
