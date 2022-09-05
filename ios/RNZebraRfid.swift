//
//  RNZebraRfid.swift
//  zebra_new
//
//  Created by MacBook Pro on 15/12/2020.
//

import Foundation

@objc(RNZebraRfid)
class RNZebraRfid: RCTEventEmitter {
  
  var ScannedTags: NSMutableArray = []
  var readers: [srfidReaderInfo] = []
  let radioOption: zt_RadioOperationEngine = zt_RadioOperationEngine()
  var LocateTimer: Timer?
  
  var isPressed: Bool = true
  
  var tag_NoofBatch:Int =  1
  
  override init() {
    super.init()
    zt_RfidAppEngine.shared()?.removeDeviceListDelegate(self)
    zt_RfidAppEngine.shared()?.addDeviceListDelegate(self)
    zt_RfidAppEngine.shared()?.remove(self)
    zt_RfidAppEngine.shared()?.add(self)
    
//    zt_ScannerAppEngine.bshared()?.enableScannersDetection(true)
//    ConnectionManager.shared()
//    zt_ScannerAppEngine.bshared()?.add(self)
    
    zt_ScannerAppEngine.bshared()?.add(self)
    //zt_ScannerAppEngine.bshared()?.add(self)
    
    //zt_ScannerAppEngine.bshared()?.removeDevConnectiosDelegate(self)
    
  }
  
  override class func moduleName() -> String! {
    return "RNZebraRfid"
  }
  
  override class func requiresMainQueueSetup() -> Bool {
    return false
  }
  
  override func supportedEvents() -> [String]! {
    return ["onRfidRead", "onAppeared", "onDisappeared", "onProximityRead"]
  }
  
