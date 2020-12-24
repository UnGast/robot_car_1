public struct MotionState: Codable {
  public var leftWheel: Double
  public var rightWheel: Double

  public init(leftWheel: Double, rightWheel: Double) {
    self.leftWheel = leftWheel
    self.rightWheel = rightWheel
  }
}