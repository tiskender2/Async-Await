//
//  ViewController.swift
//  AsyncAwaitExample
//
//  Created by Tolga İskender on 7.11.2021.
//

import UIKit



// async neden kullanır ?
// uzun bir işin bitmesini beklemeden bu işin sonucuna bağımlı olmayan diğer işlere devam edebilmek için kullanılır
// await neden kullanır  ?
// async tagi ile sistemde yurutulen işin  işlemini bitirip olumlu sonuc dondugunu anlamak için kullanılır

class ViewController: UIViewController {

    @IBOutlet weak var resultImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            await fetchImages()
        }
       // fetchImagesClosure()
    }

    
}

//MARK: ASYNC AWAIT
extension ViewController {
    
    func fetchImages() async {
        let image = await loadImage(index: 1)
        self.resultImage.image = image
//        async let image1 = await loadImage(index: 1)
//        async let image2 = await loadImage(index: 2)
//        async let image3 = await loadImage(index: 3)
//        let imageArray = await [image1, image2]
//        let image3Result = await image3
//        DispatchQueue.main.async {
//            for i in 0..<imageArray.count {
//                print(i)
//                print(imageArray[i])
//                self.resultImage.image = imageArray[i]
//                DispatchQueue.main.asyncAfter(deadline: .now() + 2 ) {
//                    self.resultImage.image = image3Result
//                }
//
//            }
//
//        }
        
    }
    
    func loadImage(index: Int) async -> UIImage {
        let imageURL = URL(string: "https://picsum.photos/200/300")!
        let request = URLRequest(url: imageURL)
        let (data, _) = try! await URLSession.shared.data(for: request, delegate: nil)
        print("Finished loading image \(index)")
        return UIImage(data: data)!
    }
    
    
}





//MARK: CLOSURE
extension ViewController {
    
    func fetchImagesClosure() {
        loadImage(index: 1) { [weak self] image, error in
            if error == nil {
                self?.loadImage(index: 2) { image2, error in
                        if error == nil {
                            self?.resultImage.image = image2
                        } else {
                            print(error.debugDescription)
                        }
                    }
                DispatchQueue.main.async {
                    self?.resultImage.image = image
                }
            } else {
                print(error.debugDescription)
            }
        }
    }
    
    func loadImage(
        index: Int,
        completionHandler: @escaping (_ image: UIImage?, _ error: String?) -> Void) {
        let imageURL = URL(string: "https://picsum.photos/200/300")!
        let imageTask = URLSession.shared.dataTask(with: imageURL) { data, response, error in
            guard let data = data, let image = UIImage(data: data), (response as? HTTPURLResponse)?.statusCode == 200 else {
                completionHandler(nil, "error")
                return
            }
            completionHandler(image, nil)
            
        }
        imageTask.resume()
    }
}
