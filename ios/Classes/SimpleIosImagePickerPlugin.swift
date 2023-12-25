import UIKit
import Flutter
import PhotosUI

public class SimpleIosImagePickerPlugin: NSObject, FlutterPlugin, PHPickerViewControllerDelegate {
    
    private var result: FlutterResult?
    private var compressionQuality: Double = 1.0
    private var targetWidth: CGFloat?
    private var targetHeight: CGFloat?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "simple_ios_image_picker", binaryMessenger: registrar.messenger())
        let instance = SimpleIosImagePickerPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        self.result = result
        
        if call.method == "pickImage" {
            if let arguments = call.arguments as? [String: Any] {
                if let quality = arguments["compressionQuality"] as? Double {
                    self.compressionQuality = quality
                }
                self.targetWidth = arguments["width"] as? CGFloat
                self.targetHeight = arguments["height"] as? CGFloat

                if let limit = arguments["limit"] as? Int {
                    showPicker(limit: limit)
                } else {
                    showPicker(limit: 0)
                }
            }
        }
    }
    
    private func showPicker(limit: Int) {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = limit
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        
        if let viewController = UIApplication.shared.delegate?.window??.rootViewController {
            viewController.present(picker, animated: true, completion: nil)
        }
    }
    
    public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        var imagesData: [Data] = []
        let dispatchGroup = DispatchGroup()
        
        for result in results {
            dispatchGroup.enter()
            result.itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                if let uiImage = image as? UIImage {
                    let size = CGSize(width: self.targetWidth ?? uiImage.size.width, 
                                      height: self.targetHeight ?? uiImage.size.height)
                    let resizedImage = self.resizedImage(image: uiImage, for: size)
                    if let data = resizedImage?.jpegData(compressionQuality: self.compressionQuality) {
                        imagesData.append(data)
                    }
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.result?(imagesData)
        }
    }

    private func resizedImage(image: UIImage, for size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        image.draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
}
