#ifndef SCAPE_DEPTH_DO_NOT_DEFINE_CAMERA_UNIFORMS
uniform float scape_Near;
uniform float scape_Far;
#endif

float linearDepth(float depthSample)
{
	depthSample = 2.0 * depthSample - 1.0;
	float zLinear = 2.0 * scape_Near * scape_Far / (scape_Far + scape_Near - depthSample * (scape_Far - scape_Near));
	return zLinear;
}

float restoreDepth(float zLinear)
{
	float zOverW = ((scape_Far + scape_Near) - ((2.0 * scape_Near * scape_Far) / zLinear)) / (scape_Far - scape_Near);
	float z = (zOverW + 1.0) / 2.0;

	return z;
}