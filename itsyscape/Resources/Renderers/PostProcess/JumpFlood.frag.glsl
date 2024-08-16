uniform vec2 scape_TextureSize;
uniform vec2 scape_JumpDistance;
uniform float scape_MaxDistance;

void jump(Image image, vec2 textureCoordinate, vec2 offset, inout vec3 current)
{
	vec2 position = textureCoordinate + scape_JumpDistance * offset;
	position = clamp(position, vec2(0.0), vec2(1.0));

	vec4 jumpSample = Texel(image, position);
	if (jumpSample.z < 0.0)
	{
		return;
	}

	vec2 seed = jumpSample.xy;
	float d = distance(floor(textureCoordinate * scape_TextureSize), seed);
	if (d < current.z)
	{
		current = vec3(seed, d);
	}
}

vec4 effect(vec4 color, Image image, vec2 textureCoordinate, vec2 screenCoordinates)
{
	vec3 current = vec3(vec2(0.0), scape_MaxDistance);

	for (float x = -1.0; x <= 1.0; x += 1.0)
	{
		for (float y = -1.0; y <= 1.0; y += 1.0)
		{
			jump(image, textureCoordinate, vec2(x, y), current);
		}
	}

	if (current.z == scape_MaxDistance)
	{
		discard;
	}

	return vec4(current.xy, current.z, 1.0);
}
