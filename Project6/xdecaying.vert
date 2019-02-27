#version 330 compatibility
out vec2 vST;
out vec3 vMC;
out vec3 vNf;
out vec3 vLf;
out vec3 vEf;

uniform float uA=0.2;
uniform float uB=3.0;
uniform float uC=0.0;
uniform float uD=0.0;
uniform float uE=0.0;
uniform float uLightX=5.0;
uniform float uLightY=10.;
uniform float uLightZ=20;

vec3 eyeLightPosition = vec3(uLightX, uLightY, uLightZ);
const float PI = 3.1415926;

void
main( )
{
    float x = gl_Vertex.x;
    float y = gl_Vertex.y;

	/////////// Cosinus flowing in X, Decaying in X and Y ///////////
	float z = uA * (cos(2*PI*uB*x+uC)*exp(-uD*x))*(exp(-uE*y));

	/////////// Getting the Normal ////////////
	//  calculus derivatives
	float dzdx =  uA * (-sin(2*PI*uB*x+uC)*2*PI*uB*exp(-uD*x)+cos(2*PI*uB*x+uC)*(-uD)*exp(-uD*x))*(exp(-uE*y));
	float dzdy = uA*(cos(2*PI*uB*x+uC)*exp(-uD*x))*(-uE*exp(-uE*y));

	// Tangent vectors
	vec3 Tx = vec3(1., 0., dzdx);
	vec3 Ty = vec3(0., 1., dzdy);

	// Normal
	vec3 normal = normalize(cross(Tx, Ty));

	vec4 aVertex = vec4(x, y, gl_Vertex.z ,1.);
	vMC = aVertex.xyz; // used for the Bump-Mapping

	/////////////// Lighting ///////////////
	vec4 ECposition = gl_ModelViewMatrix * aVertex;
	vNf = normalize(gl_NormalMatrix * normal);
	vLf = eyeLightPosition - ECposition.xyz;
	vEf = vec3(0., 0., 0.) - ECposition.xyz;

	gl_Position = gl_ModelViewProjectionMatrix * aVertex;
    
}
