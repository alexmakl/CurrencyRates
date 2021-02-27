//
//  RatesController.swift
//  CurrencyRates
//
//  Created by Alexander on 19.02.2021.
//

import UIKit

class RatesController: UITableViewController {
    
    @IBAction func pushRefreshAction(_ sender: UIBarButtonItem) {
        Model.shared.loadXMLFile(date: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("startLoadingXML"), object: nil, queue: nil) { (notification) in
            DispatchQueue.global(qos: .userInitiated).async {
                DispatchQueue.main.async {
                    let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
                    activityIndicator.startAnimating()
                    self.navigationItem.rightBarButtonItem?.customView = activityIndicator
                }
            }
        }

        NotificationCenter.default.addObserver(forName: NSNotification.Name("dataRefreshed"), object: nil, queue: nil) { (notification) in
            DispatchQueue.global(qos: .userInitiated).async {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.navigationItem.title = Model.shared.currentDate
                    let barButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.refresh, target: self, action: #selector(self.pushRefreshAction(_:)))
                    self.navigationItem.rightBarButtonItem = barButtonItem
                }
            }
        }
        navigationItem.title = Model.shared.currentDate
        
        Model.shared.loadXMLFile(date: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Model.shared.currencies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let rateForCell = Model.shared.currencies[indexPath.row]
        cell.textLabel?.text = rateForCell.name
        cell.detailTextLabel?.text = rateForCell.value

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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
