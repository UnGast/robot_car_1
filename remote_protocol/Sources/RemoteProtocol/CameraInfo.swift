public struct CameraInfo: Codable {
  public var id: String
  public var name: String
  public var stream: StreamInfo?

  public init(id: String, name: String, stream: StreamInfo? = nil) {
    self.id = id
    self.name = name
    self.stream = stream
  }
}

extension CameraInfo {
  public struct StreamInfo: Codable {
    public var host: String
    public var port: Int
    public var codec: CameraStreamCodec

    public init(host: String, port: Int, codec: CameraStreamCodec) {
      self.host = host
      self.port = port
      self.codec = codec
    }
  }
}