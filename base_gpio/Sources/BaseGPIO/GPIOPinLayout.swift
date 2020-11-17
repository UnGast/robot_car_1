public enum GPIOPinLayout<GPIOPinId: GPIOPinIdProtocol> {
  case pin(_ id: GPIOPinId)
  indirect case row(_ children: [GPIOPinLayout])
  indirect case column(_ children: [GPIOPinLayout])

  public func asAny() -> GPIOPinLayout<String> {
    switch self {
    case .pin(let id):
      return .pin(id.description)
    case .row(let children):
      return .row(children.map { $0.asAny() })
    case .column(let children):
      return .column(children.map { $0.asAny() })
    }
  }
}