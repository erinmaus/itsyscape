#define MAX_JUMP_DISTANCE 64

uniform vec2 scape_TextureSize;
uniform vec2 scape_JumpDistance;
uniform float scape_MaxDistance;

void jump(Image image, vec2 textureCoordinate, vec2 offset, inout vec3 current)
{
	vec2 position = textureCoordinate + scape_JumpDistance * offset;
	position = clamp(position, vec2(0.0), vec2(1.0));

	vec4 jumpSample = Texel(image, position);
	if (jumpSample.z == 1.0)
	{
		return;
	}

	vec2 seed = jumpSample.xy;
	vec2 absoluteSeed = floor(mix(vec2(-MAX_JUMP_DISTANCE), vec2(MAX_JUMP_DISTANCE), seed) + position * scape_TextureSize);
	vec2 currentPosition = floor(textureCoordinate * scape_TextureSize);
	float d = distance(currentPosition, absoluteSeed) / MAX_JUMP_DISTANCE;
	if (d < current.z)
	{
		//vec2 difference = jump
		vec2 offset = absoluteSeed - currentPosition;
		offset /= vec2(MAX_JUMP_DISTANCE);
		offset += vec2(1.0);
		offset /= vec2(2.0);

		current = vec3(offset, d);
	}
}

vec4 effect(vec4 color, Image image, vec2 textureCoordinate, vec2 screenCoordinates)
{
	vec3 current = vec3(vec2(0.0), 1.0);

	for (float x = -1.0; x <= 1.0; x += 1.0)
	{
		for (float y = -1.0; y <= 1.0; y += 1.0)
		{
			jump(image, textureCoordinate, vec2(x, y), current);
		}
	}

	if (current.z == 1.0)
	{
		return Texel(image, textureCoordinate);
	}

	return vec4(current.xy, current.z, 1.0);
}
