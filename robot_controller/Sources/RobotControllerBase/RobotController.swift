import BaseGPIO

open class RobotController {
  open var gpioController: GPIOController

  public init(gpioController: GPIOController) {
    self.gpioController = gpioController
  }
}