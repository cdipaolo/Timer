//
//  ViewController.swift
//  Timer
//
//  Created by Conner DiPaolo on 12/20/14.
//  Copyright (c) 2014 Conner DiPaolo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{

    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startButtonOutlet: UIButton!
    @IBOutlet weak var stopButtonOutlet: UIButton!

    var laps: [String] = []
    var lapNumber = 0
    var timer: NSTimer? = nil
    var timerTime: NSDate? = nil
    var stopBool: Bool = false
    var timeStopped: NSDate? = nil

    
    // Function takes NSTimeInterval and gives a string representation with padded zeros
    func stringFromTimeInterval(interval: NSTimeInterval) ->String {
        let ti: Int = Int(interval)
        let ms: Int = Int(interval*100) - (ti*100)
        let msString: String = ms<10 ? "0\(ms)": "\(ms)"
        let seconds: Int = ti % 60
        let minutes: Int = (ti / 60) % 60
        let hours: Int = (ti / 3600)
        if seconds < 10
        {
            return minutes<10 ? "\(hours):0\(minutes):0\(seconds).\(msString)" :"\(hours):\(minutes):0\(seconds).\(msString)"
        }
        else
        {
            return minutes<10 ? "\(hours):0\(minutes):\(seconds).\(msString)" : "\(hours):\(minutes):\(seconds).\(msString)"
        }
    }
    
    func updateLabel()
    {
        if timer != nil
        {
            if timerTime != nil
            {
                let time: NSTimeInterval = -timerTime!.timeIntervalSinceNow
                
                let timeString: String = stringFromTimeInterval(time)
                timeLabel.text = timeString
            }
            
            
        }
    }
    
    @IBAction func startButton()
    {
        if timer == nil && !stopBool
        {
            timerTime = NSDate()
            timer = NSTimer.scheduledTimerWithTimeInterval((5/100), target: self, selector: Selector("updateLabel"), userInfo: nil, repeats: true)
            
            //Update the start button image
            startButtonOutlet.setTitle("Lap", forState: UIControlState.Normal)
            let noImage = UIImage()
            startButtonOutlet.setImage(noImage, forState: UIControlState.Normal)
            
            //change clear button to stop button
            stopButtonOutlet.setImage(UIImage(named: "stop"), forState: UIControlState.Normal)
            stopButtonOutlet.setTitle("", forState: UIControlState.Normal)
        }
        else if timer == nil && stopBool
        {
            // if timer inactive and stopped then resume timer
            timerTime = timerTime!.dateByAddingTimeInterval(-timeStopped!.timeIntervalSinceNow)
            stopBool = false
            timer = NSTimer.scheduledTimerWithTimeInterval((5/100), target: self, selector: Selector("updateLabel"), userInfo: nil, repeats: true)
            
            //Update the start button image
            startButtonOutlet.setTitle("Lap", forState: UIControlState.Normal)
            let noImage = UIImage()
            startButtonOutlet.setImage(noImage, forState: UIControlState.Normal)
            
            //change clear button to stop button
            stopButtonOutlet.setImage(UIImage(named: "stop"), forState: UIControlState.Normal)
            stopButtonOutlet.setTitle("", forState: UIControlState.Normal)
        }
        else
        {
            // If timer active then the lap button was pressed: record lap
            let time: NSTimeInterval = -timerTime!.timeIntervalSinceNow
            lapNumber++
            laps.append("Lap \(lapNumber): " + stringFromTimeInterval(time))
            self.tableView.reloadData()
            
        }
    }
    
    @IBAction func stopButton()
    {
        if timer != nil && !stopBool
        {
            // if timer running, they stopped the timer
            timer = nil
            stopBool = true
            
            // set the time stopped to now so you can resume later from the correct time
            timeStopped = NSDate()
            
            //change start button to lap button
            startButtonOutlet.setImage(UIImage(named: "start")!, forState: UIControlState.Normal)
            startButtonOutlet.setTitle("", forState: UIControlState.Normal)
            
            //change stop button to clear button 
            stopButtonOutlet.setImage(UIImage(), forState: UIControlState.Normal)
            stopButtonOutlet.setTitle("Clear", forState: UIControlState.Normal)
        }
        else if timer == nil && stopBool
        {
            // if timer stopped, they cleared timer
            // reset everything....... Lord Zeroth Returns!!
            timer = nil
            stopBool = false
            timeLabel.text = "0:00:00.00"
            self.laps = []
            self.lapNumber = 0
            self.tableView.reloadData()
            
            //change clear button to stop button
            stopButtonOutlet.setImage(UIImage(named: "stop"), forState: UIControlState.Normal)
            stopButtonOutlet.setTitle("", forState: UIControlState.Normal)
            
        }
    }
    
    
    // create necessary tableView functions
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return laps.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell: UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        cell.textLabel?.text = laps[indexPath.row]
        return cell
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        // register the tableView and its dataSource as this class (self)
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

