import BaseGPIO

extension GPIOHeaderLayout: Codable {
  public enum CodingKeys: String, CodingKey {
    case typeRow, typeColumn, typePin, children, pinId
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    switch self {
    case .row(let children):
      try container.encode(true, forKey: .typeRow)
      var array = container.nestedUnkeyedContainer(forKey: .children)
      try array.encode(contentsOf: children)
    case .column(let children):
      try container.encode(true, forKey: .typeColumn)
      var array = container.nestedUnkeyedContainer(forKey: .children)
      try array.encode(contentsOf: children)
    case .pin(let id):
      try container.encode(true, forKey: .typePin)
      try container.encode(id, forKey: .pinId)
    }
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    if let _ = try? container.decode(Bool.self, forKey: .typeRow) {
      let children = try container.decode([GPIOHeaderLayout].self, forKey: .children)
      self = .row(children)
    } else if let _ = try? container.decode(Bool.self, forKey: .typeColumn) {
      let children = try container.decode([GPIOHeaderLayout].self, forKey: .children)
      self = .column(children)
    } else if let _ = try? container.decode(Bool.self, forKey: .typePin) {
      let id = try container.decode(Int.self, forKey: .pinId)
      self = .pin(id)
    } else {
      throw DecodingError.dataCorrupted(DecodingError.Context(
        codingPath: container.codingPath,
        debugDescription: "Unable to decode because value is neither of type row, column nor pin."
      ))
    }
  }
}