//
//  MeetingForm.swift
//  MeetingScheduler
//
//  Created by Aptence on 05/09/19.
//  Copyright © 2019 Verma. All rights reserved.
//

import UIKit

class MeetingForm: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == startTime {
            return startTimeArray.count
        }else{
            return endTimeArray.count
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == startTime {
            return startTimeArray[row]
        }else{
            return endTimeArray[row]
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == startTime {
            startDate.text = startTimeArray[row]
        }else{
            endDate.text = endTimeArray[row]
        }
    }
    
    @IBOutlet weak var dateButton: UIButton!
    
    @IBOutlet weak var startDate: UITextField!
    
    @IBOutlet weak var endDate: UITextField!
    @IBOutlet weak var descriptionView: UITextView!
    
    @IBOutlet weak var submitButton: UIButton!
    
    var datePassed: String = ""
    let startTime = UIPickerView()
    let endTime = UIPickerView()
    
    
    var startTimeArray = [String]()
    var endTimeArray = [String]()
    
    override func viewDidLoad() {
        startTime.delegate = self
        endTime.delegate = self
        
        startTime.dataSource = self
        endTime.dataSource = self
        
        
        startTime.showsSelectionIndicator = true
        endTime.showsSelectionIndicator = true
        
        startDate.inputView = startTime
        endDate.inputView = endTime
        
        
        super.viewDidLoad()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.submitButton.layer.cornerRadius = 10
        self.submitButton.clipsToBounds = true
        self.dateButton.isEnabled = false
        self.descriptionView.layer.borderWidth = 0.4
        
        
        dateButton.setTitle(datePassed, for: .normal)
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0/255.0, green: 150.0/255.0, blue: 136.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 0, green: 150, blue: 136, alpha: 1)
        self.navigationController?.navigationBar.tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        let leftButton = UIBarButtonItem(title: "❮ Back", style: .plain, target: self, action: #selector(backPressed))
        
        
        self.navigationItem.setLeftBarButton(leftButton, animated: true)
    }
    
    
    @objc func backPressed(){
        self.navigationController?.popViewController(animated: true)
    }
}

