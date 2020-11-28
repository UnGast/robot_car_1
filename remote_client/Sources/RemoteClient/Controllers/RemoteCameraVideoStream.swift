import SwiftGUI
import RemoteProtocol
import GStreamer

public class RemoteCameraVideoStream: AppSinkVideoStream {
  private let pipeline: GStreamer.Pipeline
  private let bus: GStreamer.Bus

  public init(camera: CameraInfo) {
    pipeline = Pipeline()
    bus = pipeline.getBus()

    let source = TcpClientSource(host: "127.0.0.1", port: camera.streamPort!)
    let parser = H263Parse()
    let decoder = AVDecH263()
    let converter = VideoConvert()
    let scaler = VideoScale()
    let capsfilter = Capsfilter()
    capsfilter.setCaps(Caps(mediaType: "video/x-raw", format: "RGB", width: 400, height: 400))
    let sink = AppSink()

    //sink.setMaxBuffers(1)
    //sink.setDrop(true)

    pipeline.add(source)
    pipeline.add(parser)
    pipeline.add(decoder)
    pipeline.add(converter)
    pipeline.add(scaler)
    pipeline.add(capsfilter)
    pipeline.add(sink)

    source.link(to: parser)
    parser.link(to: decoder)
    decoder.link(to: converter)
    converter.link(to: scaler)
    scaler.link(to: capsfilter)
    capsfilter.link(to: sink)

    try! pipeline.setState(.playing)

    super.init(sink: sink, size: ISize2(400, 400))

    /*let source = VideoTestSource()
    source.setPattern(.snow)
    let capsfilter = Capsfilter()
    capsfilter.setCaps(Caps(mediaType: "video/x-raw", format: "RGB", width: 400, height: 400))
    let sink = AppSink()
    sink.setMaxBuffers(1)
    sink.setDrop(true)

    pipeline.add(source)
    pipeline.add(capsfilter)
    pipeline.add(sink)

    source.link(to: capsfilter)
    capsfilter.link(to: sink)

    try! pipeline.setState(.playing)*/
  }

  override open func getCurrentFrame() -> UnsafeMutableBufferPointer<UInt8>? {
    let frame = super.getCurrentFrame()
    print("GET FRAME!", frame)
    for message in bus.popAll() {
      print("PEEK THE BUS", message.type, message.data)
    }
    return frame
  }
}