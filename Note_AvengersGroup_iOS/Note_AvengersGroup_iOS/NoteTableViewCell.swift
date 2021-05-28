//
//  NoteTableViewCell.swift
//  NotesApp
//
//

import UIKit

class NoteTableViewCell: UITableViewCell{
    
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var musicNoteIcon: UIImageView!
    @IBOutlet weak var noteImageView: UIImageView!
    @IBOutlet weak var locationIcon: UIImageView!
    @IBOutlet weak var noteBodyLabel: UILabel!
    
    var note: NoteItem?{
        didSet{
        
            self.titleLabel.text = note?.title ?? ""
            self.subjectLabel.text = note?.subject ?? ""
            self.noteBodyLabel.text = note?.body
            if let datetimestamp = self.note?.time{
                let date = Date(timeIntervalSince1970: TimeInterval(datetimestamp))
                self.timeLabel.text = self.timeAgoSinceDate(date.toGlobalTime())
                
            }
             
            
            if let _ = note?.audio{
                self.musicNoteIcon.isHidden = false
            }else{
                self.musicNoteIcon.isHidden = true
            }
            
            if let address = note?.address{
                if address.isEmpty{
                    self.locationIcon.isHidden = false
                }else{
                    self.locationIcon.isHidden = false
                }
               
            }else{
                self.locationIcon.isHidden = true
            }
            
            if let photo = note?.photo{
                self.noteImageView.isHidden = false
                self.noteImageView.image = UIImage(data: photo)
            }else{
                self.noteImageView.image = nil
                self.noteImageView.isHidden = true
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.containerView.layer.cornerRadius = 10
        self.containerView.clipsToBounds = true
        self.containerView.layer.masksToBounds = false
        self.containerView.layer.shadowRadius = 1.5
        self.containerView.layer.shadowOpacity = 0.4
        self.containerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.containerView.layer.shadowColor = UIColor.lightGray.cgColor
        self.noteImageView.layer.cornerRadius = 5
        
    }
    
    
    func timeAgoSinceDate(_ date:Date, numericDates:Bool = false) -> String {
        let calendar = Calendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = Date()
        let earliest = now < date ? now : date
        let latest = (earliest == now) ? date : now
        let components = calendar.dateComponents(unitFlags, from: earliest,  to: latest)
        
        if (components.year! >= 2) {
            return "\(components.year!) years ago"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!) months ago"
        } else if (components.month! >= 1){
            if (numericDates){
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) weeks ago"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) days ago"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) hours ago"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!) minutes ago"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1 minute ago"
            } else {
                return "A minute ago"
            }
        } else if (components.second! >= 3) {
            return "\(components.second!) seconds ago"
        } else {
            return "Just now"
        }
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
}

extension Date {
    func localDate() -> Date {
        let nowUTC = Date()
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: nowUTC))
        guard let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: nowUTC) else {return Date()}

        return localDate
    }
    
    func dateWithOutTime() -> Date {
        
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        let startOfDate = calendar.startOfDay(for: self)
        print(startOfDate)
        return startOfDate
    }
}


extension Date {

    // Convert local time to UTC (or GMT)
    func toGlobalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }

    // Convert UTC (or GMT) to local time
    func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }

}
