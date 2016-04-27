//
//  ProductDetails.swift
//  Scanner
//
//  Created by kavita patel on 4/6/16.
//  Copyright © 2016 kavita patel. All rights reserved.
//

import Foundation

class productDetails {
    
    func getdetail(upc: String, completion:(name: String, proucturl: String, itemcategory: String, img: NSData, error: NSError?) -> Void)    {
        let url = NSURL(string: "http://api.walmartlabs.com/v1/items?apiKey=d7fx3fuv9crs6yt9sa6fr9s4&upc=\(upc)")!
        let urlsession = NSURLSession.sharedSession()
        let jsonquery = urlsession.dataTaskWithURL(url, completionHandler:
            { data, response, error -> Void in
                
                do
                {
                    let err = error
                    let result = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSDictionary
                    let _name = result.valueForKeyPath("items.name") as? [String]
                    let _producturl = result.valueForKeyPath("items.productUrl") as? [String]
                    let _itemcategory = result.valueForKeyPath("items.categoryPath") as? [String]
                    let imgurlstr = result.valueForKeyPath("items.thumbnailImage") as? [String]
                    let imgurl = NSURL(string: imgurlstr![0])
                    let _img = NSData(contentsOfURL: imgurl!)
                    
                    completion(name: _name![0], proucturl: _producturl![0], itemcategory: _itemcategory![0], img: _img!, error: err)
                }
                catch
                {
                    print("json error")
                    
                }
                
        })
        jsonquery.resume()
        
    }
    
    
}