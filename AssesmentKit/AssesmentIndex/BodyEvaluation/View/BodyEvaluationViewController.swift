//
//  BodyMassIndexViewController.swift
//  AssesmentKit
//
//  Created by 山田　天星 on 2022/09/12.
//

import UIKit
import RxSwift
import RxCocoa

class BodyEvaluationViewController: UIViewController {
    
    enum EvaluationType {
        case bodyMassIndex
        case rohrerIndex
        case obesityIndex
    }
    
    var currentEvalutationType: EvaluationType?
    
    //backgroundView
    @IBOutlet weak var bmiBackgroundView: UIView!
    @IBOutlet weak var obesityIndexBackgroundView: UIView!
    @IBOutlet weak var rohrerIndexBackgroundView: UIView!
    //値の表示
    @IBOutlet weak var bmiOutputLabel: UILabel!
    @IBOutlet weak var obesityIndexOutputLabel: UILabel!
    @IBOutlet weak var rohrerIndexOutputLabel: UILabel!
    //分類
    @IBOutlet weak var bmiEvaluationLabel: UILabel!
    @IBOutlet weak var obesityIndexEvaluationLabel: UILabel!
    @IBOutlet weak var rohrerIndexEvaluationLabel: UILabel!
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
    //StackView
    @IBOutlet weak var InputParentStackView: UIStackView!
    @IBOutlet weak var sexTypeStackView: UIStackView!
    @IBOutlet weak var ageOutputStackView: UIStackView!
    @IBOutlet weak var ageParentStackView: UIStackView!
    @IBOutlet weak var heightParentStackView: UIStackView!
    @IBOutlet weak var weightParentStackView: UIStackView!
    
    let disposeBag = DisposeBag()
    
    private var viewModel: BodyEvaluationViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
//        configureBinding()
        configureAction()
        //Protocolに抽象に依存するようにする
        viewModel = BodyEvaluationViewModel(
            input: (age: ageSelectPickerView.rx.itemSelected.asObservable(),
                    sexType: sexTypeSegmentedControl.rx.value.asObservable(),
                    height: heightSelectSlider.rx.value.asObservable(),
                    weight: weightSelectSlider.rx.value.asObservable())
        )
        
        //初期値
        viewModel?.ageSelectPickerViewText
            .bind(to: ageSelectPickerView.rx.itemTitles) { _, str in return str }
            .disposed(by: disposeBag)
        
