public protocol RemoteProtocolServer {
  func startCommunication()

  func send<M: RemoteProtocolServerMessage>(_ message: M)
}