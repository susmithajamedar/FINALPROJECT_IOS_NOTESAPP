//
//  ViewController.swift
//  NotesApp
//
//￼

import UIKit
import CoreData


class NotesListViewController: UIViewController {
    
    @IBOutlet weak var notesTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var sortSegment: UISegmentedControl!
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var notes = [NoteItem]()
    var filtredNotes = [NoteItem]()
  
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getAllItems()
    }
    
    func getAllItems(){
        do{
            self.notes = try context.fetch(NoteItem.fetchCoreRequest())
            self.notes = self.notes.sorted(by: {$0.time > $1.time})
            self.filtredNotes = self.notes
            self.notesTableView.reloadData()
        
        }catch let error {
            print(error.localizedDescription)
        }
    }
    
   
    
    
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.sortSegment.selectedSegmentIndex = 1
    }
    
    
    
    @IBAction func addNote(_ sender: UIBarButtonItem) {
        let vc = storyboard?.instantiateViewController(identifier: "NoteDetailViewController") as! NoteDetailViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func sortSwitched(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            self.filtredNotes = self.filtredNotes.sorted(by: {$0.title! < $1.title!})
            
            self.notesTableView.reloadData()
        }else{
            self.filtredNotes = self.filtredNotes.sorted(by: {$0.time > $1.time})
            
            self.notesTableView.reloadData()
        }
    }
    
    
    
    
    
    
}

extension NotesListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "NoteDetailViewController") as! NoteDetailViewController
        vc.note = self.filtredNotes[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtredNotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteTableViewCell") as! NoteTableViewCell
        cell.note = self.filtredNotes[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = self.filtredNotes[indexPath.row]
            self.context.delete(item)
            
            do{
                 try context.save()
            }catch let error {
                print(error.localizedDescription)
            }
            
            self.getAllItems()
        }
    }
    

    
}


extension NotesListViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty{
            self.filtredNotes = self.notes
        }else{
            self.filtredNotes = self.notes.filter{$0.title!.lowercased().contains(searchText.lowercased())}
        }
        self.notesTableView.reloadData()
    }
}


