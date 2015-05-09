add3 = (u, v) -> new CoffeeGL.Vec3(u.x + v.x, u.y + v.y, u.z + v.z)
sub3 = (u, v) -> new CoffeeGL.Vec3(u.x - v.x, u.y - v.y, u.z - v.z)
sc_mul3 = (v, s) -> new CoffeeGL.Vec3(v.x*s, v.y*s, v.z*s)
norm3 = (v) -> Math.sqrt(v.x*v.x + v.y*v.y + v.z*v.z)
normalize3 = (v) -> sc_mul3(v, 1 / norm3(v))
cross3 = (u, v) -> new CoffeeGL.Vec3(-(u.z*v.y) + u.y*v.z, u.z*v.x - u.x*v.z, -(u.y*v.x) + u.x*v.y)

class ShapesExample

  init : () =>

    @top_node = new CoffeeGL.Node()

    r = new CoffeeGL.Request('7-tower-tested.glsl')
    r.get (data) =>
      @shader = new CoffeeGL.Shader data
      @shader.bind()
      @shader.setUniform3v("uAmbientLightingColor", new CoffeeGL.Colour.RGB(0.5,0.5,0.5))

    @c = new CoffeeGL.Camera.MousePerspCamera new CoffeeGL.Vec3 0,0,5
    @top_node.add @c

    @light1 = new CoffeeGL.Light.PointLight(new CoffeeGL.Vec3(0.0,10.0,25.0), new CoffeeGL.Colour.RGB(1.0,1.0,1.0) )
    @light2 = new CoffeeGL.Light.PointLight(new CoffeeGL.Vec3(-10,10.0,25.0), new CoffeeGL.Colour.RGB(1.0,1.0,1.0) )
    @light3 = new CoffeeGL.Light.PointLight(new CoffeeGL.Vec3(0.0,-10.0,-5.0), new CoffeeGL.Colour.RGB(1.0,1.0,1.0) )

    @top_node.add @light1
    @top_node.add @light2
    @top_node.add @light3

    @quad = new CoffeeGL.Quad()
    @quad.v[0].c = new CoffeeGL.Colour.RGBA(1,0,0,1)
    @quad.v[1].c = new CoffeeGL.Colour.RGBA(1,1,0,1)
    @quad.v[2].c = new CoffeeGL.Colour.RGBA(1,0,1,1)
    @quad.v[3].c = new CoffeeGL.Colour.RGBA(0,1,1,1)
    [@quad.v[0].p.x, @quad.v[0].p.y, @quad.v[0].p.z] = [-1, 1, -1]
    [@quad.v[1].p.x, @quad.v[1].p.y, @quad.v[1].p.z] = [-1, -1, -1]
    [@quad.v[2].p.x, @quad.v[2].p.y, @quad.v[2].p.z] = [1, 1, 1]
    [@quad.v[3].p.x, @quad.v[3].p.y, @quad.v[3].p.z] = [1, -1, 1]
    @nq = new CoffeeGL.Node(@quad)
    @nq.add(@c)
    @top_node.add(@nq)

    console.log(@quad)
    makeTower = (scale, steps) =>
      [v0, v1, v2, v3] = [@quad.v[0].p, @quad.v[1].p, @quad.v[2].p, @quad.v[3].p]

      for i in [1..steps]
        a = sub3(v1, v0)
        b = sub3(v2, v0)
        c = sc_mul3(normalize3(cross3(a, b)), scale)

        u0 = add3(add3(sc_mul3(v0, 0.9), sc_mul3(v3, 0.1)), c)
        u1 = add3(add3(sc_mul3(v1, 0.9), sc_mul3(v2, 0.1)), c)
        u2 = add3(add3(sc_mul3(v2, 0.9), sc_mul3(v1, 0.1)), c)
        u3 = add3(add3(sc_mul3(v3, 0.9), sc_mul3(v0, 0.1)), c)

        q = new CoffeeGL.Quad()
        q.v[0].p = u0
        q.v[1].p = u1
        q.v[2].p = u2
        q.v[3].p = u3
        [q.v[0].c, q.v[1].c, q.v[2].c, q.v[3].c] = [@quad.v[0].c, @quad.v[1].c, @quad.v[2].c, @quad.v[3].c]
        n = new CoffeeGL.Node(q)
        n.add(@c)
        @top_node.add(n)

        [v0, v1, v2, v3] = [u0, u1, u2, u3]

    makeTower(0.25, 8)

#    GL.enable GL.CULL_FACE
#    GL.cullFace GL.BACK
#    GL.enable GL.DEPTH_TEST

  update : (dt) =>
    @light1.pos = @c.pos
    @light2.pos = @c.pos
    @light3.pos = @c.pos

  draw : () =>

    GL.clearColor(0.15, 0.15, 0.15, 1.0)
    GL.clear(GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT)

    @top_node.draw() if @top_node?


example = new ShapesExample()
cgl = new CoffeeGL.App('webgl-canvas', example, example.init, example.draw, example.update)
