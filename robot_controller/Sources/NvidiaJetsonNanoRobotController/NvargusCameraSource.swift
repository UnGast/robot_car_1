import GStreamer

public class NvargusCameraSource: Element {
    public init(name: String? = nil) {
        super.init(factoryName: "nvarguscamerasrc", name: name)
    }

    required public init(internalElement: InternalElement) {
        super.init(internalElement: internalElement)
    }
}