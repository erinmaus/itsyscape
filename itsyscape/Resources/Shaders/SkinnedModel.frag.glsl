uniform Image scape_DiffuseTexture;
uniform Image scape_SpecularTexture;

varying vec2 frag_Direction;

void performAdvancedEffect(vec2 textureCoordinate, inout vec4 color, inout vec3 position, inout vec3 normal, out float specular)
{
	if ((frag_Direction.x > 0.0 && frag_Direction.y > 0.0) ||
	    (frag_Direction.x < 0.0 && frag_Direction.y < 0.0))
	{
		discard;
	}

	textureCoordinate.t = 1.0 - textureCoordinate.t;
	color *= Texel(scape_DiffuseTexture, textureCoordinate);
	specular = Texel(scape_SpecularTexture, textureCoordinate).r;
}

vec4 performEffect(vec4 color, vec2 textureCoordinate)
{
	if ((frag_Direction.x > 0.0 && frag_Direction.y > 0.0) ||
	    (frag_Direction.x < 0.0 && frag_Direction.y < 0.0))
	{
		discard;
	}

	textureCoordinate.t = 1.0 - textureCoordinate.t;
	return Texel(scape_DiffuseTexture, textureCoordinate) * color;
}

#pragma option SCAPE_LIGHT_MODEL_V2