  /* RFID get Device */
  @objc
  func getAvailableDevices(_ resolve: @escaping RCTPromiseResolveBlock,
                           rejecter reject: @escaping RCTPromiseRejectBlock)  -> Void {
      let devices = zt_RfidAppEngine.shared()?.getActualDeviceList() as? [srfidReaderInfo] ?? []
      var response: [[String: Any]] = []
      for device in devices {
        print("Reader Name: ", device.getReaderName() ?? "Unknown")
        let dev: [String : Any] = ["name": device.getReaderName() ?? "",
                                   "address": device.getReaderID()]
        response.append(dev)
      }
    if response.count > 0 {
      resolve(response)
    } else {
      reject("Error", "No device Found!", nil)
    }
  }
 
  
  @objc
  func connect(_ deviceName: String,
               resolver resolve: @escaping RCTPromiseResolveBlock,
               rejecter reject: @escaping RCTPromiseRejectBlock) -> Void
  {
    let devices = zt_RfidAppEngine.shared()?.getActualDeviceList() as? [srfidReaderInfo] ?? []
    guard let reader: srfidReaderInfo = devices.last(where: { $0.getReaderName() == deviceName}) else {
//      reject("Error", "Device Not available!", nil)
      return
    }
    
    if zt_RfidAppEngine.shared()?.activeReader()?.getID() != reader.getReaderID() {
      zt_RfidAppEngine.shared()?.connect(reader.getReaderID())
      if let _ = zt_RfidAppEngine.shared()?.activeReader() {
        zt_RfidAppEngine.shared()
        self.requestBatteryStatus()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
          zt_RfidAppEngine.shared()?.switchMode(0)
        }
        resolve(deviceName)
      } else {
        reject("Error", "Connection Failed!", nil)
      }
    }
  }
 
  
  func requestBatteryStatus()
  {
    zt_RfidAppEngine.shared()?.requestBatteryStatus(nil)
  }
  
  @objc
   func isConnected(_ resolve: @escaping RCTPromiseResolveBlock,
                    rejecter reject: @escaping RCTPromiseRejectBlock) {
     guard let engine = zt_RfidAppEngine.shared() else {
       reject("Error", "Connection Failed!", nil)
       return
     }
     //print("isConnected: \(engine.activeReader()?.isActive())")
     resolve(engine.activeReader()?.isActive())
   }

  
  @objc
  func disconnect(_ deviceName: String,
                  resolver resolve: @escaping RCTPromiseResolveBlock,
                  rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
    let devices = zt_RfidAppEngine.shared()?.getActualDeviceList() as? [srfidReaderInfo] ?? []
    guard let reader: srfidReaderInfo = devices.last(where: { $0.getReaderName() == deviceName}) else {
      reject("Error", "Device Not available!", nil)
      return
    }
    
    if zt_RfidAppEngine.shared()?.activeReader()?.getID() == reader.getReaderID() {
      zt_RfidAppEngine.shared()?.disconnect(reader.getReaderID())
      
      resolve(deviceName)
    }
  }
  
  
  @objc
  func setPower(_ power: Int,
                resolver resolve: @escaping RCTPromiseResolveBlock,
                rejecter reject: @escaping RCTPromiseRejectBlock) {
    //DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
      if power == 0 {
          reject("Erro", "Invalid", nil)
        }
        print("CHECK::: power \(power)")
        
        var message: NSString?
        zt_RfidAppEngine.shared().setAntennaConfiguration(&message, pow: Float(Int16(power)))
        resolve(power)
    //}
  
  }
  
  @objc
  func getPower(_ resolve: @escaping RCTPromiseResolveBlock,
                rejecter reject: @escaping RCTPromiseRejectBlock) {
  
    let configuration = zt_RfidAppEngine.shared()?.sledConfiguration();
    if let config = configuration  {
      resolve(config.currentAntennaPowerLevel)
    } else {
      reject("Erro", "Invalid", nil)
    }
  }
  
  @objc
  func getBatteryLevel(_ resolve: @escaping RCTPromiseResolveBlock,
                         rejecter reject: @escaping RCTPromiseRejectBlock) {
   

      self.requestBatteryStatus()
      if let batteryInfo = zt_RfidAppEngine.shared()?.getBatteryInfo() {
        resolve(batteryInfo.getPowerLevel())
      }  else {
        reject("Erro", "Invalid", nil)
      }

    }
    
  // MARK: - Set Beep
  @objc
  func setBeeper(_ beep: String,
                resolver resolve: @escaping RCTPromiseResolveBlock,
                rejecter reject: @escaping RCTPromiseRejectBlock) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
      switch beep {
          case "low":
            zt_RfidAppEngine.shared()?.updateBeep(SRFID_BEEPERCONFIG_LOW)
            resolve(beep)
            //break
          case "high":
              zt_RfidAppEngine.shared()?.updateBeep(SRFID_BEEPERCONFIG_HIGH)
            resolve(beep)
            //break
          case "medium":
              zt_RfidAppEngine.shared()?.updateBeep(SRFID_BEEPERCONFIG_MEDIUM)
            resolve(beep)
            //break
          case "quiet":
                zt_RfidAppEngine.shared()?.updateBeep(SRFID_BEEPERCONFIG_QUIET)
            resolve(beep)
            //break
          default:
            zt_RfidAppEngine.shared()?.updateBeep(SRFID_BEEPERCONFIG_QUIET)
            resolve(beep)
          }
    }
    
    //zt_RfidAppEngine.shared()?.updateBeep(beep)
    
  }
  
  
  // MARK: - Start Tag Locator
  @objc
  func startTagLocate(_ tag: String,
                resolver resolve: @escaping RCTPromiseResolveBlock,
                rejecter reject: @escaping RCTPromiseRejectBlock) {
    //AE1000000000000001493865
    if let status = zt_RfidAppEngine.shared()?.start_LocateTag(tag) {
      print(status)
      
      if status == SRFID_RESULT_SUCCESS {
        resolve(true)
      }
      else{
        resolve(false)
      }
   //   LocateTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(getproximity), userInfo: nil, repeats: true)
//      LocateTimer =  Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
//        let distance = zt_RfidAppEngine.shared()?.operationEngine()?.getProximityPercent()
//        resolve(distance?.description)
//      }
      //resolve(status)
      
    }  else {
      reject("Erro", "Invalid", nil)
    }
   
  }
   // MARK: - Set Power Management
  @objc
  func setPowerManagement(_ enable: String,
                resolver resolve: @escaping RCTPromiseResolveBlock,
                rejecter reject: @escaping RCTPromiseRejectBlock) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
      switch enable {
          case "ENABLE":
            zt_RfidAppEngine.shared()?.updatePowerManage(true)
            resolve(enable)
          default:
            zt_RfidAppEngine.shared()?.updatePowerManage(false)
            resolve(enable)
          }
    }
    
    //zt_RfidAppEngine.shared()?.updateBeep(beep)
    
  }

  
  
              
                     
  // MARK: - Stop Tag locator
  @objc
  func stopTagLocate(_ resolve: @escaping RCTPromiseResolveBlock,
                      rejecter reject: @escaping RCTPromiseRejectBlock) {
    
    if let status = zt_RfidAppEngine.shared()?.stop_LocateTag() {
//      LocateTimer?.invalidate()
      print(status)
      resolve(status)
    }  else {
      reject("Erro", "Invalid", nil)
    }
    
  }
  
  
  // MARK: - RFID and Bar code switch method
  @objc
  func setMode(_ mode: String,
               resolver resolve: @escaping RCTPromiseResolveBlock,
               rejecter reject: @escaping RCTPromiseRejectBlock) {

    if mode == "BARCODE"{
      
      //zt_RfidAppEngine.shared()?.switchMode(1)
      zt_RfidAppEngine.shared()?.switchMode(1)
      zt_RfidAppEngine.shared()?.disconnect((zt_RfidAppEngine.shared()?.activeReader()?.getID())!)
      Barcode_Mode()
      
    }
    else{
     
      ConnectionManager.shared()?.disconnect()
      RFID_Mode()
      
    }
    
    resolve(mode)
  }
  
  // MARK: - Bar code Mode Method
  func Barcode_Mode() {
    //zt_RfidAppEngine.shared()?.disconnect((zt_RfidAppEngine.shared()?.activeReader()?.getID())!)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
        // your code here
      let devices = zt_ScannerAppEngine.bshared()?.getAvailableScannersList() as? [SbtScannerInfo] ?? []
        
        if devices.count > 0 {
          
          ConnectionManager.shared()?.connectDevice(usingScannerId: devices[0].getScannerID())
  //        self.connect_barcode(devices[0].getScannerName()) { (reso) in
  //         // resolve(reso)
  //        } rejecter: { (str1, str2, err) in
  //         // reject("Error", "Connection Failed!", nil)
  //        }
      }
      else{
       // reject("Error", "No device Found!", nil)
      }
    }
    
  }
  
  // MARK: - RFID Mode Method
  func RFID_Mode() {
    
    //zt_ScannerAppEngine.bshared()?.disconnect((zt_ScannerAppEngine.bshared()?.previousScannerId())!)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
        // your code here
      let devices = zt_RfidAppEngine.shared()?.getActualDeviceList() as? [srfidReaderInfo] ?? []
      
      if devices.count > 0 {
        
        zt_RfidAppEngine.shared()?.connect(devices[0].getReaderID())
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
          zt_RfidAppEngine.shared()?.switchMode(0)
        }

      } else {
        //reject("Error", "No device Found!", nil)
      }
    }
    
    
  }
  
  
  
