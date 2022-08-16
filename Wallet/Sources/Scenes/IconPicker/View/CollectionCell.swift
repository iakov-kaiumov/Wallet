//
//  CollectionCell.swift
//  Wallet

import UIKit
import SnapKit

final class CollectionCell: UITableViewCell {
    
    // MARK: - Properties
    private var collectionView: UICollectionView?
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // MARK: - Public methods
    func setCollectionViewDataSourceDelegate(dataSourceDelegate: UICollectionViewDataSource & UICollectionViewDelegate & UICollectionViewDelegateFlowLayout,
                                             forRow row: Int) {
        collectionView?.delegate = dataSourceDelegate
        collectionView?.dataSource = dataSourceDelegate
        collectionView?.tag = row
        collectionView?.reloadData()
    }
    
    // MARK: - Private methods
    private func setup() {
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: contentView.frame, collectionViewLayout: layout)
        guard let collectionView = collectionView else {
            return
        }
        
        collectionView.isScrollEnabled = false
        collectionView.register(UICollectionViewCell.self,
                                forCellWithReuseIdentifier: "Cell")
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.leading.top.trailing.bottom.equalToSuperview()
        }
        
    }
}
