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
    
    // MARK: - Private Properties
    var delegate: ColorChangeViewControllerDelegate!
    var colorPassedFromAnotherVC: UIColor!
    
    // MARK: - Override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        colorBoxView.layer.cornerRadius = 15
        setInitialSliderValues()
        setColorBoxColor()
        setSliderLabelsValues()
        setTexFieldsValues()
        createToolBar()
        colorBoxView.backgroundColor = colorPassedFromAnotherVC
    }
    
    // MARK: - IB Actions
    @IBAction func changeColorWithSliders(_ sender: UISlider) {
        setColorBoxColor()
        for (label, slider) in zip(sliderValuesLabels, colorSliders) {
            label.text = string(from: slider)
        }
        
        for (textField, slider) in zip(textFields, colorSliders) {
            textField.text = string(from: slider)
        }
    }
    
    @IBAction func pushDoneButton() {
        delegate.getColor(colorOf: colorBoxView.backgroundColor ?? UIColor(
                            red: 0,
                            green: 0,
                            blue: 0,
                            alpha: 1))
        dismiss(animated: true)
    }
    
    
    // MARK: - Private methods
    private func setInitialSliderValues() {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        let colorArray = [red, green, blue]
        
        colorBoxView.backgroundColor?.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        for (slider, color) in zip(colorSliders, colorArray) {
            slider.value = Float(color)
        }
        
    }
    
    private func setSliderLabelsValues() {
        for (label, slider) in zip(sliderValuesLabels, colorSliders) {
            label.text = string(from: slider)
        }
    }
    
    private func setTexFieldsValues() {
        for (textField, label) in zip(textFields, sliderValuesLabels) {
            textField.text = label.text
        }
    }
    
    private func createToolBar() {
        let toolBar = UIToolbar(frame: CGRect(
                                    x: 0,
                                    y: 0,
                                    width: view.frame.size.width,
                                    height: 50))
        
        let flexibleSpace = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: self,
            action: nil)
        
        let doneButton = UIBarButtonItem(
            title: "Done",
            style: .plain,
            target: self,
            action: #selector(didTapDone))
        
        toolBar.items = [flexibleSpace, doneButton]
        toolBar.sizeToFit()
        
        textFields.forEach { $0.inputAccessoryView = toolBar }
    }
    
    @objc private func didTapDone() {
        for field in textFields {
            field.resignFirstResponder()
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

extension UIColor {
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return (red, green, blue, alpha)
    }
}
