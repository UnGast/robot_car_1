public struct GPIOHeader: Codable {
  public var pinRoles: [Int: [GPIOHeaderPinRole]]
  public var layout: GPIOHeaderLayout

  public init(pinRoles: [Int: [GPIOHeaderPinRole]], layout: GPIOHeaderLayout) {
    self.pinRoles = pinRoles
    self.layout = layout
  }
}