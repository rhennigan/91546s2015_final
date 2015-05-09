refreshRate = 5

class DrawingPad
  constructor: ->
    @getCanvas()
    @clearCanvas()
    @refresh()
    @initialize()


    @getMousePos = (event) =>
      rect = @canvas.getBoundingClientRect()
      x: event.clientX - rect.left
      y: event.clientY - rect.top

    @canvas.addEventListener "mousedown", (e) =>
      switch @mode
        when "DRAW"
          @dragging = true
          @startDrag = @getMousePos(e)
          console.log(@startDrag)
          @modified = true

    @canvas.addEventListener "mousemove", (e) =>
      if @dragging
        switch @mode
          when "DRAW"
            p = @getMousePos(e)
            index = (p.x + p.y * @canvas.width) * 4
            @imageData[index    ] = 1
            @imageData[index + 1] = 1
            @imageData[index + 2] = 1
            @imageData[index + 3] = 1
            @modified = true

      @canvas.addEventListener "mouseup", (e) =>
        @dragging = false
        @refresh()


  refresh: =>
    @clearCanvas()
    @drawingContext.putImageData(@imageData, 0, 0)
    @modified = false

  clearCanvas: ->
    @drawingContext.clearRect 0, 0, @canvas.width, @canvas.height
    @imageData = @drawingContext.getImageData 0, 0, @canvas.width, @canvas.height
    @drawingContext.putImageData @imageData, 0, 0
    @modified = true


  getCanvas: ->
    @modified = false
    @canvas = document.getElementById('canvas')
    @drawingContext = @canvas.getContext '2d'
    @mode = "DRAW"
    @imageData = @drawingContext.createImageData(canvas.width, canvas.height)
    console.log @imageData
    @refreshRate = 5
    setInterval @refresh, @refreshRate
    @refresh()

  initialize: ->



window.drawingPad = new DrawingPad()
