import SwiftGUI
import GfxMath
import GStreamer

open class AppSinkVideoStream: VideoStream {
  internal let sink: GStreamer.AppSink
  private let sinkPad: GStreamer.Pad

  private var _size: ISize2 = .zero {
    didSet {
      onSizeChanged.invokeHandlers(size)
    }
  }
  override open var size: ISize2 {
    _size
  }
  private var sizeRetrieved: Bool = false

  public init(sink: GStreamer.AppSink) {
    self.sink = sink
    self.sinkPad = sink.sinkPads[0]
  }

  override open func getCurrentFrame() -> Frame? {
    do {
      if try sink.getState() == .playing, let sample = sink.pullSample() {
        // TODO: might need to listen for pad caps change --> update size!!
        if !sizeRetrieved, let capsStructure = sinkPad.caps.getStructure(0) {
          if let width = capsStructure.get("width", Int32.self),
            let height = capsStructure.get("height", Int32.self) {
              _size = ISize2(Int(width), Int(height))
              sizeRetrieved = true
          }
        }

        if !sizeRetrieved {
          return nil
        }

        // TODO: need to free memory
        if let buffer = sample.getBuffer() {
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