#include "Resources/Shaders/Math.common.glsl"

uniform Image scape_DiffuseTexture;
uniform Image scape_SchismTexture;

uniform float scape_SchismRotationSpeed;
uniform float scape_SchismHoleSpeed;
uniform float scape_SchismRings;

uniform float scape_AlphaCutoffSpeed;
uniform vec2 scape_AlphaCutoffRange;

vec2 rotate(float theta, vec2 p)
{
	float sinTheta = sin(theta);
	float cosTheta = cos(theta);
	mat2 rotationMatrix = mat2(cosTheta, -sinTheta, sinTheta, cosTheta);
	return p * rotationMatrix;
}

vec2 performAlphaEffect(vec2 textureCoordinate)
{
	textureCoordinate.s += mix(-(1.0 / 16.0), (1.0 / 16.0), sin(scape_Time * SCAPE_PI * 2.0) * cos(textureCoordinate.t * SCAPE_PI * 2.0));
    textureCoordinate.s = mod(textureCoordinate.s, 1.0);
    textureCoordinate.t = mod(textureCoordinate.t, 1.0);

    return textureCoordinate;
}

void performSchismEffect(Image image, vec2 textureCoordinate, inout vec4 color)
{
	vec2 schismCartesianCoordinate = textureCoordinate - vec2(0.5, 0.5);
	schismCartesianCoordinate = rotate(scape_SchismRotationSpeed * scape_Time, schismCartesianCoordinate);

	float schismCoordinateAngle = atan(schismCartesianCoordinate.y, schismCartesianCoordinate.x) / 2.0;
	float schismCoordinateDistance = length(schismCartesianCoordinate) / scape_SchismRings;
	vec2 schismPolarTextureCoordinate = vec2(
		(scape_Time * scape_SchismHoleSpeed) - (1.0 / schismCoordinateDistance),
		schismCoordinateAngle / SCAPE_PI);

	vec4 schismSaple = Texel(image, schismPolarTextureCoordinate);
	color *= schismSaple;
}

vec4 performEffect(vec4 color, vec2 textureCoordinate)
{
	performSchismEffect(scape_DiffuseTexture, performAlphaEffect(textureCoordinate), color);
	color.a = mix(scape_AlphaCutoffRange.x, scape_AlphaCutoffRange.y, color.a);

	performSchismEffect(scape_SchismTexture, textureCoordinate, color);
	color.a = mix(scape_AlphaCutoffRange.x, scape_AlphaCutoffRange.y, color.a);

	return color;
}
