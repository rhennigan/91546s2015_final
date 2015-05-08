class SVGContainer

  blue = 'rgb(12, 90, 129)'
  orange = 'rgb(214, 74, 39)'
  gray = 'rgb(142, 173, 171)'
  green = 'rgb(102, 203, 57)'
  stroke = '0.01'
  svg=document.getElementById("svgcontainer")

  constructor: () ->
    @n = 5
    @r = 0.75

  createSVGLine = (p1, p2, c, d) ->
    line = document.createElementNS('http://www.w3.org/2000/svg', 'line')
    line.setAttribute('x1', p1.x)
    line.setAttribute('y1', p1.y)
    line.setAttribute('x2', p2.x)
    line.setAttribute('y2', p2.y)
    line.setAttribute('stroke-width', stroke)
    line.setAttribute('stroke', c)
    if d then line.setAttribute('stroke-dasharray', "0.025, 0.025")
    line

  createSVGCircle = (cx, cy, r) ->
    circle = document.createElementNS('http://www.w3.org/2000/svg', 'circle')
    circle.setAttribute('cx', cx)
    circle.setAttribute('cy', cy)
    circle.setAttribute('r', r)
    circle.setAttribute('fill', 'none')
    circle.setAttribute('stroke', orange)
    circle.setAttribute('stroke-width', stroke)
    circle

  createSVGText = (text, x, y, s, c) ->
    label = document.createElementNS('http://www.w3.org/2000/svg', 'text')
    label.setAttribute('x', x)
    label.setAttribute('y', y)
    label.setAttribute('fill', c)
    label.setAttribute('font-size', s)
    label.setAttribute('font-family', 'helvetica')
    label.setAttribute('style', 'font-weight:bold')
    label.innerHTML = text
    label

  drawImage: () ->
    s = 1.5-@r
    circle = createSVGCircle(@r+s, @r+s, @r)
    svg.appendChild(circle)

    ex = 0
    ey = 0

    for i in [0..@n]
      p1 = {x: @r*Math.cos(i*(2*Math.PI)/@n)+@r+s, y:@r*Math.sin(i*(2*Math.PI)/@n)+@r+s}
      p2 = {x: @r*Math.cos((i+1)*(2*Math.PI)/@n)+@r+s, y:@r*Math.sin((i+1)*(2*Math.PI)/@n)+@r+s}

      p_line = createSVGLine(p1, p2, blue, false)
      svg.appendChild(p_line)

      p3 = {x:(p1.x + p2.x)/2, y:(p1.y + p2.y)/2}
      c_line = createSVGLine({x:@r+s, y:@r+s}, p3, blue, false)
      svg.appendChild(c_line)

      x = p3.x - 1.5
      y = p3.y - 1.5
      norm = Math.sqrt(x*x + y*y)
      ex = @r*x/norm + 1.5
      ey = @r*y/norm + 1.5
      p4 = {x:ex, y:ey}
      e_line = createSVGLine(p3, p4, gray, true)
      svg.appendChild(e_line)

    svg.appendChild(createSVGLine({x:@r+s, y:@r+s}, {x:2*@r+s, y:@r+s}, green, true))

    svg.appendChild(createSVGText("n = #{@n}", 0.1, 0.1, '0.1px', 'black'))

    svg.appendChild(createSVGText('r', @r+1.3, @r-.05+s, '0.1px', green))

    tx = Math.cos(Math.PI/@n) + @r
    ty = Math.sin(Math.PI/@n) + @r
    eps = Math.round(1000*(@r - @r*Math.cos(Math.PI / @n)))/1000
    svg.appendChild(createSVGText("&epsilon; = r - r cos(&pi;/n)", ex+.05, ey+.05, '0.075px', gray))
    svg.appendChild(createSVGText("&nbsp;&nbsp; = #{eps}", ex+.05, ey+.05+.15, '0.075px', gray))


  clearImage: () ->
    while svg.childElementCount > 0
      svg.removeChild(svg.firstChild)

c = new SVGContainer()
c.drawImage()

g = new dat.GUI()
nc = g.add(c, 'n', 3, 50).step(1)
rc = g.add(c, 'r', 0.4, 1.75)
nc.onChange( =>
  c.clearImage()
  c.drawImage()
)
rc.onChange( =>
  c.clearImage()
  c.drawImage()
)
