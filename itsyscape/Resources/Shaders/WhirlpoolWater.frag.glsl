#line 1

uniform highp float scape_Time;
uniform highp vec4 scape_TimeScale;
uniform Image scape_DiffuseTexture;

// Whirlpool center in world coordinates.
uniform highp vec2 scape_WhirlpoolCenter;

// Radius of the whirlpool in world coordinates.
uniform highp float scape_WhirlpoolRadius;

// How many rings there are. This should be > 0.
uniform highp float scape_WhirlpoolRings;

// Direction and speed of rotation.
uniform highp float scape_WhirlpoolRotationSpeed;

// Other speed value for hole (how fast stuff falls into hole).
uniform highp float scape_WhirlpoolHoleSpeed;

// Hole radius.
uniform highp float scape_WhirlpoolHoleRadius;

// Hole color.
uniform highp vec4 scape_WhirlpoolHoleColor;

// Foam color.
uniform highp vec4 scape_WhirlpoolFoamColor;

const float PI = 3.1415926535;

vec2 rotate(float theta , vec2 p)
{
	float sinTheta = sin(theta);
	float cosTheta = cos(theta);
	mat2 rotationMatrix = mat2(cosTheta, -sinTheta, sinTheta, cosTheta);
	return p * rotationMatrix;
}

vec4 performEffect(vec4 color, vec2 textureCoordinate)
{
	textureCoordinate += sin(scape_Time * scape_TimeScale.y) * scape_TimeScale.x;

	vec2 relativeWorldPosition = frag_Position.xz - scape_WhirlpoolCenter;
	vec2 whirlpoolCartesianCoordinate = relativeWorldPosition;
	whirlpoolCartesianCoordinate = rotate(scape_WhirlpoolRotationSpeed * scape_Time, whirlpoolCartesianCoordinate);

	float whirlpoolCoordinateAngle = atan(whirlpoolCartesianCoordinate.y, whirlpoolCartesianCoordinate.x) / 2.0;
	float whirlpoolCoordinateDistance = length(whirlpoolCartesianCoordinate) / max(scape_WhirlpoolRings, 1.0);
	vec2 whirlpoolTextureCoordinate = vec2(
		(scape_Time * scape_WhirlpoolHoleSpeed) - (1.0 / whirlpoolCoordinateDistance),
		whirlpoolCoordinateAngle / PI);

	vec4 waterSample = Texel(scape_DiffuseTexture, textureCoordinate);

	float distanceFromCenter = length(relativeWorldPosition);
	float foam = smoothstep(scape_WhirlpoolRadius - 4.0, scape_WhirlpoolRadius, distanceFromCenter);
	float shadow = 1.0 - smoothstep(0.0, scape_WhirlpoolHoleRadius, distanceFromCenter);
	vec4 whirlpoolSample = Texel(scape_DiffuseTexture, whirlpoolTextureCoordinate);
	whirlpoolSample.rgb = (1.0 - shadow) * whirlpoolSample.rgb + shadow * scape_WhirlpoolHoleColor.rgb;
	whirlpoolSample.rgb = (1.0 - foam) * whirlpoolSample.rgb + foam * scape_WhirlpoolFoamColor.rgb;

	float alpha = smoothstep(scape_WhirlpoolRadius - 2.0, scape_WhirlpoolRadius, distanceFromCenter);
	vec4 compositedSample = mix(whirlpoolSample, waterSample, alpha);

	return compositedSample * color;
}