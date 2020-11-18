public enum GPIOHeaderPinRole {
  case voltage(_ level: Double)
  case gpio(_ id: UInt)
  case i2cSda(_ id: UInt)
  case i2cScl(_ id: UInt)
  case gnd
  case uartTx(_ id: UInt)
  case uartRx(_ id: UInt)
  case uartRts(_ id: UInt)
  case i2sClk(_ id: Int)
}