uniform vec2 scape_TextureSize;
uniform vec2 scape_JumpDistance;
uniform float scape_MaxDistance;

void jump(Image texture, vec2 current, vec2 offset, inout vec4 min)
{
	vec2 position = current + scape_JumpDistance * offset;
	//position = clamp(position, vec2(0.0), vec2(1.0));
	// if (length(clamp(position, vec2(0.0), vec2(1.0)) - position) > 0)
	// {
	// 	return;
	// }

	vec4 sample = Texel(texture, position);
	if (sample.z == 0.0)
	{
		return;
	}

	vec2 seed = sample.rg;
	//vec2 currentScaled = floor(current * scape_TextureSize);
	//vec2 seedScaled = floor(seed * scape_TextureSize);
	float distance = length(current - seed);
	if (distance < min.w)
	{
		min = vec4(seed, 1.0, distance);
	}
}

vec4 effect(vec4 color, Image texture, vec2 textureCoordinate, vec2 screenCoordinates)
{
	vec4 current = vec4(vec2(0.0), 0.0, scape_MaxDistance);

	for (float x = -1.0; x <= 1.0; x += 1.0)
	{
		for (float y = -1.0; y <= 1.0; y += 1.0)
		{
			jump(texture, textureCoordinate, vec2(x, y), current);
		}
	}

	if (current.w == scape_MaxDistance)
	{
		discard;
	}

	//return vec4(current.rg, 0.0, Texel(texture, textureCoordinate).a);
	return vec4(current.rg, 1.0, 1.0);
}
