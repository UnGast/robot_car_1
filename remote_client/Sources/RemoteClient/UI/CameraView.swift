import SwiftGUI
import RemoteProtocol
import GStreamer

public class CameraView: SingleChildWidget {
  @Inject
  private var store: Store

  override public func buildChild() -> Widget {
    ObservingBuilder(store.$state.compute { $0.cameras }) { [unowned self] in
      Column {
        store.state.cameras.map { buildCamera($0) }
      }
    }
  }

  private func buildCamera(_ camera: CameraInfo) -> Widget {
    Row { [unowned self] in
      Text("Name: \(camera.name)")

      Button {
        Text("stream!")
      } onClick: { _ in
        stream(camera)
      }
    }
  }

  private func stream(_ camera: CameraInfo) {
    let pipeline = Pipeline()

    let source = TcpClientSource(host: "127.0.0.1", port: camera.streamPort)
    let parser = H263Parse()
    let decoder = AVDecH263()
    let sink = AutoVideoSink(sync: false)

    pipeline.add(source)
    pipeline.add(parser)
    pipeline.add(decoder)
    pipeline.add(sink)

    source.link(to: parser)
    parser.link(to: decoder)
    decoder.link(to: sink)

    try! pipeline.play()
  }
}