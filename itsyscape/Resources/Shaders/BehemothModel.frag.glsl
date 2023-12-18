#line 1

uniform ArrayImage scape_DiffuseTexture;
uniform Image scape_BlendTexture;
uniform float scape_NumLayers;

struct TriPlanarTextureCoordinates
{
	vec2 x, y, z;
};

varying vec3 frag_ModelPosition;

TriPlanarTextureCoordinates triplanarMap()
{
	TriPlanarTextureCoordinates result;

	result.x = frag_ModelPosition.zy;
	result.y = frag_ModelPosition.xz;
	result.z = frag_ModelPosition.xy;

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

vec4 sampleDiffuse(vec3 weight, TriPlanarTextureCoordinates triPlanarTextureCoordinates, float layer)
{
	vec4 x = Texel(scape_DiffuseTexture, vec3(triPlanarTextureCoordinates.x * vec2(1 / 5.0), layer)) * weight.x;
	vec4 y = Texel(scape_DiffuseTexture, vec3(triPlanarTextureCoordinates.y * vec2(1 / 5.0), layer)) * weight.y;
	vec4 z = Texel(scape_DiffuseTexture, vec3(triPlanarTextureCoordinates.z * vec2(1 / 5.0), layer)) * weight.z;

	return x + y + z;
}

vec4 performEffect(vec4 color, vec2 textureCoordinate)
{
	textureCoordinate.t = 1.0 - textureCoordinate.t;

	float blend = smoothstep(0.4, 0.5, 1 - Texel(scape_BlendTexture, textureCoordinate).r);

	float textureLayer = blend * scape_NumLayers;
	float textureDelta = textureLayer - floor(textureLayer);

	TriPlanarTextureCoordinates triPlanarTextureCoordinates = triplanarMap();
	vec3 weight = triplanarWeights();

	vec4 textureFrom = sampleDiffuse(weight, triPlanarTextureCoordinates, max(floor(textureLayer) - 1, 0));
	vec4 textureTo = sampleDiffuse(weight, triPlanarTextureCoordinates, min(ceil(textureLayer), scape_NumLayers));

	return mix(textureFrom, textureTo, textureDelta) * color;
}
