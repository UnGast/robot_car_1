import BaseGPIO

extension GPIOHeaderPinRole: Codable {
  public enum CodingKeys: String, CodingKey {
    case voltage, gpio, i2cSda, i2cScl, gnd, uartTx, uartRx, uartRts, i2sClk
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    switch self {
    case let .voltage(level):
      try container.encode(level, forKey: .voltage)
    case let .gpio(id):
      try container.encode(id, forKey: .gpio)
    case let .i2cSda(id):
      try container.encode(id, forKey: .i2cSda)
    case let .i2cScl(id):
      try container.encode(id, forKey: .i2cScl)
    case let .gnd:
      try container.encode(true, forKey: .gnd)
    case let .uartTx(id):
      try container.encode(id, forKey: .uartTx)
    case let .uartRx(id):
      try container.encode(id, forKey: .uartRx)
    case let .uartRts(id):
      try container.encode(id, forKey: .uartRts)
    case let .i2sClk(id):
      try container.encode(id, forKey: .i2sClk)
    }
  }

  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    if let level = try? values.decode(Double.self, forKey: .voltage) {
      self = .voltage(level)
    } else if let id = try? values.decode(UInt.self, forKey: .gpio) {
      self = .gpio(id)
    } else if let id = try? values.decode(UInt.self, forKey: .i2cSda) {
      self = .i2cSda(id)
    } else if let id = try? values.decode(UInt.self, forKey: .i2cScl) {
      self = .i2cScl(id)
    } else if let _ = try? values.decode(Bool.self, forKey: .gnd) {
      self = .gnd
    } else if let id = try? values.decode(UInt.self, forKey: .uartTx) {
      self = .uartTx(id)
    } else if let id = try? values.decode(UInt.self, forKey: .uartRx) {
      self = .uartRx(id)
    } else if let id = try? values.decode(UInt.self, forKey: .uartRts) {
      self = .uartRts(id)
    } else if let id = try? values.decode(UInt.self, forKey: .i2sClk) {
      self = .i2sClk(id)
    } else {
      throw DecodingError.dataCorrupted(DecodingError.Context(
        codingPath: values.codingPath,
        debugDescription: "Unable to decode because no pin role is contained in the encoded values."
      ))
    }
  }
}