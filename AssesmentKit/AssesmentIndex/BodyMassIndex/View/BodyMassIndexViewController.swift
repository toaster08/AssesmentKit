//
//  BodyMassIndexViewController.swift
//  AssesmentKit
//
//  Created by 山田　天星 on 2022/09/12.
//

import UIKit
import RxSwift
import RxCocoa

class BodyMassIndexViewController: UIViewController {
    
    //backgroundView
    @IBOutlet weak var bmiBackgroundView: UIView!
    @IBOutlet weak var obesityIndexBackgroundView: UIView!
    @IBOutlet weak var rohrerIndexBackgroundView: UIView!
    //値の表示
    @IBOutlet weak var bmiOutputLabel: UILabel!
    @IBOutlet weak var evaluationTextLabel: UILabel!
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
    
    let disposeBag = DisposeBag()
    
    var viewModel: BodyMassIndexViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        configureBinding()
        configureAction()
        
        viewModel = BodyMassIndexViewModel(weight: weightSelectSlider.rx.value.asObservable(),
                                           height: heightSelectSlider.rx.value.asObservable(),
                                           sexType: sexTypeSegmentedControl.rx.value.asObservable(),
                                           age: ageSelectPickerView.rx.itemSelected.asObservable())
    }
    
    //ViewDidLayoutSubViewの意味は？
    //ViewDidLoadに入れるとバグる
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupShadowLayer()
    }
    
    private func setup() {
        ageSelectPickerView.isHidden = true
        heightSelectSlider.isHidden = true
        weightSelectSlider.isHidden = true
        
        //初期設定
        obesityIndexBackgroundView.isHidden = true
        rohrerIndexBackgroundView.isHidden = true
        
        setupBackgroundView()
        setupStackView()
        setupPickerView()
        setupNavigationBar()
    }
    
    private func configureBinding() {
        let allAges = Person.allAge.map { String($0) }
        Observable.just(allAges)
            .bind(to: ageSelectPickerView.rx.itemTitles) { _, str in
                return str
            }
            .disposed(by: disposeBag)
        
        ageSelectPickerView.rx.modelSelected(String.self)
            .map { $0.first }
            .map { $0! + "歳" }
            .bind(to: ageOutputLabel.rx.text)
            .disposed(by: disposeBag)
        
        heightSelectSlider.rx.value
            .map {
                let value = String(format: "%.1f", $0)
                let height = value + "cm"
                return height
            }
            .bind(to: heightOutputLabel.rx.text)
            .disposed(by: disposeBag)
        
        weightSelectSlider.rx.value
            .map {
                let value = String(format: "%.1f", $0)
                let weight = value + "kg"
                return weight
            }
            .bind(to: weightOutputLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func configureAction() {
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
    
    private func setupNavigationBar() {
        navigationItem
            .rightBarButtonItems
        = [.init(barButtonSystemItem: .action,
                 target: self,
                 action: nil),
           .init(title: "All",
                 style: .plain,
                 target: self,
                 action: nil)
        ]
        
        navigationController?
            .navigationBar
            .prefersLargeTitles = false
    }
    
    func setupBackgroundView() {
        [bmiBackgroundView,
         obesityIndexBackgroundView,
         rohrerIndexBackgroundView]
            .forEach { backgroundView in
                backgroundView?.backgroundColor = .white
                backgroundView?.layer.borderColor = UIColor.white.cgColor
                backgroundView?.layer.borderWidth = .init(1)
                backgroundView?.layer.cornerRadius = 10
            }
    }
    
    func setupPickerView() {
        ageSelectPickerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 300)
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
    
    func configureEvaluationLabel(in text: String) {
        evaluationTextLabel.text = text
    }
    
    private func setupShadowLayer() {
        
        [bmiBackgroundView,
         obesityIndexBackgroundView,
         rohrerIndexBackgroundView]
            .forEach { backgroundView in
                backgroundView?.layer.shadowPath = UIBezierPath(rect: backgroundView!.bounds).cgPath
                backgroundView?.layer.shadowRadius = 5
                backgroundView?.layer.shadowColor = UIColor.lightGray.cgColor
                backgroundView?.layer.shadowOffset = .zero
                backgroundView?.layer.shadowOpacity = 0.6
            }
        
        //        bmiBackgroundView.layer.masksToBounds = false
    }
}
