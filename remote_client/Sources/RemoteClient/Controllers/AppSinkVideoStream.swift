import SwiftGUI
import GfxMath
import GStreamer

open class AppSinkVideoStream: VideoStream {
  private let sink: AppSink

  public init(sink: AppSink, size: ISize2) {
    // TODO: read size from sink caps!
    self.sink = sink
    super.init(size: size)
  }

  override open func getCurrentFrame() -> UnsafeMutableBufferPointer<UInt8>? {
    if let sample = sink.pullSample() {
      let buffer = sample.getBuffer()
      let map = buffer.getMap()
      
      let rawData = map.data!

      let frameBuffer = UnsafeMutableBufferPointer<UInt8>.allocate(capacity: size.width * size.height * 3)
      for row in 0..<size.height {
        let resultRowStartIndex = row * size.width * 3
        let rawRowStartIndex = row * size.width * 3 //+ (row * 1)
        for column in 0..<size.width * 3 {
          frameBuffer[resultRowStartIndex + column] = rawData[rawRowStartIndex + column]
        }
      }

      return frameBuffer
    }
    return nil
  } 
}