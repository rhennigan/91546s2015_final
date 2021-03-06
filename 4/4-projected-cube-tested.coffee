RED = new CoffeeGL.Colour.RGB(0.839216,0.290196,0.152941)
GREEN = new CoffeeGL.Colour.RGB(0.4,0.796078,0.223529)
BLUE = new CoffeeGL.Colour.RGB(0.0470588,0.352941,0.505882)
GRAY = new CoffeeGL.Colour.RGB(0.556863,0.678431,0.670588)

class Main

  init: () =>

    @top = new CoffeeGL.Node()

    req = new CoffeeGL.Request('4-projected-cube-tested.glsl')
    req.get (data) =>
      @shader = new CoffeeGL.Shader(data)
      @shader.bind()
      @shader.setUniform3v("uAmbientLightingColor", new CoffeeGL.Colour.RGB(0.025, 0.025, 0.025))

    @camera = new CoffeeGL.Camera.MousePerspCamera(new CoffeeGL.Vec3(0, 0, 15))
    @top.add(@camera)

    @light1 = new CoffeeGL.Light.PointLight(new CoffeeGL.Vec3(10, 0, 0), RED)
    @light2 = new CoffeeGL.Light.PointLight(new CoffeeGL.Vec3(0, 10, 0), GREEN)
    @light3 = new CoffeeGL.Light.PointLight(new CoffeeGL.Vec3(0, 0, 10), BLUE)
    @top.add(@light1)
    @top.add(@light2)
    @top.add(@light3)

    th = 0.025
    res = 10
    seg = 4
    h = 2.0
    col = new CoffeeGL.Colour.RGBA(0.5, 0.5, 0.5, 1.0)

    @cube = new CoffeeGL.Node()
    @cs =
      for i in [1..12]
        c = new CoffeeGL.Shapes.Cylinder(th, res, seg, h, col)
        cn = new CoffeeGL.Node(c)
        @cube.add(cn)
        cn

    @cs[ 0].matrix.translate(new CoffeeGL.Vec3(-1, 0,  1))
    @cs[ 1].matrix.translate(new CoffeeGL.Vec3(-1, 0, -1))
    @cs[ 2].matrix.translate(new CoffeeGL.Vec3( 1, 0,  1))
    @cs[ 3].matrix.translate(new CoffeeGL.Vec3( 1, 0, -1))

    @cs[ 4].matrix.rotate(new CoffeeGL.Vec3(1, 0,  0), Math.PI / 2)
    @cs[ 4].matrix.translate(new CoffeeGL.Vec3(-1,  0, -1))
    @cs[ 5].matrix.rotate(new CoffeeGL.Vec3(1, 0,  0), Math.PI / 2)
    @cs[ 5].matrix.translate(new CoffeeGL.Vec3(-1,  0,  1))
    @cs[ 6].matrix.rotate(new CoffeeGL.Vec3(1, 0,  0), Math.PI / 2)
    @cs[ 6].matrix.translate(new CoffeeGL.Vec3( 1,  0, -1))
    @cs[ 7].matrix.rotate(new CoffeeGL.Vec3(1, 0,  0), Math.PI / 2)
    @cs[ 7].matrix.translate(new CoffeeGL.Vec3( 1,  0,  1))

    @cs[ 8].matrix.rotate(new CoffeeGL.Vec3(0, 0, 1), Math.PI / 2)
    @cs[ 8].matrix.translate(new CoffeeGL.Vec3( 1, 0, -1))
    @cs[ 9].matrix.rotate(new CoffeeGL.Vec3(0, 0, 1), Math.PI / 2)
    @cs[ 9].matrix.translate(new CoffeeGL.Vec3( 1, 0,  1))
    @cs[10].matrix.rotate(new CoffeeGL.Vec3(0, 0, 1), Math.PI / 2)
    @cs[10].matrix.translate(new CoffeeGL.Vec3(-1,  0, -1))
    @cs[11].matrix.rotate(new CoffeeGL.Vec3(0, 0, 1), Math.PI / 2)
    @cs[11].matrix.translate(new CoffeeGL.Vec3(-1,  0,  1))

    @top.add(@cube)

    GL.enable GL.CULL_FACE
    GL.cullFace GL.BACK
    GL.enable GL.DEPTH_TEST

  update: (dt) =>
    x = @camera.pos.x
    y = @camera.pos.y
    z = @camera.pos.z
    t1 = dt * 2 * Math.PI / 1000
    t2 = dt * 4 * Math.PI / 1000
    t3 = dt * 6 * Math.PI / 1000
    [@light1.pos.x, @light1.pos.y] = [x*Math.cos(t1)-y*Math.sin(t1), y*Math.cos(t1) + x*Math.sin(t1)]
    [@light2.pos.x, @light2.pos.y] = [x*Math.cos(t2)-y*Math.sin(t2), y*Math.cos(t2) + x*Math.sin(t2)]
    [@light3.pos.x, @light3.pos.y] = [x*Math.cos(t3)-y*Math.sin(t3), y*Math.cos(t3) + x*Math.sin(t3)]

  draw: () =>
    GL.clearColor(0.15, 0.15, 0.15, 1.0)
    GL.clear(GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT)

    @top.draw() if @top?

main = new Main()
cgl = new CoffeeGL.App('webgl-canvas', main, main.init, main.draw, main.update)
