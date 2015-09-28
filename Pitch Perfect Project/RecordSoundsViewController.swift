//
//  RecordSoundsViewController.swift
//  Pitch Perfect Project
//
//  Created by Moaz on 9/21/15.
//  Copyright © 2015 Moaz Ahmed. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    //Outlets
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!
    
    //Global Declarations
    var audioRecorder: AVAudioRecorder!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getRecordFileName() -> NSURL {
        
        //return date time as file name
        
        //get executable's directory
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        //get file name
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime) + ".wav"
        
        //generate file path
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        return filePath!
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        
        //save file if recording is successfull
        if flag {
            let audioFile = RecordedAudio(filePathUrl: audioRecorder.url, fileTitle: audioRecorder.url.lastPathComponent)
            self.performSegueWithIdentifier("recordingStopped", sender: audioFile)
        }else{
            recordLabel.text = "Recording Failed"
            print("Recording was not successfull")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        //check if this is the right segue
        if segue.identifier == "recordingStopped" {
            let playSoundsVS: PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            
            //transfer data to second scene
            playSoundsVS.recievedAudio = sender as! RecordedAudio
        }
    }
    
/********************** Action Handlers ****************************/

    @IBAction func recordButton(sender: UIButton) {
        
        //recording started
        recordLabel.text = "Recording..."
        recordButton.enabled = false
        
        //show control buttons
        resumeButton.hidden = false
        stopButton.hidden = false
        pauseButton.hidden = false
        
        //create recording session
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        let filePath = getRecordFileName()
        
        try! audioRecorder = AVAudioRecorder(URL: filePath, settings: [:])
        audioRecorder.meteringEnabled = true
        audioRecorder.delegate = self
        
        //start recording
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopButton(sender: UIButton) {

        //recording stopped
        recordLabel.text = "Tab To Record"
        recordButton.enabled = true
        
        //stop recording and prepare for segue
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }

    @IBAction func pauseButton(sender: AnyObject) {
        
        //pause recording
        audioRecorder.pause()
        recordLabel.text = "Recording Paused"
    }
    
    @IBAction func resumeButton(sender: AnyObject) {
        
        //resume recording
        audioRecorder.record()
        recordLabel.text = "Recording..."

    }
    
}

