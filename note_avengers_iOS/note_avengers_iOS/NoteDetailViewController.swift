//
//  NoteDetailViewController.swift
//  note_avengers_iOS
//
//  Created by Vijay Kumar Sevakula on 2021-05-27.
//

import UIKit
import CoreLocation
struct Location {
    var fullAddress: String?
    var location: CLLocation?
    
}
var locationPicked:((Location)->())?

class NoteDetailViewController: UIViewController {
    @IBOutlet weak var titleLabel: UITextField!
    
    @IBOutlet weak var subtitleLabel: UITextField!
    @IBOutlet weak var noteBodyTextView: UITextView!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var note : NotesItem?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func addLocationButtonTapped(_ button: UIButton) {
        
        
        let vc = storyboard?.instantiateViewController(identifier: "LocationPickerViewController") as! LocationPickerViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func saveButtonTapped(_ button: UIBarButtonItem) {
       
        let noteItem = NotesItem(context: self.context)
        if let title = self.titleLabel.text{
            let finalTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
            if !finalTitle.isEmpty{
                //note.title = finalTitle
                noteItem.title = finalTitle
            }else{
                display_alert(msg_title: "Alert", msg_desc: "Note title is required", action_title: "OK")
                return
            }
        }
        
        if let text = self.subtitleLabel.text{
            let subject = text.trimmingCharacters(in: .whitespacesAndNewlines)
            if !subject.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty{
                noteItem.subject = subject
            }else{
                display_alert(msg_title: "Alert", msg_desc: "Note subject is required", action_title: "OK")
                return
            }
        }
        
        if let text = self.noteBodyTextView.text{
            let body = text.trimmingCharacters(in: .whitespacesAndNewlines)
            if !body.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty{
                noteItem.body = body
            }else{
                display_alert(msg_title: "Alert", msg_desc: "Note body is required", action_title: "OK")
                return
            }
        }
        
       
        
        
      
       
        if let note = self.note{
            //self.note = noteItem
            self.context.delete(note)
        }else{
          
        }
        
        do{
            try context.save()
            self.navigationController?.popViewController(animated: true)
        }catch let error {
            print(error.localizedDescription)
        }
        
        
        
    }
    
    func display_alert(msg_title : String , msg_desc : String ,action_title : String){
        let ac = UIAlertController(title: msg_title, message: msg_desc, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: action_title, style: .default)
        {
            (result : UIAlertAction) -> Void in
           // _ = self.navigationController?.popViewController(animated: true)
        })
        present(ac, animated: true)
    }

}
