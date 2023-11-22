//
//  ViewController.swift
//  WorldTrotter
//
//  Created by Ibrahim Mansoor on 11/7/23.
//

import UIKit

class ConversionViewController: UIViewController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ConversionViewController loaded its view")
        
        updateCelsiusLabel()
    }
    
    @IBOutlet var celsiusLabel: UILabel!
    @IBOutlet var textField: UITextField!
    
    var fahrenheitValue: Measurement<UnitTemperature>?{
        didSet{
            updateCelsiusLabel()
        }
    }
    
    var celsiusValue: Measurement<UnitTemperature>? {
        if let fahrenheitValue = fahrenheitValue {
            return fahrenheitValue.converted(to: .celsius)
        } else {
            return nil
        }
    }
    
    let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 1
        return nf
    }() 
    
    func updateCelsiusLabel() {
        if let celsiusLabel = celsiusLabel, let _ = celsiusValue?.value {
            celsiusLabel.text = numberFormatter.string(from: NSNumber(value: celsiusValue?.value ?? 0))
        } else {
            celsiusLabel?.text = "???"
        }
    }
    
    
    
    
    @IBAction func dismssKeyboard(_ sender: UITapGestureRecognizer) {
        textField.resignFirstResponder()
    }
    
    @IBAction func fahrenheitFieldEditingChanged(_ textfield: UITextField) {
        if let text = textfield.text , let value = Double(text) {
            fahrenheitValue = Measurement(value: value, unit: .fahrenheit)
        } else {
            fahrenheitValue = nil
        }
    }
}

