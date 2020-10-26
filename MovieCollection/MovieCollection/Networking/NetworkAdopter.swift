//
//  NetworkAdopter.swift
//  MovieCollection
//
//  Created by Guru on 26/10/20.
//

import Foundation

public enum Method: Int {
    case post,get,put,delete
}
extension Method {
    
    var name:String {
        switch self {
        case .post:
            return "POST"
        case .get:
            return "GET"
        case .put:
            return "PUT"
        default:
            return "DELETE"
        }
    }
}
enum ConfigureURL {
   
    static let BASE_COMPANY_URL              = "https://api.themoviedb.org/3/"
    static let NOWPLAYING                    = "movie/now_playing"
    static let SEARCH                        = "search/movie"
}

class HttpClientApi: NSObject{
    
    //TODO: remove app transport security arbitary constant from info.plist file once we get API's
    var session : URLSession = URLSession.shared
    
    static func instance() ->  HttpClientApi{
        return HttpClientApi()
    }
    
    func makeAPICall<T:Codable>(url: String,modelObject:T.Type, params: [String:Any], method: Method, callback:Callback<T,String>) {
        
        //let urlString = URL(string: Config.BASE_COMPANY_URL + url)
        guard var urlComponents = URLComponents(string: ConfigureURL.BASE_COMPANY_URL + url) else { return }

        var queryItems = [URLQueryItem]()
        for (key,value) in params {
            queryItems.append(URLQueryItem(name:key, value: value as? String))
        }
        urlComponents.queryItems = queryItems
        print("Request URL is:\(urlComponents.url!.absoluteString)")
        
        var  request = URLRequest(url: urlComponents.url!)
        request.httpMethod = method.name
        if method.name == "POST" {
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            //request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        }else{
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        //print(params)
        session.dataTask(with: request) { (data, response, error) -> Void in
            if let data = data {
                if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode {
                    do{
                        let json = try JSONDecoder().decode(modelObject, from: data)
                        callback.onSuccess(json)
                    }catch let error {
                        callback.onFailure(error.localizedDescription)
                    }
                }else if let response = response as? HTTPURLResponse, 400...499 ~= response.statusCode{
                    print("Api Failed with Response Code:\(response.statusCode)")
                    callback.onFailure(response.statusCode.description)
                }else {
                    callback.onFailure(error?.localizedDescription ?? "")
                }
            }else {
                callback.onFailure(error?.localizedDescription ?? "")
            }
            }.resume()
        
    }
    func makeGetAPICall<T:Codable>(url: String,modelObject:T.Type,params: [String:Any], method: Method,callback:Callback<T,String>) {
        
        let urlString = URL(string: ConfigureURL.BASE_COMPANY_URL + url)
        
        var  request = URLRequest(url: urlString!)
        request.httpMethod = method.name
        let urlSession : URLSession = URLSession.shared
        print("Request URL is:\(request.url!.absoluteString)")

        urlSession.dataTask(with: request) { (data, response, error) -> Void in
            if let data = data {
                if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode {
                    do{
                        let json = try JSONDecoder().decode(modelObject, from: data)
                        callback.onSuccess(json)
                    }catch let error {
                        callback.onFailure(error.localizedDescription)
                    }
                } else if let response = response as? HTTPURLResponse, 400...499 ~= response.statusCode{
                    print("Api Failed with Response Code:\(response.statusCode)")
                    callback.onFailure(error?.localizedDescription ?? "")
                }
            }else {
                callback.onFailure(error?.localizedDescription ?? "")
            }
            }.resume()
        
    }
    func getPostString(params:[String:Any]) -> String
    {
        var data = [String]()
        for(key, value) in params
        {
            data.append(key + "=\(value)")
        }
        return data.map { String($0) }.joined(separator: "&")
    }
    func imageUploadRequest(attachemnt: Data?, uploadUrl: String, param: [String:String], callBack:Callback<Any, Any>) {
        
        let myUrl = NSURL(string: ConfigureURL.BASE_COMPANY_URL + uploadUrl)
        
        let request = NSMutableURLRequest(url:myUrl! as URL)
        request.httpMethod = "POST"
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        //let imageData = imageView.image!.jpegData(compressionQuality: 0.2)
        
        if(attachemnt==nil)  { return; }
        
        request.httpBody = createBodyWithParameters(parameters: param, filePathKey: "profilepic", imageDataKey: attachemnt!, boundary: boundary) as Data
        
        //myActivityIndicator.startAnimating();
        
        let task =  URLSession.shared.dataTask(with: request as URLRequest,
                                               completionHandler: {
                                                (data, response, error) -> Void in
                                                if let data = data {
                                                    
                                                    // You can print out response object
                                                    print(data.count)
                                                    // you can use data here
                                                    
                                                    // Print out reponse body
                                                    let responseString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                                                    print("****** response data = \(responseString!)")
                                                    
                                                    let json =  try!JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                                                    callBack.onSuccess(json)
                                                    
                                                    
                                                } else if let error = error {
                                                    print(error.localizedDescription)
                                                    callBack.onFailure(error.localizedDescription)
                                                }
        })
        task.resume()
        
        
    }
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: Data, boundary: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        
        let filename = "sample.jpg"
        
        let mimetype = "image/jpg"
        
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey)
        body.appendString(string: "\r\n")
        
        body.appendString(string: "--\(boundary)--\r\n")
        
        return body
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
}
extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
