// From https://github.com/tobspr/GLSL-Color-Spaces

const float HCV_EPSILON = 1e-10;
const float HSL_EPSILON = 1e-10;

vec3 rgb_to_hcv(vec3 rgb)
{
    // Based on work by Sam Hocevar and Emil Persson
    vec4 P = (rgb.g < rgb.b) ? vec4(rgb.bg, -1.0, 2.0/3.0) : vec4(rgb.gb, 0.0, -1.0/3.0);
    vec4 Q = (rgb.r < P.x) ? vec4(P.xyw, rgb.r) : vec4(rgb.r, P.yzx);
    float C = Q.x - min(Q.w, Q.y);
    float H = abs((Q.w - Q.y) / (6.0 * C + HCV_EPSILON) + Q.z);
    return vec3(H, C, Q.x);
}

vec3 hue_to_rgb(float hue)
{
    float R = abs(hue * 6.0 - 3.0) - 1.0;
    float G = 2.0 - abs(hue * 6.0 - 2.0);
    float B = 2.0 - abs(hue * 6.0 - 4.0);
    return clamp(vec3(R,G,B), vec3(0.0), vec3(1.0));
}

// Converts from linear rgb to HSL
vec3 rgb_to_hsl(vec3 rgb)
{
    vec3 HCV = rgb_to_hcv(rgb);
    float L = HCV.z - HCV.y * 0.5;
    float S = HCV.y / (1.0 - abs(L * 2.0 - 1.0) + HSL_EPSILON);
    return vec3(HCV.x, S, L);
}

vec3 hsl_to_rgb(vec3 hsl)
{
    vec3 rgb = hue_to_rgb(hsl.x);
    float C = (1.0 - abs(2.0 * hsl.z - 1.0)) * hsl.y;
    return (rgb - 0.5) * C + hsl.z;
}

uniform Image scape_ScreenTexture;
uniform Image scape_DiffuseTexture;

varying highp vec2 frag_ScreenCoord;

const float TARGET_HUE = 30.0 / 360.0;
const float TARGET_HUE_WIDTH = 30.0 / 360.0;

vec4 performEffect(vec4 color, vec2 textureCoordinate)
{
    vec3 hsl = rgb_to_hsl(Texel(scape_ScreenTexture, frag_ScreenCoord).rgb);
    float distanceFromTargetHue = clamp(abs(hsl.x - TARGET_HUE) / TARGET_HUE_WIDTH, 0.0, 1.0);
    hsl.y *= 1.0 - distanceFromTargetHue;
    return vec4(hsl_to_rgb(hsl.xyz) * color.rgb, color.a) * Texel(scape_DiffuseTexture, textureCoordinate);
}
