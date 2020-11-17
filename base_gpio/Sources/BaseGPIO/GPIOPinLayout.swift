public enum GPIOPinLayout {
  case pin(_ id: GPIOPinId)
  indirect case row(_ children: [GPIOPinLayout])
  indirect case column(_ children: [GPIOPinLayout])
}