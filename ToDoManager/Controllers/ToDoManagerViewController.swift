//
//  ViewController.swift
//  ToDoManager
//
//  Created by Zehra Saglam on 04/05/2023.
//

import UIKit
import RealmSwift

class ToDoManagerViewController: SwipeTableViewController {
    var items: Results<Item>?
    let realm = try! Realm()
    
    var selectedCat : CategoryItem? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80.0
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist") ?? "o")
        
        //loadItems()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        title = selectedCat!.title
        guard let navBar = navigationController?.navigationBar else {fatalError("nav bar doesnt exist")}
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCells", for: indexPath)
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let item = items?[indexPath.row]
        
        cell.textLabel?.text = items?[indexPath.row].title ?? "No Item Mate"
        cell.accessoryType = item?.isDone ?? false ? .checkmark: .none
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = items?[indexPath.row] {
            do {
                try realm.write{
                    item.isDone = !item.isDone
                }
            } catch{
                print(error)
            }
            tableView.reloadData()
        }
        
    }
    
    //override func tableView
    
    func saveItems(item: Item) {
        do {
            //try context.save() // this is for nsobject
            try realm.write{
                realm.add(item)
                self.selectedCat?.items.append(item)
            }
        } catch {
            print(error)
        }
        tableView.reloadData()
    }
    
    func loadItems() {
        
        items = selectedCat?.items.sorted(byKeyPath: "title")
        tableView.reloadData()
    }
    
    override func deleteData(at indexPath: IndexPath) {
        if let item = self.items?[indexPath.row] {
            do {
                try realm.write{
                    realm.delete(item)
                }
            } catch {
                print(error)
            }
        }
       
    }
    
    //MARK: - Updating
    override func editData(at indexPath: IndexPath) {
        
        if let item = self.items?[indexPath.row] {
            
            var textField = UITextField()
            
            let alert = UIAlertController(title: "Edit To-Do", message: "Edit your to-do", preferredStyle: .alert)
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

    @IBAction func addButtonAction(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new item", message: "Type your new item's title", preferredStyle: .alert)
        let action = UIAlertAction(title: "Nice", style: .default){ (action) in
            // what happens now
            
            let newItem = Item()
            newItem.title = textField.text!
            newItem.isDone = false

            print(newItem)
            
            self.saveItems(item: newItem)
        }
        alert.addTextField {(alertTextField) in
            alertTextField.placeholder = "New item"
            textField = alertTextField
            print("voav")
        }
        alert.addAction(action)
        
        present(alert, animated: true)
    }
}

