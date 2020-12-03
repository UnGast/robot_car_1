import BaseGPIO
import RobotControllerBase
import GStreamer

public class MockRobotController: RobotController {
  public init() {
    super.init(gpioController: MockGPIOController())
    cameras = ["one": Camera(id: "one", name: "the one camera")]
  }

  override open func getCameraStreamSource(id cameraId: String) -> GStreamer.Element {
    let source = GStreamer.VideoTestSource()
    source.isLive = true
    //source.setPattern(.white)
    let capsfilter = GStreamer.Capsfilter()
    return source
  }
}