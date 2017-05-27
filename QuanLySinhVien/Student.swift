import UIKit

class Student {
    
    // MARK: Properties
    var studentName: String
    var studentYearOld: String
    var university: String
    var description: String

    // MARK: Initialization
    init?(studentName: String, studentYearOld: String, university: String, description: String) {
        
        // Initialization should fail if there is no name or if the rating is negative.
        // The studentName must not be empty.
        guard !studentYearOld.isEmpty else {
            return nil
        }
        
        // Initialize stored properties.
        self.studentName = studentName
        self.studentYearOld = studentYearOld
        self.university = university
        self.description = description
    }
}
