public enum GPIOHeaderPinRole {
  case voltage(_ level: Double), gpio(_ number: UInt), i2cSda(_ number: UInt), i2cScl(_ number: UInt), gnd, uartTx(_ number: UInt), uartRx(_ number: UInt), uartRts(_ number: UInt), i2sClk(_ number: Int)
}