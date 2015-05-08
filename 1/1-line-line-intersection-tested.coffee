EPS = 0.00001

Vec2 = CoffeeGL.Vec2
Vec3 = CoffeeGL.Vec3
Vec4 = CoffeeGL.Vec4

class LineSegment
  constructor: (@p1, @p2, @c1, @c2) ->
    if not @c1?
      @c1 = new CoffeeGL.Colour.RGBA.WHITE()
    if not @c2?
      @c2 = new CoffeeGL.Colour.RGBA.WHITE()

    @v = [new CoffeeGL.Vertex(@p1, @c1), new CoffeeGL.Vertex(@p2, @c2)]
    gl = CoffeeGL.Context.gl
    @layout = gl.LINES

  parametric: (t) ->
    p1 = sc_mul3(@p1, 1-t)
    p2 = sc_mul3(@p2, t)
    add3(p1, p2)

add3 = (u, v) -> new Vec3(u.x + v.x, u.y + v.y, u.z + v.z)

sub3 = (u, v) -> new Vec3(u.x - v.x, u.y - v.y, u.z - v.z)

sc_mul3 = (v, s) -> new Vec3(v.x*s, v.y*s, v.z*s)

mul3 = (u, v) -> new Vec3(u.x*v.x, u.y*v.y, u.z*v.z)

dot3 = (u, v) -> u.x*v.x + u.y*v.y + u.z*v.z

norm3 = (v) -> Math.sqrt(v.x*v.x + v.y*v.y + v.z*v.z)

normalize3 = (v) -> sc_mul3(v, 1 / norm3(v))

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

intersection_params = (line1, line2) ->
  if not coplanar(line1, line2)
    null
  else
    [x1, x2] = [line1.p1, line1.p2]
    [x3, x4] = [line2.p1, line2.p2]

    a1 = sub3(x2, x1)
    b1 = sub3(x4, x3)
    c1 = sub3(x3, x1)

    n1 = norm3(cross3(a1, b1))
    s1 = dot3(cross3(c1, b1), cross3(a1, b1)) / (n1*n1)

    a2 = b1
    b2 = a1
    c2 = sc_mul3(c1, -1)

    n2 = n1
    s2 = dot3(cross3(c2, b2), cross3(a2, b2)) / (n2*n2)

    [s1, s2]

intersection_point = (line1, line2) ->
  [s1, s2] = intersection_params(line1, line2)
  if 0 <= s1 <= 1 and 0 <= s2 <= 1 then line1.parametric(s1) else null


class Viewer

  constructor: () ->
    CoffeeGL.Context.mouseMove.add @onMouseMove, @
    CoffeeGL.Context.mouseDown.add @onMouseDown, @
    CoffeeGL.Context.mouseUp.add @onMouseUp, @

    @dragging = false
    @p1 = new Vec2(0, 0)
    @p2 = new Vec2(0, 0)
    @p3 = new Vec2(0, 0)
    @p4 = new Vec2(0, 0)

    @set1 = false
    @set2 = false
    @set3 = false
    @set4 = false

    @px = 0
    @py = 0
    @dx = 0
    @dy = 0

  onMouseMove: (event) ->
    if dragging
      [x, y] = [event.mouseX, event.mouseY]
      [@dx, @dy] = [x - @px, y - @py]
      [@px, @py] = [x, y]
    @

  onMouseDown: (event) ->
    [@px, @py] = [event.mouseX, event.mouseY]
    [@dx, @dy] = [0, 0]
    @

  onMouseUp: (event) ->
    @

  onMouseOver: (event) ->
    if @px == 0 and @py == 0
      [@px, @py] = [event.mouseX, event.mouseY]

init = () ->
  drag_start = new Vec2(0, 0)
  drag_current = new Vec2(0, 0)
  dragging = false
  placed_one = false
  placed = new Vec2(0, 0)


  CoffeeGL.Context.mouseDown.add (event) =>
    xy = [x, y] = [event.mouseX, event.mouseY]
    [drag_start.x, drag_start.y] = [drag_current.x, drag_current.y] = xy
    dragging = true
    if not placed_one
      [placed.x, placed.y] = xy
      placed_one = true

  CoffeeGL.Context.mouseMove.add (event) =>
    if dragging then [drag_current.x, drag_current.y] = [event.mouseX, event.mouseY]


  nodes = []

  red = new CoffeeGL.Colour.RGBA(1.0, 0.0, 0.0, 1.0)
  blue = new CoffeeGL.Colour.RGBA(0.0, 0.0, 1.0, 1.0)

  a = () -> Math.random() * 580
  l1 = new LineSegment(new Vec3(a(), a(), 0), new Vec3(a(), a(), 0), red, red)
  l2 = new LineSegment(new Vec3(a(), a(), 0), new Vec3(a(), a(), 0), blue, blue)
  [s1, s2] = intersection_params(l1, l2)

  r = new CoffeeGL.Request('1-line-line-intersection-tested.glsl')
  r.get (data) =>
    shader = new CoffeeGL.Shader(data)
    shader.bind()

  @nodel1 = new CoffeeGL.Node l1
  @nodel2 = new CoffeeGL.Node l2

  @cameral = new CoffeeGL.Camera.OrthoCamera(new Vec3(0, 0, 0.2), new Vec3(0, 0, 0))

  @nodel1.add @cameral
  @nodel2.add @cameral

draw = () ->
  GL.clearColor(0.15, 0.15, 0.15, 1.0)
  GL.clear(GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT)
#  for node in nodes
#    node.draw()
  @nodel1.draw()
  @nodel2.draw()

cgl = new CoffeeGL.App('webgl-canvas', this, init, draw)