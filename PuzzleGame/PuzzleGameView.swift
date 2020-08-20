//
//  PuzzleGameView.swift
//  PuzzleGame
//
//  Created by top on 2020/8/20.
//  Copyright © 2020 top. All rights reserved.
//

import UIKit

class PuzzleGameItem: UIControl {
    
    let imageView = UIImageView()
    
    let titleLabel = UILabel()
    
    var index: Int = 0
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        
        titleLabel.textAlignment = .center
        addSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
        titleLabel.frame = bounds
    }
    
    func blankItem() {
        imageView.image = nil
        titleLabel.text = nil
    }
}


public class PuzzleGameView: UIView {

    
    /// 所有的item
    private var originItems: [PuzzleGameItem] = []
    
    /// 显示的 item
    private var displayItems: [PuzzleGameItem] = []
    
    /// 空白 item
    private var blankItem: PuzzleGameItem?
    
    /// 等级：默认 3 x 3
    private(set) var grade: Int = 5
    
    /// 点击次数
    private(set) var successCount: Int = 0
    
    /// 图片
    private(set) var image: UIImage = UIImage(named: "image0")!
    
    /// 间隔
    private(set) var itemInterval: CGFloat = 1
    
    /// 显示
    private(set) var showIndex: Bool = false
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        createItems()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        updateDisplayItems()
    }
}

private extension PuzzleGameView {
    
    /// 分割图片
    func croppingImage() -> [UIImage] {
        let itemWidth = image.size.width / CGFloat(grade)
        let itemHeight = image.size.height / CGFloat(grade)
        var images: [UIImage] = []
        for i in 0 ..< grade {
            for j in 0 ..< grade {
                if let cgImage = image.cgImage?.cropping(to: CGRect(x: itemWidth * CGFloat(j), y: itemHeight * CGFloat(i), width: itemWidth, height: itemHeight)) {
                    images.append(UIImage(cgImage: cgImage))
                }
            }
        }
        return images
    }
    
    /// 创建 items
    func createItems() {
        originItems.forEach{ $0.removeFromSuperview() }
        originItems.removeAll()
        displayItems.removeAll()
        
        var items: [PuzzleGameItem] = []
        let images = croppingImage()
        for (index, image) in images.enumerated() {
            let item = PuzzleGameItem()
            item.index = index
            item.imageView.image = image
            item.titleLabel.text = "\(index)"
            item.titleLabel.isHidden = !showIndex
            item.addTarget(self, action: #selector(didSelected(item:)), for: .touchUpInside)
            items.append(item)
            addSubview(item)
        }
        self.originItems = items
        self.displayItems = items
        self.blankItem = items.last
        self.blankItem?.blankItem()
    }
    
    /// 更新显示的 items 位置
    func updateDisplayItems() {
        let itemWidth = (bounds.width - itemInterval * CGFloat(grade - 1)) / CGFloat(grade)
        let itemHeight = (bounds.width - itemInterval * CGFloat(grade - 1)) / CGFloat(grade)
        for (index, item) in displayItems.enumerated() {
            let originX = (itemWidth + itemInterval) * CGFloat(index%grade)
            let originY = (itemHeight + itemInterval) * CGFloat(index/grade)
            item.frame = CGRect(x: originX, y: originY, width: itemWidth, height: itemHeight)
        }
    }
    
    /// 是否拼图成功
    func isPuzzleSuccess() -> Bool {
        guard displayItems.count == originItems.count else { return false }
        for index in 0 ..< displayItems.count where originItems[index] != displayItems[index] {
            return false
        }
        return true
    }
    
    /// 是否能够交换
    func isEnableExchange(item: PuzzleGameItem) -> Bool {
        guard let blankItem = blankItem, let index1 = displayItems.firstIndex(of: blankItem), let index2 = displayItems.firstIndex(of: item) else { return false }
        let diffIndex = abs(index1 - index2)
        return diffIndex == 1 || diffIndex == grade
    }
    
    /// 随机相邻的 item
    func randomNearItem() -> PuzzleGameItem {
        var nearItems: [PuzzleGameItem] = []
        for item in displayItems where isEnableExchange(item: item) {
            nearItems.append(item)
        }
        let count = nearItems.count
        let randomIndex = Int(arc4random())%count
        return nearItems[randomIndex]
    }
    
    /// 交换两个 item
    func swapAt(item: PuzzleGameItem) {
        guard let blankItem = blankItem, let index1 = displayItems.firstIndex(of: blankItem), let index2 = displayItems.firstIndex(of: item) else { return}
        displayItems.swapAt(index1, index2)
    }
    
    /// 随机交换 item。交换 count 次数
    func randomSwapItem(_ count: Int) {
        if count <= 0 { return }
        swapAt(item: randomNearItem())
        randomSwapItem(count - 1)
    }
    
    /// 选中 item
    @objc func didSelected(item: PuzzleGameItem) {
        if isEnableExchange(item: item) {
            swapAt(item: item)
            updateDisplayItems()
            print("是否交换成功: \(isPuzzleSuccess() ? "成功" : "失败")")
        }
    }
}

public extension PuzzleGameView {
    
    /// 设置级别
    func set(grade: Int) {
        if grade == self.grade { return }
        self.grade = grade
        self.createItems()
        self.disband()
    }
    
    /// 设置图片
    func set(image: UIImage) {
        if self.image == image { return }
        self.image = image
        self.createItems()
        self.disband()
    }
    
    /// 显示所有的索引值
    func showIndex(_ show: Bool) {
        if self.showIndex == show { return }
        self.showIndex = show
        displayItems.forEach{ $0.titleLabel.isHidden = !show }
    }
    
    /// 重置
    func reset() {
        displayItems.removeAll()
        displayItems.append(contentsOf: originItems)
        updateDisplayItems()
    }
    
    /// 解散，随机排序
    @objc func disband() {
        randomSwapItem(100)
        updateDisplayItems()
    }
}
