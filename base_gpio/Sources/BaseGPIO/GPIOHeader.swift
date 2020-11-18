public struct GPIOHeader: Codable {
  public var pinRoles: [UInt: [GPIOHeaderPinRole]]
  public var layout: GPIOHeaderLayout

  public init(pinRoles: [UInt: [GPIOHeaderPinRole]], layout: GPIOHeaderLayout) {
    self.pinRoles = pinRoles
    self.layout = layout
  }
}