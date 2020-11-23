public struct CameraInfo: Codable {
  public var id: String
  public var name: String
  public var streamPort: Int

  public init(id: String, name: String, streamPort: Int) {
    self.id = id
    self.name = name
    self.streamPort = streamPort
  }
}