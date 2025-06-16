struct TriplanarTextureCoordinates
{
	vec2 x, y, z;
};

TriplanarTextureCoordinates triplanarMap(vec3 modelPosition, vec3 modelNormal)
{
	TriplanarTextureCoordinates result;

	result.x = -modelPosition.zy;
	result.y = modelPosition.xz;
	result.z = -modelPosition.xy;

	if (modelNormal.x < 0.0)
	{
		result.x.x = -result.x.x;
	}

	if (modelNormal.y < 0.0)
	{
		result.y.x = -result.y.x;
	}

	if (modelNormal.z > 0.0)
	{
		result.z.x = -result.z.x;
	}

	result.x.x += 0.5;
	result.z.x += 0.5;

	return result;
}

vec3 triplanarWeights(vec3 modelNormal, float offset, float exponent)
{
	vec3 w = pow(clamp(abs(modelNormal) - vec3(offset), vec3(0.0), vec3(1.0)), vec3(exponent));
	return w / (w.x + w.y + w.z);
}

vec4 sampleTriplanar(Image image, TriplanarTextureCoordinates triPlanarTextureCoordinates, vec3 weight, float scale)
{
	vec4 x = Texel(image, triPlanarTextureCoordinates.x * vec2(scale)) * weight.x;
	vec4 y = Texel(image, triPlanarTextureCoordinates.y * vec2(scale)) * weight.y;
	vec4 z = Texel(image, triPlanarTextureCoordinates.z * vec2(scale)) * weight.z;

	return x + y + z;
}

vec4 sampleTriplanarArray(ArrayImage image, TriplanarTextureCoordinates triPlanarTextureCoordinates, vec3 weight, float scale, float layer)
{
	vec4 x = Texel(image, vec3(triPlanarTextureCoordinates.x * vec2(scale), layer)) * weight.x;
	vec4 y = Texel(image, vec3(triPlanarTextureCoordinates.y * vec2(scale), layer)) * weight.y;
	vec4 z = Texel(image, vec3(triPlanarTextureCoordinates.z * vec2(scale), layer)) * weight.z;

	return x + y + z;
}
