RED = new CoffeeGL.Colour.RGB(0.839216,0.290196,0.152941)
GREEN = new CoffeeGL.Colour.RGB(0.4,0.796078,0.223529)
BLUE = new CoffeeGL.Colour.RGB(0.0470588,0.352941,0.505882)
GRAY = new CoffeeGL.Colour.RGB(0.556863,0.678431,0.670588)


class Main

  init: () =>

    polygon = (x, y, z, n) ->
      step = 2 * Math.PI / n
      center = new Vec3(x, y, z)
      mesh = new CoffeeGL.TriangleMesh()
      for i in [0...n]
        theta1 = step * i
        theta2 = step * (i + 1)
        p1 = Vec3.add(center, new Vec3(Math.cos(theta1), Math.sin(theta1), 0))
        p2 = Vec3.add(center, new Vec3(Math.cos(theta2), Math.sin(theta2), 0))
        n1 = @noise.simplex3(p1.x, p1.y, p1.z)
        n2 = @noise.simplex3(p2.x, p2.y, p2.z)
        [p1.x, p1.y, p1.z] = [p1.x + n1, p1.y + n1, p1.z + n1]
        [p2.x, p2.y, p2.z] = [p2.x + n2, p2.y + n2, p2.z + n2]



    @noise = new CoffeeGL.Noise.Noise()

    console.log(@noise.simplex3(1.0, 1.5, 2.0))

    @top = new CoffeeGL.Node()

    req = new CoffeeGL.Request('5-plane-from-polygonstested.glsl')
    req.get (data) =>
      @shader = new CoffeeGL.Shader(data)
      @shader.bind()
      @shader.setUniform3v("uAmbientLightingColor", new CoffeeGL.Colour.RGB(0.025, 0.025, 0.025))

    @camera = new CoffeeGL.Camera.MousePerspCamera(new CoffeeGL.Vec3(0, 0, 15))
    @top.add(@camera)

    @light = new CoffeeGL.Light.PointLight(new CoffeeGL.Vec3(10, 0, 0), new CoffeeGL.Colour.RGBA.WHITE())
    @top.add(@light)

    # Cylinder(radius, resolution, segments, height, colour)
#    th = 0.025
#    res = 10
#    seg = 4
#    h = 2.0
#    col = new CoffeeGL.Colour.RGBA(0.5, 0.5, 0.5, 1.0)
    #    @c = new CoffeeGL.Shapes.Cylinder(th, res, seg, h, col)
    #    cn = new CoffeeGL.Node(@c)
    #    @top.add(cn)
    #    cn.matrix.translate(new CoffeeGL.Vec3(-1, -1,  0))
#
#    @cube = new CoffeeGL.Node()
#    @cs =
#      for i in [1..12]
#        c = new CoffeeGL.Shapes.Cylinder(th, res, seg, h, col)
#        cn = new CoffeeGL.Node(c)
#        @cube.add(cn)
#        cn
#
#    @cs[ 0].matrix.translate(new CoffeeGL.Vec3(-1, 0,  1))
#    @cs[ 1].matrix.translate(new CoffeeGL.Vec3(-1, 0, -1))
#    @cs[ 2].matrix.translate(new CoffeeGL.Vec3( 1, 0,  1))
#    @cs[ 3].matrix.translate(new CoffeeGL.Vec3( 1, 0, -1))
#
#    @cs[ 4].matrix.rotate(new CoffeeGL.Vec3(1, 0,  0), Math.PI / 2)
#    @cs[ 4].matrix.translate(new CoffeeGL.Vec3(-1,  0, -1))
#    @cs[ 5].matrix.rotate(new CoffeeGL.Vec3(1, 0,  0), Math.PI / 2)
#    @cs[ 5].matrix.translate(new CoffeeGL.Vec3(-1,  0,  1))
#    @cs[ 6].matrix.rotate(new CoffeeGL.Vec3(1, 0,  0), Math.PI / 2)
#    @cs[ 6].matrix.translate(new CoffeeGL.Vec3( 1,  0, -1))
#    @cs[ 7].matrix.rotate(new CoffeeGL.Vec3(1, 0,  0), Math.PI / 2)
#    @cs[ 7].matrix.translate(new CoffeeGL.Vec3( 1,  0,  1))
#
#    @cs[ 8].matrix.rotate(new CoffeeGL.Vec3(0, 0, 1), Math.PI / 2)
#    @cs[ 8].matrix.translate(new CoffeeGL.Vec3( 1, 0, -1))
#    @cs[ 9].matrix.rotate(new CoffeeGL.Vec3(0, 0, 1), Math.PI / 2)
#    @cs[ 9].matrix.translate(new CoffeeGL.Vec3( 1, 0,  1))
#    @cs[10].matrix.rotate(new CoffeeGL.Vec3(0, 0, 1), Math.PI / 2)
#    @cs[10].matrix.translate(new CoffeeGL.Vec3(-1,  0, -1))
#    @cs[11].matrix.rotate(new CoffeeGL.Vec3(0, 0, 1), Math.PI / 2)
#    @cs[11].matrix.translate(new CoffeeGL.Vec3(-1,  0,  1))

    @top.add(@cube)

    GL.enable GL.CULL_FACE
    GL.cullFace GL.BACK
    GL.enable GL.DEPTH_TEST

  update: (dt) =>
    @light.pos = @camera.pos

  draw: () =>
    GL.clearColor(0.15, 0.15, 0.15, 1.0)
    GL.clear(GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT)

    @top.draw() if @top?

main = new Main()
cgl = new CoffeeGL.App('webgl-canvas', main, main.init, main.draw, main.update)
