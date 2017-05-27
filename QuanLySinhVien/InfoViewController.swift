import UIKit
import os.log

class InfoViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {

    // MARK: Properties
    @IBOutlet weak var textFieldStudentName: UITextField!
    @IBOutlet weak var textFieldStudentYearOld: UITextField!
    @IBOutlet weak var textFieldUniversity: UITextField!
    @IBOutlet weak var textViewDescription: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var student: Student?
    
    var infoStudent: Student? {
        didSet {
            configureView()
        }
    }
    
    func configureView() {
        if let infoStudent = infoStudent {
            if let studentName = textFieldStudentName, let studentYearOld = textFieldStudentYearOld, let university = textFieldUniversity, let description = textViewDescription {
                studentName.text = infoStudent.studentName
                studentYearOld.text = infoStudent.studentYearOld
                university.text = infoStudent.university
                description.text = infoStudent.description
                title = infoStudent.studentName
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        // Handle the text field’s user input through delegate callbacks.
        textFieldStudentName.delegate = self
        // Set up views if editing an existing Meal.
        if let student = student {
            navigationItem.title = student.studentName
            textFieldStudentName.text = student.studentName
            textFieldStudentYearOld.text = student.studentYearOld
            textFieldUniversity.text = student.university
            textViewDescription.text = student.description
        }
        // Enable the Save button only if the text field has a valid Meal name.
        updateSaveButtonState()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let studentName = textFieldStudentName.text ?? ""
        let studentYearOld = textFieldStudentYearOld.text ?? ""
        let university = textFieldUniversity.text ?? ""
        let description = textViewDescription.text ?? ""
        
        // Set the meal to be passed to MealTableViewController after the unwind segue.
        student = Student(studentName: studentName, studentYearOld: studentYearOld, university: university, description: description)
    }
    
    // MARK: Private method
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = textFieldStudentName.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    // MARK: Actions

    @IBAction func cancel(_ sender: UIBarButtonItem) {
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMealMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The MealViewController is not inside a navigation controller.")
        }
    }
}
