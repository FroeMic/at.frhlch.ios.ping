//
//  ICMPHeader.swift
//  ping
//
//  Created by Michael Fröhlich on 24.06.18.
//  Copyright © 2018 Michael Fröhlich. All rights reserved.
//

import Foundation

struct ICMPHeader {
    
    /**
     * type of message
     */
    var type: UInt8
    
    /**
     * type sub code
     */
    var code: UInt8
    
    /**
     * ones' complement checksum of struct
     */
    var checkSum: UInt16
    
    var identifier: UInt16
    var sequenceNumber: UInt16
    var data: timeval
    
    
    private static func calculateCheckSum(buffer: UnsafeMutableRawPointer, bufferLength: Int) -> UInt16 {
        
        var bufferLength = bufferLength
        var checksum: UInt32 = 0
        var buf = buffer.assumingMemoryBound(to: UInt16.self)
        
        while bufferLength > 1 {
            checksum += UInt32(buf.pointee)
            buf = buf.successor()
            bufferLength -= MemoryLayout<UInt16>.size
        }
        
        if bufferLength == 1 {
            checksum += UInt32(UnsafeMutablePointer<UInt16>(buf).pointee)
        }
        
        checksum = (checksum >> 16) + (checksum & 0xFFFF)
        checksum += checksum >> 16
        return ~UInt16(checksum)
        
    }
    
    public static func createICMPPackage(identifier: UInt16, sequenceNumber: UInt16, payloadSize: UInt32) -> NSData? {
        
        let packet: String = "\(arc4random()) Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet."

        // Construct the ping packet.
        var payload: NSData = NSData(data: packet.data(using: String.Encoding.utf8)!)
        payload = payload.subdata(with: NSMakeRange(0, Int(payloadSize))) as NSData
        
        var package: NSMutableData = NSMutableData(capacity: MemoryLayout<ICMPHeader>.size+payload.length)!

        let mutableBytes = package.mutableBytes
        
        let header: ICMPHeader = mutableBytes.assumingMemoryBound(to: ICMPHeader.self).pointee
        var icmpHeader: ICMPHeader = header

        icmpHeader.type = ICMPType.EchoRequest.rawValue
        icmpHeader.code = 0
        icmpHeader.checkSum = CFSwapInt16(0)
        icmpHeader.identifier = CFSwapInt16HostToBig(identifier)
        icmpHeader.sequenceNumber = CFSwapInt16HostToBig(sequenceNumber)
        
        memcpy(&package + MemoryLayout<ICMPHeader>.size, payload.bytes, payload.length)
        
        // construct package without checksum
        var byteBuffer = [UInt8]()
        withUnsafeBytes(of: &icmpHeader) {
            (bytes: UnsafeRawBufferPointer) in byteBuffer += bytes
        }
        package.replaceBytes(in: NSMakeRange(0, byteBuffer.count), withBytes: byteBuffer)
        package.replaceBytes(in: NSMakeRange(byteBuffer.count, payload.length), withBytes: payload.bytes)

        // calculate checksum
        icmpHeader.checkSum = ICMPHeader.calculateCheckSum(buffer: package.mutableBytes, bufferLength: package.length)

        // write checksum into package
        byteBuffer = [UInt8]()
        withUnsafeBytes(of: &icmpHeader) {
            (bytes: UnsafeRawBufferPointer) in byteBuffer += bytes
        }
        package.replaceBytes(in: NSMakeRange(0, byteBuffer.count), withBytes: byteBuffer)
        
//        icmpHeader.checkSum = ICMPHeader.calculateCheckSum(buffer: package.mutableBytes, bufferLength: package.length)
//
//        var byteBuffer = [UInt8]()
//        withUnsafeBytes(of: &icmpHeader) {
//            (bytes: UnsafeRawBufferPointer) in byteBuffer += bytes
//        }
//        package.replaceBytes(in: NSMakeRange(0, byteBuffer.count), withBytes: byteBuffer)
//        package.replaceBytes(in: NSMakeRange(byteBuffer.count, payload.length), withBytes: payload.bytes)
//
        print("ping package after: \(package)")

        return package
    }
    
