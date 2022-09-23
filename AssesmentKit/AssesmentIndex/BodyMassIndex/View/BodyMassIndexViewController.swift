//
//  BodyMassIndexViewController.swift
//  AssesmentKit
//
//  Created by 山田　天星 on 2022/09/12.
//

import UIKit

class BodyMassIndexViewController: UIViewController {
    
    //BMI
    @IBOutlet weak var bmiBackgroundView: UIView!
    @IBOutlet weak var bmiOutputLabel: UILabel!
    //性別
    @IBOutlet weak var sexTypeSegmentedControl: UISegmentedControl!
    //年齢
    @IBOutlet weak var ageOutputLabel: UILabel!
    @IBOutlet weak var ageSelectPickerView: UIPickerView!
    @IBOutlet weak var ageInputButton: UIButton!
    //身長
    @IBOutlet weak var heightOutputLabel: UILabel!
    @IBOutlet weak var heightSelectSlider: UISlider!
    @IBOutlet weak var heightInputButton: UIButton!
    //体重
    @IBOutlet weak var weightOutputLabel: UILabel!
    @IBOutlet weak var weightSelectSlider: UISlider!
    @IBOutlet weak var weightInputButton: UIButton!
    //Stack
    @IBOutlet weak var ageStackView: UIStackView!
    @IBOutlet weak var parentStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        navigationItem
            .rightBarButtonItem
        = .init(barButtonSystemItem: .action,
                target: self,
                action: nil)
        
        ageSelectPickerView.isHidden = true
        heightSelectSlider.isHidden = true
        weightSelectSlider.isHidden = true
        
        ageInputButton
            .addAction(
                UIAction(handler: { [self] _ in
                    self.ageSelectPickerView.isHidden.toggle()
                }),
                for: .touchUpInside
            )
        
        heightInputButton
            .addAction(
                UIAction(handler: { [self] _ in
                    self.heightSelectSlider.isHidden.toggle()
                }),
                for: .touchUpInside
            )
        
        weightInputButton
            .addAction(
                UIAction(handler: { [self] _ in
                    self.weightSelectSlider.isHidden.toggle()
                }),
                for: .touchUpInside
            )
        
    }
    
    //ViewDidLayoutSubViewの意味は？
    //ViewDidLoadに入れるとバグる
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupShadowLayer()
    }
    
    private func setup() {
        setupBackgroundView()
        setupStackView()
        setupPickerView()
    }
    
    func setupBackgroundView() {
        bmiBackgroundView.backgroundColor = .white
        bmiBackgroundView.layer.borderColor = UIColor.white.cgColor
        bmiBackgroundView.layer.borderWidth = .init(1)
        bmiBackgroundView.layer.cornerRadius = 10
    }
    
    func setupPickerView() {
        ageSelectPickerView.delegate = self
        ageSelectPickerView.dataSource = self
        
        ageSelectPickerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 300)
//        ageSelectPickerView.backgroundColor = UIColor(red: 0.69, green: 0.93, blue: 0.9, alpha: 1.0)
    }
    
    func setupStackView() {
        ageStackView.isLayoutMarginsRelativeArrangement = true
        ageStackView
            .directionalLayoutMargins
        = NSDirectionalEdgeInsets(top: 0,
                                  leading: 0,
                                  bottom: 0,
                                  trailing: 5)
        
        parentStackView.isLayoutMarginsRelativeArrangement = true
        
        parentStackView
            .directionalLayoutMargins
        = NSDirectionalEdgeInsets(top: 0,
                                  leading: 20,
                                  bottom: 20,
                                  trailing: 20)
    }
    
    private func setupShadowLayer() {
        bmiBackgroundView.layer.shadowPath = UIBezierPath(rect: bmiBackgroundView.bounds).cgPath
        bmiBackgroundView.layer.shadowRadius = 5
        bmiBackgroundView.layer.shadowColor = UIColor.lightGray.cgColor
        bmiBackgroundView.layer.shadowOffset = .zero
        bmiBackgroundView.layer.shadowOpacity = 0.4
        //        bmiBackgroundView.layer.masksToBounds = false
    }
}

extension BodyMassIndexViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    // UIPickerViewの列の数
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // UIPickerViewの行数、リストの数
    public func pickerView(_ pickerView: UIPickerView,
                           numberOfRowsInComponent component: Int) -> Int {
        return Person.allAge.count
    }
    
    // UIPickerViewの最初の表示
    public func pickerView(_ pickerView: UIPickerView,
                           titleForRow row: Int,
                           forComponent component: Int) -> String? {
        
        return  String(Person.allAge[row])
    }
    
    // UIPickerViewのRowが選択された時の挙動
    public func pickerView(_ pickerView: UIPickerView,
                           didSelectRow row: Int,
                           inComponent component: Int) {
        
        ageOutputLabel.text = String(Person.allAge[row]) + "歳"
    }
}
