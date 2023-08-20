//
//  CategoryTableViewController.swift
//  ToDoManager
//
//  Created by Zehra Saglam on 10/05/2023.
//

import UIKit
import CoreData
import RealmSwift

class CategoryTableViewController: SwipeTableViewController {
    
    let realm = try! Realm()

    var cats: Results<CategoryItem>? //You get result type of data when you fetch from realm
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist") ?? "o")
        
        ///Users/zehra/Library/Developer/CoreSimulator/Devices/90818C21-F03D-4CCD-84CE-01E1ACAB05EC/data/Containers/Data/Application/FF4D60A0-66C1-41A7-8AA4-5C8FE8FEE69C/Documents/default.realm
        
        Load()
        
        tableView.rowHeight = 80.0
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cats?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination as! ToDoManagerViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationViewController.selectedCat = cats?[indexPath.row]
        }
        
    }
    
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
//        cell.delegate = self
//        return cell
//    }
    
    /*
    // Pragma Mark
     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - TableView Datasourse Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCells", for: indexPath) as! SwipeTableViewCell
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = cats?[indexPath.row].title ?? "No Cat Around"
//        cell.delegate = self
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    //MARK: - Data Manipulation Methods
    
    override func deleteData(at indexPath: IndexPath) {
        if let item = self.cats?[indexPath.row] {
            do {
                try self.realm.write{
                    self.realm.delete(item)
                }
            } catch{
                print(error)
            }
            //tableView.reloadData()
        }
    }
    
    //MARK: - Updating
    override func editData(at indexPath: IndexPath) {
        
        if let item = self.cats?[indexPath.row] {
            
            var textField = UITextField()
            
            
            let alert = UIAlertController(title: "Edit Category", message: "Edit your category name", preferredStyle: .alert)
            let action = UIAlertAction(title: "Update", style: .default) {_ in

                do {
                    try self.realm.write{
                        item.title = textField.text!
                    }
                } catch{
                    print(error)
                }
                self.tableView.reloadData()
            }
            alert.addAction(action)
            alert.addTextField {alertTextField in
                textField = alertTextField
                textField.text = item.title
            }
            present(alert, animated: true)
        }
    }
    
    //MARK: - Saving
    func Save(category: CategoryItem) {
        do {
            //try context.save() // this is for nsobject
            try realm.write{
                realm.add(category)
            }
        } catch {
            print(error)
        }
        tableView.reloadData()
    }
    
    //MARK: - Loading
    func Load() {
        cats = realm.objects(CategoryItem.self) //cats must be result type
        tableView.reloadData()
    }

    //MARK: - Add button action
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add Category", message: "Let's add a category for new to-dos", preferredStyle: .alert)
        let action = UIAlertAction(title: "Create", style: .default) {_ in
            //let newCat = Category(context: self.context) //this is for nsobject
            let newCat = CategoryItem()
            newCat.title = textField.text!
            //self.cats.append(newCat) // it's not a simple array now so it will update itself automatically
            self.Save(category: newCat)
            print(textField.text!)
        }
        alert.addAction(action)
        alert.addTextField {alertTextField in
            textField = alertTextField
        }
        present(alert, animated: true)
    }
    
}
