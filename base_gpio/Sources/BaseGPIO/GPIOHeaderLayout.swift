public enum GPIOHeaderLayout {
  case pin(_ id: GPIOHeaderPinId)
  indirect case row(_ children: [GPIOHeaderLayout])
  indirect case column(_ children: [GPIOHeaderLayout])
}