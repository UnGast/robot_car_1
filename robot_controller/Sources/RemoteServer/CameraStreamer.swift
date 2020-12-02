import RobotControllerBase
import GStreamer
import RemoteProtocol

public class CameraStreamer {
  //private let camera: Camera
  private let pipeline: Pipeline
  private let bus: Bus
  private let source: GStreamer.Element
  public let host: String
  public private(set) var port: UInt = 5000
  public private(set) var codec: CameraStreamCodec = .h263

  public init(host: String, source: GStreamer.Element) {
    self.host = host
    self.source = source
    
    pipeline = Pipeline() // try! Pipeline(parse: "videotestsrc is-live=true ! x264enc bitrate=100  ! rtph264pay ! udpsink host=127.0.0.1 port=\(port)")
    bus = pipeline.getBus()

    let sink = try! Bin(parse: "videoconvert ! x264enc bitrate=100  ! rtph264pay ! udpsink host=127.0.0.1 port=\(port)")

    pipeline.add(source, sink)

    GStreamer.link(source, sink)

    /*let encoder = AVEncH263()
    let sink = TcpServerSink(host: "0.0.0.0", port: Int(port))

    pipeline.add(source)
    pipeline.add(encoder)
    pipeline.add(sink)

    source.link(to: encoder)
    encoder.link(to: sink)*/
  }

  public func startStream() {
    try! pipeline.setState(.playing)
    print("START STREAM")
    bus.popAllPrintErrors()
  }
}