#version 330 compatibility

in vec3 vMCposition;
in vec4 vColor;
in float vLightIntensity;
in vec2 vST;
in float Z; 

uniform float uAd;
uniform float uBd;
uniform float uNoiseAmp;
uniform float uNoiseFreq;
uniform float uAlpha;
uniform float uTol;
uniform sampler3D Noise3;
uniform bool uUseChromaDepth;
uniform float uChromaRed;
uniform float uChromaBlue;

vec3
ChromaDepth(float t )
{
	t = clamp( t, 0., 1. );

	float b = 1.;
	float g = 0.0;
	float r = 1. - 6. * ( t - (5./6.) );

	if( t <= (5./6.) )
	{
		b = 6. * ( t - (4./6.) );
		g = 0.;
		r = 1.;
	}

	if( t <= (4./6.) )
	{
		b = 0.;
		g = 1. - 6. * ( t - (3./6.) );
		r = 1.;
	}

	if( t <= (3./6.) )
	{
		b = 0.;
		g = 1.;
		r = 6. * ( t - (2./6.) );
	}

	if( t <= (2./6.) )
	{
		b = 1. - 6. * ( t - (1./6.) );
		g = 1.;
		r = 0.;
	}

	if( t <= (1./6.) )
	{
		b = 1.;
		g = 6. * t;
	}

	return vec3( r, g, b );
}

void
main( )
{ 
	float Ar = uAd/2.;
	float Br = uBd/2.;
	int numins = int( vST.s / uAd );
	int numint = int( vST.t / uBd );
	
	vec4 nv = texture3D( Noise3, uNoiseFreq*vMCposition );
	float n = nv.r + nv.g + nv.b + nv.a;    //  1. -> 3.
	n = n - 2.;                             // -1. -> 1.

	float sc = float(numins) * uAd  +  Ar;
	float ds = vST.s - sc;                   // wrt ellipse center
	float tc = float(numint) * uBd  +  Br;
	float dt = vST.t - tc;                   // wrt ellipse center

	float oldDist = sqrt( ds*ds + dt*dt );
	float newDist = oldDist + uNoiseAmp*n; // noise value
	float scale = newDist / oldDist;        // this could be < 1., = 1., or > 1.

	ds *= scale;                            // scale by noise factor
	ds /= Ar;                               // ellipse equation

	dt *= scale;                            // scale by noise factor
	dt /= Br;                               // ellipse equation

	float d = ds*ds + dt*dt;
	float alpha=1.;

	gl_FragColor = vec4( 0.8, 0.2, 0.5, 1 );

	float m = smoothstep( 1.-uTol, 1.+uTol, d );

	if( abs( d - 1. ) <= uTol )
	{
		gl_FragColor = mix( vec4( 0.8, 0.2, 0.5, 1 ), vColor, m );
	}
	if( d <= 1.-uTol)
	{ 
		gl_FragColor = mix( vec4( 0.8, 0.2, 0.5, 1 ), vColor, m );
	}
	if(d > 1.+uTol)
	{
		alpha = uAlpha;
		gl_FragColor = vColor;

		if (uAlpha==0.){
			discard;
		}
	}
	
	if (uUseChromaDepth)
	{
		float t = (2./3.) * ( Z - uChromaRed ) / ( uChromaBlue - uChromaRed );
		t = clamp( t, 0., 2./3. );
		gl_FragColor.xyz = ChromaDepth(t);
	}
	
	gl_FragColor = vec4( vLightIntensity*gl_FragColor.xyz, alpha);
	
}