import NvidiaJetsonGPIO
import RobotControllerBase

public class NvidiaJetsonNanoRobotController: RobotController {
  public init() {
    super.init(gpioController: NvidiaJetsonGPIOController())
  }
}