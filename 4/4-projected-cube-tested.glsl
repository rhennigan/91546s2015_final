##>VERTEX
precision mediump float;
{{ShaderLibrary.Basic}}
{{ShaderLibrary.BasicCamera}}
{{ShaderLibrary.VertexColour}}

varying vec4 vTransformedNormal;

void main(void) {
  gl_Position = uProjectionMatrix * uCameraMatrix * uModelMatrix * vec4(aVertexPosition, 1.0);

  gl_PointSize = 10.0;
}

##>FRAGMENT
precision mediump float;

{{ShaderLibrary.Basic}}
{{ShaderLibrary.VertexColour}}

void main() { 
  gl_FragColor = vColour; 
}