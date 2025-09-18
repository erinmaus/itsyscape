#line 1000

#ifndef SCAPE_DEPTH_DO_NOT_DEFINE_CAMERA_UNIFORMS
uniform float scape_Near;
uniform float scape_Far;
#endif

float linearDepth(float depthSample, float near, float far)
{
	depthSample = 2.0 * depthSample - 1.0;
	float zLinear = 2.0 * near * far / (far + near - depthSample * (far - near));
	return zLinear;
}

float linearDepth(float depthSample)
{
	return linearDepth(depthSample, scape_Near, scape_Far);
}

float restoreDepth(float zLinear, float near, float far)
{
	float zOverW = ((far + near) - ((2.0 * near * far) / zLinear)) / (far - near);
	float z = (zOverW + 1.0) / 2.0;

	return z;
}

float restoreDepth(float zLinear)
{
	return restoreDepth(zLinear, scape_Near, scape_Far);
}
