//
//  GruppViewController.swift
//  noderavverb
//
//  Created by Sidney P'Silva on 11/09/18.
//  Copyright © 2018 Vlad Lopes. All rights reserved.
//

import UIKit

class GruppViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
   
    
    @IBOutlet weak var pkvSelector: UIPickerView!
    
    var selectorGroup: [String] = []
    let tenses = ["Imperativ", "Presens", "Preteritum", "Supinum"]
 
    var verbList: [String] = []
    var answerList: [String] = []
    var verbTense = ""
    
    var verbGroup: [VerbGroup] = []
    var verbType: [VerbType] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pkvSelector.delegate = self
        pkvSelector.dataSource = self
        
        loadVerbs()
        
        // Do any additional setup after loading the view.
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        if component == 0 {
            return selectorGroup.count
        } else {
            return tenses.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
 
        if component == 0 {
            return selectorGroup[row]
        } else {
            return tenses[row]
        }
    }
    
    func loadVerbs() {
        
        let verbsURL = Bundle.main.url(forResource: "Verbs", withExtension: "json")!
        let jsonData = try! Data(contentsOf: verbsURL)
 
        do {
            let jsonDecoder = JSONDecoder()
            verbGroup = try jsonDecoder.decode([VerbGroup].self, from: jsonData)
        } catch {
            print("Erro decodificando arquivos json: \(error.localizedDescription)")
        }
        
  //      Grupo de verbos
 
        for i in 0...(verbGroup.count - 1){
            selectorGroup.append(verbGroup[i].grupp)
        }
    }
    
    func prepareVerbs() {
       
        verbList = []
        answerList = []
        for i in 0...(verbGroup.count - 1) {
            if verbGroup[i].grupp == selectorGroup[pkvSelector.selectedRow(inComponent: 0)] {
                verbType = verbGroup[i].verbs
                for u in 0...(verbType.count - 1) {
                    verbList.append(verbType[u].name)
                    answerList.append(verbType[u].tenses[pkvSelector.selectedRow(inComponent: 1)])
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        prepareVerbs()
        
        if let destinyView = segue.destination as? GameViewController {
            destinyView.tense = tenses[pkvSelector.selectedRow(inComponent: 1)]
            destinyView.verbs = verbList
            destinyView.answers = answerList
        }
    }
        
    @IBAction func bttBorja(_ sender: Any) {
      
        performSegue(withIdentifier: "segueGame", sender: nil)
    }
    
    @IBAction func bttInfo(_ sender: Any) {
        performSegue(withIdentifier: "segueInfo", sender: nil)
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