        viewModel?.ageSelectPickerViewItemString
            .bind(to: ageOutputLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel?.heightSelectSliderValueString
            .bind(to: heightOutputLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel?.weightSelectSliderValueString
            .bind(to: weightOutputLabel.rx.text)
            .disposed(by: disposeBag)
        
        //OutputLabelへ反映するバインディング
        //BMI
        viewModel?.bmiText
            .bind(to: bmiOutputLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel?.bmiTextFont
            .bind(to: bmiOutputLabel.rx.font)
            .disposed(by: disposeBag)
        
        viewModel?.bmiEvaluationText
            .bind(to: bmiEvaluationLabel.rx.text)
            .disposed(by: disposeBag)
        
        //ObesityIndex
        viewModel?.obesityIndexText
            .bind(to: obesityIndexOutputLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel?.obesityIndexTextFont
            .bind(to: obesityIndexOutputLabel.rx.font)
            .disposed(by: disposeBag)
        
        viewModel?.obesityIndexEvaluationText
            .bind(to: obesityIndexEvaluationLabel.rx.text)
            .disposed(by: disposeBag)
        
        //RohrerIndex
        viewModel?.rohrerIndexText
            .bind(to: rohrerIndexOutputLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel?.rohrerIndexTextFont
            .bind(to: rohrerIndexOutputLabel.rx.font)
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // TODO: LifeCycle
        let selectedRow = 22
        ageSelectPickerView
            .selectRow(selectedRow,
                       inComponent: 0,
                       animated: false)
        
        ageSelectPickerView
            .delegate?
            .pickerView!(
                ageSelectPickerView,
                didSelectRow: selectedRow,
                inComponent: 0)
    }
    
    //TODO: ViewDidLayoutSubViewの意味は？
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupShadowLayer()
    }
    
    private func setup() {
        ageSelectPickerView.isHidden = true
        heightSelectSlider.isHidden = true
        weightSelectSlider.isHidden = true
        
        setupBackgroundView()
        setupStackView()
        setupPickerView()
        setupNavigationBar()
        switchDisplayType()
    }
    
    func switchDisplayType() {
        if let currentEvalutationType = currentEvalutationType {
            //値ラベルの表示・非表示
            switch currentEvalutationType {
            case .bodyMassIndex:
                rohrerIndexBackgroundView.isHidden = true
                obesityIndexBackgroundView.isHidden = true
            case .rohrerIndex:
                bmiBackgroundView.isHidden = true
                obesityIndexBackgroundView.isHidden = true
            case .obesityIndex:
                bmiBackgroundView.isHidden = true
                rohrerIndexBackgroundView.isHidden = true
            }
            //評価ラベルの表示・非表示
            switch currentEvalutationType {
            case .bodyMassIndex:
                rohrerIndexEvaluationLabel.isHidden = true
                obesityIndexEvaluationLabel.isHidden = true
            case .rohrerIndex:
                bmiEvaluationLabel.isHidden = true
                obesityIndexEvaluationLabel.isHidden = true
            case .obesityIndex:
                bmiEvaluationLabel.isHidden = true
                rohrerIndexEvaluationLabel.isHidden = true
            }
            
            //入力項目の表示・非表示
            switch currentEvalutationType {
            case .bodyMassIndex:
                sexTypeStackView.isHidden = true
                ageParentStackView.isHidden = true
            case .rohrerIndex, .obesityIndex:
                break
            }
        }
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
           .init(title: "すべて",
                 style: .plain,
                 target: self,
                 action: #selector(displayAllButtonItemDidTapped))
        ]
        
        navigationController?
            .navigationBar
            .prefersLargeTitles = false
    }
    
    @objc private func displayAllButtonItemDidTapped() {
        navigationItem
            .rightBarButtonItems?[1]
        = .init(title: "もどす",
                style: .plain,
                target: self,
                action: #selector(displayTypeButtonItemDidTapped))
        
        //BackgroundViewの表示
        bmiBackgroundView.isHidden = false
        rohrerIndexBackgroundView.isHidden = false
        obesityIndexBackgroundView.isHidden = false
        //評価ラベルの表示
        bmiEvaluationLabel.isHidden = false
        rohrerIndexEvaluationLabel.isHidden = false
        obesityIndexEvaluationLabel.isHidden = false
        //入力項目の表示
        sexTypeStackView.isHidden = false
        ageParentStackView.isHidden = false
    }
    
    @objc private func displayTypeButtonItemDidTapped() {
        navigationItem
            .rightBarButtonItems?[1]
        = .init(title: "すべて",
                style: .plain,
                target: self,
                action: #selector(displayAllButtonItemDidTapped))
        
        switchDisplayType()
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
        ageSelectPickerView.frame = CGRect(x: 0,
                                           y: 0,
                                           width: self.view.frame.width,
                                           height: 300)
    }
    
    func setupStackView() {
        ageOutputStackView
            .isLayoutMarginsRelativeArrangement = true
        ageOutputStackView
            .directionalLayoutMargins
        = NSDirectionalEdgeInsets(top: 0,
                                  leading: 0,
                                  bottom: 0,
                                  trailing: 5)
        
        InputParentStackView
            .isLayoutMarginsRelativeArrangement = true
        InputParentStackView
            .directionalLayoutMargins
        = NSDirectionalEdgeInsets(top: 0,
                                  leading: 30,
                                  bottom: 20,
                                  trailing: 25)
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
    }
}
