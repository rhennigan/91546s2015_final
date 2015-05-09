// Generated by CoffeeScript 1.9.1
(function() {
  var ShapesExample, add3, cgl, cross3, example, norm3, normalize3, sc_mul3, sub3,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  add3 = function(u, v) {
    return new CoffeeGL.Vec3(u.x + v.x, u.y + v.y, u.z + v.z);
  };

  sub3 = function(u, v) {
    return new CoffeeGL.Vec3(u.x - v.x, u.y - v.y, u.z - v.z);
  };

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

  ShapesExample = (function() {
    function ShapesExample() {
      this.draw = bind(this.draw, this);
      this.update = bind(this.update, this);
      this.init = bind(this.init, this);
    }

    ShapesExample.prototype.init = function() {
      var makeTower, r, ref, ref1, ref2, ref3;
      this.top_node = new CoffeeGL.Node();
      r = new CoffeeGL.Request('7-tower-tested.glsl');
      r.get((function(_this) {
        return function(data) {
          _this.shader = new CoffeeGL.Shader(data);
          _this.shader.bind();
          return _this.shader.setUniform3v("uAmbientLightingColor", new CoffeeGL.Colour.RGB(0.5, 0.5, 0.5));
        };
      })(this));
      this.c = new CoffeeGL.Camera.MousePerspCamera(new CoffeeGL.Vec3(0, 0, 5));
      this.top_node.add(this.c);
      this.light1 = new CoffeeGL.Light.PointLight(new CoffeeGL.Vec3(0.0, 10.0, 25.0), new CoffeeGL.Colour.RGB(1.0, 1.0, 1.0));
      this.light2 = new CoffeeGL.Light.PointLight(new CoffeeGL.Vec3(-10, 10.0, 25.0), new CoffeeGL.Colour.RGB(1.0, 1.0, 1.0));
      this.light3 = new CoffeeGL.Light.PointLight(new CoffeeGL.Vec3(0.0, -10.0, -5.0), new CoffeeGL.Colour.RGB(1.0, 1.0, 1.0));
      this.top_node.add(this.light1);
      this.top_node.add(this.light2);
      this.top_node.add(this.light3);
      this.quad = new CoffeeGL.Quad();
      this.quad.v[0].c = new CoffeeGL.Colour.RGBA(1, 0, 0, 1);
      this.quad.v[1].c = new CoffeeGL.Colour.RGBA(1, 1, 0, 1);
      this.quad.v[2].c = new CoffeeGL.Colour.RGBA(1, 0, 1, 1);
      this.quad.v[3].c = new CoffeeGL.Colour.RGBA(0, 1, 1, 1);
      ref = [-1, 1, -1], this.quad.v[0].p.x = ref[0], this.quad.v[0].p.y = ref[1], this.quad.v[0].p.z = ref[2];
      ref1 = [-1, -1, -1], this.quad.v[1].p.x = ref1[0], this.quad.v[1].p.y = ref1[1], this.quad.v[1].p.z = ref1[2];
      ref2 = [1, 1, 1], this.quad.v[2].p.x = ref2[0], this.quad.v[2].p.y = ref2[1], this.quad.v[2].p.z = ref2[2];
      ref3 = [1, -1, 1], this.quad.v[3].p.x = ref3[0], this.quad.v[3].p.y = ref3[1], this.quad.v[3].p.z = ref3[2];
      this.nq = new CoffeeGL.Node(this.quad);
      this.nq.add(this.c);
      this.top_node.add(this.nq);
      console.log(this.quad);
      makeTower = (function(_this) {
        return function(scale, steps) {
          var a, b, c, i, j, n, q, ref4, ref5, ref6, ref7, results, u0, u1, u2, u3, v0, v1, v2, v3;
          ref4 = [_this.quad.v[0].p, _this.quad.v[1].p, _this.quad.v[2].p, _this.quad.v[3].p], v0 = ref4[0], v1 = ref4[1], v2 = ref4[2], v3 = ref4[3];
          results = [];
          for (i = j = 1, ref5 = steps; 1 <= ref5 ? j <= ref5 : j >= ref5; i = 1 <= ref5 ? ++j : --j) {
            a = sub3(v1, v0);
            b = sub3(v2, v0);
            c = sc_mul3(normalize3(cross3(a, b)), scale);
            u0 = add3(add3(sc_mul3(v0, 0.9), sc_mul3(v3, 0.1)), c);
            u1 = add3(add3(sc_mul3(v1, 0.9), sc_mul3(v2, 0.1)), c);
            u2 = add3(add3(sc_mul3(v2, 0.9), sc_mul3(v1, 0.1)), c);
            u3 = add3(add3(sc_mul3(v3, 0.9), sc_mul3(v0, 0.1)), c);
            q = new CoffeeGL.Quad();
            q.v[0].p = u0;
            q.v[1].p = u1;
            q.v[2].p = u2;
            q.v[3].p = u3;
            ref6 = [_this.quad.v[0].c, _this.quad.v[1].c, _this.quad.v[2].c, _this.quad.v[3].c], q.v[0].c = ref6[0], q.v[1].c = ref6[1], q.v[2].c = ref6[2], q.v[3].c = ref6[3];
            n = new CoffeeGL.Node(q);
            n.add(_this.c);
            _this.top_node.add(n);
            results.push((ref7 = [u0, u1, u2, u3], v0 = ref7[0], v1 = ref7[1], v2 = ref7[2], v3 = ref7[3], ref7));
          }
          return results;
        };
      })(this);
      return makeTower(0.25, 8);
    };

    ShapesExample.prototype.update = function(dt) {
      this.light1.pos = this.c.pos;
      this.light2.pos = this.c.pos;
      return this.light3.pos = this.c.pos;
    };

    ShapesExample.prototype.draw = function() {
      GL.clearColor(0.15, 0.15, 0.15, 1.0);
      GL.clear(GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT);
      if (this.top_node != null) {
        return this.top_node.draw();
      }
    };

    return ShapesExample;

  })();

  example = new ShapesExample();

  cgl = new CoffeeGL.App('webgl-canvas', example, example.init, example.draw, example.update);

}).call(this);

//# sourceMappingURL=7-tower-tested.js.map