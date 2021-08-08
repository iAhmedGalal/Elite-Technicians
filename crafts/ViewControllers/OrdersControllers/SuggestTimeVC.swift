//
//  SuggestTimeVC.swift
//  salon
//
//  Created by AL Badr  on 7/6/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit
import DropDown

class SuggestTimeVC: UIViewController {

    @IBOutlet weak var hourBtn: UIButton!
    @IBOutlet weak var minuteBtn: UIButton!
    @IBOutlet weak var periodBtn: UIButton!
    
    @IBOutlet weak var dateTF: UITextField!
    
    @IBOutlet weak var datesCV: UICollectionView!
    
    var datesList: [NewDates] = []
    
    var hours:[String] = []
    let hoursDropDown = DropDown()
    var selectedHour: String = ""
    
    var minutes:[String] = []
    let minutesDropDown = DropDown()
    var selectedMinute: String = ""
    
    var periods:[String] = []
    let periodsDropDown = DropDown()
    var selectedPeriod: String = "AM".localiz()
    
    var dates:[String] = []
    var timesFrom:[String] = []
    var timedTo:[String] = []

    
    var reservationId: Int = 0
    
    var doneButton: UIBarButtonItem?

    var chooseDatePicker: UIDatePicker = UIDatePicker()
    
    var selectedDateString: String = ""
    
    fileprivate var presenter: SuggestTimePresenter?
    
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        datesCV.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
    }
    
    func initView() {
        if LanguageManger.shared.currentLanguage == .ar {
            dateTF.placeholder = "اختر التاريخ"
            dateTF.textAlignment = .right
        }
        
        setupHoursDropDown()
        setupMinutesDropDown()
        setupPeriodsDropDown()
        
        dateTF.delegate = self
        
        datesCV.delegate = self
        datesCV.dataSource = self
        datesCV.register(UINib(nibName: "DateCell", bundle: nil), forCellWithReuseIdentifier: "DateCell")
        
        presenter = SuggestTimePresenter(self)
    }
    
    func setupHoursDropDown() {
        for i in (01...12) {
            hours.append(String(format: "%02d", i))
        }
        
        hoursDropDown.anchorView = hourBtn
        hoursDropDown.bottomOffset = CGPoint(x: 0, y: 0)
        hoursDropDown.dataSource = hours
        hoursDropDown.selectionAction = { [unowned self](index, item) in
            self.hourBtn.setTitle(item, for: .normal)
            self.selectedHour = self.hours[index]
        }
    }
    
    func setupMinutesDropDown() {
        for i in (00...59) {
            minutes.append(String(format: "%02d", i))
        }
        
        minutesDropDown.anchorView = minuteBtn
        minutesDropDown.bottomOffset = CGPoint(x: 0, y: 0)
        minutesDropDown.dataSource = minutes
        minutesDropDown.selectionAction = { [unowned self](index, item) in
            self.minuteBtn.setTitle(item, for: .normal)
            self.selectedMinute = self.minutes[index]
        }
    }
    
    func setupPeriodsDropDown() {
        periods.append("AM".localiz())
        periods.append("PM".localiz())

        periodsDropDown.anchorView = periodBtn
        periodsDropDown.bottomOffset = CGPoint(x: 0, y: 0)
        periodsDropDown.dataSource = periods
        periodsDropDown.selectionAction = { [unowned self](index, item) in
            self.periodBtn.setTitle(item, for: .normal)
            
            if index == 0 {
                self.selectedPeriod = "AM"
            }else if index == 1 {
                self.selectedPeriod = "PM"
            }
        }
    }
    
    @IBAction func backBtn_tapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dateBtn_tapped(_ sender: Any) {
        pickUpDate(dateTF)
        dateTF.becomeFirstResponder()
    }
    
    @IBAction func hourBtn_tapped(_ sender: Any) {
        hoursDropDown.show()
    }
    
    @IBAction func minuteBtn_tapped(_ sender: Any) {
        minutesDropDown.show()
    }
    
    @IBAction func periodBtn_tapped(_ sender: Any) {
        periodsDropDown.show()
    }
    
    @IBAction func addBtn_tapped(_ sender: Any) {
        if selectedDateString == "" {
            Helper.showFloatAlert(title: "Select date".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
        }else {
            if selectedHour == "" || selectedMinute == "" {
                Helper.showFloatAlert(title: "Select time".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
            }else {
                let newDate = NewDates()
                newDate.suggest_date = selectedDateString
                
                let selectedTime = selectedDateString + " " + selectedHour + ":" + selectedMinute + " " + selectedPeriod
                newDate.suggest_time = selectedTime
                
                newDate.convertTime()
                
                datesList.append(newDate)
                datesCV.reloadData()
                
                resetDate()
            }
        }
    }
    
    @IBAction func sendBtn_tapped(_ sender: Any) {
        if datesList.isEmpty {
            Helper.showFloatAlert(title: "Select date".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
        }else {
            
            for date in datesList{
                dates.append(date.suggest_date ?? "")
                timesFrom.append(date.suggestTimeAPI)
            }
            
            let parameters = ["id" : reservationId,
                              "date": dates,
                              "from" : timesFrom,
                              "to": timedTo] as [String : Any]
            
            presenter?.suggestTimes(parameters: parameters)
        }
    }
    
    func resetDate() {
        selectedDateString = ""
        selectedHour = ""
        selectedMinute = ""
        
        hourBtn.setTitle("HH".localiz(), for: .normal)
        minuteBtn.setTitle("MM".localiz(), for: .normal)
        periodBtn.setTitle("AM".localiz(), for: .normal)
    }
}

extension SuggestTimeVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 16, height: 48)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCell", for: indexPath) as? DateCell else {
            return UICollectionViewCell()
        }
        
        cell.configCell(item: datesList[indexPath.row])
        
        cell.removeBtn.addTarget(self, action: #selector(removeDate_tapped), for: .touchUpInside)
        cell.removeBtn.tag = indexPath.row
        
        return cell
    }
    
    @objc func removeDate_tapped(_ sender: UIButton) {
        datesList.remove(at: sender.tag)
        datesCV.reloadData()
    }
}

