//
//  IconPickerViewModel.swift
//  Wallet

protocol IconPickerViewModelDelegate: AnyObject {
    func iconPickerViewModelChangeIcon(iconId: Int, colorId: Int)
}

final class IconPickerViewModel {
    
    // MARK: - Properties
    
    struct Item {
        var color: Int?
        var icon: Int?
        var isActive: Bool
    }
    
    var delegate: IconPickerViewModelDelegate?
    var selectedColor: Int = 0
    var selectedIcon: Int = 0
    
    var model: [[Item]] = []
    private lazy var collectionCellModelBuilder = IconCollectionViewCellModelBuilder()
    
    // MARK: - Init
    
    init() {
        setupModel()
    }
    
    // MARK: - Public methods
    
    func didChooseColor(id: Int) {
        guard model.count >= 2, id < model[0].count else { return }
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
        guard model.count >= 2, id < model[1].count else { return }
        for iconId in 0...(model[1].count - 1) {
            model[1][iconId].isActive = false
        }
        model[1][id].isActive = true
        selectedIcon = id
    }
    
    func saveChoosedIcon() {
        delegate?.iconPickerViewModelChangeIcon(iconId: selectedIcon, colorId: selectedColor)
    }
    
    func setIcon(icon: Int, color: Int) {
        didChooseColor(id: color)
        didChooseIcon(id: icon)
    }
    
    func getCollectionCellModel(section: Int, row: Int) -> IconCollectionViewCell.Model {
        return collectionCellModelBuilder.build(model[section][row])
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
    }
}
