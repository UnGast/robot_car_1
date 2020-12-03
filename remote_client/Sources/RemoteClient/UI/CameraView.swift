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
    Column { [unowned self] in
      Row {
        Text("Name: \(camera.name)")

        Button {
          Text("stream!")
        } onClick: { _ in
          store.dispatch(.RequestCameraStream(cameraId: camera.id))
        }
      }

      Text("CAMREA STREAM \(camera.stream)")

      if camera.stream != nil {
        ConstrainedSize(minSize: DSize2(800, 800)) {
          VideoView(stream: RemoteCameraVideoStream(camera: camera))
        }
      }
    }
  }
}