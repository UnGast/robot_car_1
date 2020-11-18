public struct GPIOHeader {
  public var pinRoles: [String: [GPIOHeaderPinRole]]
  public var layout: GPIOHeaderLayout

  public init(pinRoles: [String: [GPIOHeaderPinRole]], layout: GPIOHeaderLayout) {
    self.pinRoles = pinRoles
    self.layout = layout
  }
}