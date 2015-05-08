
class Main

  init: () =>

    @top = new CoffeeGL.Node()

    req = new CoffeeGL.Request('4-projected-cube-tested.glsl')
    req.get (data) =>
      @shader = new CoffeeGL.Shader(data)
      @shader.bind()
      @shader.setUniform3v("uMaterialAmbientColor")

main = new Main()
cgl = new CoffeeGL.App('webgl-canvas', main, main.init, main.draw, main.update)
