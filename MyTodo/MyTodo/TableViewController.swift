//
//  TableViewController.swift
//  MyTodo
//
//  Created by nju on 2021/10/22.
//

import UIKit

class TableViewController: UITableViewController {

    var items:[TodoItem] = [
        TodoItem(title: "work", isChecked: true, priority: 4),
        TodoItem(title: "play", isChecked: false, priority: 3)
    ]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationController?.navigationBar.prefersLargeTitles = true
        loadItems()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell...
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath) as! TableViewCell
        let item = items[indexPath.row]
        cell.title.text! = item.title
        cell.priority.text! = String(item.priority)
        if item.isChecked{
            cell.status.text! = "✅"
        }
        else{
            cell.status.text! = " "
        }
        if indexPath.row == 0{
            print(cell.title.text)
            cell.title.textColor = UIColor.red
            cell.priority.textColor = UIColor.red
        }
        else
        {
            cell.title.textColor = UIColor.black
            cell.priority.textColor = UIColor.black
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        items.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "Delete"){ [weak self] (action, view, completionHandler) in
            self?.rightdelete(indexPath: indexPath)
            completionHandler(true)
        }
        action.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func rightdelete(indexPath: IndexPath)
    {
        items.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "addItem"{
            let addItemController = segue.destination as! ItemViewController
            addItemController.addItemDelegate = self
        }
        if segue.identifier == "editItem"{
            let editItemController = segue.destination as! ItemViewController
            let cell = sender as! TableViewCell
            var isChecked:Bool
            if cell.status.text! == "✅"{
                isChecked = true
            }
            else{
                isChecked = false
            }
            let item = TodoItem(title: cell.title.text!, isChecked: isChecked, priority: Int(cell.priority.text!)!)
            editItemController.itemToEdit = item
            editItemController.itemIndex = tableView.indexPath(for: cell)!.row
            editItemController.editItemDelegate = self
        }
    }

}

extension TableViewController:AddItemDelegate{
    func addItem(item:TodoItem){
        self.items.append(item)
        self.items.sort(by: {(item1:TodoItem, item2:TodoItem) -> Bool in
            if item1.isChecked == false{
                if item2.isChecked == true{
                    return true
                }
                else{
                    return item1.priority > item2.priority
                }
            }
            else{
                if item2.isChecked == false{
                    return false
                }
                else{
                    return item1.priority > item2.priority
                }
            }
        })
        self.tableView.reloadData()
    }
}

extension TableViewController:EditItemDelegate{
    func editItem(item: TodoItem, itemIndex: Int) {
        self.items[itemIndex] = item
        self.items.sort(by: {(item1:TodoItem, item2:TodoItem) -> Bool in
            if item1.isChecked == false{
                if item2.isChecked == true{
                    return true
                }
                else{
                    return item1.priority > item2.priority
                }
            }
            else{
                if item2.isChecked == false{
                    return false
                }
                else{
                    return item1.priority > item2.priority
                }
            }
        })
        self.tableView.reloadData()
    }
}

extension TableViewController{
    func dataFilePath()->URL{
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        return path!.appendingPathComponent("TodoItems.json")
    }
    func saveAllItems(){
        do{
            let data = try JSONEncoder().encode(items)
            try data.write(to: dataFilePath(), options: .atomic)
        }catch{
            print("Can not save: \(error.localizedDescription)")
        }
    }
    func loadItems(){
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path){
            do{
                items = try JSONDecoder().decode([TodoItem].self, from: data)
            } catch {
                print("Error decoding list:\(error.localizedDescription)")
            }
        }
    }
}

