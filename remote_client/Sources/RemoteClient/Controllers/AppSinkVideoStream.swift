import SwiftGUI
import GfxMath
import GStreamer

open class AppSinkVideoStream: VideoStream {
  internal let sink: AppSink

  public init(sink: AppSink, size: ISize2) {
    // TODO: read size from sink caps!
    self.sink = sink
    super.init(size: size)
  }

  override open func getCurrentFrame() -> Frame? {
    do {
      if try sink.getState() == .playing, let sample = sink.pullSample() {
        // TODO: need to free memory
        print("GOT SAMPLE")

        if let buffer = sample.getBuffer() {

          print("GOT BUFFER")

          let map = buffer.getMap()

          var rawData: AnyRandomAccessCollection<UInt8>? = nil

          if let immutableRawData = map.data {
            rawData = AnyRandomAccessCollection(immutableRawData)
          } else if let mutableRawData = map.mutableData {
            rawData = AnyRandomAccessCollection(mutableRawData)
          }

          if let rawData = rawData {
            let frameData = [UInt8](unsafeUninitializedCapacity: size.width * size.height * 3) { frameDataBuffer, _ in
              for row in 0..<size.height {
                let resultRowStartIndex = row * size.width * 3
                let rawRowStartIndex = row * size.width * 3 //+ (row * 1)
                for column in 0..<size.width * 3 {
                  frameDataBuffer[resultRowStartIndex + column] = rawData[AnyIndex(rawRowStartIndex + column)]
                }
              }
            }

            return VideoStream.Frame(frameData)
          }
        }
      }
    } catch {
      print("error occurred while trying to get frame: \(error)")
    }

    return nil
  } 
}