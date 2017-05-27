import UIKit

class StudentTableViewCell: UITableViewCell {

    @IBOutlet weak var studentNameRow: UILabel!
    @IBOutlet weak var descriptionRow: UILabel!
    @IBOutlet weak var universityRow: UILabel!
    @IBOutlet weak var studentYearOldRow: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
