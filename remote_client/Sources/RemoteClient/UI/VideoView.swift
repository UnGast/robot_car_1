import SwiftGUI
import GStreamer

public class VideoView: Widget {
  private let stream: VideoStream

  public init(stream: VideoStream) {
    self.stream = stream
  }

  override public func getBoxConfig() -> BoxConfig {
    BoxConfig(preferredSize: DSize2(stream.size))
  }

  override public func performLayout(constraints: BoxConstraints) -> DSize2 {
    constraints.constrain(DSize2(stream.size))
  }

  override public func renderContent() -> RenderObject? {
    VideoRenderObject(stream: stream, bounds: globalBounds)
  }
}