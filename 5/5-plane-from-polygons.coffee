add3 = (u, v) -> new CoffeeGL.Vec3(u.x + v.x, u.y + v.y, u.z + v.z)
sub3 = (u, v) -> new CoffeeGL.Vec3(u.x - v.x, u.y - v.y, u.z - v.z)
sc_mul3 = (v, s) -> new CoffeeGL.Vec3(v.x*s, v.y*s, v.z*s)
norm3 = (v) -> Math.sqrt(v.x*v.x + v.y*v.y + v.z*v.z)
normalize3 = (v) -> sc_mul3(v, 1 / norm3(v))
cross3 = (u, v) -> new CoffeeGL.Vec3(-(u.z*v.y) + u.y*v.z, u.z*v.x - u.x*v.z, -(u.y*v.x) + u.x*v.y)

normal = (vertices) ->
  center = new CoffeeGL.Vec3(0, 0, 0)
  n = vertices.length
  for i in [0...n]
    center.x += vertices[i].x
    center.y += vertices[i].y
    center.z += vertices[i].z
  center.x = center.x / n
  center.y = center.y / n
  center.z = center.z / n

  normals =
    for i in [0..(n-1)]
      v1 = sub3(vertices[i], center)
      v2 = sub3(vertices[i+1], center)
      normalize3(cross3(v1, v2))

  normalVector = new CoffeeGL.Vec3(0, 0, 0)
  for i in [0...(n-1)]
    normalVector.x += normals[i].x
    normalVector.y += normals[i].y
    normalVector.z += normals[i].z
  normalVector.x = normalVector.x / n
  normalVector.y = normalVector.y / n
  normalVector.z = normalVector.z / n

  error = 0
  for i in [0...n]
    error += norm3(sub3(normalVector, normals[i]))

  {A: normalVector.x, B: normalVector.y, C: normalVector.z, D: error < 0.1}

noise = new CoffeeGL.Noise.Noise()

n = 7
step = 2 * Math.PI / n
exact = []
approx = []
for i in [0..5]
  theta1 = step * i
  theta2 = step * (i + 1)
  p1 = new CoffeeGL.Vec3(Math.cos(theta1), Math.sin(theta1), 0)
  p2 = new CoffeeGL.Vec3(Math.cos(theta1), Math.sin(theta1), 0)
  p2.z = noise.simplex2(p2.x, p2.y) / 100.0
  exact.push(p1)
  approx.push(p2)

console.log(exact)
console.log(approx)

console.log(normal(exact))
console.log(normal(approx))


#RED = new CoffeeGL.Colour.RGB(0.839216,0.290196,0.152941)
#GREEN = new CoffeeGL.Colour.RGB(0.4,0.796078,0.223529)
#BLUE = new CoffeeGL.Colour.RGB(0.0470588,0.352941,0.505882)
#GRAY = new CoffeeGL.Colour.RGB(0.556863,0.678431,0.670588)
#
#sc_mul3 = (v, s) -> new CoffeeGL.Vec3(v.x*s, v.y*s, v.z*s)
#norm3 = (v) -> Math.sqrt(v.x*v.x + v.y*v.y + v.z*v.z)
#normalize3 = (v) -> sc_mul3(v, 1 / norm3(v))
#cross3 = (u, v) -> new CoffeeGL.Vec3(-(u.z*v.y) + u.y*v.z, u.z*v.x - u.x*v.z, -(u.y*v.x) + u.x*v.y)
#
#class Main
#
#  init: () =>
#
#    @top = new CoffeeGL.Node()
#
#    req = new CoffeeGL.Request('5-plane-from-polygonstested.glsl')
#    req.get (data) =>
#      @shader = new CoffeeGL.Shader(data)
#      @shader.bind()
#      @shader.setUniform3v("uAmbientLightingColor", new CoffeeGL.Colour.RGB(0.025, 0.025, 0.025))
#
#    @camera = new CoffeeGL.Camera.MousePerspCamera(new CoffeeGL.Vec3(0, 0, 15))
#    @top.add(@camera)
#
#    @light = new CoffeeGL.Light.PointLight(new CoffeeGL.Vec3(0.0,10.0,25.0), new CoffeeGL.Colour.RGB(1.0,1.0,1.0) )
#    @top.add(@light)
#
#    @noise = new CoffeeGL.Noise.Noise()
#
#    polygon = (x, y, z, n) =>
#      step = 2 * Math.PI / n
#      center = new CoffeeGL.Vec3(x, y, z)
#      mesh = new CoffeeGL.TriangleMesh()
#      normals = []
#      for i in [0...n]
#        theta1 = step * i
#        theta2 = step * (i + 1)
#        p1 = CoffeeGL.Vec3.add(center, new CoffeeGL.Vec3(Math.cos(theta1), Math.sin(theta1), 0))
#        p2 = CoffeeGL.Vec3.add(center, new CoffeeGL.Vec3(Math.cos(theta2), Math.sin(theta2), 0))
#        n1 = @noise.simplex3(p1.x, p1.y, p1.z) / 100
#        n2 = @noise.simplex3(p2.x, p2.y, p2.z) / 100
#        [p1.x, p1.y, p1.z] = [p1.x + n1, p1.y + n1, p1.z + n1]
#        [p2.x, p2.y, p2.z] = [p2.x + n2, p2.y + n2, p2.z + n2]
#        v1 = new CoffeeGL.Vertex(center, new CoffeeGL.Colour.RGBA.WHITE())
#        v2 = new CoffeeGL.Vertex(p1, new CoffeeGL.Colour.RGBA.WHITE())
#        v3 = new CoffeeGL.Vertex(p2, new CoffeeGL.Colour.RGBA.WHITE())
#        normal = normalize3(cross3(CoffeeGL.Vec3.sub(p1, center), CoffeeGL.Vec3.sub(p2, center)))
#        normals.push(normal)
#        t = new CoffeeGL.Triangle(v1,v2,v3)
#        mesh.addTriangle(t)
#      new CoffeeGL.Node(mesh)
#
#
#
#    p1 = polygon(0, 0, 0, 5)
#    p1.add(@light)
#    p2 = polygon(1, 0, 0, 5)
#    console.log(p1, p2)
#    p2.add(@light)
#    @top.add(p1)
#    @top.add(p2)
#
#    testPolygons =
#      for x in [-2..2]
#        for y in [-2..2]
#          @top.add(polygon(x, y, 0, 5))

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
#
#    @top.add(@cube)
#
#  GL.enable GL.CULL_FACE
#  GL.cullFace GL.BACK
#  GL.enable GL.DEPTH_TEST
#
#  update: (dt) =>
#    #@light.pos = @camera.pos
#
#  draw: () =>
#    GL.clearColor(0.15, 0.15, 0.15, 1.0)
#    GL.clear(GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT)
#
#    @top.draw() if @top?
#
#main = new Main()
#cgl = new CoffeeGL.App('webgl-canvas', main, main.init, main.draw, main.update)
