import NvidiaJetsonGPIO
import RobotControllerBase
import GStreamer

public class NvidiaJetsonNanoRobotController: RobotController {
  public init() {
    super.init(gpioController: NvidiaJetsonGPIOController())
    cameras = ["one": Camera(id: "one", name: "the one camera")]
  }

  override open func getCameraStreamSource(id cameraId: String) -> GStreamer.Element {
    let source = try! GStreamer.Bin(parse: "nvarguscamerasrc ! video/x-raw(memory:NVMM),width=720, height=480,format=NV12, framerate=30/1 ! videoconvert ! videoscale ! videorate ! video/x-raw,width=200,height=200,framerate=10/1")
    return source
  }
}