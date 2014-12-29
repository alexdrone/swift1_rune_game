//
//  ViewController.swift
//  Runes
//
//  Created by Alex Usbergo on 28/07/14.
//  Copyright (c) 2014 Alex Usbergo. All rights reserved.
//

import UIKit
import MicroKit
import AVFoundation
import AudioToolbox

public class ViewController: UIViewController, LevelViewDelegate {

    /// the name of the xib file describing the current level
    public var levelName = "0"
    var dotStack: [Dot] = [Dot]()
    var audioPlayer = AVAudioPlayer()
    
    /// subviews
    @IBOutlet var levelView: LevelView?
    var levelWrapperView: FBShimmeringView?
    var backgroundView: ImageView?
    var backgroundOverlayView: ImageView?
    var timeLabel: TimeLabel?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view, typically from a nib.
        NSBundle.mainBundle().loadNibNamed(levelName, owner: self, options: nil)
        
        //the background view
        self.backgroundView = ImageView(image: UIImage(named: "mountains-back"))
        
        self.backgroundOverlayView =  ImageView(image: UIImage(named: "mountains-front"))

        self.levelWrapperView = FBShimmeringView(frame:  self.view.bounds)
        self.levelWrapperView!.contentView = self.levelView
        self.levelWrapperView!.shimmering = true
        self.levelWrapperView!.shimmeringSpeed = 60

        self.levelView!.backgroundColor = UIColor.clearColor()
        self.levelView!.delegate = self

        self.timeLabel = TimeLabel(frame: CGRectMake(self.view.bounds.size.width - TimeLabel.defaultSize().width, 20, TimeLabel.defaultSize().width, TimeLabel.defaultSize().height))
        self.levelView!.timeLabel = self.timeLabel

        self.view.addSubview(self.backgroundView!)
        self.view.addSubview(self.backgroundOverlayView!)
        self.view.addSubview(self.levelWrapperView!)
        self.view.addSubview(self.timeLabel!)
        
        self.view.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.view.backgroundColor = ColorSwatch.LightBlue.__conversion()
    }
    

    override public func viewDidAppear(animated: Bool) {
        
        for view in self.levelView!.subviews {
            if view is Dot {
                (view as Dot).pop(duration: 4)
            }
        }
        
        //animates in the background

        UIView.animateWithDuration(4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: nil, animations: {
            self.backgroundView!.center = self.view.center

        }, completion: {
                (value: Bool) in
                self.backgroundView!.motionEffect = 80
        })

        UIView.animateWithDuration(2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: nil, animations: {
            self.backgroundOverlayView!.center = self.view.center
            
            }, completion: {
                (value: Bool) in
                self.backgroundOverlayView!.motionEffect = 40
            })
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// Called when the user touch is over a dot
    public func levelView(LevelView: AnyObject, beganTouchWithDot dot: Dot) {
        
        // reset the stack
        self.dotStack = [Dot]()

        if !dot.currentDot || dot.matched {
            
            self.abortSelection()
            
        } else {
            
            //add the first object
            self.dotStack.append(dot)
            dot.selectDot(true)
            self.playSelectionSound(sound: 1)
        }
    }

    /// Called when the user touch is over a dot
    public func levelView(LevelView: AnyObject, didTouchDot dot: Dot) {
        
        if dot.matched {
            self.abortSelection()
        }
        
        let lastDot = self.dotStack[self.dotStack.count-1]
        
        if (lastDot.glyph == dot.glyph || lastDot.color == dot.color) && lastDot.isAdjacent(dot) {
            
            self.dotStack.append(dot)
            dot.selectDot(true)
            self.playSelectionSound()
            
        } else {
            self.abortSelection()
        }
        
    }
    
    /// The user interaction is over
    public func levelViewTouchesEnded(LevelView: AnyObject) {
        
        //matches all the dots
        for index in 0..<self.dotStack.count-1 {
            
            let dot = self.dotStack[index]
            let nextDot = self.dotStack[index+1]
            
            dot.matched = true;
            dot.currentDot = false;
            
            //cretes the line between the two dots                        
            self.levelView!.layer.insertSublayer(dot.createLineLayerToDot(nextDot), below: nextDot.layer)
            
            self.playConnectionSound()
        }
        
        let dot = self.dotStack[self.dotStack.count-1]
        dot.currentDot = true
        
        //reset the stack
        self.dotStack = [Dot]()
        
        //puzzle completed
        if dot.endDot {
            self.levelView?.endDotSelected = true
        }
    }
    
    /// The time is up or the player reached the end dot
    public func levelView(LevelView: AnyObject, levelOverWithSuccess success: Bool) {
        
        if success {
            print("Good boy!")
        } else {
            print("Game over!")
        }
     }
    
    /// Abort the current dot selection
    func abortSelection() {
        
        self.levelView!.abortSelection = true
        
        for dot in self.dotStack {
            dot.selectDot(false)
        }
        
        // reset the stack
        self.dotStack = [Dot]()
    }
    
    /// Plays the 'crescendo' sound during the selection of the dots
    func playSelectionSound(sound: Int? = nil) {
        
        let count = (sound != nil) ? sound : (self.dotStack.count%7) + 1
        let url = NSBundle.mainBundle().URLForResource(NSString(format: "%d", count!), withExtension: "m4a")

        self.audioPlayer = AVAudioPlayer(contentsOfURL: url, error: nil)
        self.audioPlayer.volume = 0.3
        self.audioPlayer.prepareToPlay()
        self.audioPlayer.play()
    }
    
    /// Plays the sound when the dots are connected
    func playConnectionSound() {
     
        let url = NSBundle.mainBundle().URLForResource("x", withExtension: "m4a")
        
        self.audioPlayer = AVAudioPlayer(contentsOfURL: url, error: nil)
        self.audioPlayer.volume = 0.2
        self.audioPlayer.prepareToPlay()
        self.audioPlayer.play()
        
//        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate));
    }

}