// MARK: -  Barcode get Device
 @objc
 func getAvailableDevices_barcode(_ resolve: @escaping RCTPromiseResolveBlock,
                          rejecter reject: @escaping RCTPromiseRejectBlock)  -> Void {
   
   let devices = zt_ScannerAppEngine.bshared()?.getAvailableScannersList() as? [SbtScannerInfo] ?? []
     //let devices = zt_RfidAppEngine.shared()?.getActualDeviceList() as? [srfidReaderInfo] ?? []
     var response: [[String: Any]] = []
     for device in devices {
       print("Reader Name: ", device.getScannerName() ?? "Unknown")
       let dev: [String : Any] = ["name": device.getScannerName() ?? "",
                                  "address": device.getScannerID()]
       response.append(dev)
     }
   if response.count > 0 {
     resolve(response)
   } else {
     reject("Error", "No device Found!", nil)
   }
 }
 
// MARK: - Bar code Connect
 @objc
 func connect_barcode(_ deviceName: String,
              resolver resolve: @escaping RCTPromiseResolveBlock,
              rejecter reject: @escaping RCTPromiseRejectBlock) -> Void
 {
   let devices = zt_ScannerAppEngine.bshared()?.getAvailableScannersList() as? [SbtScannerInfo] ?? []
   guard let reader: SbtScannerInfo = devices.last(where: { $0.getScannerName() == deviceName}) else {
//      reject("Error", "Device Not available!", nil)
     return
   }
  
   
   if (reader.getScannerID() != 0) {
     //zt_ScannerAppEngine.bshared()?.connect(reader.getScannerID())
     ConnectionManager.shared()?.connectDevice(usingScannerId: reader.getScannerID())
       //zt_RfidAppEngine.shared()
      // self.requestBatteryStatus()
     print("Connected BarCode")
       resolve(deviceName)
     } else {
       reject("Error", "Connection Failed!", nil)
     }
   
 }
 
  // MARK: - Bar code disconnect
  @objc
  func disconnect_barcode(_ deviceName: String,
                  resolver resolve: @escaping RCTPromiseResolveBlock,
                  rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
    
    let devices = zt_ScannerAppEngine.bshared()?.getAvailableScannersList() as? [SbtScannerInfo] ?? []
    guard let reader: SbtScannerInfo = devices.last(where: { $0.getScannerName() == deviceName}) else {
 //      reject("Error", "Device Not available!", nil)
      return
    }
    
    if (reader.getScannerID() != 0) {
      ConnectionManager.shared()?.disconnect()
      print("Connected BarCode")
        resolve(deviceName)
      } else {
        reject("Error", "Connection Failed!", nil)
      }
  }
  
  
  @objc
     func setBatchSize(_ size: Int,
                   resolver resolve: @escaping RCTPromiseResolveBlock,
                   rejecter reject: @escaping RCTPromiseRejectBlock) {
       
       if size == 0 {
         reject("Erro", "Invalid", nil)
       }
       print("CHECK::: power \(size)")
       tag_NoofBatch = size
       resolve(true)
     }
  
  
  @objc
  func StartScanning(_ scan: Int, resolver resolve: @escaping RCTPromiseResolveBlock,
                     rejecter reject: @escaping RCTPromiseRejectBlock) {
    
    if scan == 1 {
      var message: NSString?
      isPressed = true
      radioOption.startInventory(true, aMemoryBank: SRFID_MEMORYBANK_NONE, message: &message)
      resolve(true)
    } else {
      var message: NSString?
      radioOption.stopInventory(&message)
      isPressed = false
      resolve(true)
    }
    
  }
