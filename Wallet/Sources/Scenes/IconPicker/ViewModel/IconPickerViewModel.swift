//
//  IconPickerViewModel.swift
//  Wallet

final class IconPickerViewModel {
    
    // MARK: - Properties
    
    struct Item {
        var color: Int?
        var icon: Int?
        var isActive: Bool
    }
    
    var selectedColor: Int = 0
    var selectedIcon: Int = 0
    
    var model: [[Item]] = []
    lazy var collectionCellModelBuilder = IconCollectionViewCellModelBuilder()
    
    // MARK: - Init
    
    init() {
        setupModel()
    }
    
    // MARK: - Public methods
    
    func didChooseColor(id: Int) {
        for colorId in 0...(model[0].count - 1) {
            model[0][colorId].isActive = false
        }
        
        for iconId in 0...(model[1].count - 1) {
            model[1][iconId].color = id
        }
        
        model[0][id].isActive = true
        selectedColor = id
    }
    
    func didChooseIcon(id: Int) {
        for iconId in 0...(model[1].count - 1) {
            model[1][iconId].isActive = false
        }
        
        model[1][id].isActive = true
        selectedIcon = id
    }
    
    // MARK: - Private methods
    
    private func setupModel() {
        
        var colors: [Item] = []
        
        for i in 0...7 {
            colors.append(Item(color: i, icon: nil, isActive: false))
        }
        
        var icons: [Item] = []
        
        for i in 0...29 {
            icons.append(Item(color: 0, icon: i, isActive: false))
        }
        
        model = [colors, icons]
        
        model[0][0].isActive = true
        model[1][0].isActive = true
    }
}
