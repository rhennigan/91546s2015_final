##>VERTEX
precision mediump float;
{{ShaderLibrary.Basic}}
{{ShaderLibrary.BasicCamera}}
{{ShaderLibrary.CameraExtra}}
{{ShaderLibrary.VertexNormal}}
{{ShaderLibrary.VertexColour}}

void main(void) {
  vPosition =   uModelMatrix * vec4(aVertexPosition, 1.0);
  gl_Position =  uProjectionMatrix * uCameraMatrix * vPosition;

  vEyePosition = uCameraInverseMatrix * vPosition;

  vTransformedNormal = vec4(uNormalMatrix * aVertexNormal,1.0);
}

##>FRAGMENT
precision mediump float;

{{ShaderLibrary.Basic}}
{{ShaderLibrary.VertexNormal}}
{{ShaderLibrary.VertexColour}}
{{ShaderLibrary.BasicCamera}}
{{ShaderLibrary.CameraExtra}}

uniform vec3 uPointLightPos[10];

uniform vec3 uAmbientLightingColor;

uniform vec3 uPointLightDiffuse[10];
uniform vec3 uPointLightSpecular[10];
uniform vec3 uPointLightAttenuation[10];
uniform int uNumLights;

void main(void) {
  vec3 ambientLightWeighting = uAmbientLightingColor;
  float alpha = 1.0;

  vec3 normal = normalize(vTransformedNormal.xyz);
  vec3 specularLightWeighting = vec3(0.0, 0.0, 0.0);
  vec3 diffuseLightWeighting = vec3(0.0, 0.0, 0.0);
  vec3 eyeDirection = normalize(vEyePosition.xyz);
 
  for (int i =0; i < 10; i++) {
    if (i >= uNumLights)
      break;
    vec3 lightDirection = normalize(uPointLightPos[i].xyz - vPosition.xyz);
    vec3 reflectionDirection = reflect(-lightDirection, normal);

    float specularLightBrightness = pow(max(dot(reflectionDirection, eyeDirection), 0.0), 255.0);
    specularLightWeighting = specularLightWeighting + (uPointLightSpecular[i] * specularLightBrightness);

    float diffuseLightBrightness = max(dot(normal, lightDirection), 0.0);
    diffuseLightWeighting = diffuseLightWeighting + (uPointLightDiffuse[i] * diffuseLightBrightness);
  }

  alpha = vColour.a;

  gl_FragColor = vec4( vColour.rgb * diffuseLightWeighting + vColour.rgb * specularLightWeighting,
    alpha
  );

} 

   