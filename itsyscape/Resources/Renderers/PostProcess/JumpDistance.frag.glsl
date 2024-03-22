uniform vec2 scape_TextureSize;
uniform vec2 scape_JumpDistance;
uniform float scape_MaxDistance;

void jump(Image texture, vec2 current, vec2 offset, inout vec3 min)
{
	vec2 position = current + scape_JumpDistance * offset;
	if (length(clamp(position, vec2(0.0), vec2(1.0)) - position) > 0)
	{
		return;
	}

	vec2 seed = Texel(texture, position).rg;
	vec2 currentScaled = floor(current * scape_TextureSize);
	vec2 seedScaled = floor(seed * scape_TextureSize);
	float distance = length(currentScaled - seedScaled);
	if (distance < min.z)
	{
		min = vec3(seed, distance);
	}
}

vec4 effect(vec4 color, Image texture, vec2 textureCoordinate, vec2 screenCoordinates)
{
	vec3 current = vec3(vec2(0.0), scape_MaxDistance);

	for (float x = -1.0; x <= 1.0; x += 1.0)
	{
		for (float y = -1.0; y <= 1.0; y += 1.0)
		{
			jump(texture, textureCoordinate, vec2(x, y), current);
		}
	}

	return vec4(current.rg, 0.0, Texel(texture, textureCoordinate).a);
}
