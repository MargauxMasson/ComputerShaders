#version 330 compatibility
in vec2 vST;
in vec3 vMC;
in vec3 vNf;
in vec3 vLf;
in vec3 vEf;

uniform float uKa=0.4, uKd=0.6, uKs=0.3;
uniform vec4 uColor;
uniform vec4 uSpecularColor;
uniform float uShininess=10;

void
main ()
{
	vec3 Normal, Light, Eye;

	//////////////////////// Lighting  ////////////////////////////////
	Normal = normalize(vNf);
	Light = normalize(vLf);
	Eye = normalize(vEf);

	vec4 ambient = uKa * uColor;
	float d = max( dot(Normal,Light), 0. );
	vec4 diffuse = uKd * d * uColor;
	float s = 0.;

	if( dot(Normal,Light) > 0. ) // only do specular if the light can see the point
	{
			vec3 ref = normalize( 2. * Normal * dot(Normal,Light) - Light );
			s = pow( max( dot(Eye,ref),0. ), uShininess );
	}
	vec4 specular = uKs * s * uSpecularColor;
	gl_FragColor = vec4( ambient.rgb + diffuse.rgb + specular.rgb, 1. );
}

