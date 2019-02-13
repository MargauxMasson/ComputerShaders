#version 330 compatibility
out vec2 vST;
out vec3 vMC;
out vec3 vNf;
out vec3 vLf;
out vec3 vEf;

uniform float uA;
uniform float uB;
uniform float uC;
uniform float uD;
uniform float uE;
uniform float uLightX;
uniform float uLightY;
uniform float uLightZ;

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

	////////////// Extra credits: z = uA * cos(2*PI*uB*r+uC)*exp(-uD*r) - rock in a pond simulation /////////
	float r = sqrt(x*x+y*y);
	// float z = uA * cos(2*PI*uB*r+uC)*exp(-uD*r);
	float drdx = x / r;
	float drdy = y / r;

	/////////// Getting the Normal ////////////
	// float dzdx = uA*2*PI*uB*drdx*(-sin(2*PI*uB*r+uC))*exp(-uD*r)+uA*cos(2*PI*uB*r+uC)*(-uD*drdx)*exp(-uD*r);
	// float dzdy = uA*2*PI*uB*drdy*(-sin(2*PI*uB*r+uC))*exp(-uD*r)+uA*cos(2*PI*uB*r+uC)*(-uD*drdy)*exp(-uD*r);

	// Tangent vectors
	vec3 Tx = vec3(1., 0., dzdx);
	vec3 Ty = vec3(0., 1., dzdy);

	// Normal
	vec3 normal = normalize(cross(Tx, Ty));

	vec4 aVertex = vec4(x, y,  z ,1.);
	vMC = aVertex.xyz; // used for the Bump-Mapping

	/////////////// Lighting ///////////////
	vec4 ECposition = gl_ModelViewMatrix * aVertex;
	vNf = normalize(gl_NormalMatrix * normal);
	vLf = eyeLightPosition - ECposition.xyz;
	vEf = vec3(0., 0., 0.) - ECposition.xyz;

	gl_Position = gl_ModelViewProjectionMatrix * aVertex;
    
}