extension SuggestTimeVC: SuggestTimePresenterView {
    func setSuggestTimesSuccess(_ message: String) {
        Helper.showFloatAlert(title: message, subTitle: "", type: Constants.AlertType.AlertSuccess)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ordersNotification"), object: nil, userInfo: nil)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func setSuggestTimesFailure(_ message: String) {
        Helper.showFloatAlert(title: message, subTitle: "", type: Constants.AlertType.AlertError)
    }
    
    func showConnectionErrorMessage() {
        Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
    }
}

extension SuggestTimeVC: UITextFieldDelegate {
    func pickUpDate(_ textField : UITextField){
        chooseDatePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        chooseDatePicker.backgroundColor = UIColor.white
        
        if #available(iOS 13.4, *) {
            chooseDatePicker.preferredDatePickerStyle = .wheels
        }
        
        chooseDatePicker.datePickerMode = UIDatePicker.Mode.date

        chooseDatePicker.locale = Locale(identifier: "en_GB")

        dateTF.inputView = chooseDatePicker
        
        chooseDatePicker.minimumDate = Date()
        
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
        doneButton = UIBarButtonItem(title: "Done".localiz(), style: .done, target: self, action: #selector(dateSelected))
        toolbar.setItems([flexSpace, doneButton!], animated: false)
        toolbar.sizeToFit()
        
        dateTF.inputAccessoryView = toolbar
    }

    
    @objc func dateSelected(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_GB")

        selectedDateString = dateFormatter.string(from: chooseDatePicker.date)
            
        dateTF.text = selectedDateString
        dateTF.resignFirstResponder()
    }
}
