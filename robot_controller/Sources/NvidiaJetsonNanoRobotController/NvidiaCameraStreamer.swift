import RemoteServer
import GStreamer

public class NvidiaCameraStreamer: CameraStreamer {
    override public func buildEncoder() -> GStreamer.Element {
        return try! GStreamer.Bin(parse: "nvvidconv ! 'video/x-raw(memory:NVMM),format=NV12,width=100,height=100' ! omxh264enc bitrate=1000 temporal-tradeoff=3")
    }
}