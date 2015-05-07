###LineSegment###
# A simple line segment formed from a start point @p1, and end point @p2, and their corresponding
# colors @c1 and @c2, which default to white if left out.
class LineSegment
  constructor: (@p1, @p2, @c1, @c2) ->
    @v = [new CoffeeGL.Vertex(@p1, @c1), new CoffeeGL.Vertex(@p2, @c2)]
    gl = CoffeeGL.Context.gl
    @layout = gl.LINES

  _addToNode: (node) ->
    node.geometry = @
    @

  flatten: () ->
    t = []
    for vertex in @v
      t.concat vertex.flatten()
    t

init = () ->
  v0 = new CoffeeGL.Vertex(new CoffeeGL.Vec3(-1, -1, 0), new CoffeeGL.Colour.RGBA.WHITE())
  v1 = new CoffeeGL.Vertex(new CoffeeGL.Vec3(0, 1, 0), new CoffeeGL.Colour.RGBA.WHITE())
  v2 = new CoffeeGL.Vertex(new CoffeeGL.Vec3(1, -1, 0), new CoffeeGL.Colour.RGBA.WHITE())

  t = new CoffeeGL.Triangle(v0, v1, v2)

  p1 = new CoffeeGL.Vec2(100, 100)
  p2 = new CoffeeGL.Vec2(480, 480)
  c1 = new CoffeeGL.Colour.RGBA(1.0, 0.0, 0.0, 0.75)
  c2 = new CoffeeGL.Colour.RGBA(0.0, 0.0, 1.0, 0.75)

  l = new LineSegment(p1, p2, c1, c2)

  r = new CoffeeGL.Request('basic_vertex_colour.glsl')
  r.get (data) =>
    shader = new CoffeeGL.Shader(data)
    shader.bind()

  @nodet = new CoffeeGL.Node t
  @nodel = new CoffeeGL.Node l.line

  @camerat = new CoffeeGL.Camera.PerspCamera()
  @cameral = new CoffeeGL.Camera.OrthoCamera(new CoffeeGL.Vec3(0, 0, 0.2), new CoffeeGL.Vec3(0, 0, 0))

  @nodet.add @camerat
  @nodel.add @cameral

draw = () ->
  GL.clearColor(0.15, 0.15, 0.15, 1.0)
  GL.clear(GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT)
  @nodet.draw()
  @nodel.draw()

cgl = new CoffeeGL.App('webgl-canvas', this, init, draw)
