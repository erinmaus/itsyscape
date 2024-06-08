uniform Image scape_DiffuseTexture;

uniform vec3 scape_CameraEye;
uniform vec3 scape_CameraTarget;

uniform float scape_ClipAlphaMultiplier;

vec4 getPlane(vec3 direction, vec3 point)
{
	vec3 normal = normalize(direction);
	float d = -dot(point, normal);

	return vec4(normal, d);
}

vec4 performEffect(vec4 color, vec2 textureCoordinate)
{
	vec3 eyeToTargetDirection = scape_CameraEye - scape_CameraTarget;
	vec3 leftDirection = normalize(cross(eyeToTargetDirection, vec3(0.0, 1.0, 0.0)));
	vec4 eyeToTargetPlane = getPlane(eyeToTargetDirection, scape_CameraTarget);
	vec4 leftPlane = getPlane(leftDirection, scape_CameraTarget - leftDirection * vec3(5.0));
	vec4 rightPlane = getPlane(-leftDirection, scape_CameraTarget + leftDirection * vec3(5.0));

	float d1 = -dot(eyeToTargetPlane, vec4(frag_Position, 1.0));
	float d2 = -dot(leftPlane, vec4(frag_Position, 1.0));
	float d3 = -dot(rightPlane, vec4(frag_Position, 1.0));

	float alpha = 1.0;

	if (d1 <= 0.0 && d2 <= 0.0 && d3 <= 0.0)
	{
		float maxD = abs(max(d2, d3));
		alpha = 1.0 - smoothstep(0.0, 1.0, maxD);
		alpha *= scape_ClipAlphaMultiplier;
	}

	textureCoordinate.t = 1.0 - textureCoordinate.t;
	return Texel(scape_DiffuseTexture, textureCoordinate) * color * vec4(vec3(1.0), alpha);
}
