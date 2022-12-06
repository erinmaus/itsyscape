uniform Image scape_DiffuseTexture;
uniform float scape_Scale;

struct TriPlanarTextureCoordinates
{
	vec2 x, y, z;
};

TriPlanarTextureCoordinates triplanarMap()
{
	TriPlanarTextureCoordinates result;

	result.x = frag_Position.zy * scape_Scale;
	result.y = frag_Position.xz * scape_Scale;
	result.z = frag_Position.xy * scape_Scale;

	if (frag_Normal.x < 0)
	{
		result.x.x = -result.x.x;
	}

	if (frag_Normal.y < 0)
	{
		result.y.x = -result.y.x;
	}

	if (frag_Normal.z < 0)
	{
		result.z.x = -result.z.x;
	}

	return result;
}

vec3 triplanarWeights()
{
	vec3 w = abs(frag_Normal);
	return w / (w.x + w.y + w.z);
}

vec4 performEffect(vec4 color, vec2 textureCoordinate)
{
	TriPlanarTextureCoordinates triPlanarTextureCoordinates = triplanarMap();
	vec3 weight = triplanarWeights();

	vec4 x = Texel(scape_DiffuseTexture, triPlanarTextureCoordinates.x) * weight.x;
	vec4 y = Texel(scape_DiffuseTexture, triPlanarTextureCoordinates.y) * weight.y;
	vec4 z = Texel(scape_DiffuseTexture, triPlanarTextureCoordinates.z) * weight.z;

	return (x + y + z) * color;
}
