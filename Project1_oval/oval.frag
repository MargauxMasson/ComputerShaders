#version 330 compatibility

in float vLightIntensity; 
in vec4  vColor;
in vec2  vST;

uniform float uAd;
uniform float uBd;
uniform float uTol;

const vec4 dots_color = vec4( 0.7, 0., 1, 1 ); 

void
main( )
{
     float Ar = uAd/2.;
     float Br = uBd/2.;
     int numins = int( vST.s / uAd );
     int numint = int( vST.t / uBd );
     float sc = numins *uAd + Ar;
     float tc = numint *uBd + Br;
     float f = ((vST.s - sc)/ Ar)*((vST.s - sc)/Ar)+((vST.t - tc)/Br)*((vST.t - tc)/Br);
     
     float d = smoothstep( 1-uTol, 1+uTol, f );
     gl_FragColor = mix( dots_color, vColor, d );
     gl_FragColor.rgb *= vLightIntensity;
}
