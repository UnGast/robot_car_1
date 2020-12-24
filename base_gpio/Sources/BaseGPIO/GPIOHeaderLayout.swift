public enum GPIOHeaderLayout {
  case pin(_ id: Int)
  indirect case row(_ children: [GPIOHeaderLayout])
  indirect case column(_ children: [GPIOHeaderLayout])
}