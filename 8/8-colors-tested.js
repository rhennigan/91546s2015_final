// Generated by CoffeeScript 1.9.1
(function() {
  var DrawingPad, refreshRate,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  refreshRate = 5;

  DrawingPad = (function() {
    function DrawingPad() {
      this.refresh = bind(this.refresh, this);
      this.getCanvas();
      this.clearCanvas();
      this.refresh();
      this.initialize();
      this.getMousePos = (function(_this) {
        return function(event) {
          var rect;
          rect = _this.canvas.getBoundingClientRect();
          return {
            x: event.clientX - rect.left,
            y: event.clientY - rect.top
          };
        };
      })(this);
      this.canvas.addEventListener("mousedown", (function(_this) {
        return function(e) {
          switch (_this.mode) {
            case "DRAW":
              _this.dragging = true;
              _this.startDrag = _this.getMousePos(e);
              console.log(_this.startDrag);
              return _this.modified = true;
          }
        };
      })(this));
      this.canvas.addEventListener("mousemove", (function(_this) {
        return function(e) {
          var index, p;
          if (_this.dragging) {
            switch (_this.mode) {
              case "DRAW":
                p = _this.getMousePos(e);
                index = (p.x + p.y * _this.canvas.width) * 4;
                _this.imageData[index] = 1;
                _this.imageData[index + 1] = 1;
                _this.imageData[index + 2] = 1;
                _this.imageData[index + 3] = 1;
                _this.modified = true;
            }
          }
          return _this.canvas.addEventListener("mouseup", function(e) {
            _this.dragging = false;
            return _this.refresh();
          });
        };
      })(this));
    }

    DrawingPad.prototype.refresh = function() {
      this.clearCanvas();
      this.drawingContext.putImageData(this.imageData, 0, 0);
      return this.modified = false;
    };

    DrawingPad.prototype.clearCanvas = function() {
      this.drawingContext.clearRect(0, 0, this.canvas.width, this.canvas.height);
      this.imageData = this.drawingContext.getImageData(0, 0, this.canvas.width, this.canvas.height);
      this.drawingContext.putImageData(this.imageData, 0, 0);
      return this.modified = true;
    };

    DrawingPad.prototype.getCanvas = function() {
      this.modified = false;
      this.canvas = document.getElementById('canvas');
      this.drawingContext = this.canvas.getContext('2d');
      this.mode = "DRAW";
      this.imageData = this.drawingContext.createImageData(canvas.width, canvas.height);
      console.log(this.imageData);
      this.refreshRate = 5;
      setInterval(this.refresh, this.refreshRate);
      return this.refresh();
    };

    DrawingPad.prototype.initialize = function() {};

    return DrawingPad;

  })();

  window.drawingPad = new DrawingPad();

}).call(this);

//# sourceMappingURL=8-colors-tested.js.map
