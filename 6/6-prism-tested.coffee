add3 = (u, v) -> new CoffeeGL.Vec3(u.x + v.x, u.y + v.y, u.z + v.z)
sub3 = (u, v) -> new CoffeeGL.Vec3(u.x - v.x, u.y - v.y, u.z - v.z)
sc_mul3 = (v, s) -> new CoffeeGL.Vec3(v.x*s, v.y*s, v.z*s)
norm3 = (v) -> Math.sqrt(v.x*v.x + v.y*v.y + v.z*v.z)
normalize3 = (v) -> sc_mul3(v, 1 / norm3(v))
cross3 = (u, v) -> new CoffeeGL.Vec3(-(u.z*v.y) + u.y*v.z, u.z*v.x - u.x*v.z, -(u.y*v.x) + u.x*v.y)

class ShapesExample

  init : () =>

    @top_node = new CoffeeGL.Node()

    r = new CoffeeGL.Request('6-prism-tested.glsl')
    r.get (data) =>
      @shader = new CoffeeGL.Shader data
      @shader.bind()
      @shader.setUniform3v("uAmbientLightingColor", new CoffeeGL.Colour.RGB(0.5,0.5,0.5))

    @c = new CoffeeGL.Camera.MousePerspCamera new CoffeeGL.Vec3 0,0,15
    @top_node.add @c

    @light = new CoffeeGL.Light.PointLight(new CoffeeGL.Vec3(0.0,10.0,25.0), new CoffeeGL.Colour.RGB(1.0,1.0,1.0) )

    @top_node.add @light

    @quad = new CoffeeGL.Quad()
    [@quad.v[0].p.x, @quad.v[0].p.y, @quad.v[0].p.z] = [-1, 1, -1]
    [@quad.v[1].p.x, @quad.v[1].p.y, @quad.v[1].p.z] = [-1, -1, -1]
    [@quad.v[2].p.x, @quad.v[2].p.y, @quad.v[2].p.z] = [1, 1, 1]
    [@quad.v[3].p.x, @quad.v[3].p.y, @quad.v[3].p.z] = [1, -1, 1]
    @nq = new CoffeeGL.Node(@quad)
    @nq.add(@c)
    @top_node.add(@nq)

    makePrism = (scale) =>
      [v0, v1, v2, v3] = [@quad.v[0].p, @quad.v[1].p, @quad.v[2].p, @quad.v[3].p]
      a = sub3(v1, v0)
      b = sub3(v2, v0)
      c = sc_mul3(normalize3(cross3(a, b)), scale)

      @quad2 = new CoffeeGL.Quad()
      @quad2.v[0].p = add3(@quad.v[0].p, c)
      @quad2.v[1].p = add3(@quad.v[1].p, c)
      @quad2.v[2].p = add3(@quad.v[2].p, c)
      @quad2.v[3].p = add3(@quad.v[3].p, c)
      @nq2 = new CoffeeGL.Node(@quad2)
      @nq2.add(@c)
      @top_node.add(@nq2)

    makePrism(1)
    makePrism(2)
    makePrism(3)


  update : (dt) =>
    @light.pos = @c.pos

  draw : () =>

    GL.clearColor(0.15, 0.15, 0.15, 1.0)
    GL.clear(GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT)

    @top_node.draw() if @top_node?


example = new ShapesExample()
cgl = new CoffeeGL.App('webgl-canvas', example, example.init, example.draw, example.update)
