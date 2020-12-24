import NvidiaJetsonGPIO
import RobotControllerBase
import GStreamer
import RemoteProtocol

public class NvidiaJetsonNanoRobotController: RobotController {
  private var motor1EnablePin = 50
  private var motor1ForwardPin = 14
  private var motor1BackwardPin = 194
  private var motor2EnablePin = 18
  private var motor2ForwardPin = 16
  private var motor2BackwardPin = 17

  public init() {
    super.init(gpioController: NvidiaJetsonGPIOController())
    cameras = ["one": Camera(id: "one", name: "the one camera")]
    try! gpioController.set(gpioId: motor1EnablePin, direction: .output)
    try! gpioController.set(gpioId: motor1EnablePin, value: .high)
    try! gpioController.set(gpioId: motor1ForwardPin, direction: .output)
    try! gpioController.set(gpioId: motor1ForwardPin, value: .high)
    try! gpioController.set(gpioId: motor1BackwardPin, direction: .output)
    try! gpioController.set(gpioId: motor2EnablePin, direction: .output)
    try! gpioController.set(gpioId: motor2ForwardPin, direction: .output)
    try! gpioController.set(gpioId: motor2BackwardPin, direction: .output)
  }

  override open func getCameraStreamSource(id cameraId: String) -> GStreamer.Element {
    let source = try! GStreamer.Bin(parse: "nvarguscamerasrc ! video/x-raw(memory:NVMM),width=720, height=480,format=NV12, framerate=30/1 ! videoconvert ! videoscale ! videorate ! video/x-raw,width=200,height=200,framerate=10/1")
    return source
  }

  override open func updateMotionState(_ motionState: MotionState) {
    print("UPDATE MOTION STATE", motionState)
  }
}