    public static func extractICMPResponse(data: NSData, ipHeaderData: AutoreleasingUnsafeMutablePointer<NSData?>, ipData: AutoreleasingUnsafeMutablePointer<NSData?>, icmpHeaderData: AutoreleasingUnsafeMutablePointer<NSData?>, icmpData: AutoreleasingUnsafeMutablePointer<NSData?>) -> Bool {
        
        guard let buffer: NSMutableData = data.mutableCopy() as? NSMutableData else {
            return false
        }
        
        if buffer.length < (MemoryLayout<IPHeader>.size+MemoryLayout<ICMPHeader>.size) {
            if buffer.length > 1 {
                print("buffer.length \(buffer.length)")
                print("MemoryLayout<IPHeader>.size \(MemoryLayout<IPHeader>.size)")
                print("MemoryLayout<ICMPHeader>.size \(MemoryLayout<ICMPHeader>.size)")
                print("MemoryLayout<IPHeader>.size+MemoryLayout<ICMPHeader>.size \(MemoryLayout<IPHeader>.size+MemoryLayout<ICMPHeader>.size)")
            }
            return false
        }
        
        var mutableBytes = buffer.mutableBytes
        
        guard let ipHeader: IPHeader = (withUnsafePointer(to: &mutableBytes) { (temp) in
            return unsafeBitCast(temp, to: IPHeader.self)
        }) else {
            return false
        }
        
        assert((ipHeader.versionAndHeaderLength & 0xF0) == 0x40)     // IPv4
        assert(ipHeader.protocol == 1)                               // ICMP
        
        let ipHeaderLength: UInt8 = (ipHeader.versionAndHeaderLength & 0x0F) * UInt8(MemoryLayout<UInt32>.size)
        
        let range:NSRange = NSMakeRange(0, MemoryLayout<IPHeader>.size)
        ipHeaderData.pointee = buffer.subdata(with: range) as NSData?
        
        if (buffer.length >= MemoryLayout<IPHeader>.size + Int(ipHeaderLength)) {
            ipData.pointee = buffer.subdata(with:NSMakeRange(MemoryLayout<IPHeader>.size, Int(ipHeaderLength))) as NSData?
        }
        
        if (buffer.length < Int(ipHeaderLength) + MemoryLayout<ICMPHeader>.size) {
            return false
        }
        
        let icmpHeaderOffset: size_t = size_t(ipHeaderLength)
        
        var headerBuffer = mutableBytes.assumingMemoryBound(to: UInt8.self) + icmpHeaderOffset
        
        guard let icmpheader: ICMPHeader = (withUnsafePointer(to: &headerBuffer) { (temp) in
            return unsafeBitCast(temp, to: ICMPHeader.self)
        }) else {
            return false
        }
        
        var icmpHeader = icmpheader
        
        let receivedChecksum: UInt16 = icmpHeader.checkSum
        icmpHeader.checkSum = 0
        let calculatedChecksum: UInt16 = ICMPHeader.calculateCheckSum(buffer: &icmpHeader, bufferLength: buffer.length - icmpHeaderOffset)
        icmpHeader.checkSum = receivedChecksum
        
        if (receivedChecksum != calculatedChecksum) {
            print("invalid ICMP header. Checksums did not match")
            return false
        }
        
        
        let icmpDataRange = NSMakeRange(icmpHeaderOffset + MemoryLayout<ICMPHeader>.size, buffer.length - (icmpHeaderOffset + MemoryLayout<ICMPHeader>.size))
        icmpHeaderData.pointee = buffer.subdata(with: NSMakeRange(icmpHeaderOffset, MemoryLayout<ICMPHeader>.size)) as NSData?
        icmpData.pointee = buffer.subdata(with:icmpDataRange) as NSData?
        
        return true
    }


}

