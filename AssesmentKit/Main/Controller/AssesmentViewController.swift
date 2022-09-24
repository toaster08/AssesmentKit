//
//  ViewController.swift
//  AssesmentKit
//
//  Created by 山田　天星 on 2022/08/07.
//

import UIKit

class AssesmentViewController: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Int, String>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, String>
    
    private var collectionView: UICollectionView! = nil
    private var dataSource: DataSource!
    
    enum Section {
        case main
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureCellDataSource()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds,
                                          collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.delegate = self
        view.addSubview(collectionView)
    }
    
    private func createCellResgistration() -> UICollectionView.CellRegistration<CollectionViewCell, String> {

        let cellRegistration = UICollectionView.CellRegistration { (cell: CollectionViewCell, indexPath: IndexPath, itemIdentifier: String) in
            
            cell.layer.cornerRadius = 10
            cell.layer.borderColor = UIColor.white.cgColor
            cell.layer.cornerRadius = 10
            cell.layer.borderWidth = 1
            cell.label.text = AssesmentKit(rawValue: indexPath.item)?.title
            cell.backgroundColor = AssesmentKit(rawValue: indexPath.item)?.color
        }
        
        return cellRegistration
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        //各Sectionの設定
        let sectionProvider = { (sectionIndex: Int,
                                layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let section = self.gridSection(in: layoutEnvironment)
            return section
        }
        
        //section全体の設定
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider,
                                                         configuration: config)
        return layout
    }
    
    func configureCellDataSource() {
        let cellRegistration = createCellResgistration()
        
        dataSource = DataSource(collectionView: collectionView) { (collectionView: UICollectionView,
                                                                   indexPath: IndexPath,
                                                                   itemIdentifier: String) in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                                for: indexPath,
                                                                item: itemIdentifier)
        }
        
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(AssesmentKit.allCases.map { $0.title })
        dataSource.apply(snapshot)
    }
    
    
    private func gridSection(in enviroment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let itemCount: CGFloat = 2 // 横に並べる数
        let itemWidth = 1.0 / itemCount
        let itemHeight = itemWidth * 0.7
       
        //item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(itemWidth),
                                              heightDimension: .fractionalWidth(itemHeight))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)

        //group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(itemHeight))
        let group =  NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        //section 一つだけである場合トップとボトムはタイトル直下と最下部ということになる
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 20,
                                                        leading: 5,
                                                        bottom: 20,
                                                        trailing: 5)
        return section
    }
}

extension AssesmentViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

//        guard let item = self.dataSource.itemIdentifier(for: indexPath) as AssesmentKit else { return }
        guard let storyboard = self.storyboard else { return }

        let item = AssesmentKit(rawValue: indexPath.item)
        switch item {
        case .bodyMassIndex:
            let vc = storyboard.instantiateViewController(withIdentifier: "BodyEvaluationViewController") as! BodyEvaluationViewController
            vc.currentEvalutationType = .bodyMassIndex
            navigationController?.pushViewController(vc, animated: true)
        case .rohrerIndex:
            let vc = storyboard.instantiateViewController(withIdentifier: "BodyEvaluationViewController") as! BodyEvaluationViewController
            vc.currentEvalutationType = .rohrerIndex
            navigationController?.pushViewController(vc, animated: true)
        case .obesityIndex:
            let vc = storyboard.instantiateViewController(withIdentifier: "BodyEvaluationViewController") as! BodyEvaluationViewController
            vc.currentEvalutationType = .obesityIndex
            navigationController?.pushViewController(vc, animated: true)
        case .fromNowOn, .none:
            return
        }
    }
}

extension UIColor {
    static var randomColor: UIColor {
        let r = CGFloat.random(in: 0 ... 0) / 255.0
        let g = CGFloat.random(in: 100 ... 255) / 255.0
        let b = CGFloat.random(in: 100 ... 255) / 255.0
        return UIColor(red: r, green: g, blue: b, alpha: 0.7)
    }
}

// グループ内のitem間のスペースを設定
//        items.interItemSpacing = .fixed(itemSpacing)

// セクション間のスペースを設定
// 用意したグループを基にセクションを生成
// 基本的にセルの数は意識しない、セルが入る構成(セクション)を用意しておくだけで勝手に流れてく
//        group.interItemSpacing = .fixed(10)
        // 生成したグループ(items)が縦に並んでいくグループを生成（実質これがセクション）
//        let groups = NSCollectionLayoutGroup
//            .vertical(
//                layoutSize: NSCollectionLayoutSize(
//                    widthDimension: .fractionalWidth(1.0),
//                    heightDimension: .absolute(itemLength)),
//                subitems: [items]
//            )
//        group.contentInsets.trailing = 10
//        group.contentInsets.leading = 10
        
