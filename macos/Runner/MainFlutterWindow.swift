import Cocoa
import Foundation
import FlutterMacOS

class MainFlutterWindow: NSWindow {
    
    open var currentFile: String?
    
    override func awakeFromNib() {
        let flutterViewController = FlutterViewController.init()
        let windowFrame = self.frame
        self.contentViewController = flutterViewController
        self.setFrame(windowFrame, display: true)
        
        RegisterGeneratedPlugins(registry: flutterViewController)
        
        // interect with Flutter
        let channel = FlutterMethodChannel(name: "pclViewer", binaryMessenger: flutterViewController.engine.binaryMessenger)
            channel.setMethodCallHandler({
                (call: FlutterMethodCall, result: FlutterResult) -> Void in
                if (call.method == "getCurrentFile") {
                    result(self.currentFile)
                } else {
                    result(FlutterMethodNotImplemented)
                }
            })
        
        super.awakeFromNib()
    }

}
