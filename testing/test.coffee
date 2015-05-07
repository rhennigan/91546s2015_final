###LineSegment###
# A simple line segment formed from a start point @p1, and end point @p2, and their corresponding
# colors @c1 and @c2, which default to white if left out.
class LineSegment
  constructor: (@p1, @p2, @c1, @c2) ->

    if not @c1?
      @c1 = new CoffeeGL.Colour.RGBA.WHITE()
    if not @c2?
      @c2 = new CoffeeGL.Colour.RGBA.WHITE()

    @v1 = new CoffeeGL.Vertex(@p1, @c1)
    @v2 = new CoffeeGL.Vertex(@p2, @c2)

    @line = new CoffeeGL.VertexSoup([@v1, @v2])
    @line.layout = gl.LINES



init = () ->
  v0 = new CoffeeGL.Vertex(new CoffeeGL.Vec3(-1, -1, 0), new CoffeeGL.Colour.RGBA.WHITE())
  v1 = new CoffeeGL.Vertex(new CoffeeGL.Vec3(0, 1, 0), new CoffeeGL.Colour.RGBA.WHITE())
  v2 = new CoffeeGL.Vertex(new CoffeeGL.Vec3(1, -1, 0), new CoffeeGL.Colour.RGBA.WHITE())

  t = new CoffeeGL.Triangle(v0, v1, v2)

  r = new CoffeeGL.Request('basic_vertex_colour.glsl')
  r.get (data) =>
    shader = new CoffeeGL.Shader(data)
    shader.bind()

  @node = new CoffeeGL.Node t

  @camera = new CoffeeGL.Camera.PerspCamera()

  @node.add @camera

draw = () ->
  GL.clearColor(0.15, 0.15, 0.15, 1.0)
  GL.clear(GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT)
  @node.draw()

cgl = new CoffeeGL.App('webgl-canvas', this, init, draw)
