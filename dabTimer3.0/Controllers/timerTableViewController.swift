//
//  timerTableViewController.swift
//  dabTimer3.0
//
//  Created by Adam Reed on 2/12/18.
//  Copyright © 2018 RD concepts. All rights reserved.
//

import UIKit
import GoogleMobileAds

class timerTableViewController: UITableViewController, UpDownTimerViewControllerDelegate, AddTimerViewControllerDelegate {
    
    var timersObject: TimerListItem!

    @IBOutlet weak var GoogleBannerViewMain: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = timersObject?.name
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //MARK:= google Adwords
        // Test AdMob Banner ID
        //GoogleBannerViewMain.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        
        // Live AdMob Banner ID
        GoogleBannerViewMain.adUnitID = "ca-app-pub-3940256099942544/6300978111"
        GoogleBannerViewMain.rootViewController = self
        GoogleBannerViewMain.load(GADRequest())
    }

    @IBAction func addTimer(_ sender: Any) {
        
        let newRowIndex = timersObject?.items.count
        
        let newTimer = UpDownTimer()
        newTimer.name = "New Timer"
        timersObject?.items.append(newTimer)
        let indexPath = IndexPath(row: newRowIndex!, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        
    }
    
    
    //MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowTimer" {
            let controller = segue.destination as! UpDownTimerViewController
            controller.delegate = self
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.timerToWorkWith = timersObject?.items[indexPath.row]
            }
        } else if segue.identifier == "AddTimer" {
            let controller = segue.destination as! AddTimerViewController
            controller.delegate = self
        }
    }

  
    //MARK:- Private Methods
    func makeCell(for tableView: UITableView) -> UITableViewCell {
        let cellIdentifier = "TimerItem"
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            return cell
        } else {
            return UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        }
    }
    
    func configureText(for cell: UITableViewCell, with item: UpDownTimer) {
        
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.name
        let upTime = cell.viewWithTag(1001) as! UILabel
        upTime.text = String(item.heatUpTimer)
        let downTime = cell.viewWithTag(1002) as! UILabel
        downTime.text = String(item.coolDownTimer)
        
    }
    
    
    //MARK:- Table View
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (timersObject?.items.count)!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell = makeCell(for: tableView)
            let listTimer = timersObject?.items[indexPath.row]
        configureText(for: cell, with: listTimer!)
            cell.accessoryType = .detailDisclosureButton

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            let listTimer = timersObject?.items[indexPath.row]
            
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {
        
        
        timersObject?.items.remove(at: indexPath.row)

        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
        let controller = storyboard!.instantiateViewController(withIdentifier: "AddTimerController") as! AddTimerViewController
        controller.delegate = self
        
        let timerList = timersObject?.items[indexPath.row]
        controller.upDownTimerToEdit = timerList
        navigationController?.pushViewController(controller, animated: true)
    }
    

    //MARK:- Delegate Methods
    // UpDownTimerViewController - Delegate for returning the updated timer
    func returnTimerToWorkWith(_ controller: UpDownTimerViewController, didFinishWithTimer timer: UpDownTimer) {
        if let index = timersObject?.items.index(of: timer) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: timer)
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    // AddTimerViewController - Delegate for renaming the timer
    
    
    func addTimerViewControllerDelegateDidCancel(_ controller: AddTimerViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func sortTimers() {
        timersObject.items.sort(by:{ timers1, timers2 in
            return timers1.name.localizedCompare(timers2.name) == .orderedAscending })
    }
    
    func addTimerViewController(_ controller: AddTimerViewController, didFinishAdding timerListItem: UpDownTimer) {
        
        let newRowIndex = timersObject?.items.count
        timersObject?.items.append(timerListItem)
        
        
        let indexPath = IndexPath(row: newRowIndex!, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        sortTimers()
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
        
    }

    
    func addTimerViewController(_ controller: AddTimerViewController, didFinishEditing timerListItem: UpDownTimer) {
        if let index = timersObject?.items.index(of: timerListItem) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: timerListItem)
            }
        }
        
        navigationController?.popViewController(animated: true)
    }
}
    
    

