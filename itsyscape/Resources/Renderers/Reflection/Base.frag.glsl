#include "Resources/Shaders/RendererPass.common.glsl"

#define SCAPE_ALPHA_DISCARD_THRESHOLD 0.1
#define SCAPE_REFLECTION_PASS 1

uniform vec3 scape_ReflectionProperties;
uniform vec4 scape_OutlineColor;

varying vec3 frag_Position;
varying vec3 frag_Normal;
varying vec2 frag_Texture;
varying vec4 frag_Color;

vec4 performEffect(vec4 color, vec2 textureCoordinate);

#ifdef SCAPE_REFLECTION_PASS_CUSTOM_REFLECTION_PROPERTIES
void getReflectionProperties(
	inout float reflectionPower,
	inout float ratioIndexOfRefrction,
	inout float roughness);
#endif

void effect()
{
	vec4 diffuse = performEffect(frag_Color, frag_Texture);

	if (diffuse.a < SCAPE_ALPHA_DISCARD_THRESHOLD)
	{
		discard;
	}

    vec3 reflectionProperties = scape_ReflectionProperties;

#ifdef SCAPE_REFLECTION_PASS_CUSTOM_REFLECTION_PROPERTIES
	getReflectionProperties(reflectionProperties.x, reflectionProperties.y, reflectionProperties.z);
#endif

	love_Canvases[0] = vec4(reflectionProperties.xyz, diffuse.a);
}
