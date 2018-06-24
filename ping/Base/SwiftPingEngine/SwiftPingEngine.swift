//
//  SwiftPingEngine.swift
//  ping
//
//  Created by Michael Fröhlich on 24.06.18.
//  Copyright © 2018 Michael Fröhlich. All rights reserved.
//

import Foundation

public class SwiftPingEngine : NSObject {
    
    var identifier:UInt32?
    var host: String?
    var ip: String?
    var configuration: PingConfiguration?
    
    private var hasScheduledNextPing: Bool = false
    private var ipv4address: Data?
    private var socket: CFSocket?
    private var socketSource: CFRunLoopSource?
    
    private var isPinging: Bool = false
    private var currentSequenceNumber: UInt64 = 0
    private var currentStartDate: Date?
    
    private var timeoutBlock: (() -> Void)?
    private var currentQueue:DispatchQueue?
    
    public var pingEngineDelegate: SwiftPingEngineDelegate?
    
    private init(host: String, ipv4Address: Data, configuration: PingConfiguration, queue: DispatchQueue) {
        super.init()
        
        self.initialize(host: host, ipv4Address: ipv4Address, configuration: configuration, queue: queue)
    }
    
   private convenience init(ipv4Address: String, config configuration: PingConfiguration, queue: DispatchQueue) {
        
        var socketAddress: sockaddr_in?
        memset(&socketAddress, 0, MemoryLayout<sockaddr_in>.size)
        
        socketAddress!.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        socketAddress!.sin_family = UInt8(AF_INET)
        socketAddress!.sin_port = 0
        socketAddress!.sin_addr.s_addr = inet_addr(ipv4Address.cString(using: String.Encoding.utf8))
        let data = NSData(bytes: &socketAddress, length: MemoryLayout<sockaddr_in>.size)
        
        // calling designated initializer
        self.init(host: ipv4Address, ipv4Address: data as Data, configuration: configuration, queue: queue)
    }
    
    deinit {
        CFRunLoopSourceInvalidate(socketSource)
        socketSource = nil
        socket = nil
    }
    
    private func initialize(host: String, ipv4Address: Data, configuration: PingConfiguration, queue: DispatchQueue) {
        
        self.host = host;
        self.ipv4address = ipv4Address;
        self.configuration = configuration;
        self.identifier = UInt32(arc4random_uniform(UInt32(UInt16.max)));
        self.currentQueue = queue
        
        let socketAddress:sockaddr_in = (ipv4Address as NSData).bytes.assumingMemoryBound(to: sockaddr_in.self).pointee
        self.ip = String(cString: inet_ntoa(socketAddress.sin_addr), encoding: String.Encoding.ascii)!
        
        var context = CFSocketContext()
        context.version = 0
        context.info = unsafeBitCast(self, to: UnsafeMutableRawPointer.self)
        
        self.socket =  CFSocketCreate(kCFAllocatorDefault, AF_INET, SOCK_DGRAM, IPPROTO_ICMP, CFSocketCallBackType.dataCallBack.rawValue, {
            (socket, type, address, data, info ) in
            
            let _self = unsafeBitCast(info, to: SwiftPingEngine.self)
        
            if (type as CFSocketCallBackType) == CFSocketCallBackType.dataCallBack {
                print("CFSocketCallBackType.dataCallBack ")

                print("\(data.length)")
                
                let fData = data?.assumingMemoryBound(to: UInt8.self)
                let bytes = UnsafeBufferPointer<UInt8>(start: fData, count: MemoryLayout<UInt8>.size)
                let cfdata = Data(buffer: bytes)
                _self.socket(socket: socket!, didReadData: cfdata)
            } else {
                print("Other")
            }

        }, &context)
        
        self.socketSource = CFSocketCreateRunLoopSource(nil, self.socket, 0)
        CFRunLoopAddSource(CFRunLoopGetMain(), self.socketSource, CFRunLoopMode.commonModes)
    }

