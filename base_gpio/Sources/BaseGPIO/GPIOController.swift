public protocol GPIOController {
    var headers: [GPIOHeader] { get }

    subscript<Id: GPIOHeaderPinId>(gpio gpio: Id) -> GPIOPinState { get set }
}