import UIKit
import Flutter
import PhotosUI

public class SimpleIosImagePickerPlugin: NSObject, FlutterPlugin, PHPickerViewControllerDelegate {
    
    private var result: FlutterResult?
    private var compressionQuality: Double = 1.0
    private var maxWidth: CGFloat? 
    private var maxHeight: CGFloat? 
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "simple_ios_image_picker", binaryMessenger: registrar.messenger())
        let instance = SimpleIosImagePickerPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        self.result = result
        
        if call.method == "pickImage" {
            if let arguments = call.arguments as? [String: Any] {
                self.compressionQuality = (arguments["compressionQuality"] as? Double) ?? 1.0
                self.maxWidth = arguments["maxWidth"] as? CGFloat
                self.maxHeight = arguments["maxHeight"] as? CGFloat

                let limit = arguments["limit"] as? Int ?? 0
                showPicker(limit: limit)
            }
        }
    }
    
    private func showPicker(limit: Int) {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = limit
        configuration.filter = .images
        if #available(iOS 15.0, *) {
            configuration.selection = .ordered
        }
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        
        if let viewController = UIApplication.shared.delegate?.window??.rootViewController {
            viewController.present(picker, animated: true, completion: nil)
        }
    }
    
    public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        var imagesData: [Int: Data] = [:]
        let dispatchGroup = DispatchGroup()
        
        for (index, result) in results.enumerated() {
            dispatchGroup.enter()
            result.itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                if let uiImage = image as? UIImage {
                    let resizedImage = self.resizeImage(image: uiImage, maxWidth: self.maxWidth, maxHeight: self.maxHeight)
                    if let data = resizedImage.jpegData(compressionQuality: self.compressionQuality) {
                        imagesData[index] = data
                    }
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            let imageList = (0..<imagesData.count).map { imagesData[$0] }
            self.result?(imageList)
        }
    }

    private func resizeImage(image: UIImage, maxWidth: CGFloat?, maxHeight: CGFloat?) -> UIImage {
        let widthRatio  = maxWidth.map { $0 / image.size.width } ?? 1
        let heightRatio = maxHeight.map { $0 / image.size.height } ?? 1
        let ratio = min(widthRatio, heightRatio)
        let newSize = CGSize(width: image.size.width * ratio, height: image.size.height * ratio)
        return UIGraphicsImageRenderer(size: newSize).image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}