    private func socket(socket:CFSocket, didReadData data: Data?) {
        
        var ipHeaderData: NSData?
        var ipData: NSData?
        var icmpHeaderData: NSData?
        var icmpData: NSData?
        
        let successfullyExtractdICMPHeader = ICMPHeader.extractICMPResponse(data: data! as NSData, ipHeaderData: &ipHeaderData, ipData: &ipData, icmpHeaderData: &icmpHeaderData, icmpData: &icmpData)
        
        if !successfullyExtractdICMPHeader {
            print("Failed to successfully extract ICMPHeader")
            let extractedIPAddressBlock = extractIPAddressBlock(ipHeaderData: ipHeaderData)
            
            if (ipHeaderData != nil && self.ip == extractedIPAddressBlock) {
                return
            }
        } else {
            print("'Success")
        }
        
        guard let id = self.identifier, let currentStartDate = self.currentStartDate else {
            return
        }
        
        let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorCannotDecodeRawData, userInfo: nil)
        let response = PingResponse(id: id, ipAddress: nil, sequenceNumber: Int64(currentSequenceNumber), duration: Date().timeIntervalSince(currentStartDate), error: error)
        
        pingEngineDelegate?.receivedPingResponse(self, response: response)
        scheduleNextPing()
        return
    }
    
}

// MARK: Public Factory Functions
extension SwiftPingEngine {
    
    public class func createPingEngine(host:String,
                           configuration: PingConfiguration = PingConfiguration(),
                           queue: DispatchQueue = DispatchQueue(label: "SwiftPingEngine"),
                           success: @escaping (_ pingEngine: SwiftPingEngine) -> (),
                           failure: @escaping (_ error: NSError) -> ()
                           ) {
        
        DispatchQueue.global().async{
            var error: NSError?
            let ipv4Address: Data? = getIPv4AddressFromHost(host:host, error: &error)
            
            queue.async {
                if let error = error {
                    failure(error)
                }
                else if let ipv4Address = ipv4Address {
                    let pingEngine = SwiftPingEngine(host: host, ipv4Address: ipv4Address, configuration: configuration, queue: queue)
                    success(pingEngine)
                }
            }
            
        }
    }
}


// MARK: Public Interface
extension SwiftPingEngine {
    
    public func start() {
        if isPinging == false{
            isPinging = true
            currentSequenceNumber = 0
            currentStartDate = nil
            sendPing()
        }
    }
    
    public func stop() {
        isPinging = false
        currentSequenceNumber = 0
        currentStartDate = nil
        
        if timeoutBlock != nil {
            timeoutBlock = nil
        }
    }
    
}

// MARK: Private Functions
extension SwiftPingEngine {
    
    private func scheduleNextPing(){
        if (hasScheduledNextPing == false) {
            return;
        }
        
        hasScheduledNextPing = true
        if (self.timeoutBlock != nil) {
            self.timeoutBlock = nil;
        }
        
        let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64((self.configuration?.pingInterval)! * Double(NSEC_PER_SEC)))
        
        
        self.currentQueue?.asyncAfter(deadline: dispatchTime) {
            self.hasScheduledNextPing = false
        }
    }
    
    func sendPing() {
        guard self.isPinging else {
            return
        }
        
        self.currentSequenceNumber += 1
        self.currentStartDate = Date()
        
        guard let icmpPackage: NSData = ICMPHeader.createICMPPackage(identifier: UInt16(self.identifier!), sequenceNumber: UInt16(self.currentSequenceNumber), payloadSize: UInt32(self.configuration!.payloadSize)) else {
            // TODO: handle error
            print("Error: Could not Construct ICMP Package")
            return
        }
        
//        guard let ipv4Address = self.ipv4address as? CFData else {
//            print("failed \(self.ipv4address))"
//        }
//        print(">>> Socket")
//        print(socket!)
//        print(">>> ipv4address")
//        print(self.ipv4address as! CFData)
        
//        let sourceAddr: [UInt8] = self.ipv4address!
//        let ipAddressBlock = ("\(sourceAddr[0]).\(sourceAddr[1]).\(sourceAddr[2]).\(sourceAddr[3])"
//        print(ipAddressBlock)
////
//        print(">>> icmpPackage")
//        print(icmpPackage as CFData)
        
        let socketError: CFSocketError = CFSocketSendData(socket!, self.ipv4address as! CFData, icmpPackage as CFData, self.configuration!.timeOutInterval)
//        let socketError: CFSocketError = CFSocketSendData(socket!, nil, icmpPackage as CFData, self.configuration!.timeOutInterval)

        
        if socketError == CFSocketError.error {
            let error = NSError(domain: NSURLErrorDomain, code:NSURLErrorCannotFindHost, userInfo: [:])
            let response = PingResponse(id: self.identifier!, ipAddress: nil, sequenceNumber: Int64(currentSequenceNumber), duration: Date().timeIntervalSince(currentStartDate!), error: error)

            pingEngineDelegate?.receivedPingResponse(self, response: response)
            scheduleNextPing()
            return
        }
        else if socketError == CFSocketError.timeout {

            let error = NSError(domain: NSURLErrorDomain, code:NSURLErrorTimedOut, userInfo: [:])
            let response = PingResponse(id: self.identifier!, ipAddress: nil, sequenceNumber: Int64(currentSequenceNumber), duration: Date().timeIntervalSince(currentStartDate!), error: error)

            pingEngineDelegate?.receivedPingResponse(self, response: response)
            scheduleNextPing()
            return
        }

        // TODO: Refactor this mess
        let sequenceNumber: UInt64 = self.currentSequenceNumber
        self.timeoutBlock = { () -> Void in
            if (sequenceNumber != self.currentSequenceNumber) {
                return
            }

            self.timeoutBlock = nil
            let error = NSError(domain: NSURLErrorDomain, code:NSURLErrorTimedOut, userInfo: [:])
            // TODO: why is the ip address nil here?
            let response = PingResponse(id: self.identifier!, ipAddress: nil, sequenceNumber: Int64(self.currentSequenceNumber), duration: Date().timeIntervalSince(self.currentStartDate!), error: error)

            self.pingEngineDelegate?.receivedPingResponse(self, response: response)
            self.scheduleNextPing()
        }

//        if let configuration = self.configuration {
//            self.currentQueue?.asyncAfter(deadline: .now() + configuration.pingInterval, execute: {
//                self.timeoutBlock?()
//            })
//        }
    }
    
}