// MARK: - Write Tag
  @objc
 func WriteTag(_ tagID: String,
                withTagData data: String,
                resolver resolve: @escaping RCTPromiseResolveBlock,
                rejecter reject: @escaping RCTPromiseRejectBlock) {
    //DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
      if tagID != "" && data != "" {
        if let status = zt_RfidAppEngine.shared()?.writeonTag(tagID, withData: data) {
        
          if status == SRFID_RESULT_SUCCESS {
            resolve(true)
          }
          else if status == SRFID_RESULT_READER_NOT_AVAILABLE {
            reject("Error", "Operation failed: no active reader", nil)
          }
          else if status == SRFID_RESULT_READER_NOT_AVAILABLE {
            reject("Error", "Write timeout", nil)
          }
          else{
            reject("Error", "Unable To Write Tag", nil)
          }
        }
        }
      else{
        reject("Error", "Please fill tagid or Tag data", nil)
      }

   // }
  }
  // MARK: - Set Singultion
  @objc
	func setSingultionControl(_ SingultionControl: String,
                            Tag TagPopulation: Int,
                            SControlFlag Flag: String,
                            InState State: String,
                resolver resolve: @escaping RCTPromiseResolveBlock,
                rejecter reject: @escaping RCTPromiseRejectBlock) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
      
      var SRFID_SESSION_ID: SRFID_SESSION
      var SRFID_SLFLAG_ID: SRFID_SLFLAG
      var SRFID_INVENTORYSTATE_ID: SRFID_INVENTORYSTATE
      
    switch SingultionControl {
      case "S0":
          SRFID_SESSION_ID = SRFID_SESSION_S0
      case "S1":
        SRFID_SESSION_ID = SRFID_SESSION_S1
      case "S2":
        SRFID_SESSION_ID = SRFID_SESSION_S2
      case "S3":
        SRFID_SESSION_ID = SRFID_SESSION_S3
      default:
        SRFID_SESSION_ID = SRFID_SESSION_S0
      }
      
      switch Flag {
        case "ALL":
          SRFID_SLFLAG_ID = SRFID_SLFLAG_ALL
        case "AS":
          SRFID_SLFLAG_ID = SRFID_SLFLAG_ASSERTED
        case "DES":
          SRFID_SLFLAG_ID = SRFID_SLFLAG_DEASSERTED
        default:
          SRFID_SLFLAG_ID = SRFID_SLFLAG_ALL
      }
      
      switch State {
      case "A":
        SRFID_INVENTORYSTATE_ID = SRFID_INVENTORYSTATE_A
      case "B":
        SRFID_INVENTORYSTATE_ID = SRFID_INVENTORYSTATE_B
      case "AB":
        SRFID_INVENTORYSTATE_ID = SRFID_INVENTORYSTATE_AB_FLIP
      default:
        SRFID_INVENTORYSTATE_ID = SRFID_INVENTORYSTATE_A
      }
      
      
      zt_RfidAppEngine.shared()?.updateSingultionControl(SRFID_SESSION_ID, setTagPopulation: Int32(TagPopulation),setSlFlag: SRFID_SLFLAG_ID, setInventoryState: SRFID_INVENTORYSTATE_ID)
                 resolve(true)
    }
 
  }
  
  @objc
  func setUniqueTag(_ TagBool: Int,
                resolver resolve: @escaping RCTPromiseResolveBlock,
                rejecter reject: @escaping RCTPromiseRejectBlock) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
      
      switch TagBool {
      case 1:
        zt_RfidAppEngine.shared()?.setUniqueTag(true)
      default:
        zt_RfidAppEngine.shared()?.setUniqueTag(false)
      }
      resolve(true)
    }
  } 
  // MARK: - Set Singultion

}

