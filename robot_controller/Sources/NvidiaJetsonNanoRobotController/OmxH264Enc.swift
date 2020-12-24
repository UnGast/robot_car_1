import GStreamer

public class OmxH264Enc: Element {
    public init(name: String? = nil) {
        super.init(factoryName: "omxh264enc", name: name)
    }

    required public init(internalElement: InternalElement) {
        super.init(internalElement: internalElement)
    }
}