// MARK: Networking Helper Functions
extension SwiftPingEngine {
    
    private static func getIPv4AddressFromHost(host: String, error: AutoreleasingUnsafeMutablePointer<NSError?>) -> Data? {
        
        var streamError: CFStreamError = CFStreamError()
        let cfhost = CFHostCreateWithName(nil, host as CFString).takeRetainedValue()
        let status = CFHostStartInfoResolution(cfhost, .addresses, &streamError)
        
        var data:Data?
        
        if status == false {
            
            if Int32(streamError.domain)  == kCFStreamErrorDomainNetDB {
                error.pointee = NSError(domain: kCFErrorDomainCFNetwork.asString, code: Int(CFNetworkErrors.cfHostErrorUnknown.rawValue), userInfo: [kCFGetAddrInfoFailureKey.asString : "error in host name or address lookup"])
            }
            else{
                error.pointee = NSError(domain: kCFErrorDomainCFNetwork as String, code: Int(CFNetworkErrors.cfHostErrorUnknown.rawValue), userInfo: nil)
            }
        }
        else{
            var success: DarwinBoolean = false
            guard let addresses = CFHostGetAddressing(cfhost, &success)?.takeUnretainedValue() as NSArray? else
            {
                error.pointee = NSError(domain: kCFErrorDomainCFNetwork as String, code: Int(CFNetworkErrors.cfHostErrorHostNotFound.rawValue), userInfo: [NSLocalizedDescriptionKey:"failed to retrieve the known addresses from the given host"])
                return nil
            }
            
            for address in addresses {
                
                let addressData = address as! NSData
                let addrin = addressData.bytes.assumingMemoryBound(to: sockaddr.self).pointee
                if addressData.length >= MemoryLayout<sockaddr>.size && addrin.sa_family == UInt8(AF_INET) {
                    data = addressData as Data
                    break
                }
            }
            
            if data?.count == 0 || data == nil {
                error.pointee = NSError(domain: kCFErrorDomainCFNetwork as String, code: Int(CFNetworkErrors.cfHostErrorHostNotFound.rawValue) , userInfo: nil)
            }
        }
        
        return data
    }
    
    private func extractIPAddressBlock(ipHeaderData: NSData?) -> String? {
        guard let ipHeaderData = ipHeaderData else {
            return nil
        }
    
        var bytes: UnsafeRawPointer = ipHeaderData.bytes
        let ipHeader: IPHeader = unsafeBitCast(bytes, to: IPHeader.self)
//        guard let ipHeader: IPHeader = (withUnsafePointer(to: &bytes) { (temp) in
//            return unsafeBitCast(temp, to: IPHeader.self)
//        })else{
//            print("ipheader data is nil")
//            return nil
//        }
    
        let sourceAddr:[UInt8] = ipHeader.sourceAddress
        let ipAddressBlock = ("\(sourceAddr[0]).\(sourceAddr[1]).\(sourceAddr[2]).\(sourceAddr[3])")

        print(ipAddressBlock)
        return ipAddressBlock
    }
    
}

