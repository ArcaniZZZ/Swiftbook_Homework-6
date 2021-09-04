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
    
    @IBOutlet var textFields: [UITextField]! {
        didSet {
            for (textField, label) in zip(textFields, sliderValuesLabels) {
                label.text = textField.text ?? ""
            }
        }
    }
    
    @IBOutlet var colorSliders: [UISlider]!
    
    // MARK: - Private Properties
    var delegate: ColorChangeViewControllerDelegate!
    var colorPassedFromAnotherVC: UIColor!
    
    // MARK: - Override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        colorBoxView.layer.cornerRadius = 15
        setInitialSliderValues()
        setSliderLabelsValues()
        setTexFieldsValues()
        setColorBoxColor()
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
        delegate.getColor(of: colorBoxView.backgroundColor ?? UIColor(
                            red: 0,
                            green: 0,
                            blue: 0,
                            alpha: 1))
        dismiss(animated: true)
    }

    // MARK: - Private methods
    private func setInitialSliderValues() {
        var currentRed: CGFloat = 0
        var currentGreen: CGFloat = 0
        var currentBlue: CGFloat = 0
        var currentAlpha: CGFloat = 0
        
        colorPassedFromAnotherVC.getRed(
            &currentRed,
            green: &currentGreen,
            blue: &currentBlue,
            alpha: &currentAlpha)
        
        let currentColors = [currentRed, currentGreen, currentBlue]
        
        for (slider, color) in zip(colorSliders, currentColors) {
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
    
    private func string(from slider: UISlider) -> String {
        String(format: "%.2f", slider.value)
    }
    
    private func showAlert(
        title: String = "Wrong Entry!",
        message: String = "The value should be from 0 to 1 inclusive",
        textField: UITextField? = nil) {
        
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        
        let okAction = UIAlertAction(
            title: "OK",
            style: .default) { _ in
            textField?.text = "0"
        }
        
        alert.addAction(okAction)
        present(alert, animated: true)
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
                  floatValue <= 1
            else { showAlert(textField: textField); return }
            slider.value = floatValue
            setColorBoxColor()
        }
    }
}
