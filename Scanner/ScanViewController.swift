//
//  ViewController.swift
//  Scanner
//
//  Created by kavita patel on 4/6/16.
//  Copyright © 2016 kavita patel. All rights reserved.
//

import UIKit
import AVFoundation

class ScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var imgview: UIImageView!
    @IBOutlet weak var lblitemUrl: UILabel!
    @IBOutlet weak var lblitemcategory: UILabel!
    @IBOutlet weak var lblitemname: UILabel!
   
    @IBOutlet weak var savebtn: UIBarButtonItem!
    @IBOutlet weak var lblUPCcode: UILabel!
    var capturesession: AVCaptureSession!
    var previewlayer: AVCaptureVideoPreviewLayer!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        let tap = UITapGestureRecognizer(target: self, action: #selector(ScanViewController.UrlSelected) )
        tap.numberOfTapsRequired = 1
        lblitemUrl.addGestureRecognizer(tap)
       
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Portrait
    }
    
    
    func setupcapturesession()
    {
        self.savebtn.enabled = false
        let videocapturedevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
         capturesession = AVCaptureSession()
       
        let videoinput: AVCaptureDeviceInput
        //set up scan bar
        do
        {
            videoinput = try AVCaptureDeviceInput(device: videocapturedevice)
            
            capturesession.addInput(videoinput)
            setuppreviewlayer({
                self.capturesession.startRunning()
                
                self.addmetadatacaptureoutsession()
                
            })
            
        }
        catch{
            showalert("Scanning Error", msg: "Your device is not supported for scanning")
            return
        }
        
        
    }
    func setuppreviewlayer(completion:() -> ())
    {
       
        
        
        // set up preview layer
        previewlayer = AVCaptureVideoPreviewLayer(session: capturesession)
        previewlayer.frame = view.layer.bounds
        previewlayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        view.layer.addSublayer(previewlayer)
        
        completion()
    }
    
    func addmetadatacaptureoutsession()
    {
        let metadata = AVCaptureMetadataOutput()
        self.capturesession.addOutput(metadata)
        metadata.metadataObjectTypes = metadata.availableMetadataObjectTypes
        metadata.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
       
        
        if let metadataObject = metadataObjects.first
        {
           
            if let decodeddata: AVMetadataMachineReadableCodeObject = metadataObject as? AVMetadataMachineReadableCodeObject
            {
                
                foundcode(decodeddata.stringValue)
                capturesession.stopRunning()
                capturesession = nil
                previewlayer.removeFromSuperlayer()
                previewlayer = nil
                
            }
                
          
        }
    }
    
    
    
    
    func foundcode(code: String) {
        
        let itemobj = productDetails()
        lblUPCcode.text = code
      
        itemobj.getdetail(String(code.characters.dropFirst())) { (itemname, itemurl, itemcategory, imgdata, error) in
            
            dispatch_async(dispatch_get_main_queue(), {
                if error != nil
                {
                    self.showalert("Scanner", msg: "Item Not Found")
                    
                }
                else
                {
                    self.savebtn.enabled = true
                    self.showalert("Scanner", msg: "Item Found")
                    self.lblitemcategory.text = itemcategory
                    self.lblitemUrl.text = itemurl
                    self.lblitemname.text = itemname
                    
                    self.lblUPCcode.text = "027084120134"
                    
                    
                    self.imgview.image = UIImage(data: imgdata)!
                    
                }
                
                return
            })
        }
        
        
    }
    
    
    func UrlSelected()
    {
        if let _url = NSURL(string: lblitemUrl.text! as String)
        {
            UIApplication.sharedApplication().openURL(_url)
        }
    }
    func showalert(title: String, msg:String)
    {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let alertaction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(alertaction)
        presentViewController(alert, animated: true, completion: nil)
        
        
    }
    
    @IBAction func openscanner(sender: AnyObject) {
        
        setupcapturesession()
        
        if capturesession.running == false
        {
            capturesession.startRunning()
            
        }
        lblUPCcode.text = "None"
        imgview.image = nil
        lblitemUrl.text = "http://www.walmart.com"
        lblitemcategory.text = ""
        lblitemname.text = ""
        
    }
    
    @IBAction func savebtn(sender: AnyObject) {
        let itemvcobj = InventoryTableViewController()
        if lblitemname != ""
        {
           itemvcobj.saveitem(lblitemname.text!, img: imgview.image!, completion: {
           self.showalert("Save", msg: "Product saved in your list.")
           })
        }
        
        
    }
    @IBAction func cancelbtn(sender: AnyObject) {
       if capturesession != nil
       {
        if capturesession.running == true
       {
        
        capturesession.stopRunning()
        capturesession = nil
        previewlayer.removeFromSuperlayer()
        previewlayer = nil
        }
        }
        lblUPCcode.text = "None"
        imgview.image = nil
        lblitemUrl.text = "http://www.walmart.com"
        lblitemcategory.text = ""
        lblitemname.text = ""
     
    }
    

}

