import UIKit
import os.log

class StudentTableViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating {
    
    let searchController = UISearchController(searchResultsController: nil)
    var filteredStudents = [Student]()

    // MARK: Properties
    var infoViewController: InfoViewController? = nil
    var students = [Student]()
    
    // MARK: View setup
    override func viewDidLoad() {
        super.viewDidLoad()

        searchController.searchBar.scopeButtonTitles = ["All", "Other"]
        searchController.searchBar.delegate = self
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        //searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        self.tableView.tableHeaderView = searchController.searchBar
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        
        loadDataSample()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // Load sample student list
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredStudents.count
        }
        return students.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "StudentTableViewCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! StudentTableViewCell
        
        // Fetches the appropriate student for the data source layout.
        let student: Student
        if searchController.isActive && searchController.searchBar.text != "" {
            student = filteredStudents[indexPath.row]
        } else {
            student = students[indexPath.row]
        }

        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.masksToBounds = true
        cell.studentNameRow.text = student.studentName
        cell.studentYearOldRow.text = "Age: " + student.studentYearOld
        cell.universityRow.text = student.university
        cell.descriptionRow.text = student.description

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "AddItem":
            os_log("Adding a new meal.", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
            guard let studentInfoViewController = segue.destination as? InfoViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedStudentCell = sender as? StudentTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedStudentCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedStudent: Student
            
            if searchController.isActive && searchController.searchBar.text != "" {
                selectedStudent = filteredStudents[indexPath.row]
            } else {
                selectedStudent = students[indexPath.row]
            }

            studentInfoViewController.infoStudent = selectedStudent
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }

    }

    // MARK: Private method
    
    func loadDataSample() {
        guard let student1 = Student(studentName: "Cao Yen Ngoc", studentYearOld: "22", university: "Ho Chi Minh city University and Technology of Education", description: "MISSION\nThe mission of HCMUTE is to be a leading institution in training, scientific research and technology transfer in Vietnam, continuously innovate to provide human resources and scientific products with high quality in the fields of technical and vocational education, science and technology to meet the demands of the economic-social development of the country and the region.\n\nVISION\nThe HCMC University of Technology and Education will become a top center of training, research, creativity, innovation and entrepreneurship in Vietnam, on a par with regional and worldwide prestigious universities.") else {
            fatalError("Unable to instantiate student1")
        }
        
        guard let student2 = Student(studentName: "Cao Yen Ngoc 2", studentYearOld: "22", university: "Ho Chi Minh city University and Technology of Education", description: "MISSION\nThe mission of HCMUTE is to be a leading institution in training.") else {
            fatalError("Unable to instantiate student2")
        }
        
        students += [student1, student2]
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredStudents = students.filter { student in
            let categoryMatch = (scope == "All") || (student.university == scope)
            return  categoryMatch && student.studentName.lowercased().contains(searchText.lowercased())
        }
        
        tableView.reloadData()
    }
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchText: searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
    
    func updateSearchResults(for searchController : UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchText: searchController.searchBar.text!, scope: scope)
    }
    
    // MARK: Actions

    @IBAction func unwindToStudentList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? InfoViewController, let student = sourceViewController.student {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing meal.
                students[selectedIndexPath.row] = student
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                // Add a new meal.
                let newIndexPath = IndexPath(row: students.count, section: 0)
                
                students.append(student)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
    }
}
