//
//  MainTableViewController.swift
//  
//
//  Created by Adam Reed on 2/16/18.
//

import UIKit
import GoogleMobileAds

class MainTableViewController: UITableViewController, EditViewControllerDelegate, UINavigationControllerDelegate {
    
    
    var dataModel: DataModel!
    
    @IBOutlet weak var GoogleBannerView: GADBannerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "UpDownTimer"
        navigationItem.largeTitleDisplayMode = .always
        
        //MARK:= google Adwords
        // Test AdMob Banner ID
        //GoogleBannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        
        
        // Live AdMob Banner ID
        GoogleBannerView.adUnitID = "ca-app-pub-3940256099942544/6300978111"
        GoogleBannerView.rootViewController = self
        GoogleBannerView.load(GADRequest())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.delegate = self
        
        let index = dataModel.indexOfSelectedTimerlist
        
        if index >= 0 && index < dataModel.lists.count {
            let timerListItem = dataModel.lists[index]
            performSegue(withIdentifier: "ShowTimers", sender: timerListItem)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    //MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowTimers" {
            let controller = segue.destination as! timerTableViewController
            controller.timersObject = sender as! TimerListItem
        } else if segue.identifier == "Add" {
            let controller = segue.destination as! EditViewController
            controller.delegate = self
        }
    }
    

    // MARK:- Private Methods
    func makeCell(for tableView: UITableView) -> UITableViewCell {
        let cellIdentifier = "Cell"
        if let cell =
            tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            return cell
        } else {
            return UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
    }
    
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataModel.lists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = makeCell(for: tableView)
        // Update cell informaiton
        let timerList = dataModel.lists[indexPath.row]
        cell.textLabel?.text = timerList.name
        
        cell.accessoryType = .detailDisclosureButton
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        dataModel.indexOfSelectedTimerlist = indexPath.row
        
        let timerlist = dataModel.lists[indexPath.row]
        performSegue(withIdentifier: "ShowTimers", sender: timerlist)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        dataModel.lists.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    

    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
        let controller = storyboard!.instantiateViewController(withIdentifier: "EditViewController") as! EditViewController
        controller.delegate =  self
        
        let timerListItem = dataModel.lists[indexPath.row]
        controller.timerToEdit = timerListItem
        
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
    
    
    // MARK: - Delegate methods
    func editViewControllerDidCancel(_ controller: EditViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func editViewController(_ controller: EditViewController, didFinishAdding timerListItem: TimerListItem) {
        
        let newTimer = UpDownTimer()
        newTimer.name = "New Timer"
        timerListItem.items.append(newTimer)
        
        dataModel.lists.append(timerListItem)
        dataModel.sortTimerlists()
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
    
    func editViewController(_ controller: EditViewController, didFinishEditing timerListItem: TimerListItem) {
        
        dataModel.sortTimerlists()
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
        
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        // Reset the index to -1 if the back button was tapped.
        if viewController === self {
            dataModel.indexOfSelectedTimerlist = -1
        }
        
    }
    
    
}
    



