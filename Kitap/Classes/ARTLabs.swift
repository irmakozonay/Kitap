//
//  ARTLabs.swift
//  Kitap
//
//  Created by Irmak Ozonay on 16.03.2021.
//

import Foundation
import QuickLook
import ARKit

public protocol ARTLabsDelegate {
    func modelLoadStarted()
    func modelLoadFinished()
}

public class ARTLabs : NSObject, QLPreviewControllerDataSource/*, QLPreviewControllerDelegate*/ {
    
    static let shared = ARTLabs()
//    var viewController = LoadingViewController() //mail01 bu ve bunu kullanan ornekler
//    var activeView: UIView?
    
    var modelURL: URL?
    public var delegate : ARTLabsDelegate?
    
    static var apiKey = ""
    
    override init(){}
    
    public static func artlabs() -> ARTLabs{ //mail2 populer olarak kullanilan firebase gibi frameworklere benzettim RemoteConfig.remoteConfig() gibi
        return shared
    }
    
    public static func setApiKey(_ apiKey: String){ //mail2 init kelimesi reserved oldugu icin kullanamiyoruz.
        ARTLabs.apiKey = apiKey
    }
    
    public func startARSession(productSKU: String){
//        UIApplication.shared.keyWindow?.rootViewController?.present(viewController, animated: true, completion: nil) //mail01
//        if let activeView = self.activeView {
//            let width: CGFloat = 20;
//            let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: activeView.frame.size.width/2 - width/2, y: activeView.frame.size.height/2 - width/2, width: width, height: width))
//            activityIndicator.startAnimating()
//            self.activeView?.addSubview(activityIndicator)
//        }
        downloadSampleUSDZ()
    }
    
//    public func setActiveView(_ activeView: UIView) { //mail01 bunda sorun kisinin viewi uzerinde islem yapiyoruz ve view uzerinde yapilacak farkli islemleri kontrol edemeyiz + tasarim uyumsuz kalabilir
//        self.activeView = activeView
//    }
    
    //mail3 ben olsam getModelURL + completion - getModelURL de urlden sonra download vb baya islem gerekiyo eklerdim
    //mail1 loading ekrani gerekli
    //mail2 swift4 ile yapiyorum ve ios9 sonrasi destekli
    
    public func getModelURL(productSKU: String, completion: @escaping (_ modelUrl: String?) -> Void) { //mail2 or mail3 completion block ile olmali direk string return edemez - ya da semaphore kullanicam
        let url = URL(string: "https://staging.api.artlabs.ai/secure/product/" + productSKU)!
        var request = URLRequest(url: url)
        request.setValue(ARTLabs.apiKey, forHTTPHeaderField: "x-api-key")
        print(ARTLabs.apiKey)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print ("error: \(error!)")
                return
            }
            guard let data = data else {
                print("No data")
                return
            }
            print(String(decoding: data, as: UTF8.self))
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 401 {
                    print("Please check your API key")
                    return
                } else if httpResponse.statusCode != 200 {
                    print("Response code: \(httpResponse.statusCode)")
                    return
                }
            }
            guard let product = try? JSONDecoder().decode(Product.self, from: data) else {
                print("Error: Couldn't decode data")
                return
            }
            print(product.name)
            if let productModel = product.models.first(where: { $0.file.ext == ".usdz" }) {
                completion(productModel.file.url)
            }
        }
        task.resume()
    }
    
    func downloadSampleUSDZ() {
        print("start download")
        delegate?.modelLoadStarted()
        let url = URL(string: "https://artlabs-3d.s3.eu-central-1.amazonaws.com/2a17bd30_2fe4_4202_81ad_b6cb3929e767_3e3ffd43d4.usdz")!
        let downloadTask = URLSession.shared.downloadTask(with: url) { [self] urlOrNil, responseOrNil, errorOrNil in
            guard let fileURL = urlOrNil else { return }
            do {
                let documentsURL = try
                    FileManager.default.url(for: .documentDirectory,
                                            in: .userDomainMask,
                                            appropriateFor: nil,
                                            create: false)
                print("fileURL: \(fileURL)")
                let savedURL = documentsURL.appendingPathComponent("artlabs_3dmodel." + url.pathExtension/*url.lastPathComponent*/)
                removeFile(fileUrl: savedURL)
                try FileManager.default.moveItem(at: fileURL, to: savedURL)
                self.modelURL = savedURL
                print("savedURL: \(savedURL)")
                DispatchQueue.main.async {
                    delegate?.modelLoadFinished()
                    self.presentAR()
                }
            } catch {
                print ("file error: \(error)")
            }
        }
        downloadTask.resume()
    }
    
    func removeFile(fileUrl: URL){
        if FileManager.default.fileExists(atPath: fileUrl.path) {
            do{
                try FileManager.default.removeItem(atPath: fileUrl.path)
            } catch{
                print("Meshkraft - file manager cant removeitem")
            }
        }
    }
    
    public func presentAR(){
        guard modelURL != nil else { return }
        let previewController = QLPreviewController()
        previewController.dataSource = self
//        previewController.delegate = self
//        viewController.dismiss(animated: true, completion: {UIApplication.shared.keyWindow?.rootViewController?.present(previewController, animated: true, completion: nil)})
        UIApplication.shared.keyWindow?.rootViewController?.present(previewController, animated: true, completion: nil)
//        viewController.disable()
//        viewController.present(previewController, animated: true, completion: nil)
    }
    
    public func numberOfPreviewItems(in controller: QLPreviewController) -> Int { return 1 }
    
    public func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        let url = self.modelURL!
        return url as QLPreviewItem
    }
    
//    public func previewControllerWillDismiss(_ controller: QLPreviewController) {
//        viewController.dismiss(animated: true, completion: nil)
//    }
}
