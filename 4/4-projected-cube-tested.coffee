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
      @shader.setUniform3v("uAmbientLightingColor", new CoffeeGL.Colour.RGB(0.1, 0.1, 0.1))

    @camera = new CoffeeGL.Camera.MousePerspCamera(new CoffeeGL.Vec3(0, 0, 25))
    @top.add(@camera)

    @light1 = new CoffeeGL.Light.PointLight(new CoffeeGL.Vec3(1, 0, 0), RED)
    @light2 = new CoffeeGL.Light.PointLight(new CoffeeGL.Vec3(0, 1, 0), GREEN)
    @light3 = new CoffeeGL.Light.PointLight(new CoffeeGL.Vec3(0, 0, 1), BLUE)
    @top.add(@light1)
    @top.add(@light2)
    @top.add(@light3)

    # Cylinder(radius, resolution, segments, height, colour)
    th = 0.1
    res = 10
    seg = 8
    h = 2
    col = new CoffeeGL.Colour.RGB(0.5, 0.5, 0.5)
    @cube_skeleton =
      for i in [1..12]
        c = new CoffeeGL.Shapes.Cylinder(th, res, seg, h, col)
        cn = new CoffeeGL.Node(c)
        


main = new Main()
cgl = new CoffeeGL.App('webgl-canvas', main, main.init, main.draw, main.update)
