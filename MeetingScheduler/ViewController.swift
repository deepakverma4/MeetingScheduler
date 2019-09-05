//
//  ViewController.swift
//  MeetingScheduler
//
//  Created by Aptence on 05/09/19.
//  Copyright © 2019 Verma. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var meetingCollection: UICollectionView!
    
    @IBOutlet weak var scheduleButton: UIButton!
    
    let cellId = "meetingId"
    
    var meetingData: JSON = ""
    var meetingArray = [JSON]()
    var selectedDate: String = ""
    var startTimeArray = [String]()
    var endTimeArray = [String]()
    
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        meetingCollection.delegate = self
        meetingCollection.dataSource = self
        
        scheduleButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        
        meetingCollection.alwaysBounceVertical = true
        meetingCollection.refreshControl = refreshControl
        
        getData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        self.scheduleButton.layer.cornerRadius = 10
        self.scheduleButton.clipsToBounds = true
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0/255.0, green: 150.0/255.0, blue: 136.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 0, green: 150, blue: 136, alpha: 1)
        self.navigationController?.navigationBar.tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        let leftButton = UIBarButtonItem(title: "❮ Previous", style: .plain, target: self, action: #selector(prevPressed))
        let rightButton = UIBarButtonItem(title: "Next ❯", style: .plain, target: self, action: #selector(nextPressed))
        
        self.navigationItem.setLeftBarButton(leftButton, animated: true)
        self.navigationItem.setRightBarButton(rightButton, animated: true)
    }
    
    
    @objc func prevPressed(){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        formatter.locale = Locale(identifier: "en_IN")
        guard let prevDate = formatter.date(from: selectedDate) else {return}
        
        selectedDate = formatter.string(from: Calendar.current.date(byAdding: .day, value: -1, to: prevDate)!)
        let dayNum = Calendar.current.component(.weekday, from: prevDate)
        
        if dayNum == 6 || dayNum == 7 {
            return
        }
        
        getData(date: selectedDate)
    }
    
    @objc func nextPressed(){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        formatter.locale = Locale(identifier: "en_IN")
        guard let nextDate = formatter.date(from: selectedDate) else {return}
        
        selectedDate = formatter.string(from: Calendar.current.date(byAdding: .day, value: 1, to: nextDate)!)
        
        let dayNum = Calendar.current.component(.weekday, from: nextDate)
        
        if dayNum == 6 || dayNum == 7 {
            return
        }
        
        getData(date: selectedDate)
    }
    
    @objc func getData(date: String = ""){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        
        let todayDate = Date()
        
        
        let params: Parameters = [
            "date": date == "" ? formatter.string(from: todayDate) : date
        ]
        selectedDate = date == "" ? formatter.string(from: todayDate) : date
        self.navigationItem.title =  date == "" ? formatter.string(from: todayDate) : date
        
        Alamofire.request("http://fathomless-shelf-5846.herokuapp.com/api/schedule", method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            
            if let status = response.response?.statusCode {
                self.meetingData = JSON(response.result.value ?? "Error")
                if status > 199 && status < 300 {
                    print("meetingData",self.meetingData)
                    self.refreshControl.endRefreshing()
                    let unsortedArray = self.meetingData.arrayValue
                    self.meetingArray = unsortedArray.sorted(by: { (start, end) -> Bool in
                        return start["start_time"].doubleValue < end["start_time"].doubleValue
                    })
                    
                    for (_,data):(String, JSON) in self.meetingData {
                        
                        print("dataaaaa",data)
                        self.startTimeArray.append(data["start_time"].stringValue)
                        self.endTimeArray.append(data["end_time"].stringValue)
                        //
                    }
                    
                    
                    self.meetingCollection.reloadData()
                }else{
                    print("failure data", self.meetingData)
                }
                
            }
        }
    }
    
    @objc func reloadData(){
        getData()
    }
    
    @objc func buttonPressed(){
        let form = self.storyboard?.instantiateViewController(withIdentifier: "meetingForm") as! MeetingForm
        form.datePassed = selectedDate
        form.startTimeArray = startTimeArray
        form.endTimeArray = endTimeArray
        self.navigationController?.pushViewController(form, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.meetingArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = meetingCollection.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MeetingCell
        cell.descriptionLabel.text = self.meetingData[indexPath.row]["description"].stringValue
        
        cell.timelLabel.text = "\(getTime(time24: "\(self.meetingArray[indexPath.row]["start_time"])")) - \(getTime(time24: "\(self.meetingArray[indexPath.row]["end_time"])"))"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width , height: 80)
    }
    
    func getTime(time24: String) -> String {
        let dateAsString = time24
        let df = DateFormatter()
        df.dateFormat = "HH:mm"
        
        let date = df.date(from: dateAsString)
        df.dateFormat = "hh:mma"
        
        let time12 = df.string(from: date!)
        return time12
    }
    
}

extension Date {
    mutating func changeDays(by days: Int) {
        self = Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
}
