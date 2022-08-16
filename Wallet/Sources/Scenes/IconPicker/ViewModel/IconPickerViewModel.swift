//
//  IconPickerViewModel.swift
//  Wallet

final class IconPickerViewModel {
    
    // MARK: - Properties
    
    lazy var model = generateModel()
    
    // MARK: - Private functions
    
    private func generateModel() -> [Array<String>] {
        var colors: [String] = []
        var icons: [String] = []
        for i in 0...7 {
            colors.append("Color-" + String(i))
        }
        
        for i in 0...29 {
            icons.append("Icon-" + String(i))
        }
        
        return [colors, icons]
    }
}
