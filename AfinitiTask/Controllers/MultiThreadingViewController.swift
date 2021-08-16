//
//  ViewController.swift
//  AfinitiTask
//
//  Created by Ehtisham Rauf on 14/08/2021.
//

import UIKit
import Alamofire

class MultiThreadingViewController: UIViewController {

    //MARK: - OUTLETS -
    @IBOutlet var imageViewCollection: [UIImageView]!
    @IBOutlet var progressBarCollection: [UIProgressView]!
    
    //MARK: - PROPERTIES -
    let imagesUrl : [String] =
        [
            "https://wonderfulengineering.com/wp-content/uploads/2013/12/high-definition-wallpaper-3.jpg",
            "https://www.desktopbackground.org/download/o/2012/12/09/496563_38-beautiful-wallpapers-in-high-resolution-for-free-download_1920x1080_h.jpg",
            "https://cdn.pixabay.com/photo/2018/09/23/18/30/drop-3698073__480.jpg"
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - IBACTIONS -
    @IBAction func downloadClickHandler(_ sender: UIButton) {
        
        self.loadImagesConcurrently()
        
    }
    
    
}

//MARK: - IMAGE HANDLERS -
extension MultiThreadingViewController{
    
    //MARK: - IMAGE LOADING HANDLER -
    func loadImagesConcurrently(){
        
        let dispatchQueue = DispatchQueue(label: "concurrent.queue",attributes: .concurrent)
        
        for (index,imageURL) in self.imagesUrl.enumerated(){
            
            let progressBar = self.progressBarCollection[index]
            let imageView = self.imageViewCollection[index]
            
            dispatchQueue.async {

                self.downloadImage(imageUrl: imageURL, progressBar: progressBar, imageView: imageView)
            
            }
           
        }
        
    }
    
    //MARK: - IMAGE DOWNLOADING HANDLER -
    func downloadImage(imageUrl:String,progressBar:UIProgressView,imageView:UIImageView){
        
        AF.request(imageUrl)
            .downloadProgress { progress in
                
                DispatchQueue.main.async {
                    
                    progressBar.progress = Float(progress.fractionCompleted)
                    
                }
                
            }
            .responseData { response in
                
                DispatchQueue.main.async {
                    
                    if let DownloadedImage = UIImage(data: response.data!){
                        
                        imageView.image = DownloadedImage
                        
                    }
                    
                }
                
            }
        
    }
    
}
