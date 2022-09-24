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
        configureBinding()
        configureAction()
        //Protocolにすることで依存性を逆転する
        viewModel = BodyEvaluationViewModel(
            input: (age: ageSelectPickerView.rx.itemSelected.asObservable(),
                    sexType: sexTypeSegmentedControl.rx.value.asObservable(),
                    height: heightSelectSlider.rx.value.asObservable(),
                    weight: weightSelectSlider.rx.value.asObservable())
        )
        
        //OutputLabelへ反映するオブザーバー
        viewModel?.bmiObservable
            .map({ bmi in
                guard let value = bmi?.value else {
                    self.bmiOutputLabel.font = UIFont(name: "Helvetica", size: 20)
                    return "計算不可"
                }
                
                self.bmiOutputLabel.font = UIFont(name: "Helvetica", size: 35)
                return String(format: "%.1f", value)
            })
            .subscribe(bmiOutputLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel?.obesityIndexObservable
            .map({ obesityIndex in
                guard let value = obesityIndex?.value else {
                    self.obesityIndexOutputLabel.font = UIFont(name: "Helvetica", size: 20)
                    return "計算不可"
                }
                
                self.obesityIndexOutputLabel.font = UIFont(name: "Helvetica", size: 35)
                return String(format: "%.f", value)
            })
            .subscribe(obesityIndexOutputLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel?.rohrerIndexObservable
            .map({ rohrerIndex in
                guard let value = rohrerIndex?.value else {
                    self.rohrerIndexOutputLabel.font = UIFont(name: "Helvetica", size: 20)
                    return "計算不可"
                }
                
                self.rohrerIndexOutputLabel.font = UIFont(name: "Helvetica", size: 35)
                return String(format: "%.f", value)
            })
            .subscribe(rohrerIndexOutputLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel?.bmiObservable
            .map({ bmi in
                guard  let type = bmi?.evaluatedType.description else { return "" }
                return "現在のBMIの評価は\(type)です"
            })
            .subscribe(bmiEvaluationLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel?.obesityIndexObservable
            .map({ obesityIndex in
                guard  let type = obesityIndex?.evaluatedType.description else { return "" }
                return "現在の肥満度の評価は\(type)です"
            })
            .subscribe(obesityIndexEvaluationLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel?.rohrerIndexObservable
            .map({ rohrerIndex in
                guard  let type = rohrerIndex?.evaluatedType.description else { return "" }
                return "現在のローレル指数の評価は\(type)です"
            })
            .subscribe(rohrerIndexEvaluationLabel.rx.text)
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
    
    private func configureBinding() {
        
        let allAges = Person.allAge.map { $0.description }
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
        
        //なんの意味がああるの？
        //        bmiBackgroundView.layer.masksToBounds = false
    }
}
