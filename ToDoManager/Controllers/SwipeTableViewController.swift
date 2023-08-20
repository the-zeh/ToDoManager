//
//  SwipeTableViewController.swift
//  ToDoManager
//
//  Created by Zehra Saglam on 21/06/2023.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            self.deleteData(at: indexPath)
            print("item deleted")
            

        }
        let editAction = SwipeAction(style: .destructive, title: "Edit") { action, indexPath in
            // handle action by updating model with deletion
            self.editData(at: indexPath)
            print("item deleted")
            
        }

        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        editAction.image = UIImage(named: "edit-icon")
        editAction.backgroundColor = UIColor(named: "edit-bg-color")

        return [deleteAction, editAction]
    }
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
                cell.delegate = self
                return cell
    }
    
    func deleteData(at indexPath: IndexPath) {
        
    }
    
    func editData(at indexPath: IndexPath) {


    }

}
