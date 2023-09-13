import Flutter
import UIKit
import PhotosUI

public class SimpleIosImagePickerPlugin: NSObject, FlutterPlugin, PHPickerViewControllerDelegate {
    
    private var result: FlutterResult?
    private var compressionQuality: Double = 1.0
    private var minWidth: Int = 1920
    private var minHeight: Int = 1080
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "simple_ios_image_picker", binaryMessenger: registrar.messenger())
        let instance = SimpleIosImagePickerPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        self.result = result
        
        if call.method == "pickImage" {
            if let arguments = call.arguments as? [String: Any],
            let limit = arguments["limit"] as? Int {
                if let quality = arguments["compressionQuality"] as? Double {
                    self.compressionQuality = quality
                }
                if let minWidth = arguments["minWidth"] as? Int {
                    self.minWidth = minWidth
                }
                if let minHeight = arguments["minHeight"] as? Int {
                    self.minHeight = minHeight
                }
                showPicker(limit: limit)
            } else {
                showPicker(limit: 0)
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
                    let resizedImage = self.fetchResizeImage(image: uiImage, targetSize: CGSize(width: self.minWidth, height: self.minHeight))
                    if let data = resizedImage.jpegData(compressionQuality: self.compressionQuality){
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

    func fetchResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        var newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }

        // コンテキストを作成し、新しいサイズに画像を描画
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: CGRect(origin: CGPoint.zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
}

