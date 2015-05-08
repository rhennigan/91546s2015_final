EPS = 0.00001

Vec2 = CoffeeGL.Vec2
Vec3 = CoffeeGL.Vec3
Vec4 = CoffeeGL.Vec4

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

cross3 = (u, v) -> new Vec3(-(u.z*v.y) + u.y*v.z, u.z*v.x - u.x*v.z, -(u.y*v.x) + u.x*v.y)

cross4 = (u, v, w) ->
  x1 = -(u.z*v.y*w.w) + u.y*v.z*w.w + u.z*v.w*w.y - u.w*v.z*w.y - u.y*v.w*w.z + u.w*v.y*w.z
  x2 = u.z*v.x*w.w - u.x*v.z*w.w - u.z*v.w*w.x + u.w*v.z*w.x + u.x*v.w*w.z - u.w*v.x*w.z
  x3 = -(u.y*v.x*w.w) + u.x*v.y*w.w + u.y*v.w*w.x - u.w*v.y*w.x - u.x*v.w*w.y + u.w*v.x*w.y
  x4 = u.z*v.y*w.x - u.y*v.z*w.x - u.z*v.x*w.y + u.x*v.z*w.y + u.y*v.x*w.z - u.x*v.y*w.z
  new Vec4(x1, x2, x3, x4)

coplanar = (line1, line2) ->
  u1 = new Vec4(line1.p1.x, line1.p1.y, line1.p1.z, 1)
  v1 = new Vec4(line1.p2.x, line1.p2.y, line1.p2.z, 1)
  u2 = new Vec4(line2.p1.x, line2.p1.y, line2.p1.z, 1)
  v2 = new Vec4(line2.p2.x, line2.p2.y, line2.p2.z, 1)
  (-EPS < det4(u1, v1, u2, v2) < EPS)

intersection = (line1, line2) ->
  if not coplanar(line1, line2)
    null
  else
    a = vSub(line1.p2, line1.p1)
    b = vSub(line2.p2, line2.p1)
    c = vSub(line2.p1, line1.p1)

    an = vNormalize(a)
    bn = vNormalize(b)
    vn = vNormalize(v = cross3(an, bn))
    n = vNorm(v)
    n2 = n*n

    s1 = det3(c, bn, vn)
    s2 = det3(c, an, vn)

#    i1 = vAdd(line1.p1, vsMul(an, s1))
#    i2 = vAdd(line2.p1, vsMul(bn, s2))
#
#    vsMul(vAdd(i1, i2), 0.5)

    [s1, s2]


init = () ->
  v0 = new CoffeeGL.Vertex(new CoffeeGL.Vec3(-1, -1, 0), new CoffeeGL.Colour.RGBA.WHITE())
  v1 = new CoffeeGL.Vertex(new CoffeeGL.Vec3(0, 1, 0), new CoffeeGL.Colour.RGBA.WHITE())
  v2 = new CoffeeGL.Vertex(new CoffeeGL.Vec3(1, -1, 0), new CoffeeGL.Colour.RGBA.WHITE())

  t = new CoffeeGL.Triangle(v0, v1, v2)

  red = new CoffeeGL.Colour.RGBA(1.0, 0.0, 0.0, 1.0)
  blue = new CoffeeGL.Colour.RGBA(0.0, 0.0, 1.0, 1.0)

  a = () -> Math.random() * 580
  l1 = new LineSegment(new CoffeeGL.Vec3(100, 100, 0), new CoffeeGL.Vec3(300, 300, 0), red, red)
  l2 = new LineSegment(new CoffeeGL.Vec3(100, 300, 0), new CoffeeGL.Vec3(300, 100, 0), blue, blue)

  console.log(intersection(l1, l2))

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
