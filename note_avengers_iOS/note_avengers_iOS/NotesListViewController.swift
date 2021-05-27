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
    
    
    var filtredNotes = [NotesItem]()
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
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
