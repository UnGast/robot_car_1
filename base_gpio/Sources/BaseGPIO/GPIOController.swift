public protocol GPIOController {
    associatedtype GPIOPinId: GPIOPinIdProtocol
    var layout: GPIOPinLayout<GPIOPinId> { get }
}