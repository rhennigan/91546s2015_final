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
      var makePrism, r, ref, ref1, ref2, ref3;
      this.top_node = new CoffeeGL.Node();
      r = new CoffeeGL.Request('6-prism-tested.glsl');
      r.get((function(_this) {
        return function(data) {
          _this.shader = new CoffeeGL.Shader(data);
          _this.shader.bind();
          return _this.shader.setUniform3v("uAmbientLightingColor", new CoffeeGL.Colour.RGB(0.5, 0.5, 0.5));
        };
      })(this));
      this.c = new CoffeeGL.Camera.MousePerspCamera(new CoffeeGL.Vec3(0, 0, 15));
      this.top_node.add(this.c);
      this.light = new CoffeeGL.Light.PointLight(new CoffeeGL.Vec3(0.0, 10.0, 25.0), new CoffeeGL.Colour.RGB(1.0, 1.0, 1.0));
      this.top_node.add(this.light);
      this.quad = new CoffeeGL.Quad();
      ref = [-1, 1, -1], this.quad.v[0].p.x = ref[0], this.quad.v[0].p.y = ref[1], this.quad.v[0].p.z = ref[2];
      ref1 = [-1, -1, -1], this.quad.v[1].p.x = ref1[0], this.quad.v[1].p.y = ref1[1], this.quad.v[1].p.z = ref1[2];
      ref2 = [1, 1, 1], this.quad.v[2].p.x = ref2[0], this.quad.v[2].p.y = ref2[1], this.quad.v[2].p.z = ref2[2];
      ref3 = [1, -1, 1], this.quad.v[3].p.x = ref3[0], this.quad.v[3].p.y = ref3[1], this.quad.v[3].p.z = ref3[2];
      this.nq = new CoffeeGL.Node(this.quad);
      this.nq.add(this.c);
      this.top_node.add(this.nq);
      makePrism = (function(_this) {
        return function(scale) {
          var a, b, c, ref4, v0, v1, v2, v3;
          ref4 = [_this.quad.v[0].p, _this.quad.v[1].p, _this.quad.v[2].p, _this.quad.v[3].p], v0 = ref4[0], v1 = ref4[1], v2 = ref4[2], v3 = ref4[3];
          a = sub3(v1, v0);
          b = sub3(v2, v0);
          c = sc_mul3(normalize3(cross3(a, b)), scale);
          _this.quad2 = new CoffeeGL.Quad();
          _this.quad2.v[0].p = add3(_this.quad.v[0].p, c);
          _this.quad2.v[1].p = add3(_this.quad.v[1].p, c);
          _this.quad2.v[2].p = add3(_this.quad.v[2].p, c);
          _this.quad2.v[3].p = add3(_this.quad.v[3].p, c);
          _this.nq2 = new CoffeeGL.Node(_this.quad2);
          _this.nq2.add(_this.c);
          return _this.top_node.add(_this.nq2);
        };
      })(this);
      makePrism(1);
      makePrism(2);
      return makePrism(3);
    };

    ShapesExample.prototype.update = function(dt) {
      return this.light.pos = this.c.pos;
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

//# sourceMappingURL=6-prism-tested.js.map
