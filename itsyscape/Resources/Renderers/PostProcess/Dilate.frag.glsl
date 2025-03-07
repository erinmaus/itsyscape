uniform float scape_KernelRadius;
uniform vec2 scape_TexelSize;

vec4 effect(vec4 color, Image image, vec2 textureCoordinate, vec2 screenCoordinates)
{
	float radiusSquared = scape_KernelRadius * scape_KernelRadius;

	vec4 currentSample = vec4(0.0);
	for (float x = -scape_KernelRadius; x < scape_KernelRadius; x += 1.0)
	{
		for (float y = -scape_KernelRadius; y < scape_KernelRadius; y += 1.0)
		{
			vec2 offset = vec2(x, y);
			if (length(offset) <= scape_KernelRadius)
			{
				vec4 otherSample = Texel(image, textureCoordinate + offset * scape_TexelSize);
				if (otherSample.a > 0.0 && dot(otherSample, otherSample) > dot(currentSample, currentSample))
				{
					currentSample = otherSample;
				}
			}
		}
	}

	return currentSample;
}
