import RobotControllerBase
import GStreamer

public class CameraStreamer {
  //private let camera: Camera
  private let pipeline: Pipeline
  private let source: GStreamer.Element
  public private(set) var streamPort: Int = 3000

  public init(source: GStreamer.Element) {
    self.source = source
    
    pipeline = Pipeline()

    let encoder = AVEncH263()
    let sink = TcpServerSink(host: "0.0.0.0", port: streamPort)

    pipeline.add(source)
    pipeline.add(encoder)
    pipeline.add(sink)

    source.link(to: encoder)
    encoder.link(to: sink)
  }

  public func startStream() {
    try! pipeline.setState(.playing)
  }
}