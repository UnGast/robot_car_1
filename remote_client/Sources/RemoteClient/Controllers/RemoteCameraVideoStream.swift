import SwiftGUI
import RemoteProtocol
import GStreamer

public class RemoteCameraVideoStream: AppSinkVideoStream {
  public init(camera: CameraInfo) {
    let pipeline = Pipeline()

    let source = VideoTestSource()
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

    try! pipeline.setState(.playing)

    super.init(sink: sink, size: ISize2(400, 400))
  }
}