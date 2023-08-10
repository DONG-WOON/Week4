//
//  TranslationViewController.swift
//  Week4
//
//  Created by 서동운 on 8/7/23.
//

import UIKit
import Alamofire
import SwiftyJSON

class TransitionViewController: UIViewController {
    
    @IBOutlet weak var originalTextView: UITextView!
    @IBOutlet weak var translateButton: UIButton!
    @IBOutlet weak var translatedTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func detectLanguage(text: String, completion: @escaping (String) -> Void) {
        let url = "https://openapi.naver.com/v1/papago/detectLangs"
        let headers: HTTPHeaders = [
            "X-Naver-Client-Id": APIKEY.naverID,
            "X-Naver-Client-Secret": APIKEY.naverSecret
        ]
        let parameters: Parameters = [
            "query": text
        ]
        
        AF.request(url, method: .post, parameters: parameters, headers: headers).validate().responseJSON {  response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let langCode = json["langCode"].stringValue
                completion(langCode)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func translate(sourceText: String, sourceLang: String) {
        let url = "https://openapi.naver.com/v1/papago/n2mt"
        let headers: HTTPHeaders = [
            "X-Naver-Client-Id": APIKEY.naverID,
            "X-Naver-Client-Secret": APIKEY.naverSecret
        ]
        
        let parameters: Parameters = [
            "source": sourceLang,
            "target": "en",
            "text": sourceText
        ]
        
        AF.request(url, method: .post, parameters: parameters, headers: headers).validate().responseJSON {  response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let message = json["message"]
                let result = message["result"]
                let translatedText = result["translatedText"].stringValue
                
                self.translatedTextView.text = translatedText
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @IBAction func translate(_ sender: UIButton) {
        guard let text = originalTextView.text else {
            // 글자 입력 얼럿
            return
        }
        detectLanguage(text: text) { sourceLang in
            self.translate(sourceText: text, sourceLang: sourceLang)
        }
    }
}
