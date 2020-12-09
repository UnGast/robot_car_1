import RobotControllerBase
import GStreamer
import RemoteProtocol

open class CameraStreamer {
  //private let camera: Camera
  private let pipeline: Pipeline
  private let bus: Bus
  private let source: GStreamer.Element
  public let host: String
  public private(set) var port: Int = 5000
  public private(set) var codec: CameraStreamCodec = .h263

  public private(set) var state: State = .Uninitialized

  required public init(host: String, source: GStreamer.Element) {
    self.host = host
    self.source = source
    
    pipeline = Pipeline() // try! Pipeline(parse: " !  ! tcpserversink host=10.0.0.3 port=5000") // try! Pipeline(parse: "videotestsrc is-live=true ! x264enc bitrate=100  ! rtph264pay ! udpsink host=127.0.0.1 port=\(port)")
    bus = pipeline.getBus()

    try! setup()
  }

  open func buildEncoder() -> GStreamer.Element {
    fatalError("buildEncoder() not implemented")
  }

  private func setup() throws {
    if state != .Uninitialized {
      throw Error.IllegalState(message: "streamer must be in uninitialized state to perform setup")
    }
    let encoder = buildEncoder()
    let muxer = Matroskamux()
    let sink = TcpServerSink(host: host, port: port)
    pipeline.add(source, encoder, muxer, sink)
    GStreamer.link(source, encoder, muxer, sink)
    state = .Ready
  }

  public func startStream() throws {
    if state != .Ready {
      throw Error.IllegalState(message: "streamer must be in ready state to start streaming")
    }
    try! pipeline.setState(.playing)
    print("START STREAM")
    bus.popAllPrintErrors()
    state = .Streaming
  }

  internal func destroy() {
    try! pipeline.setState(.null)
    state = .Destroyed
  }
}

extension CameraStreamer {
  public enum State {
    case Uninitialized, Ready, Streaming, Destroyed
  }

  public enum Error: Swift.Error {
    case IllegalState(message: String)
  }
}