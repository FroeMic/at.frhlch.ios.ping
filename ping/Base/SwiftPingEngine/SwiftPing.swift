//
//  SwiftPing.swift
//  SwiftPing
//
//  Created by Ankit Thakur on 20/06/16.
//  Copyright © 2016 Ankit Thakur. All rights reserved.
//

import Foundation
import Darwin


class SwiftPing: NSObject {
    

    // MARK: Public APIs
    
    /// pinging to the host url, with provided configuration.
    ///
    /// - parameters:
    ///   - host: url string, to ping.
    ///   - configuration: PingConfiguration object so as to define ping interval, time interval
    ///   - completion: Closure of the format `(ping:SwiftPing?, error:NSError?) -> Void` format
    
    public class func ping(host:String, configuration:PingConfiguration, queue:DispatchQueue, completion:@escaping (_ ping:SwiftPing?, _ error:NSError?) -> Void) -> Void{
        
        print(queue)
        DispatchQueue.global().async{
            var error:NSError?;
            let ipv4Address:Data? = getIPv4AddressFromHost(host:host, error: &error)
            
            queue.async {
                if (error != nil) {
                    completion(nil, error)
                }
                else{
                    completion(SwiftPing(host: host, ipv4Address: ipv4Address!, configuration: configuration, queue: queue), nil)
                }
            }
            
        }
    }
    
    /// pinging to the host url only once, with provided configuration
    ///
    /// - parameters:
    ///   - host: url string, to ping.
    ///   - configuration: PingConfiguration object so as to define ping interval, time interval
    ///   - completion: Closure of the format `(ping:SwiftPing?, error:NSError?) -> Void` format
    
    public class func pingOnce(host:String, configuration:PingConfiguration, queue:DispatchQueue, completion:@escaping (_ response:PingResponse) -> Void) -> Void{
        
        let date = Date()
        
        SwiftPing.ping(host: host, configuration: configuration, queue: queue) { (ping, error) in
            if error != nil {
                let response = PingResponse(id: 0, ipAddress: nil, sequenceNumber: 1, duration: Date().timeIntervalSince(date), error: error)
                
                completion(response);
            }
            else {
                let ping:SwiftPing = ping!
                
                // add observer to stop the ping, if already recieved once.
                // start the ping.
                ping.observer = {(ping:SwiftPing, response:PingResponse) -> Void in
                    ping.stop()
                    ping.observer = nil
                    completion(response);
                }
                ping.start()
                
            }
        }
    }
    
    // MARK: PRIVATE
    func socketCallback(socket: CFSocket!, type:CFSocketCallBackType, address:CFData!, data:UnsafeRawPointer, info:UnsafeMutableRawPointer) {
        // Conditional cast from 'SwiftPing' to 'SwiftPing' always succeeds
        
        // 1
        var info:UnsafeMutableRawPointer = info
        guard let ping:SwiftPing = (withUnsafePointer(to: &info) { (temp) in
            return unsafeBitCast(temp, to: SwiftPing.self)
        })else{
            print("ping callback object is nil")
            return
        }
        
        if (type as CFSocketCallBackType) == CFSocketCallBackType.dataCallBack {
            
            let fData = data.assumingMemoryBound(to: UInt8.self)
            let bytes = UnsafeBufferPointer<UInt8>(start: fData, count: MemoryLayout<UInt8>.size)
            let cfdata:Data = Data(buffer: bytes)
            ping.socket(socket: socket, didReadData: cfdata)
        }
    }
    
    
    
    // Designated Intializer
    

    
    // MARK: Start and Stop the pings
    

    
    

}
