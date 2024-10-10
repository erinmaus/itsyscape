uniform float scape_Time;

uniform mat4 scape_WorldMatrix;
uniform mat4 scape_NormalMatrix;

uniform mat4 scape_ViewMatrix;
uniform mat4 scape_InverseViewMatrix;

uniform mat4 scape_ProjectionMatrix;

uniform vec4 scape_ClipPlane;

uniform vec3 scape_CameraEye;
uniform vec3 scape_CameraTarget;

mat4 getWorldViewProjection()
{
    return scape_ProjectionMatrix * scape_ViewMatrix * scape_WorldMatrix;
}
