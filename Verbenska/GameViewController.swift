//
//  GameViewController.swift
//  noderavverb
//
//  Created by Sidney P'Silva on 12/09/18.
//  Copyright © 2018 Vlad Lopes. All rights reserved.
//

import UIKit
import AVFoundation

class GameViewController: UIViewController {
  
    @IBOutlet weak var vwBack: UIView!
    @IBOutlet weak var txtRight: UITextField!
    @IBOutlet weak var txtWrong: UITextField!
    @IBOutlet weak var lblTense: UILabel!
    @IBOutlet weak var lblVerb: UILabel!
    @IBOutlet weak var lblAnswer: UILabel!
    @IBOutlet var vwLetter: [UIView]!    
    @IBOutlet var bttMix: [UIButton]!
    @IBOutlet weak var lblSupinum: UILabel!
    @IBOutlet weak var vwTimer: UIView!
    var soundPlayer: AVAudioPlayer!
    
    var verbs: [String] = []
    var answers: [String] = []
    var tense = ""
    var answer = ""
    
    var letterMix: [Character] = []
    var countRight = 0
    var countWrong = 0
    
    var bttX = UIButton()
    var number = 0
    var indice = 0
    var located = false
    
    var location = CGPoint(x: 0, y: 0)
    var primaryX: [CGFloat] = []
    var primaryY: [CGFloat] = []
    
    var viewLocation: [CGPoint] = []

    override func viewDidLoad() {
        super.viewDidLoad()
 
        vwBack.backgroundColor = UIColor(named: "myOrange")
        
        for i in 0...17 {
            primaryX.append(bttMix[i].center.x)
            primaryY.append(bttMix[i].center.y)
        }
        
        playMusic()
        selectVerb()
        
        txtRight.text = String(countRight)
        txtWrong.text = String(countWrong)
        
    
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        startTimer()
    }
    
    func playMusic() {
        if let url = Bundle.main.url(forResource: "MyMusic", withExtension: "m4a")
            
        {
            do {
                self.soundPlayer = try AVAudioPlayer(contentsOf: url)
                self.soundPlayer.volume = 1
                self.soundPlayer.play()
                self.soundPlayer.numberOfLoops = -1
            } catch {
                
            }
        }
    }
    
    func startTimer() {
        vwTimer.frame.size.width = 250
        UIView.animate(withDuration: 30.0, delay: 0.0, options: .curveLinear, animations: {self.vwTimer.frame.size.width  = 0 ;
        }) { (finished) in
            if !finished {
                return }
            self.treatResult()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        location = touch!.location(in: self.view)
        
        bttX = UIButton()
        located = false
        for i in 0...(bttMix.count - 1) {
            if (bttMix[i].center.x <= (location.x + 15) && bttMix[i].center.x >= (location.x - 15)) &&
                (bttMix[i].center.y <= (location.y + 20) && bttMix[i].center.y >= (location.y - 20)) {
                bttX = bttMix[i]
                indice = i
                located = true
                break
            }
        }
        
        bttX.center = location
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        location = touch!.location(in: self.view)
    
        bttX.center = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        location = touch!.location(in: self.view)
        
        if located == true {
            bttMix[indice].center = bttX.center
        }
        for i in 0...(number - 1) {
            if (vwLetter[i].center.x <= (location.x + 15) && vwLetter[i].center.x >= (location.x - 15)) &&
                (vwLetter[i].center.y <= (location.y + 20) && vwLetter[i].center.y >= (location.y - 20)) {
                bttMix[indice].center = vwLetter[i].center
                bttMix[indice].transform = CGAffineTransform(rotationAngle: 0.0)
                break
            }
        }
    }
    
    func selectVerb() {
        let rand = Int(arc4random_uniform(UInt32(verbs.count)))
        lblVerb.text = "att " + verbs[rand]
        answer = answers[rand]
        lblTense.text = tense + " av"
        lblAnswer.text = ""
  
        prepareQuiz()

        vwTimer.layer.removeAllAnimations()
        startTimer()
 
    }
    
    func prepareQuiz() {
        letterMix = Array(answer)
        number = letterMix.count
   
        
        for i in 0...17 {
            bttMix[i].center.x = primaryX[i]
            bttMix[i].center.y = primaryY[i]
        }
        
        viewLocation = []
        for i in 0...(bttMix.count  - 1) {
            if i < number {
                vwLetter[i].isHidden = false
                viewLocation.append(vwLetter[i].center)
                vwLetter[i].layer.cornerRadius = 5
                bttMix[i].isHidden = false
                bttMix[i].layer.borderWidth = 2
                bttMix[i].layer.borderColor = (UIColor.blue).cgColor
                bttMix[i].layer.cornerRadius = 5
            } else {
                vwLetter[i].isHidden = true
                bttMix[i].isHidden = true
            }
        }

        var result: [Int] = []
        while result.count < number {
            let random = Int(arc4random_uniform(UInt32(number)))
            if !result.contains(random) {
                result.append(random)
            }
        }
        
        var u = 0
        for i in result {
           bttMix[i].setTitle("\(letterMix[u])", for: .normal)
            u += 1
            
            let rand = Float(arc4random_uniform(UInt32(4))) / 10
            if i == 0 || (i > 0 && i % 2 == 0) {
                bttMix[i].transform = CGAffineTransform(rotationAngle: -CGFloat(rand))
            } else {
                bttMix[i].transform = CGAffineTransform(rotationAngle: CGFloat(rand))
            }
        }

        if tense == "Supinum" {
            lblSupinum.isHidden = false
        } else {
            lblSupinum.isHidden = true
        }
    }
    
    func treatResult() {       
        var letters: [String] = []
        for i in 0...(number - 1) {
            for u in 0...(number - 1) {
                if bttMix[u].center == viewLocation[i] {
                    letters.append((bttMix[u].titleLabel?.text)!)
                }
            }
        }

        let word = letters.map{ String($0)} .joined()

        if word == answer {
            vwBack.backgroundColor = UIColor.green
            countRight += 1
            txtRight.text = String(countRight)
        } else {
            vwBack.backgroundColor = UIColor.red
            countWrong += 1
            txtWrong.text = String(countWrong)
            lblAnswer.text = answer
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            
            self.vwBack.backgroundColor = UIColor(named: "myOrange")
       
            self.selectVerb()
        }
    }
    
    func gameOver () {
        vwBack.backgroundColor = UIColor.red
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            
            self.vwBack.backgroundColor = UIColor(named: "myOrange")
            self.countWrong += 1
            self.txtWrong.text = String(self.countWrong)
        }
        
    }
    
    @IBAction func bttHome(_ sender: Any) {
  
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func bttValidate(_ sender: Any) {
        treatResult()
//        print(" teste de botao")
    }
    
    @IBAction func bttSound(_ sender: Any) {
        if soundPlayer.isPlaying {
            soundPlayer.stop()
        } else {
            soundPlayer.play()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
