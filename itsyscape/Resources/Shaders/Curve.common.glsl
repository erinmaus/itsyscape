#define _interpolateQuadraticImpl(type) type a = mix(p1, p2, delta); type b = mix(p2, p3, delta); return mix(a, b, delta)

float interpolateQuadratic(float p1, float p2, float p3, float delta)
{
	_interpolateQuadraticImpl(float);
}

vec2 interpolateQuadratic(vec2 p1, vec2 p2, vec2 p3, vec2 delta)
{
	_interpolateQuadraticImpl(vec2);
}

vec3 interpolateQuadratic(vec3 p1, vec3 p2, vec3 p3, vec3 delta)
{
	_interpolateQuadraticImpl(vec3);
}

vec4 interpolateQuadratic(vec4 p1, vec4 p2, vec4 p3, vec4 delta)
{
	_interpolateQuadraticImpl(vec4);
}

#undef _interpolateQuadraticImpl

#define _interpolateCubicImpl(type) type a = mix(p1, p2, delta); type b = mix(p2, p3, delta); type c = mix(p3, p4, delta); type m = mix(a, b, delta); type n = mix(b, c, delta); return mix(m, n, delta)

float interpolateCubic(float p1, float p2, float p3, float p4, float delta)
{
	_interpolateCubicImpl(float);
}

vec2 interpolateCubic(vec2 p1, vec2 p2, vec2 p3, vec2 p4, vec2 delta)
{
	_interpolateCubicImpl(vec2);
}

vec3 interpolateCubic(vec3 p1, vec3 p2, vec3 p3, vec3 p4, vec3 delta)
{
	_interpolateCubicImpl(vec3);
}

vec4 interpolateCubic(vec4 p1, vec4 p2, vec4 p3, vec4 p4, vec4 delta)
{
	_interpolateCubicImpl(vec4);
}

#undef _interpolateCubicImpl
