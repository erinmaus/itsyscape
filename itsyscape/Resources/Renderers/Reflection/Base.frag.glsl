#include "Resources/Shaders/RendererPass.common.glsl"

#define SCAPE_ALPHA_DISCARD_THRESHOLD 0.1
#define SCAPE_REFLECTION_PASS 1

uniform float scape_ReflectionThreshold;
uniform vec3 scape_ReflectionProperties;
uniform vec4 scape_OutlineColor;

varying vec3 frag_Position;
varying vec3 frag_Normal;
varying vec2 frag_Texture;
varying vec4 frag_Color;


#ifdef SCAPE_LIGHT_MODEL_V2
void performAdvancedEffect(vec2 textureCoordinate, inout vec4 color, inout vec3 position, inout vec3 normal, out float specular);
#else
vec4 performEffect(vec4 color, vec2 textureCoordinate);
#endif

#ifdef SCAPE_REFLECTION_PASS_CUSTOM_REFLECTION_PROPERTIES
void getReflectionProperties(vec2 textureCoordinate, inout float reflectionPower, inout float reflectionDistance, inout float roughness);
#endif

void effect()
{
#ifdef SCAPE_LIGHT_MODEL_V2
	vec4 diffuse = frag_Color;
	vec3 normal = frag_Normal;
	vec3 position = frag_Position;
	float specular = 0.0;
	performAdvancedEffect(frag_Texture, diffuse, position, normal, specular);
#else
	vec3 normal = frag_Normal;
	float specular = 0.0;
	vec3 position = frag_Position;
	vec4 diffuse = performEffect(frag_Color, frag_Texture);
#endif

	if (diffuse.a < SCAPE_ALPHA_DISCARD_THRESHOLD)
	{
		discard;
	}

    vec3 reflectionProperties = scape_ReflectionProperties;

#ifdef SCAPE_REFLECTION_PASS_CUSTOM_REFLECTION_PROPERTIES
	getReflectionProperties(frag_Texture, reflectionProperties.x, reflectionProperties.y, reflectionProperties.z);
#endif

	love_Canvases[0] = vec4(reflectionProperties.xyz, scape_ReflectionThreshold);
	love_Canvases[1] = vec4(frag_Position, 1.0);
	love_Canvases[2] = vec4(frag_Normal, 1.0);
}
