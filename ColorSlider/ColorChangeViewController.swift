//
//  ViewController.swift
//  ColorSlider
//
//  Created by Arcani on 04.09.2021.
//

import UIKit

class ColorChangeViewController: UIViewController {
    
    // MARK: - IB Outlets
    @IBOutlet var colorBoxView: UIView!
    
    @IBOutlet var colorNamesLabels: [UILabel]!
    @IBOutlet var sliderValuesLabels: [UILabel]!
    
    @IBOutlet var textFields: [UITextField]!
    
    @IBOutlet var colorSliders: [UISlider]!
    
    // MARK: - Override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        colorBoxView.layer.cornerRadius = 15
        setColorBoxColor()
        setSliderLabelsValues()
    }
    
    // MARK: - IB Actions
    @IBAction func changeColorWithSliders(_ sender: UISlider) {
        setColorBoxColor()
        for (label, slider) in zip(sliderValuesLabels, colorSliders) {
            label.text = string(from: slider)
        }
    }
    
    @IBAction func changeColorWithTextFields(_ sender: UITextField) {
//        for (textField, slider) in zip(textFields, colorSliders) {
//            guard let floatValue = Float(textField.text ?? ""),
//                  floatValue >= 0 && floatValue <= 1
//            else { return }
//            slider.value = floatValue
//            setColorBoxColor()
//
//            for (textField, colorLabel) in zip(textFields, sliderValuesLabels) {
//                if textField.text != "" {
//                    colorLabel.text = textField.text
//                }
//            }
//        }
    }
    
    // MARK: - Private methods
    private func setSliderLabelsValues() {
        for (label, slider) in zip(sliderValuesLabels, colorSliders) {
            label.text = string(from: slider)
        }
    }
    
    private func setColorBoxColor() {
        guard let redSlider = colorSliders.first(where: { $0.tag == 0 }),
              let greenSlider = colorSliders.first(where: { $0.tag == 1 }),
              let blueSlider = colorSliders.first(where: { $0.tag == 2 })
        else { return }
        
        colorBoxView.backgroundColor = UIColor(
            red: CGFloat(redSlider.value),
            green: CGFloat(greenSlider.value),
            blue: CGFloat(blueSlider.value),
            alpha: 1
        )
    }
    
    private func string(from slider: UISlider) -> String {
        String(format: "%.2f", slider.value)
    }
}

// MARK: - Keyboard extensions
extension ColorChangeViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        for (textField, slider) in zip(textFields, colorSliders) {
            guard let floatValue = Float(textField.text ?? ""),
                  floatValue >= 0 && floatValue <= 1
            else { return }
            slider.value = floatValue
            setColorBoxColor()
            
            for (textField, colorLabel) in zip(textFields, sliderValuesLabels) {
                if textField.text != "" {
                    colorLabel.text = textField.text
                }
            }
        }
    }
}
