#version 330 compatibility

const float PI = 3.14159265;
const float TWOPI = 2.*PI;

uniform float uA, uB, uC, uD, uE;

out vec3 vNs;
out vec3 vMC;
out vec3 vEC;

void
main( )
{
	vMC = gl_Vertex.xyz;
    float x = gl_Vertex.x;
    float y = gl_Vertex.y;

	/////////// Cosinus flowing in X, Decaying in X and Y ///////////
	float z = uA * (cos(2*PI*uB*x+uC)*exp(-uD*x))*(exp(-uE*y));

	/////////// Getting the Normal ////////////
	//  calculus derivatives
	float dzdx =  uA * (-sin(2*PI*uB*x+uC)*2*PI*uB*exp(-uD*x)+cos(2*PI*uB*x+uC)*(-uD)*exp(-uD*x))*(exp(-uE*y));
	float dzdy = uA*(cos(2*PI*uB*x+uC)*exp(-uD*x))*(-uE*exp(-uE*y));

	////////////// Extra credits: z = uA * cos(2*PI*uB*r+uC)*exp(-uD*r) - rock in a pond simulation /////////
	//float r = sqrt(x*x+y*y);
	//float z = uA * cos(2*PI*uB*r+uC)*exp(-uD*r);
	//float drdx = x / r;
	//float drdy = y / r;

	/////////// Getting the Normal ////////////
	//float dzdx = uA*2*PI*uB*drdx*(-sin(2*PI*uB*r+uC))*exp(-uD*r)+uA*cos(2*PI*uB*r+uC)*(-uD*drdx)*exp(-uD*r);
	//float dzdy = uA*2*PI*uB*drdy*(-sin(2*PI*uB*r+uC))*exp(-uD*r)+uA*cos(2*PI*uB*r+uC)*(-uD*drdy)*exp(-uD*r);

	// Tangent vectors
	vec3 Tx = vec3(1., 0., dzdx);
	vec3 Ty = vec3(0., 1., dzdy);

	vec4 newVertex = vec4(x, y,  z ,1.);

	vec4 ECposition = gl_ModelViewMatrix * newVertex;
	vEC = ECposition.xyz;

	vec3 newNormal = normalize(  gl_NormalMatrix * cross( Tx, Ty )  );
	vNs = newNormal;
	gl_Position = gl_ModelViewProjectionMatrix * newVertex;
}
