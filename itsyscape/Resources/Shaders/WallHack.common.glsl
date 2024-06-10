#ifndef SCAPE_WALL_HACK_DO_NOT_DEFINE_CAMERA_UNIFORMS
uniform vec3 scape_CameraEye;
uniform vec3 scape_CameraTarget;
#endif

// Alpha enabled (1.0 = yes, 0.0 = no)
uniform float scape_WallHackAlpha;

// x, y == left, right, z, w == top, bottom
uniform vec4 scape_WallHackWindow;
uniform float scape_WallHackNear;

vec3 getWallHackClampedNormal(vec3 direction)
{
	return normalize(vec3(direction.x, 0.0, direction.z));
}

vec4 getWallHackPlane(vec3 normal, vec3 point)
{
	float d = -dot(point, normal);
	return vec4(normal, d);
}

float getWallHackAlpha(vec3 position)
{
	vec3 eyeToTargetDirection = getWallHackClampedNormal(scape_CameraEye - scape_CameraTarget);
	vec3 leftDirection = normalize(cross(eyeToTargetDirection, vec3(0.0, 1.0, 0.0)));
	vec4 farPlane = getWallHackPlane(eyeToTargetDirection, scape_CameraTarget);
	vec4 leftPlane = getWallHackPlane(leftDirection, scape_CameraTarget - leftDirection * vec3(scape_WallHackWindow.x));
	vec4 rightPlane = getWallHackPlane(-leftDirection, scape_CameraTarget + leftDirection * vec3(scape_WallHackWindow.y));
	vec4 topPlane = getWallHackPlane(vec3(0.0, -1.0, 0.0), scape_CameraTarget + vec3(0.0, scape_WallHackWindow.z, 0.0));
	vec4 bottomPlane = getWallHackPlane(vec3(0.0, 1.0, 0.0), scape_CameraTarget - vec3(0.0, scape_WallHackWindow.w, 0.0));
	vec4 nearPlane = getWallHackPlane(-eyeToTargetDirection, scape_CameraTarget + eyeToTargetDirection * vec3(scape_WallHackNear));

	vec4 p = vec4(position, 1.0);
	float d1 = -dot(farPlane, p);
	float d2 = -dot(leftPlane, p);
	float d3 = -dot(rightPlane, p);
	float d4 = -dot(topPlane, p);
	float d5 = -dot(bottomPlane, p);
	float d6 = 0.0;

	if (scape_WallHackNear > 0.0)
	{
		d6 = -dot(nearPlane, p);
	}

	float alpha = 1.0 - scape_WallHackAlpha;
	if (d1 <= 0.0 && d2 <= 0.0 && d3 <= 0.0 && d4 <= 0.0 && d5 <= 0.0 && d6 <= 0.0)
	//if (d6 <= 0.0)
	{
		float maxD = abs(max(d2, max(d3, max(d4, d5))));
		alpha = 1.0 - min(maxD, 0.5) / 0.5;
		alpha *= scape_WallHackAlpha;
	}

	return alpha;
}
