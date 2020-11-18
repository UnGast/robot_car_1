import BaseGPIO

public class NvidiaJetsonGPIOController: GPIOController {
    public let headers: [GPIOHeader] = [
        GPIOHeader(pinRoles: [
            "1": [.voltage(3.3)],
            "2": [.voltage(5)],
            "3": [.i2cSda(2)],
            "4": [.voltage(5)],
            "5": [.i2cScl(2)],
            "6": [.gnd],
            "7": [.gpio(216)],
            "8": [.uartTx(2)],
            "9": [.gnd],
            "10": [.uartRx(2)],
            "11": [.gpio(50), .uartRts(2)],
            "12": [.gpio(79), .i2sClk(4)]
        ], layout: .row([
            .column((1...39).map { .pin(String($0)) })
        ]))
    ]

    public subscript<Id: GPIOHeaderPinId>(gpio gpio: Id) -> GPIOPinState { 
        get { GPIOPinState(id: gpio, direction: .input, value: .low) }
        set { return }
    }

    public static let GPIO216 = "7"
    public static let GPIO50 = "11"//, GPIO14, GPIO194, GPIO16, GPIO17, GPIO18, GPIO149, GPIO200, GPPIO38, GPIO76, GPIO12, GPIO79, GPIO232, GPIO15, GPIO13, GPIO19, GPIO20, GPIO168, GPIO51, GPIO77, GPIO78 

    public init() {}
}