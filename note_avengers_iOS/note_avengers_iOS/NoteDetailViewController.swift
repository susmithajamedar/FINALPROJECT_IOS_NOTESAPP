//
//  NoteDetailViewController.swift
// NotesApp
//
//

import UIKit
import CoreLocation
import CoreData


struct Location {
    var fullAddress: String?
    var location: CLLocation?
    
}
var locationPicked:((Location)->())?

import AVFoundation
class NoteDetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UITextField!
    
    @IBOutlet weak var subtitleLabel: UITextField!
    @IBOutlet weak var noteBodyTextView: UITextView!
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var locationButton: UIButton!
    
    @IBOutlet var recordingTimeLabel: UILabel!
    @IBOutlet var record_btn_ref: UIButton!
    @IBOutlet var play_btn_ref: UIButton!
    
    
    
    var audioRecorder: AVAudioRecorder!
    var audioPlayer : AVAudioPlayer!
    var meterTimer:Timer!
    var isAudioRecordingGranted: Bool!
    var isRecording = false
    var isPlaying = false
    
    var filename = ""
    
    var imagePicker = UIImagePickerController()
    var location: Location?
    
    var note : NotesItem?
    var id = String()
    
    var isUpdate = Bool()
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.noteBodyTextView.layer.cornerRadius = 5
        self.noteBodyTextView.clipsToBounds = true
        self.noteBodyTextView.layer.masksToBounds = false
        self.noteBodyTextView.layer.shadowRadius = 1.5
        self.noteBodyTextView.layer.shadowOpacity = 0.4
        self.noteBodyTextView.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        self.noteBodyTextView.layer.shadowColor = UIColor.lightGray.cgColor
        
        self.selectedImageView.layer.cornerRadius = 5
        self.selectedImageView.clipsToBounds = true
        self.selectedImageView.layer.masksToBounds = true
        self.selectedImageView.layer.shadowRadius = 1.5
        self.selectedImageView.layer.shadowOpacity = 0.4
        self.selectedImageView.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        checkRecordPermission()
        imagePicker.delegate =  self
        
        locationPicked = { location in
            self.locationButton.setTitle(location.fullAddress, for: .normal)
            self.location = location
        }
        
        
        if let note = self.note{
            self.titleLabel.text = note.title ?? ""
            self.subtitleLabel.text = note.subject ?? ""
            self.noteBodyTextView.text = note.body ?? ""
            
            self.location = Location(fullAddress: note.address, location: CLLocation(latitude: note.latitude, longitude: note.longitude))
            let loc  = self.location?.fullAddress ?? ""
            self.locationButton.setTitle(loc, for: .normal)
            if let image = note.photo{
                self.selectedImageView.image = UIImage(data: image)
            }
            
            self.filename = note.audio ?? ""
            self.id = note.id ?? ""
            self.saveButton.title = "Update"
            isUpdate = true
        }else{
            self.saveButton.title = "Save"
            isUpdate = false
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.audioPlayer?.stop()
    }
    
    
    
    func checkRecordPermission(){
        switch AVAudioSession.sharedInstance().recordPermission {
        case AVAudioSession.RecordPermission.granted:
            isAudioRecordingGranted = true
            break
        case AVAudioSession.RecordPermission.denied:
            isAudioRecordingGranted = false
            break
        case AVAudioSession.RecordPermission.undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission({ (allowed) in
                if allowed {
                    self.isAudioRecordingGranted = true
                } else {
                    self.isAudioRecordingGranted = false
                }
            })
            break
        default:
            break
        }
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
    
    func setup_recorder(){
        if isAudioRecordingGranted{
            let session = AVAudioSession.sharedInstance()
            do{
                try session.setCategory(AVAudioSession.Category.playAndRecord, options: .defaultToSpeaker)
                try session.setActive(true)
                let settings = [
                    AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                    AVSampleRateKey: 44100,
                    AVNumberOfChannelsKey: 2,
                    AVEncoderAudioQualityKey:AVAudioQuality.high.rawValue
                ]
                audioRecorder = try AVAudioRecorder(url: getFileUrl(), settings: settings)
                audioRecorder.delegate = self
                audioRecorder.isMeteringEnabled = true
                audioRecorder.prepareToRecord()
            }
            catch let error {
                print(error.localizedDescription)
                display_alert(msg_title: "Error", msg_desc: error.localizedDescription, action_title: "OK")
            }
        }else{
            display_alert(msg_title: "Error", msg_desc: "Don't have access to use your microphone.", action_title: "OK")
        }
    }
    
    
    @objc func updateAudioMeter(timer: Timer){
        if audioRecorder.isRecording{
            let hr = Int((audioRecorder.currentTime / 60) / 60)
            let min = Int(audioRecorder.currentTime / 60)
            let sec = Int(audioRecorder.currentTime.truncatingRemainder(dividingBy: 60))
            let totalTimeString = String(format: "%02d:%02d:%02d", hr, min, sec)
            recordingTimeLabel.text = totalTimeString
            audioRecorder.updateMeters()
        }
    }
    
    func finishAudioRecording(success: Bool){
        if success{
            audioRecorder.stop()
            audioRecorder = nil
            meterTimer.invalidate()
            print("recorded successfully.")
        }else{
            print("Recording failed")
            display_alert(msg_title: "Error", msg_desc: "Recording failed.", action_title: "OK")
        }
    }
    
    
    func prepare_play(){
        do
        {
            audioPlayer = try AVAudioPlayer(contentsOf: getFileUrl())
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
        }catch let error {
           
            display_alert(msg_title: "Error", msg_desc: error.localizedDescription, action_title: "OK")
        }
    }
    
    @IBAction func play_recording(_ sender: Any)
    {
       
        if(isPlaying){
            audioPlayer?.stop()
            record_btn_ref.isEnabled = true
            play_btn_ref.setTitle(" Play", for: .normal)
            isPlaying = false
        }else{
            if FileManager.default.fileExists(atPath: getFileUrl().path){
                record_btn_ref.isEnabled = false
                play_btn_ref.setTitle(" Pause", for: .normal)
                prepare_play()
                audioPlayer?.play()
                isPlaying = true
            }else{
                display_alert(msg_title: "Error", msg_desc: "Audio file is missing.", action_title: "OK")
            }
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
        
        if let image = self.selectedImageView.image{
            noteItem.photo = image.jpegData(compressionQuality: 0.8)
            
        }
        
        if !self.filename.isEmpty{
            noteItem.audio = self.filename
        }
        
        if let loc = self.location{
           
            noteItem.latitude = loc.location?.coordinate.latitude ?? 0.0
            noteItem.longitude = loc.location?.coordinate.longitude ?? 0.0
            noteItem.address = loc.fullAddress
            
        }
        if self.id.isEmpty{
            noteItem.id = "\(Date().unixTimestamp)_id"
        }else{
            noteItem.id = self.id
        }
       
        noteItem.time = Double(Date().localDate().unixTimestamp)/1000
        
       
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
    
    @IBAction func addVoiceNoteButtonTapped(_ button: UIButton) {
        if(isRecording){
            finishAudioRecording(success: true)
            record_btn_ref.setTitle(" Record", for: .normal)
            play_btn_ref.isEnabled = true
            isRecording = false
        }else{
            filename = "\(Date().unixTimestamp)_audio.m4a"
            setup_recorder()
            
            audioRecorder.record()
            meterTimer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector:#selector(self.updateAudioMeter(timer:)), userInfo:nil, repeats:true)
            record_btn_ref.setTitle(" Stop", for: .normal)
            play_btn_ref.isEnabled = false
            isRecording = true
        }
        
    }
    
    @IBAction func playAudio(_ button: UIButton) {
        
    }
    
}


extension NoteDetailViewController : AVAudioRecorderDelegate, AVAudioPlayerDelegate{
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool)
    {
        if !flag{
            finishAudioRecording(success: false)
        }
        play_btn_ref.isEnabled = true
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool)
    {
        record_btn_ref.isEnabled = true
    }
}


extension Date {
    var unixTimestamp: Int64 {
        return Int64(self.timeIntervalSince1970 * 1_000)
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

