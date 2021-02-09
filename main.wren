import "dome" for Window
import "graphics" for Canvas, Color
import "input" for Keyboard
import "math" for Vector

class Game {
  static paddleWidth { Canvas.width / 20 } 
  static paddleHeight { Canvas.height / 4.5 }
  static gameSpeed { 7 }
  static ballSize { 7 }
  static startingBall {
    var sqrtTwo = Vector.new(1, 1).length
    return {
      "x": (Canvas.width + ballSize) / 2, 
      "y": (Canvas.height + ballSize) / 2,
      "xdir": gameSpeed / sqrtTwo,
      "ydir": gameSpeed / sqrtTwo,
    }
  }

  static init() { 
    Window.title = "Pong!"
    System.print("Width: %(Canvas.width), Height: %(Canvas.height)")
    __paddleLeftY = 0
    __paddleRightY = 100
    __ball = startingBall
    __playerScore = 0
    __AIScore = 0
  }

  static update() {
    var playerBottom = __paddleLeftY + paddleHeight
    var aiBottom = __paddleRightY + paddleHeight

    if (__paddleRightY + paddleHeight / 2 < __ball["y"]) {
      __paddleRightY = __paddleRightY + gameSpeed - 2
    }


    if (__paddleRightY + paddleHeight / 2 > __ball["y"]) {
      __paddleRightY = __paddleRightY - gameSpeed + 2
    }

    if (Keyboard.isKeyDown("Up") && __paddleLeftY > 0) {
      __paddleLeftY = __paddleLeftY - gameSpeed
    }

    if (Keyboard.isKeyDown("Down") && __paddleLeftY + paddleHeight < Canvas.height) {
      __paddleLeftY = __paddleLeftY + gameSpeed
    }

    if (__ball["x"] + ballSize > Canvas.width) {
      // __ball["xdir"] = -__ball["xdir"]
      __playerScore = __playerScore + 1
      __ball = startingBall
    }

    if (__ball["y"] + ballSize > Canvas.height) {
      __ball["ydir"] = -__ball["ydir"]
    }

    if (__ball["x"] < 0) {
      __AIScore = __AIScore + 1
      __ball = startingBall
    }

    if (__ball["y"] < 0) {
      __ball["ydir"] = -__ball["ydir"]
    }

    if (__paddleLeftY < __ball["y"] && __ball["y"] < playerBottom && __ball["x"] < 10 + paddleWidth) {
      __ball["xdir"] = -__ball["xdir"]
    }

    if (__paddleRightY < __ball["y"] && __ball["y"] < aiBottom && __ball["x"] > Canvas.width - 10 - paddleWidth) {
      __ball["xdir"] = -__ball["xdir"]
    }

    __ball["x"] = __ball["x"] + __ball["xdir"]  
    __ball["y"] = __ball["y"] + __ball["ydir"]  
  }

  static draw(alpha) {
    Canvas.cls()
    Canvas.rectfill(10, __paddleLeftY, paddleWidth, paddleHeight, Color.white)
    Canvas.rectfill(Canvas.width - 10 - paddleWidth, __paddleRightY, paddleWidth, paddleHeight, Color.white)
    Canvas.circlefill(__ball["x"], __ball["y"], ballSize, Color.white)
    Canvas.print(__playerScore, 100, 50, Color.white)
    Canvas.print(__AIScore, 220, 50, Color.white)
  }
}
