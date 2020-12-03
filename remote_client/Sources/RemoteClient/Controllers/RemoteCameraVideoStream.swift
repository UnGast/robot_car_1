import SwiftGUI
import RemoteProtocol
import GStreamer

public class RemoteCameraVideoStream: AppSinkVideoStream {
  private let pipeline: GStreamer.Pipeline
  private let bus: GStreamer.Bus

  //private let test: GStreamer.Pipeline

  public init(camera: CameraInfo) {
    /*pipeline = Pipeline()
    bus = pipeline.getBus()

    let source = UdpSrc(port: 5000)
    var caps = Caps(mediaType: "application/x-rtp")
    caps.setValue("media", "video")
    caps.setValue("clock-rate", Int32(90000))
    caps.setValue("encoding-name", "H264")
    caps.setValue("payload", Int32(96))
    source.setCaps(caps)

    let depayer = Rtph264depay()
    let decoder = Decodebin()
    let converter1 = VideoConvert()
    
    let formatFilter = Capsfilter()
    caps = Caps(mediaType: "video/x-raw")
    caps.setValue("format", "RGB")
    formatFilter.setCaps(caps)

    let */


    /*pipeline = try! Pipeline(parse: """
    udpsrc port=5000 caps = "application/x-rtp, media=(string)video, clock-rate=(int)90000, encoding-name=(string)H264, payload=(int)96" ! rtph264depay ! decodebin ! videoconvert ! video/x-raw,format=(string)RGB ! videoconvert  ! videoscale ! video/x-raw,width=(int)400,height=(int)400 !  appsink name=sink
    """)!*/
    
    // TEST WIHT: gst-launch-1.0 -v videotestsrc is-live=true ! video/x-raw,width=1000,height=1000,framerate=30/1 ! videoscale ! videoconvert      ! x264enc bitrate=3000  ! rtph264pay ! udpsink host=127.0.0.1 port=5000

    pipeline = try! Pipeline(parse: """
    tcpclientsrc host=\(camera.stream!.host) port=\(camera.stream!.port) ! matroskademux ! avdec_h264 ! videoconvert ! videoscale ! video/x-raw,format=(string)RGB,width=(int)400,height=(int)400 !  appsink max-buffers=1,drop=(boolean)true name=sink
    """)

    bus = pipeline.getBus()

    let sink = pipeline.getElementBy(name: "sink", type: AppSink.self)!

    print("STREAM CAMERA!", camera.stream)

    /*let source = Bin(parse: "videotestsrc")!
    //source.isLive = true
    //print("IS SOURCE LIVE?", source.isLive)
    let capsfilter = Capsfilter()
    capsfilter.setCaps(Caps(mediaType: "video/x-raw", format: "RGB", width: 400, height: 400))
    let sink = AppSink()
    
    sink.setMaxBuffers(1)
    sink.setDrop(true)

    pipeline.add(source)
    pipeline.add(capsfilter)
    pipeline.add(sink)

    source.link(to: capsfilter)
    capsfilter.link(to: sink)*/

    //try! pipeline.setState(.playing)

    /*let source = UdpSource(port: 5000)//TcpClientSource(host: "127.0.0.1", port: 5001)//VideoTestSource() //TcpClientSource(host: camera.stream!.host, port: Int(camera.stream!.port))

    caps = caps.fixate()

    let depay = Rtph264depay()
    let decoder = Decodebin()
    //let convert = VideoConvert()
    //let demuxer = Matroskademux()
    //let parser = H263Parse()
    //let decoder = AVDecH264()
    //let converter = VideoConvert()
    //let scaler = VideoScale()
    //let capsfilter = Capsfilter()
    //capsfilter.setCaps(Caps(mediaType: "video/x-raw", format: "RGB", width: 400, height: 400))
*/

    /*test = Pipeline(parse: """
    udpsrc port=5000 caps = "application/x-rtp, media=(string)video, clock-rate=(int)90000, encoding-name=(string)H264, payload=(int)96" ! rtph264depay ! decodebin ! videoconvert ! autovideosink
    """)!
    try! test.setState(.playing)*/

    //let source = Element(parse: "udpsrc port=5000 caps = \"application/x-rtp, media=(string)video, clock-rate=(int)90000, encoding-name=(string)H264, payload=(int)96\" ! rtph264depay ! decodebin ! videoconvert")!
    /*let source = Bin(parse: """
    videotestsrc ! "video/x-raw,width=(int)400,height=(int)319,format=(string)RGB" ! videoconvert
    """)!
    let sink = AppSink()

    //sink.setMaxBuffers(1)
    //sink.setDrop(true)

    pipeline.add(source)
    pipeline.add(sink)
   //pipeline.add(parser)
    //pipeline.add(decoder)
    //pipeline.add(converter)
    //pipeline.add(scaler)
    //pipeline.add(capsfilter)
    //pipeline.add(sink)

    //GStreamer.link(source, sink)
    source.link(to: sink)*/
    //source.link(to: parser)
    //parser.link(to: decoder)
    //decoder.link(to: sink)
    //converter.link(to: scaler)
    //scaler.link(to: capsfilter)
    //capsfilter.link(to: sink)


    do {
      try pipeline.setState(.playing)
    } catch {
      print("ERROR DURING PIPELINE PLAY")
    }
    
    for message in bus.popAll() {
      print("MESSAGE", message.type, message.data)
      if case let .error(value) = message.data {
        print("ERROR WITH MESSAGE", value.message)
      }
    }

    super.init(sink: sink)

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

  override open func getCurrentFrame() -> Frame? {
    let frame = super.getCurrentFrame()
    try! sink.setState(.playing)
    bus.popAllPrintErrors()
    return frame
  }
}