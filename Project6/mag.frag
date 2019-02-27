#version 330 compatibility
in vec2 vST;
float ResS, ResT;

uniform float uScenter;
uniform float uTcenter;
uniform float uDs;
uniform float uDt;
uniform float uMagFactor;
uniform float uRotAngle;
uniform float uSharpFactor;
uniform bool uCircle;
uniform float uRadius;
uniform sampler2D uImageUnit;

void
main ()
{
	vec3 rgb = texture2D(uImageUnit, vST).rgb;	//color

	gl_FragColor = vec4(rgb, 1.);
	

}