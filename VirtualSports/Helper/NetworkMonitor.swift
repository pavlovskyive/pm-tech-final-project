//
//  NetworkMonitor.swift
//  VirtualSports
//
//  Created by Alexandr Sopilnyak on 25.03.2021.
//

import Network

final public class NetworkMonitor {
    public static let shared = NetworkMonitor()

    public var handleConnection: ((ConnectionState) -> Void)?

    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor

    private(set) var connetionType: ConnectionType? = .unknown
    private(set) var connectionState: ConnectionState = .disconnected {
        willSet {
            handleConnection?(newValue)
        }
    }

    private init() {
        monitor = NWPathMonitor()
    }

    public func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { path in
            self.getConnectionType(path)

            if path.status == .satisfied {
                print("Internet Connection - Avaliable")
                self.connectionState = .connected
            } else {
                print("Internet Connection - Not Avaliable")
                self.connectionState = .disconnected
            }
        }
    }

    public func stopMonitoring() {
        monitor.cancel()
    }

    private func getConnectionType(_ path: NWPath) {
        if path.usesInterfaceType(.cellular) {
            connetionType = .cellular
        } else if path.usesInterfaceType(.wifi) {
            connetionType = .wifi
        } else {
            connetionType = .unknown
        }
    }

}

public enum ConnectionState {
    case connected
    case disconnected
}

public enum ConnectionType {
    case cellular
    case wifi
    case unknown
}
