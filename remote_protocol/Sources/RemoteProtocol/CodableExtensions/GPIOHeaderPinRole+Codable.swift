import BaseGPIO
/*
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
    } else {
      self = .gnd
    }
  }
}*/