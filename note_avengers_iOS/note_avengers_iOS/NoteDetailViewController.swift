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
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet var recordingTimeLabel: UILabel!
    @IBOutlet var record_btn_ref: UIButton!
    @IBOutlet var play_btn_ref: UIButton!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var note : NotesItem?
    var filename = ""
    var imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func addPhotosButtonTapped(_ button: UIButton) {
        
        
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        /*If you want work actionsheet on ipad
         then you have to use popoverPresentationController to present the actionsheet,
         otherwise app will crash on iPad */
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = button
            alert.popoverPresentationController?.sourceRect = button.bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        
        self.present(alert, animated: true, completion: nil)
        
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
    
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(.camera))
        {
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary(){
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
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
    
    func getDocumentsDirectory() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func getFileUrl() -> URL{
        let filePath = getDocumentsDirectory().appendingPathComponent(self.filename)
        return filePath
    }

}


//MARK: - UIImagePickerControllerDelegate
extension NoteDetailViewController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        /*
         Get the image from the info dictionary.
         If no need to edit the photo, use `UIImagePickerControllerOriginalImage`
         instead of `UIImagePickerControllerEditedImage`
         */
        if let editedImage = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.editedImage.rawValue)] as? UIImage{
            self.selectedImageView.image = editedImage
        }
        
        //Dismiss the UIImagePicker after selection
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
    }
}

