import Path
import BaseGPIO

public class NvidiaJetsonGPIOController: GPIOController {
    public let headers: [GPIOHeader] = [
        GPIOHeader(pinRoles: [
            1: [.voltage(3.3)],
            2: [.voltage(5)],
            3: [.i2cSda(2)],
            4: [.voltage(5)],
            5: [.i2cScl(2)],
            6: [.gnd],
            7: [.gpio(216)],
            8: [.uartTx(2)],
            9: [.gnd],
            10: [.uartRx(2)],
            11: [.gpio(50), .uartRts(2)],
            12: [.gpio(79), .i2sClk(4)],
            13: [.gpio(14)],
            14: [.gnd],
            15: [.gpio(194)],
            16: [.gpio(232)],
            17: [.voltage(3.3)],
            18: [.gpio(15)],
            19: [.gpio(16)],
            20: [.gnd],
            21: [.gpio(17)],
            22: [.gpio(13)],
            23: [.gpio(18)],
            24: [.gpio(19)],
            25: [.gnd],
            26: [.gpio(20)],
            27: [.i2cSda(1)],
            28: [.i2cScl(1)],
            29: [.gpio(149)],
            30: [.gnd],
            31: [.gpio(200)],
            32: [.gpio(168)],
            33: [.gpio(38)],
            34: [.gnd],
            35: [.gpio(76)],
            36: [.gpio(51)],
            37: [.gpio(12)],
            38: [.gpio(77)],
            39: [.gnd],
            40: [.gpio(78)]
        ], layout: .row([
            .column(stride(from: 1, through: 39, by: 2).map { .pin($0) }),
            .column(stride(from: 2, through: 40, by: 2).map { .pin($0) })
        ]))
    ]

    // map id of gpio pin to id of pin on header
    private var gpioPinHeaderIdMap: [UInt: UInt] {
        var map = [UInt: UInt]()
        for header in headers {
            for (pinId, pinRoles) in header.pinRoles {
                for pinRole in pinRoles {
                    if case let .gpio(gpioId) = pinRole {
                        map[gpioId] = pinId
                        break
                    }
                }
            }
        }
        return map
    }

    private static let gpioBasePath = Path("/sys/class/gpio")!
    private static let gpioExportPath = NvidiaJetsonGPIOController.gpioBasePath/"export"

    public static let GPIO216: UInt = 216
    public static let GPIO50: UInt = 50

    public init() {}

    private func ensureGPIOPinEnabled(_ gpioId: UInt) throws {
        guard let _ = gpioPinHeaderIdMap[gpioId] else {
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

        if getDirection(gpioId: gpioId) == .output {
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

    public func getDirection(gpioId: UInt) -> GPIOPinDirection {
        guard let _ = gpioPinHeaderIdMap[gpioId] else {
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

        return direction
    }

    public func getValue(gpioId: UInt) -> GPIOPinValue {
        guard let _ = gpioPinHeaderIdMap[gpioId] else {
            fatalError("tried to access non-existing gpio pin: \(gpioId)")
        }

        let pinPath = getGPIOPinPath(gpioId: gpioId)

        if let rawValue = try? String(contentsOf: pinPath/"value") {
            if rawValue.starts(with: "0") {
                return .low
            } else if rawValue.starts(with: "1") {
                return .high
            } else {
                fatalError("found unsupported value for gpio: \(gpioId)")
            }
        } else {
            return .low
        }
    }

    public func getPinState(gpioId: UInt) -> GPIOPinState { 
        guard let _ = gpioPinHeaderIdMap[gpioId] else {
            fatalError("tried to access non-existing gpio pin: \(gpioId)")
        }

        let direction = getDirection(gpioId: gpioId)
        let value = getValue(gpioId: gpioId)

        return GPIOPinState(id: gpioId, direction: direction, value: value)
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

    private func getGPIOPinPath(gpioId: UInt) -> Path {
        return Self.gpioBasePath/("gpio\(gpioId)")
    }
}