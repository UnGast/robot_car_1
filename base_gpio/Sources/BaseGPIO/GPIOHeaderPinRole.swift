public enum GPIOHeaderPinRole {
  case voltage(_ level: Double)
  case gpio(_ id: Int)
  case i2cSda(_ id: Int)
  case i2cScl(_ id: Int)
  case gnd
  case uartTx(_ id: Int)
  case uartRx(_ id: Int)
  case uartRts(_ id: Int)
  case i2sClk(_ id: Int)
}