//
//  TableViewController.swift
//  Memorable Places
//
//  Created by Richard Guerci on 19/09/2015.
//  Copyright © 2015 Richard Guerci. All rights reserved.
//

import UIKit

var places = [Dictionary<String,String>()]
var placeIndex = -1

class TableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		
		if NSUserDefaults.standardUserDefaults().objectForKey("places") != nil {
			places = NSUserDefaults.standardUserDefaults().objectForKey("places") as! [Dictionary<String,String>]
		}
		else{
			places.removeAtIndex(0)
		}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return places.count
    }

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		//create cell for index path
		let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
		cell.textLabel?.text =  places[indexPath.row]["name"]
		
		return cell
	}
	
	override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
		//initialize isNewPlace with selected row
		placeIndex = indexPath.row
		
		return indexPath
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "newPlace" {
			placeIndex = -1
		}
		
	}
	
	override func viewWillAppear(animated: Bool) {
		tableView.reloadData()
		print(places)
	}
	
	//Enable cell removing
	override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		
		if editingStyle == UITableViewCellEditingStyle.Delete {
			//Remove element selected
			places.removeAtIndex(indexPath.row)
			NSUserDefaults.standardUserDefaults().setObject(places, forKey: "places")
			
			//Refresh table
			tableView.reloadData()
		}
	}

}
