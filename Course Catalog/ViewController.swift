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
	var showOnlyChecked = false
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// Set size based on switch
		return showOnlyChecked ? selectedCourses.count : courses.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier:"cell",for: indexPath)
		let index = indexPath[1]
		// set key from either full list or only selected list
		let key = showOnlyChecked ? selectedCourses[index] : courseKeys[index]
		let dictionaryItem = courses[key]
		let desc = dictionaryItem?["ShortDescription"]
		// set labels
		cell.textLabel?.text = "\(key)"
		cell.detailTextLabel?.text = "\(desc ?? " ")"
		cell.accessoryType = selectedCourses.contains(key) ? .checkmark : .none

		return cell
	}
	
	// Table Cell clicked
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let cell = tableView.cellForRow(at: indexPath)
		let key = "\(cell?.textLabel?.text ?? "")"
	
		if(cell?.accessoryType == .checkmark){
			// remove from list
			// TODO: use a foreach loop instead to make it nicer
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
			selectedCourses.sort()
		}
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
		showOnlyChecked = mySwitch.isOn
		self.tableView.reloadData()
	}
	
}




