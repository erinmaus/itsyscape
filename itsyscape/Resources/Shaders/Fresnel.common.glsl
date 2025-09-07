float calculateFresnel(float amount, vec3 normal)
{
	vec3 view = -normalize(scape_CameraEye - scape_CameraTarget);

	return pow(
		1.0 - clamp(abs(dot(normalize(normal), normalize(view))), 0.0, 1.0),
		amount
	);
}