extension RNZebraRfid: zt_IRfidAppEngineDevListDelegate {
  func deviceListHasBeenUpdated() -> Bool {
    print(zt_RfidAppEngine.shared()?.getActualDeviceList()?.count ?? 0)
    let devices: [srfidReaderInfo] = zt_RfidAppEngine.shared()?.getActualDeviceList() as? [srfidReaderInfo] ?? []
    self.readers = devices
    return true
  }
}

// MARK: - RFID Scanner Delegate Handler

extension RNZebraRfid: zt_IRfidAppEngineTriggerEventDelegate {
  func getProximity(_ proximityVal: Int32) {
   print("Proximity: ", String(proximityVal))
    self.sendEvent(withName: "onProximityRead", body: String(proximityVal))
  }
  
  func onNewTriggerEvent(_ pressed: Bool) -> Bool {
    
    print("CHECK::: pressed: ", pressed)
    isPressed = pressed
    if pressed {
      var message: NSString?
      radioOption.startInventory(true, aMemoryBank: SRFID_MEMORYBANK_NONE, message: &message)
    } else {
      var message: NSString?
      radioOption.stopInventory(&message)
    }
    return true
  }
  
//  func onInventoryItem(_ tagData: srfidTagData!) {
//    if isPressed {
//      ScannedTags.add(["id": tagData.getTagId() ?? "",
//                             "rssi": Float(tagData.getPeakRSSI())
//                             ])
//      if ScannedTags.count == tag_NoofBatch {
//        self.sendEvent(withName: "onRfidRead", body: ["id": tagData.getTagId() ?? "",
//                                                      "rssi": Float(tagData.getPeakRSSI())
//                                                      ])
//        print("CHECK:::  TAG: SENT")
//        ScannedTags.removeAllObjects()
//      }
//    }
//    else{
//      if ScannedTags.count > 0 {
//        self.sendEvent(withName: "onRfidRead", body: ScannedTags)
//        print("CHECK:::  TAG: SENT")
//        ScannedTags.removeAllObjects()
//      }
//    }
//  }
  
  
  func onInventoryItem(_ tagData: srfidTagData!) {
    print("CHECK:::  onInventoryItem")
//    self.sendEvent(withName: "onRfidRead", body: [tagData.getTagId()])
//    if isPressed {
//
        print("CHECK:::  TAG: ", tagData.getTagId() ?? "unknown")
        self.sendEvent(withName: "onRfidRead", body: [["id": tagData.getTagId() ?? "",
                                                       "rssi": Float(tagData.getPeakRSSI())
                                                       ]]
                       )
//    }
  }
  
}




// MARK: - Bar code Scanner Delegate Handler

extension RNZebraRfid: IScannerAppEngineDevEventsDelegate{
  func scannerBarcodeEvent(_ barcodeData: Data!, barcodeType: Int32, fromScanner scannerID: Int32) {
    
    let str = String(decoding: barcodeData, as: UTF8.self)

    self.sendEvent(withName: "onRfidRead", body: [["id": str ?? "",
                                                    "rssi": 0
                                                      ]]
                          )
  }

  func showScannerRelatedUI(_ scannerID: Int32, barcodeNotification barcode: Bool) {
    print("showScannerRelatedUI")
  }


}
