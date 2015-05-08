// Generated by CoffeeScript 1.9.1
(function() {
  var EPS, LineSegment, RAD, Vec2, Vec3, Vec4, ZPLANE, add3, cgl, coplanar, cross3, cross4, det3, det4, dot3, draw, init, intersection_params, intersection_point, mul3, norm3, normalize3, sc_mul3, sub3;

  EPS = 0.00001;

  ZPLANE = -10;

  Vec2 = CoffeeGL.Vec2;

  Vec3 = CoffeeGL.Vec3;

  Vec4 = CoffeeGL.Vec4;

  LineSegment = (function() {
    function LineSegment(p11, p21, c11, c21) {
      var gl;
      this.p1 = p11;
      this.p2 = p21;
      this.c1 = c11;
      this.c2 = c21;
      if (this.c1 == null) {
        this.c1 = new CoffeeGL.Colour.RGBA.WHITE();
      }
      if (this.c2 == null) {
        this.c2 = new CoffeeGL.Colour.RGBA.WHITE();
      }
      this.v = [new CoffeeGL.Vertex(this.p1, this.c1), new CoffeeGL.Vertex(this.p2, this.c2)];
      gl = CoffeeGL.Context.gl;
      this.layout = gl.LINES;
    }

    LineSegment.prototype.parametric = function(t) {
      var p1, p2;
      p1 = sc_mul3(this.p1, 1 - t);
      p2 = sc_mul3(this.p2, t);
      return add3(p1, p2);
    };

    return LineSegment;

  })();

  add3 = function(u, v) {
    return new Vec3(u.x + v.x, u.y + v.y, u.z + v.z);
  };

  sub3 = function(u, v) {
    return new Vec3(u.x - v.x, u.y - v.y, u.z - v.z);
  };

  sc_mul3 = function(v, s) {
    return new Vec3(v.x * s, v.y * s, v.z * s);
  };

  mul3 = function(u, v) {
    return new Vec3(u.x * v.x, u.y * v.y, u.z * v.z);
  };

  dot3 = function(u, v) {
    return u.x * v.x + u.y * v.y + u.z * v.z;
  };

  norm3 = function(v) {
    return Math.sqrt(v.x * v.x + v.y * v.y + v.z * v.z);
  };

  normalize3 = function(v) {
    return sc_mul3(v, 1 / norm3(v));
  };

  det3 = function(u, v, w) {
    return -(u.z * v.y * w.x) + u.y * v.z * w.x + u.z * v.x * w.y - u.x * v.z * w.y - u.y * v.x * w.z + u.x * v.y * w.z;
  };

  det4 = function(u, v, w, x) {
    return -u.z * v.y * w.x * x.w + u.y * v.z * w.x * x.w + u.z * v.x * w.y * x.w - u.x * v.z * w.y * x.w - u.y * v.x * w.z * x.w + u.x * v.y * w.z * x.w + u.z * v.y * w.w * x.x - u.y * v.z * w.w * x.x - u.z * v.w * w.y * x.x + u.w * v.z * w.y * x.x + u.y * v.w * w.z * x.x - u.w * v.y * w.z * x.x - u.z * v.x * w.w * x.y + u.x * v.z * w.w * x.y + u.z * v.w * w.x * x.y - u.w * v.z * w.x * x.y - u.x * v.w * w.z * x.y + u.w * v.x * w.z * x.y + u.y * v.x * w.w * x.z - u.x * v.y * w.w * x.z - u.y * v.w * w.x * x.z + u.w * v.y * w.x * x.z + u.x * v.w * w.y * x.z - u.w * v.x * w.y * x.z;
  };

  cross3 = function(u, v) {
    return new Vec3(-(u.z * v.y) + u.y * v.z, u.z * v.x - u.x * v.z, -(u.y * v.x) + u.x * v.y);
  };

  cross4 = function(u, v, w) {
    var x1, x2, x3, x4;
    x1 = -(u.z * v.y * w.w) + u.y * v.z * w.w + u.z * v.w * w.y - u.w * v.z * w.y - u.y * v.w * w.z + u.w * v.y * w.z;
    x2 = u.z * v.x * w.w - u.x * v.z * w.w - u.z * v.w * w.x + u.w * v.z * w.x + u.x * v.w * w.z - u.w * v.x * w.z;
    x3 = -(u.y * v.x * w.w) + u.x * v.y * w.w + u.y * v.w * w.x - u.w * v.y * w.x - u.x * v.w * w.y + u.w * v.x * w.y;
    x4 = u.z * v.y * w.x - u.y * v.z * w.x - u.z * v.x * w.y + u.x * v.z * w.y + u.y * v.x * w.z - u.x * v.y * w.z;
    return new Vec4(x1, x2, x3, x4);
  };

  coplanar = function(line1, line2) {
    var ref, u1, u2, v1, v2;
    u1 = new Vec4(line1.p1.x, line1.p1.y, line1.p1.z, 1);
    v1 = new Vec4(line1.p2.x, line1.p2.y, line1.p2.z, 1);
    u2 = new Vec4(line2.p1.x, line2.p1.y, line2.p1.z, 1);
    v2 = new Vec4(line2.p2.x, line2.p2.y, line2.p2.z, 1);
    return (-EPS < (ref = det4(u1, v1, u2, v2)) && ref < EPS);
  };

  intersection_params = function(line1, line2) {
    var a1, a2, b1, b2, c1, c2, n1, n2, ref, ref1, s1, s2, x1, x2, x3, x4;
    if (!coplanar(line1, line2)) {
      return null;
    } else {
      ref = [line1.p1, line1.p2], x1 = ref[0], x2 = ref[1];
      ref1 = [line2.p1, line2.p2], x3 = ref1[0], x4 = ref1[1];
      a1 = sub3(x2, x1);
      b1 = sub3(x4, x3);
      c1 = sub3(x3, x1);
      n1 = norm3(cross3(a1, b1));
      s1 = dot3(cross3(c1, b1), cross3(a1, b1)) / (n1 * n1);
      a2 = b1;
      b2 = a1;
      c2 = sc_mul3(c1, -1);
      n2 = n1;
      s2 = dot3(cross3(c2, b2), cross3(a2, b2)) / (n2 * n2);
      return [s1, s2];
    }
  };

  intersection_point = function(line1, line2) {
    var ref, s1, s2;
    ref = intersection_params(line1, line2), s1 = ref[0], s2 = ref[1];
    if ((0 <= s1 && s1 <= 1) && (0 <= s2 && s2 <= 1)) {
      return line1.parametric(s1);
    } else {
      return null;
    }
  };

  RAD = 200;

  init = function() {
    var i, j, k, l, len, len1, line, lines, m, o, p, polygon, q, r, random_line, ref, ref1, ref2, ref3, s, vert;
    this.top_node = new CoffeeGL.Node();
    r = new CoffeeGL.Request('5-plane-from-polygonstested.glsl');
    r.get((function(_this) {
      return function(data) {
        var shader;
        shader = new CoffeeGL.Shader(data);
        return shader.bind();
      };
    })(this));
    random_line = function() {
      var c1, c2, line, p1, p2;
      p1 = new Vec3(Math.random() * 500, Math.random() * 500, ZPLANE);
      p2 = new Vec3(Math.random() * 500, Math.random() * 500, ZPLANE);
      c1 = new CoffeeGL.Colour.RGBA(Math.random(), Math.random(), Math.random(), Math.random());
      c2 = new CoffeeGL.Colour.RGBA(Math.random(), Math.random(), Math.random(), Math.random());
      line = new LineSegment(p1, p2, c1, c2);
      return line;
    };
    polygon = function(n) {
      var i, k, mesh, p1, p2, ref, results, step, theta1, theta2;
      mesh = new CoffeeGL.TriangleMesh(true);
      step = 2 * Math.PI / n;
      results = [];
      for (i = k = 0, ref = n; 0 <= ref ? k < ref : k > ref; i = 0 <= ref ? ++k : --k) {
        theta1 = step * i;
        theta2 = step * (i + 1 + EPS);
        p1 = new Vec3(RAD * Math.cos(theta1) + 250, RAD * Math.sin(theta1) + 250, ZPLANE);
        p2 = new Vec3(RAD * Math.cos(theta2) + 250, RAD * Math.sin(theta2) + 250, ZPLANE);
        results.push(new LineSegment(p1, p2));
      }
      return results;
    };
    lines = polygon(Math.floor(Math.random() * 10) + 3);
    for (k = 0, len = lines.length; k < len; k++) {
      line = lines[k];
      this.top_node.add(new CoffeeGL.Node(line));
    }
    console.log(lines);
    for (i = l = 1; l <= 10; i = ++l) {
      line = random_line();
      lines.push(line);
      this.top_node.add(new CoffeeGL.Node(line));
    }
    for (i = m = 0, ref = lines.length; 0 <= ref ? m < ref : m > ref; i = 0 <= ref ? ++m : --m) {
      line = lines[i];
      for (j = o = ref1 = i, ref2 = lines.length; ref1 <= ref2 ? o < ref2 : o > ref2; j = ref1 <= ref2 ? ++o : --o) {
        p = intersection_point(line, lines[j]);
        if (p) {
          p.z = ZPLANE + 1;
          s = new CoffeeGL.Shapes.Sphere(5, 10, p);
          ref3 = s.v;
          for (q = 0, len1 = ref3.length; q < len1; q++) {
            vert = ref3[q];
            vert.c.b = 0;
            vert.c.g = 0;
            vert.c.a = 0.5;
          }
          this.top_node.add(new CoffeeGL.Node(s));
        }
      }
    }
    this.camera = new CoffeeGL.Camera.OrthoCamera(new Vec3(0, 0, 0.2), new Vec3(0, 0, 0));
    this.camera.far = 100;
    this.top_node.add(this.camera);
    GL.enable(GL.DEPTH_TEST);
    GL.enable(GL.BLEND);
    return GL.blendFunc(GL.SRC_ALPHA, GL.ONE_MINUS_SRC_ALPHA);
  };

  draw = function() {
    var ref;
    GL.clearColor(0.15, 0.15, 0.15, 1.0);
    GL.clear(GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT);
    return (ref = this.top_node) != null ? ref.draw() : void 0;
  };

  cgl = new CoffeeGL.App('webgl-canvas', this, init, draw);

}).call(this);

//# sourceMappingURL=5-plane-from-polygonstested.js.map
