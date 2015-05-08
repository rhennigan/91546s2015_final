// Generated by CoffeeScript 1.9.1
(function() {
  var BLUE, GRAY, GREEN, Main, RED, cgl, cross3, main, norm3, normalize3, sc_mul3,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  RED = new CoffeeGL.Colour.RGB(0.839216, 0.290196, 0.152941);

  GREEN = new CoffeeGL.Colour.RGB(0.4, 0.796078, 0.223529);

  BLUE = new CoffeeGL.Colour.RGB(0.0470588, 0.352941, 0.505882);

  GRAY = new CoffeeGL.Colour.RGB(0.556863, 0.678431, 0.670588);

  sc_mul3 = function(v, s) {
    return new CoffeeGL.Vec3(v.x * s, v.y * s, v.z * s);
  };

  norm3 = function(v) {
    return Math.sqrt(v.x * v.x + v.y * v.y + v.z * v.z);
  };

  normalize3 = function(v) {
    return sc_mul3(v, 1 / norm3(v));
  };

  cross3 = function(u, v) {
    return new CoffeeGL.Vec3(-(u.z * v.y) + u.y * v.z, u.z * v.x - u.x * v.z, -(u.y * v.x) + u.x * v.y);
  };

  Main = (function() {
    function Main() {
      this.draw = bind(this.draw, this);
      this.update = bind(this.update, this);
      this.init = bind(this.init, this);
    }

    Main.prototype.init = function() {
      var p1, p2, polygon, req, testPolygons, x, y;
      this.top = new CoffeeGL.Node();
      req = new CoffeeGL.Request('5-plane-from-polygonstested.glsl');
      req.get((function(_this) {
        return function(data) {
          _this.shader = new CoffeeGL.Shader(data);
          _this.shader.bind();
          return _this.shader.setUniform3v("uAmbientLightingColor", new CoffeeGL.Colour.RGB(0.025, 0.025, 0.025));
        };
      })(this));
      this.camera = new CoffeeGL.Camera.MousePerspCamera(new CoffeeGL.Vec3(0, 0, 15));
      this.top.add(this.camera);
      this.light = new CoffeeGL.Light.PointLight(new CoffeeGL.Vec3(0.0, 10.0, 25.0), new CoffeeGL.Colour.RGB(1.0, 1.0, 1.0));
      this.top.add(this.light);
      this.noise = new CoffeeGL.Noise.Noise();
      polygon = (function(_this) {
        return function(x, y, z, n) {
          var center, i, j, mesh, n1, n2, normal, normals, p1, p2, ref, ref1, ref2, step, t, theta1, theta2, v1, v2, v3;
          step = 2 * Math.PI / n;
          center = new CoffeeGL.Vec3(x, y, z);
          mesh = new CoffeeGL.TriangleMesh();
          normals = [];
          for (i = j = 0, ref = n; 0 <= ref ? j < ref : j > ref; i = 0 <= ref ? ++j : --j) {
            theta1 = step * i;
            theta2 = step * (i + 1);
            p1 = CoffeeGL.Vec3.add(center, new CoffeeGL.Vec3(Math.cos(theta1), Math.sin(theta1), 0));
            p2 = CoffeeGL.Vec3.add(center, new CoffeeGL.Vec3(Math.cos(theta2), Math.sin(theta2), 0));
            n1 = _this.noise.simplex3(p1.x, p1.y, p1.z) / 100;
            n2 = _this.noise.simplex3(p2.x, p2.y, p2.z) / 100;
            ref1 = [p1.x + n1, p1.y + n1, p1.z + n1], p1.x = ref1[0], p1.y = ref1[1], p1.z = ref1[2];
            ref2 = [p2.x + n2, p2.y + n2, p2.z + n2], p2.x = ref2[0], p2.y = ref2[1], p2.z = ref2[2];
            v1 = new CoffeeGL.Vertex(center, new CoffeeGL.Colour.RGBA.WHITE());
            v2 = new CoffeeGL.Vertex(p1, new CoffeeGL.Colour.RGBA.WHITE());
            v3 = new CoffeeGL.Vertex(p2, new CoffeeGL.Colour.RGBA.WHITE());
            normal = normalize3(cross3(CoffeeGL.Vec3.sub(p1, center), CoffeeGL.Vec3.sub(p2, center)));
            normals.push(normal);
            t = new CoffeeGL.Triangle(v1, v2, v3);
            mesh.addTriangle(t);
          }
          return new CoffeeGL.Node(mesh);
        };
      })(this);
      p1 = polygon(0, 0, 0, 5);
      p2 = polygon(1, 0, 0, 5);
      console.log(p1, p2);
      this.top.add(p1);
      this.top.add(p2);
      return testPolygons = (function() {
        var j, results;
        results = [];
        for (x = j = -2; j <= 2; x = ++j) {
          results.push((function() {
            var k, results1;
            results1 = [];
            for (y = k = -2; k <= 2; y = ++k) {
              results1.push(this.top.add(polygon(x, y, 0, 5)));
            }
            return results1;
          }).call(this));
        }
        return results;
      }).call(this);
    };

    Main.prototype.update = function(dt) {
      return this.light.pos = this.camera.pos;
    };

    Main.prototype.draw = function() {
      GL.clearColor(0.15, 0.15, 0.15, 1.0);
      GL.clear(GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT);
      if (this.top != null) {
        return this.top.draw();
      }
    };

    return Main;

  })();

  main = new Main();

  cgl = new CoffeeGL.App('webgl-canvas', main, main.init, main.draw, main.update);

}).call(this);

//# sourceMappingURL=5-plane-from-polygonstested.js.map
