//
//  ViewController.swift
//  Course Catalog
//
//  Created by Der3k Burrola on 5/17/21.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
	
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var mySwitch: UISwitch!
		
	var courses: [String : [String : String]]!
	var courseKeys = Array<String>()
	var selectedCourses = Array<String>()
	var checkedCourses = [String: Int]()
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return courses.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier:"cell",for: indexPath)
		
		let key = courseKeys[indexPath[1]]
		let dictionaryItem = courses[key]
		let desc = dictionaryItem?["ShortDescription"]
		
		cell.textLabel?.text = "\(key)"
		cell.detailTextLabel?.text = "\(desc ?? " ")"
		if(selectedCourses.contains(key)){
			cell.accessoryType = .checkmark
		} else{
			cell.accessoryType = .none
		}
		
		return cell
	}
	
	//clicking on cell
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let cell = tableView.cellForRow(at: indexPath)
		
		let key = "\(cell?.textLabel?.text ?? "")"
		
		if(cell?.accessoryType == .checkmark){
			// remove from list
			var i = 0
			while i < selectedCourses.count
			{
				if(selectedCourses[i] == key){
					selectedCourses.remove(at: i)
					break
				}
				i = i + 1
			}
		} else {
			// add to list
			selectedCourses.append(key)
		}
		//tableView.deselectRow(at:indexPath, animated:true)
		self.tableView.reloadData()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		courses = loadCSCourses()
		courseKeys = Array(courses.keys)
		courseKeys.sort()
		self.tableView.delegate = self
	}


	func loadCSCourses() -> [String : [String : String]]? {
		let pListFileURL = Bundle.main.url(forResource: "CSCourses", withExtension: "plist", subdirectory: "")
		if let pListPath = pListFileURL?.path,
			let pListData = FileManager.default.contents(atPath: pListPath) {
			do {
				let pListObject = try PropertyListSerialization.propertyList(from: pListData, options:PropertyListSerialization.ReadOptions(), format:nil)
				guard let maybeCourses = pListObject as? [String : [String : String]] else {
					return nil
				}
				return maybeCourses
			} catch {
				print("Error reading CSCourses plist file: \(error)")
				return nil
			}
		}
		return nil
	}
	
	
	@IBAction func switch_flipped(_ sender: Any) {
		if(mySwitch.isOn){
			// Show only items that are checked
		} else{
			// show all items
		}
	}
	
}




