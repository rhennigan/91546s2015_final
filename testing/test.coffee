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

  intersection: (line) ->
    [l1x1, l1y1] = [@p1.x, @p1.y]
    [l1x2, l1y2] = [@p2.x, @p2.y]
    [l2x1, l2y1] = [line.p1.x, line.p1.y]
    [l2x2, l2y2] = [line.p2.x, line.p2.y]

    a = l1x1-l1x2
    b = l1y1-l1y2
    c = l2x1-l2x2
    d = l2y1-l2y2
    det = a*d - b*c

    console.log(det)

    if det is 0
      null
    else
      xi = (c*(l1x1*l1y2-l1y1*l1x2)-a*(l2x1*l1y2-l1y1*l2x2))/det
      yi = (d*(l1x1*l1y2-l1y1*l1x2)-b*(l2x1*l2y2-l2y1*l2x2))/det

      int1a = Math.min(l1x1, l1x2)
      int1b = Math.max(l1x1, l1x2)

      int2a = Math.min(l2x1, l2x2)
      int2b = Math.max(l2x1, l2x2)

      console.log(xi, yi)
      if xi < int1a or  xi > int1b
        null
      else if xi < int2a or xi > int2b
        null
      else
        new CoffeeGL.Vec2(xi, yi)

  parametric: (t) ->
    p1 = CoffeeGL.Vec3.multScalar(@p1, 1-t)
    p2 = CoffeeGL.Vec3.multScalar(@p2, t)
    CoffeeGL.Vec3.add(p1, p2)

vAdd = (u, v) -> new Vec3(u.x + v.x, u.y + v.y, u.z + v.z)
vSub = (u, v) -> new Vec3(u.x - v.x, u.y - v.y, u.z - v.z)
vsMul = (v, s) -> new Vec3(v.x*s, v.y*s, v.z*s)
vMul = (u, v) -> new Vec3(u.x*v.x, u.y*v.y, u.z*v.z)
vDot = (u, v) -> u.x*v.x + u.y*v.y + u.z*v.z
vNorm = (v) -> Math.sqrt(v.x*v.x + v.y*v.y + v.z*v.z)
vNormalize = (v) -> vsMul(v, 1 / vNorm(v))
det3 = (u, v, w) -> -(u.z*v.y*w.x) + u.y*v.z*w.x + u.z*v.x*w.y - u.x*v.z*w.y - u.y*v.x*w.z + u.x*v.y*w.z
det4 = (u, v, w, x) ->
  -u.z*v.y*w.x*x.w + u.y*v.z*w.x*x.w + u.z*v.x*w.y*x.w - u.x*v.z*w.y*x.w -
    u.y*v.x*w.z*x.w + u.x*v.y*w.z*x.w + u.z*v.y*w.w*x.x - u.y*v.z*w.w*x.x -
    u.z*v.w*w.y*x.x + u.w*v.z*w.y*x.x + u.y*v.w*w.z*x.x - u.w*v.y*w.z*x.x -
    u.z*v.x*w.w*x.y + u.x*v.z*w.w*x.y + u.z*v.w*w.x*x.y - u.w*v.z*w.x*x.y -
    u.x*v.w*w.z*x.y + u.w*v.x*w.z*x.y + u.y*v.x*w.w*x.z - u.x*v.y*w.w*x.z -
    u.y*v.w*w.x*x.z + u.w*v.y*w.x*x.z + u.x*v.w*w.y*x.z - u.w*v.x*w.y*x.z
  
intersection = (line1, line2) ->
  [x1, y1, z1] = [line1.p1.x, line1.p1.y, line1.p1.z]
  [x2, y2, z2] = [line1.p2.x, line1.p2.y, line1.p2.z]
  [x3, y3, z3] = [line2.p1.x, line2.p1.y, line2.p1.z]
  [x4, y4, z4] = [line2.p2.x, line2.p2.y, line2.p2.z]

  switch
    when x1 == x3 and y1 == y3 and z1 == z3, x1 == x4 and y1 == y4 and z1 == z4
      new Vec3(x1, y1, z1)
    when x2 == x3 and y2 == y3 and z2 == z3, x2 == x4 and y2 == y4 and z2 == z4
      new Vec3(x2, y2, z2)
    else
      ux = ((x3 - x4)*(y1 - y2) - (x1 - x2)*(y3 - y4))
      uy = ((x3 - x4)*(z1 - z2) - (x1 - x2)*(z3 - z4))
      uz = ((y3 - y4)*(z1 - z2) - (y1 - y2)*(z3 - z4))
      n = ux*ux + uy*uy + uz*uz


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
