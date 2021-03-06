// Generated by CoffeeScript 1.9.1
(function() {
  var add3, approx, cross3, exact, i, j, n, noise, norm3, normal, normalize3, p1, p2, sc_mul3, step, sub3, theta1, theta2;

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

  normal = function(vertices) {
    var center, error, i, j, k, l, n, normalVector, normals, ref, ref1, ref2, v1, v2;
    center = new CoffeeGL.Vec3(0, 0, 0);
    n = vertices.length;
    for (i = j = 0, ref = n; 0 <= ref ? j < ref : j > ref; i = 0 <= ref ? ++j : --j) {
      center.x += vertices[i].x;
      center.y += vertices[i].y;
      center.z += vertices[i].z;
    }
    center.x = center.x / n;
    center.y = center.y / n;
    center.z = center.z / n;
    normals = (function() {
      var k, ref1, results;
      results = [];
      for (i = k = 0, ref1 = n - 1; 0 <= ref1 ? k <= ref1 : k >= ref1; i = 0 <= ref1 ? ++k : --k) {
        v1 = sub3(vertices[i], center);
        v2 = sub3(vertices[i + 1], center);
        results.push(normalize3(cross3(v1, v2)));
      }
      return results;
    })();
    normalVector = new CoffeeGL.Vec3(0, 0, 0);
    for (i = k = 0, ref1 = n - 1; 0 <= ref1 ? k < ref1 : k > ref1; i = 0 <= ref1 ? ++k : --k) {
      normalVector.x += normals[i].x;
      normalVector.y += normals[i].y;
      normalVector.z += normals[i].z;
    }
    normalVector.x = normalVector.x / n;
    normalVector.y = normalVector.y / n;
    normalVector.z = normalVector.z / n;
    error = 0;
    for (i = l = 0, ref2 = n; 0 <= ref2 ? l < ref2 : l > ref2; i = 0 <= ref2 ? ++l : --l) {
      error += norm3(sub3(normalVector, normals[i]));
    }
    return {
      A: normalVector.x,
      B: normalVector.y,
      C: normalVector.z,
      D: error < 0.1
    };
  };

  noise = new CoffeeGL.Noise.Noise();

  n = 7;

  step = 2 * Math.PI / n;

  exact = [];

  approx = [];

  for (i = j = 0; j <= 5; i = ++j) {
    theta1 = step * i;
    theta2 = step * (i + 1);
    p1 = new CoffeeGL.Vec3(Math.cos(theta1), Math.sin(theta1), 0);
    p2 = new CoffeeGL.Vec3(Math.cos(theta1), Math.sin(theta1), 0);
    p2.z = noise.simplex2(p2.x, p2.y) / 100.0;
    exact.push(p1);
    approx.push(p2);
  }

  console.log(exact);

  console.log(approx);

  console.log(normal(exact));

  console.log(normal(approx));

}).call(this);

//# sourceMappingURL=5-plane-from-polygons.js.map
