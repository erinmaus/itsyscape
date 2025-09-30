#line 1

uniform ArrayImage scape_DiffuseTexture;

struct TriPlanarTextureCoordinates
{
	vec2 x, y, z;
};

varying vec3 frag_ModelPosition;
varying vec3 frag_ModelNormal;

TriPlanarTextureCoordinates triplanarMap()
{
	TriPlanarTextureCoordinates result;

	result.x = frag_ModelPosition.yz;
	result.y = frag_ModelPosition.xz;
	result.z = frag_ModelPosition.xy;

	if (frag_ModelNormal.x < 0.0)
	{
		result.x.x = -result.x.x;
	}

	if (frag_ModelNormal.y < 0.0)
	{
		result.y.x = -result.y.x;
	}

	if (frag_ModelNormal.z >= 0.0)
	{
		result.z.x = -result.z.x;
	}

	result.x.y += 0.5;
	result.z.x += 0.5;

	return result;
}

vec3 triplanarWeights()
{
	vec3 w = abs(frag_ModelNormal);
	return w / (w.x + w.y + w.z);
}

vec4 sampleDiffuse(vec3 weight, TriPlanarTextureCoordinates triPlanarTextureCoordinates, float layer)
{
	vec4 x = Texel(scape_DiffuseTexture, vec3(triPlanarTextureCoordinates.x * vec2(1.0 / 5.0), layer)) * weight.x;
	vec4 y = Texel(scape_DiffuseTexture, vec3(triPlanarTextureCoordinates.y * vec2(1.0 / 5.0), layer)) * weight.y;
	vec4 z = Texel(scape_DiffuseTexture, vec3(triPlanarTextureCoordinates.z * vec2(1.0 / 5.0), layer)) * weight.z;

	return x + y + z;
}

vec4 performEffect(vec4 color, vec2 textureCoordinate)
{
	textureCoordinate.t = 1.0 - textureCoordinate.t;

	TriPlanarTextureCoordinates triPlanarTextureCoordinates = triplanarMap();
	vec3 weight = triplanarWeights();

	vec4 diffuseSample = sampleDiffuse(weight, triPlanarTextureCoordinates, 0.0);
	return diffuseSample * color;
}
