public enum GPIOPinLayout {
  case Pin(_ pin: GPIOPin)
  indirect case Row(_ children: [GPIOPinLayout])
  indirect case Column(_ children: [GPIOPinLayout])
}