import RemoteServer
import GStreamer

public class MockCameraStreamer: CameraStreamer {
    override open func buildEncoder() -> GStreamer.Element {
        X264Enc(bitrate: 1000)
    }
}