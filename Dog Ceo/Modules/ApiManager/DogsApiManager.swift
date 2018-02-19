//
//  DogsApiManager.swift
//  Dog Ceo
//
//  Created by Samuel on 05-02-18.
//  Copyright © 2018 Samuel. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import DataCache

public class DogsApiManager {
    
    public func getBreeds(_ completionHandler: (([Breed]?) -> Void)?) {
        
        let endpoint = "https://dog.ceo/api/breeds/list"
        
        Alamofire.request(endpoint, method: .get).responseJSON { response in
            
            guard response.result.isSuccess else {
                let error: NSError = response.result.error! as NSError
                debugPrint("Failure: " + error.localizedDescription)
                completionHandler?(nil)
                return
            }
            var entities = Array<Breed>()
            
            for breed in (response.result.value as! NSDictionary).value(forKey: "message") as! NSArray{
                entities.append(Breed(name: breed as? String))
            }
            
            completionHandler?(entities)
            
            return
        }
    }
    
    
    
    public func getSubBreeds(_ breedName: String, completionHandler: (([Breed]?) -> Void)?) {
        
        let endpoint = "https://dog.ceo/api/breed/\(breedName)/list"
        
        Alamofire.request(endpoint, method: .get).responseJSON { response in
            
            guard response.result.isSuccess else {
                let error: NSError = response.result.error! as NSError
                debugPrint("Failure: " + error.localizedDescription)
                completionHandler?(nil)
                return
            }
            
            var entities = Array<Breed>()
            
            if let _ =  (response.result.value as! NSDictionary).value(forKey: "message") as? String{
                completionHandler?(entities)
                return
            }
            
            for breed in (response.result.value as! NSDictionary).value(forKey: "message") as! NSArray{
                entities.append(Breed(name: breed as? String))
            }
            
            completionHandler?(entities)
            
            return
        }
    }
    
    public func getImagesBreeds(_ breedName: String, completionHandler: (([String]?) -> Void)?) {
        
        let endpoint = "https://dog.ceo/api/breed/\(breedName)/images"
        
        Alamofire.request(endpoint, method: .get).responseJSON { response in
            
            guard response.result.isSuccess else {
                let error: NSError = response.result.error! as NSError
                debugPrint("Failure: " + error.localizedDescription)
                completionHandler?(nil)
                return
            }
            
            var entities = Array<String>()
            
            if let _ =  (response.result.value as! NSDictionary).value(forKey: "message") as? String{
                completionHandler?(entities)
                return
            }
            
            for breedImageName in (response.result.value as! NSDictionary).value(forKey: "message") as! NSArray{
                entities.append(breedImageName as! String)
            }
            
            completionHandler?(entities)
            
            return
        }
    }
    
    public func getImagesSubBreeds(_ breedName: String,subBreedName: String, completionHandler: (([String]?) -> Void)?) {
        
        let endpoint = "https://dog.ceo/api/breed/\(breedName)/\(subBreedName)/images"
        
        Alamofire.request(endpoint, method: .get).responseJSON { response in
            
            guard response.result.isSuccess else {
                let error: NSError = response.result.error! as NSError
                debugPrint("Failure: " + error.localizedDescription)
                completionHandler?(nil)
                return
            }
            
            var entities = Array<String>()
            
            if let _ =  (response.result.value as! NSDictionary).value(forKey: "message") as? String{
                completionHandler?(entities)
                return
            }
            
            for breedImageName in (response.result.value as! NSDictionary).value(forKey: "message") as! NSArray{
                entities.append(breedImageName as! String)
            }
            
            completionHandler?(entities)
            
            return
        }
    }
    
    public func getRandomBreedImage(_ name: String, completionHandler: ((UIImage?,String) -> Void)?){
        
        let endpoint = "https://dog.ceo/api/breed/\(name)/images/random"
        
        Alamofire.request(endpoint, method: .get).responseJSON { response in
            
            guard response.result.isSuccess else {
                let error: NSError = response.result.error! as NSError
                debugPrint("Failure: " + error.localizedDescription)
                completionHandler?(nil,name)
                return
            }
            
            self.retrieveImage(endpoint: (response.value as! NSDictionary).value(forKey: "message") as! String, identifier : name, completionHandler: completionHandler)
            
            return
        }
        
        
    }
    
    public func getRandomSubBreedImage(_ name: String,breed: String, completionHandler: ((UIImage?,String) -> Void)?){
        
        let endpoint = "https://dog.ceo/api/breed/\(breed)/\(name)/images/random"
        
        Alamofire.request(endpoint, method: .get).responseJSON { response in
            
            guard response.result.isSuccess else {
                let error: NSError = response.result.error! as NSError
                debugPrint("Failure: " + error.localizedDescription)
                completionHandler?(nil,name)
                return
            }
            
            self.retrieveImage(endpoint: (response.value as! NSDictionary).value(forKey: "message") as! String, identifier : name, completionHandler: completionHandler)
            
            return
        }
        
    }
    public func retrieveImage(endpoint: String, identifier: String, completionHandler: ((UIImage?,String) -> Void)?){
        
        if let image = DataCache.instance.readImageForKey(key: identifier){
            completionHandler?(image,identifier)
        }else{
            Alamofire.request(endpoint).responseImage { response in
                
                if let image = response.result.value {
                    completionHandler?(image,identifier)
                    
                    DataCache.instance.write(image: image, forKey: identifier)
                }else{
                    completionHandler?(nil,identifier)
                }
            }
            
        }
        
    }
    
}
