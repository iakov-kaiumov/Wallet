//
//  CollectionCell.swift
//  Wallet

import UIKit

final class CollectionCell: UITableViewCell {
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .blue
    }
}
