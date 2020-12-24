import BaseGPIO
import RobotControllerBase
import GStreamer
import RemoteProtocol

public class MockRobotController: RobotController {
  public init() {
    super.init(gpioController: MockGPIOController())
    cameras = ["one": Camera(id: "one", name: "the one camera")]
  }

  override open func getCameraStreamSource(id cameraId: String) -> GStreamer.Element {
    return VideoTestSource()
  }

  override open func updateMotionState(_ motionState: MotionState) {
    print("updating motion state to", motionState)
  }
}