import RobotControllerBase
import GStreamer

public class CameraStreamer {
  private let camera: Camera
  public private(set) var streamPort: Int = 3000

  public init(camera: Camera) {
    self.camera = camera
  }

  public func startStream() {
    let pipeline = Pipeline()

    let source = VideoTestSource()
    let encoder = AVEncH263()
    let sink = TcpServerSink(host: "0.0.0.0", port: streamPort)

    pipeline.add(source)
    pipeline.add(encoder)
    pipeline.add(sink)

    source.link(to: encoder)
    encoder.link(to: sink)

    try! pipeline.play()
  }
}