uniform highp float scape_Time;

const float TWO_PI = 6.28;
const float SPIKES = 2;
const float RADIUS = 0.2;
const float HALF_RADIUS = 0.1;

vec4 performEffect(vec4 color, vec2 textureCoordinate)
{
	float textureY = clamp(textureCoordinate.y, HALF_RADIUS, 1 - HALF_RADIUS);
	float timeOffset = scape_Time * TWO_PI;
	float xOffset = textureCoordinate.x * TWO_PI * SPIKES;

	// Offset sine to be between [0, 1] rather than [-1, 1]
	float centerY = (sin(timeOffset + xOffset) + 1) / 2;

	// Scale center to fit between [RADIUS, 1 - 2RADIUS]
	// so it the line doesn't get cut off by the edges
	centerY *= 1 - RADIUS * 2;
	centerY += RADIUS;

	float difference = distance(centerY, textureCoordinate.y);
	float absoluteDifference = abs(difference);

	if (absoluteDifference > RADIUS)
	{
		discard;
	}

	// Apply an alpha effect as the line moves from 'center' of wave
	float alpha = 1 - absoluteDifference / RADIUS;

	return vec4(color.rgb, alpha);
}
