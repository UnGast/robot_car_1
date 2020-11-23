import BaseGPIO

open class RobotController {
  open var gpioController: GPIOController
  open var cameras: [Camera] = []

  public init(gpioController: GPIOController) {
    self.gpioController = gpioController
  }
}