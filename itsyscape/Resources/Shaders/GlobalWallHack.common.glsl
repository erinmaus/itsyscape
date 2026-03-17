// x, y == left, right, z, w == top, bottom
uniform vec4 scape_GlobalWallHackWindow;

vec4 getGlobalWallHackPlane(vec3 normal, vec3 point)
{
	float d = -dot(point, normal);
	return vec4(normal, d);
}

float getGlobalWallHackAlpha(vec3 position, float globalAlpha)
{
	if (dot(scape_GlobalWallHackWindow, scape_GlobalWallHackWindow) < EPSILON)
	{
		return 1.0;
	}

	vec3 eyeToTargetDirection = normalize(scape_InverseViewMatrix[2].xyz);
	vec3 leftDirection = normalize(scape_InverseViewMatrix[0].xyz);
	vec3 topDirection = normalize(scape_InverseViewMatrix[1].xyz);

	vec4 farPlane = getGlobalWallHackPlane(eyeToTargetDirection, scape_CameraTarget);
	vec4 leftPlane = getGlobalWallHackPlane(leftDirection, scape_CameraTarget - leftDirection * vec3(scape_GlobalWallHackWindow.x));
	vec4 rightPlane = getGlobalWallHackPlane(-leftDirection, scape_CameraTarget + leftDirection * vec3(scape_GlobalWallHackWindow.y));
	vec4 topPlane = getGlobalWallHackPlane(topDirection, scape_CameraTarget - topDirection * vec3(scape_GlobalWallHackWindow.z));
	vec4 bottomPlane = getGlobalWallHackPlane(-topDirection, scape_CameraTarget + topDirection * vec3(scape_GlobalWallHackWindow.w));

	vec4 p = vec4(position, 1.0);
	float d1 = -dot(farPlane, p);
	float d2 = -dot(leftPlane, p);
	float d3 = -dot(rightPlane, p);
	float d4 = -dot(topPlane, p);
	float d5 = -dot(bottomPlane, p);

	float alpha = 1.0 - globalAlpha;
	if (d1 <= 0.0 && d2 <= 0.0 && d3 <= 0.0 && d4 <= 0.0 && d5 <= 0.0)
	{
		float maxD = abs(max(d2, max(d3, max(d4, d5))));
		alpha = 1.0 - min(maxD, 0.5) / 0.5;
		alpha *= alpha;
	}

	return alpha;
}
