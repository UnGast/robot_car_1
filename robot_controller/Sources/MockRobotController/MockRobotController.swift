import BaseGPIO
import RobotControllerBase
import GStreamer

public class MockRobotController: RobotController {
  public init() {
    super.init(gpioController: MockGPIOController())
    cameras = ["one": Camera(id: "one", name: "the one camera")]
  }

  override open func getCameraStreamSource(id cameraId: String) -> GStreamer.Element {
    let camera = cameras[cameraId]!
    let bin = GStreamer.Bin()
    let source = GStreamer.VideoTestSource()
    //source.setPattern(.white)
    let capsfilter = GStreamer.Capsfilter()
    return source
  }
}