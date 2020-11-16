public protocol RemoteProtocolClient {
  func startCommunication()

  func send<M: RemoteProtocolClientMessage>(_ message: M)
}