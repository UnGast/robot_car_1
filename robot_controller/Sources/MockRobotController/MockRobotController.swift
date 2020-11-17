import BaseGPIO
import RobotControllerBase

public class MockRobotController: RobotController {
  public init() {
    super.init(gpioController: MockGPIOController())
  }
}