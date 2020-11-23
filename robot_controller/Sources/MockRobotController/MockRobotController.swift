import BaseGPIO
import RobotControllerBase

public class MockRobotController: RobotController {
  public init() {
    super.init(gpioController: MockGPIOController())
    cameras = [Camera(id: "one", name: "the one camera")]
  }
}