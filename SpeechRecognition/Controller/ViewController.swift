//
//  ViewController.swift
//  SpeechRecognition
//
//  Created by Artur Ratajczak on 13/04/2019.
//  Copyright © 2019 Artur Ratajczak. All rights reserved.
//

import UIKit
import Speech
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {

    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    @IBOutlet weak var transcriptionTextField: UITextView!
    
    var audioPlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activitySpinner.isHidden = true
    }

    @IBAction func transcribeBtnWasPressed(_ sender: Any) {
        activitySpinner.isHidden = false
        activitySpinner.startAnimating()
        requestSpeechAuth()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        player.stop()
        activitySpinner.stopAnimating()
        activitySpinner.isHidden = true
    }
    
    func requestSpeechAuth(){
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            if authStatus == SFSpeechRecognizerAuthorizationStatus.authorized {
                if let path = Bundle.main.url(forResource: "testRecord", withExtension: "mp3") {
                    do {
                        let sound = try AVAudioPlayer(contentsOf: path)
                        self.audioPlayer = sound
                        self.audioPlayer.delegate = self
                        sound.play()
                        print("Audo played")
                    } catch {
                        print("Error when playing")
                    }
                    
                    let recoginzer = SFSpeechRecognizer()
                    let request = SFSpeechURLRecognitionRequest(url: path)
                    recoginzer?.recognitionTask(with: request, resultHandler: { (result, error) in
                        if let errorStatus = error {
                            print(errorStatus.localizedDescription)
                        } else {
                            self.transcriptionTextField.text = result?.bestTranscription.formattedString
                        }
                    })
                } else {
                    print("Invalid audio path")
                }
            } else {
                print("Speech authorization failed")
            }
        }
    }

}

