//
//  PlaySoundsViewController.swift
//  Pitch Perfect Project
//
//  Created by Moaz on 9/21/15.
//  Copyright © 2015 Moaz Ahmed. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    //Global Declaration
    var recievedAudio: RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //initialize audio engine
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: recievedAudio.filePathUrl)
    }

    
    /********************** Audio Processing ****************************/

    //generic function that accepts any number of audio nodes and connect
    //them to the audio engine
    func audioEngineNodesSetup(audioNodes: AVAudioNode...) {
        
        //reset every thing
        audioEngine.stop()
        audioEngine.reset()
        
        //created audioPlayerNode
        let audioPlayerNode = AVAudioPlayerNode()
        
        //attach all audio nodes
        audioEngine.attachNode(audioPlayerNode)
        
        for audioNode in audioNodes {
            audioEngine.attachNode(audioNode)
        }
        
        //connect all nodes in correct order
        for var index = 0 ; index < audioNodes.count ; index++ {
            
            switch index {
                
            case 0:
                audioEngine.connect(audioPlayerNode, to: audioNodes[index], format: nil)
            case 1...audioNodes.count:
                audioEngine.connect(audioNodes[index-1], to: audioNodes[index], format: nil)
            default:
                break
            }
        }
        
        audioEngine.connect(audioNodes.last!, to: audioEngine.outputNode, format: nil)
        
        //prepare file for playback
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        //start playback
        try! audioEngine.start()
        audioPlayerNode.play()
    }
    
    func playAudioWithVariablePitch (pitch: Float) {
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        
        audioEngineNodesSetup(changePitchEffect)
        
    }
    
    func playAudioWithVariableRate(rate: Float) {

        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        let changePlaybackRateNode = AVAudioUnitVarispeed()
        changePlaybackRateNode.rate = rate
        
        audioEngineNodesSetup(changePlaybackRateNode)
    }
    
    
    /********************** Action Handlers ****************************/
    
    @IBAction func slowPlaybackButton(sender: UIButton) {
        
        playAudioWithVariableRate(0.75)
        
    }
    
    @IBAction func fastPlaybackButton(sender: AnyObject) {
        
        playAudioWithVariableRate(2.0)
    }
    
    @IBAction func chipMunkButton(sender: AnyObject) {
        
        playAudioWithVariablePitch(1500)
    }
    
    @IBAction func darthVaderButton(sender: AnyObject) {
        
        playAudioWithVariablePitch(-1500)
    }
    
    @IBAction func reverbButton(sender: AnyObject) {
        
        //set reverb
        let reverbEffect = AVAudioUnitReverb()
        reverbEffect.loadFactoryPreset(AVAudioUnitReverbPreset.LargeHall2)
        reverbEffect.wetDryMix = 60
        
        audioEngineNodesSetup(reverbEffect)
    }
    
    @IBAction func echoButton(sender: AnyObject) {
        
        //set echo with delay 300 ms
        let echoAudioNode = AVAudioUnitDelay()
        echoAudioNode.delayTime = NSTimeInterval(0.3)
        
        audioEngineNodesSetup(echoAudioNode)
    }
    
    @IBAction func stopButton(sender: AnyObject) {
        
        //stop playback
        audioEngine.stop()
        audioEngine.reset()
    }
}
