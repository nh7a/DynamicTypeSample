import UIKit

class TableViewController: UITableViewController {
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TableViewCell.registerForTableView(tableView)
        
        // For self-sizing cell.
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150
        
        // For Dynamic Type support.
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(TableViewController.onContentSizeCategoryDidChange(_:)),
                                                         name: UIContentSizeCategoryDidChangeNotification,
                                                         object: nil)
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = TableViewCell.dequeueReusableCellForTableView(tableView, forIndexPath: indexPath)
        if let l = cell.viewWithTag(100) as? UILabel {
            l.text = "\(indexPath.row)"
        }
        return cell
    }
    
    // MARK: - Notification handler
    
    func onContentSizeCategoryDidChange(note: NSNotification) {
        TableViewCell.registerForTableView(tableView)  // Re-register to take into account new preffered size.
        tableView.reloadData()
    }
}

// MARK: -

class TableViewCell: UITableViewCell {
    class var reuseIdentifier: String {
        return "TableViewCell" + UIApplication.sharedApplication().preferredContentSizeCategory
    }
    
    class func registerForTableView(tableView: UITableView) {
        tableView.registerNib(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
    }
    
    class func dequeueReusableCellForTableView(tableView: UITableView, forIndexPath indexPath: NSIndexPath) -> TableViewCell {
        return tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! TableViewCell
    }
}
