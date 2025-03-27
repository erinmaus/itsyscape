vec4 dilateMin(float radius, Image image, vec2 textureCoordinate, vec2 texelSize, vec4 defaultSample)
{
	float radiusSquared = radius * radius;

	vec4 currentSample = defaultSample;
	for (float x = -radius; x < radius; x += 1.0)
	{
		for (float y = -radius; y < radius; y += 1.0)
		{
			vec2 offset = vec2(x, y);
			if (dot(offset, offset) <= radiusSquared)
			{
				vec4 otherSample = Texel(image, textureCoordinate + offset * texelSize);
				if (dot(otherSample, otherSample) < dot(currentSample, currentSample))
				{
					currentSample = otherSample;
				}
			}
		}
	}

	return currentSample;
}

vec4 dilateMax(float radius, Image image, vec2 textureCoordinate, vec2 texelSize, vec4 defaultSample)
{
	float radiusSquared = radius * radius;

	vec4 currentSample = defaultSample;
	for (float x = -radius; x < radius; x += 1.0)
	{
		for (float y = -radius; y < radius; y += 1.0)
		{
			vec2 offset = vec2(x, y);
			if (dot(offset, offset) <= radiusSquared)
			{
				vec4 otherSample = Texel(image, textureCoordinate + offset * texelSize);
				if (dot(otherSample, otherSample) > dot(currentSample, currentSample))
				{
					currentSample = otherSample;
				}
			}
		}
	}

	return currentSample;
}