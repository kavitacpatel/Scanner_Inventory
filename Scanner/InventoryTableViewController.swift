//
//  InventoryTableViewController.swift
//  Scanner
//
//  Created by kavita patel on 4/6/16.
//  Copyright © 2016 kavita patel. All rights reserved.
//

import UIKit
import CoreData

class InventoryTableViewController: UITableViewController {

    var items = [NSManagedObject]()
    var itemnm = [String]()
    var img: UIImage!
       
    override func viewDidLoad() {
        super.viewDidLoad()
         navigationItem.leftBarButtonItem = editButtonItem()
       // self.tableview.registerClass(UITableViewCell.self, forCellReuseIdentifier: "ItemCell")

    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appdelegate.managedObjectContext
        let request = NSFetchRequest(entityName: "Products")
        do{
            let result = try context.executeFetchRequest(request)
            items = result as! [NSManagedObject]
            self.tableView.reloadData()
        }
        catch
        {
            print("Couldnt fetch data")
        }
        
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: indexPath)
        let item = items[indexPath.row]
        cell.textLabel?.text = item.valueForKey("name") as? String
        
        return cell
    }
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete
        {
            let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let context = appdelegate.managedObjectContext
            context.deleteObject(items[indexPath.row] as NSManagedObject)
            items.removeAtIndex(indexPath.row)
            do
                {
                    try context.save()
                    self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            catch
            {
                print("Cant delete")
            }
        }
    }
    func saveitem(name: String, img: UIImage , completion:() -> ())
    {
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appdelegate.managedObjectContext
        let entity = NSEntityDescription.entityForName("Products", inManagedObjectContext: context)
        let _item = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: context)
        _item.setValue(name, forKey: "name")
        do{
            try context.save()
            items.append(_item)
        }
        catch
        {
            print("Cant save")
        }
        self.tableView.reloadData()
        
    }
    

}
