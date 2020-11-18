import Path
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

    private static let gpioBasePath = Path("/sys/class/gpio")!
    private static let gpioExportPath = NvidiaJetsonGPIOController.gpioBasePath/"export"

    // map id of gpio pin to id of pin on header
    private static let gpioPinHeaderIdMap: [UInt: UInt] = [
        216: 7,
        50: 11,
        79: 12
    ]

    public static let GPIO216: UInt = 216
    public static let GPIO50: UInt = 50

    public subscript(gpio gpioId: UInt) -> GPIOPinState { 
        get {
            guard let _ = Self.gpioPinHeaderIdMap[gpioId] else {
                fatalError("tried to access non-existing gpio pin: \(gpioId)")
            }

            let pinPath = getGPIOPinPath(gpioId: gpioId)
            
            let direction: GPIOPinDirection
            if let rawDirection = try? String(contentsOf: pinPath/"direction") {
                if rawDirection.starts(with: "in") {
                    direction = .input
                } else if rawDirection.starts(with: "out") {
                    direction = .output
                } else {
                    fatalError("unsupported gpio direction in file: \(rawDirection)")
                }
            } else {
                direction = .input
            }

            let value: GPIOPinValue
            if let rawValue = try? String(contentsOf: pinPath/"value") {
                if rawValue.starts(with: "1") {
                    value = .high
                } else if rawValue.starts(with: "0") {
                    value = .low
                } else {
                    fatalError("unsupported gpio value in file: \(rawValue)")
                }
            } else {
                value = .low
            }

            return GPIOPinState(id: gpioId, direction: direction, value: value)
        }

        set { 
            /*let pinPath = getGPIOPinPath(gpioId: gpioId)

            if !pinPath.exists {
                String(gpioId).write(to: Self.gpioExportPath)
            }

            let rawDirection: String
            switch newValue.direction {
            case .input:
                rawDirection = "in"
            case .output
                rawDirection = "out"
            }
            rawDirection.write(to: pinPath/"direction")

            if newValue.direction == .output {
                let rawValue: String
                switch newValue.value {
                case .high:
                    rawValue = "1"
                case .low:
                    rawValue = "0"
                }
                rawValue.write(to: pinPath/"value")
            }*/
            return
        }
    }

    private func ensureGPIOPinEnabled(_ gpioId: UInt) throws {
        guard let _ = Self.gpioPinHeaderIdMap[gpioId] else {
            fatalError("tried to access non-existing gpio pin: \(gpioId)")
        }

        let pinPath = getGPIOPinPath(gpioId: gpioId)

        if !pinPath.exists {
            try String(gpioId).write(to: Self.gpioExportPath)
        }
    }

    public func set(gpioId: UInt, direction: GPIOPinDirection) throws {
        try ensureGPIOPinEnabled(gpioId)

        let pinPath = getGPIOPinPath(gpioId: gpioId)

        let rawDirection: String
        switch direction {
        case .input:
            rawDirection = "in"
        case .output:
            rawDirection = "out"
        }
        try rawDirection.write(to: pinPath/"direction")
    }

    public func set(gpioId: UInt, value: GPIOPinValue) throws {
        try ensureGPIOPinEnabled(gpioId)

        let pinPath = getGPIOPinPath(gpioId: gpioId)

        if self[gpio: gpioId].direction == .output {
            let rawValue: String
            switch value {
            case .high:
                rawValue = "1"
            case .low:
                rawValue = "0"
            }
            try rawValue.write(to: pinPath/"value")
        } else {
            fatalError("can't set value for a gpio pin which is not configured as output")
        }
    }

    /*public enum GPIO: String, CaseIterable {
        case p216 = "216", p50 = "50"

        public headerPinId: String {
            switch self {
            case p216:
                return "7"
            case p50:
                return "11"
            }
        }
    }*/
    //public static let GPIO216 = "7"
    //public static let GPIO50 = "11"//, GPIO14, GPIO194, GPIO16, GPIO17, GPIO18, GPIO149, GPIO200, GPPIO38, GPIO76, GPIO12, GPIO79, GPIO232, GPIO15, GPIO13, GPIO19, GPIO20, GPIO168, GPIO51, GPIO77, GPIO78 

    public init() {}

    private func getGPIOPinPath(gpioId: UInt) -> Path {
        return Self.gpioBasePath/("gpio\(gpioId)")
    }
}