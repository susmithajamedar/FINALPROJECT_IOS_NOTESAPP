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

    var note : NotesItem?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
