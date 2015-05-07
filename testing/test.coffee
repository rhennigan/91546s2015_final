###LineSegment###
# A simple line segment formed from a start point @p1, and end point @p2, and their corresponding
# colors @c1 and @c2, which default to white if left out.
class LineSegment
  constructor: (@p1, @p2, @c1, @c2) ->
    if not @c1?
      @c1 = new CoffeeGL.Colour.RGBA.WHITE()
    if not @c2?
      @c2 = new CoffeeGL.Colour.RGBA.WHITE()

    @v = [new CoffeeGL.Vertex(@p1, @c1), new CoffeeGL.Vertex(@p2, @c2)]
    gl = CoffeeGL.Context.gl
    @layout = gl.LINES

  intersection2D: (line) ->
    [l1x1, l1y1] = [@p1.x, @p1.y]
    [l1x2, l1y2] = [@p2.x, @p2.y]
    [l2x1, l2y1] = [line.p1.x, line.p1.y]
    [l2x2, l2y2] = [line.p2.x, line.p2.y]

    det = (l1x1-l1x2)*(l2y1-l2y2) - (l1y1-l1y2)*(l2x1-l2x2)

    if det is 0
      null
    else
      

    t1 = t1n / t1d
    t2 = t2n / t2d

    if isNaN(t1) and isNaN(t2)  # collinear


  parametric: (t) ->
    p1 = CoffeeGL.Vec3.multScalar(@p1, 1-t)
    p2 = CoffeeGL.Vec3.multScalar(@p2, t)
    CoffeeGL.Vec3.add(p1, p2)

init = () ->
  v0 = new CoffeeGL.Vertex(new CoffeeGL.Vec3(-1, -1, 0), new CoffeeGL.Colour.RGBA.WHITE())
  v1 = new CoffeeGL.Vertex(new CoffeeGL.Vec3(0, 1, 0), new CoffeeGL.Colour.RGBA.WHITE())
  v2 = new CoffeeGL.Vertex(new CoffeeGL.Vec3(1, -1, 0), new CoffeeGL.Colour.RGBA.WHITE())

  t = new CoffeeGL.Triangle(v0, v1, v2)

  red = new CoffeeGL.Colour.RGBA(1.0, 0.0, 0.0, 1.0)
  blue = new CoffeeGL.Colour.RGBA(0.0, 0.0, 1.0, 1.0)

  a = () -> Math.random() * 580
  l1 = new LineSegment(new CoffeeGL.Vec3(100, 100, 0), new CoffeeGL.Vec3(200, 100, 0), red, red)
  l2 = new LineSegment(new CoffeeGL.Vec3(200, 100, 0), new CoffeeGL.Vec3(400, 100, 0), blue, blue)

  console.log(l1.intersection(l2))

  r = new CoffeeGL.Request('basic_vertex_colour.glsl')
  r.get (data) =>
    shader = new CoffeeGL.Shader(data)
    shader.bind()

  @nodet = new CoffeeGL.Node t
  @nodel1 = new CoffeeGL.Node l1
  @nodel2 = new CoffeeGL.Node l2

  @camerat = new CoffeeGL.Camera.PerspCamera()
  @cameral = new CoffeeGL.Camera.OrthoCamera(new CoffeeGL.Vec3(0, 0, 0.2), new CoffeeGL.Vec3(0, 0, 0))

  @nodet.add @camerat
  @nodel1.add @cameral
  @nodel2.add @cameral

draw = () ->
  GL.clearColor(0.15, 0.15, 0.15, 1.0)
  GL.clear(GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT)
  #@nodet.draw()
  @nodel1.draw()
  @nodel2.draw()

cgl = new CoffeeGL.App('webgl-canvas', this, init, draw)
