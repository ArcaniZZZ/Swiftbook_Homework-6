//
//  StartingPageViewController.swift
//  ColorSlider
//
//  Created by Arcani on 04.09.2021.
//

import UIKit

protocol ColorChangeViewControllerDelegate {
    func getColor(colorOf: UIColor)
}

class StartingPageViewController: UIViewController {
    
    @IBOutlet var backGroundView: UIView!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let colorSettingsVC = segue.destination as? ColorChangeViewController else { return }
        colorSettingsVC.delegate = self
        colorSettingsVC.colorPassedFromAnotherVC = backGroundView.backgroundColor
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension StartingPageViewController: ColorChangeViewControllerDelegate {
    func getColor(colorOf: UIColor) {
        backGroundView.backgroundColor = colorOf
    }
}


