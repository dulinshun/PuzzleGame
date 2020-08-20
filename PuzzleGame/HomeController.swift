//
//  HomeController.swift
//  PuzzleGame
//
//  Created by top on 2020/8/20.
//  Copyright © 2020 top. All rights reserved.
//

import UIKit

class HomeController: UIViewController {

    let gameView = PuzzleGameView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let btnRandom = UIButton()
        btnRandom.setTitle("随机", for: .normal)
        btnRandom.frame = CGRect(x: 20, y: 100, width: 80, height: 40)
        btnRandom.backgroundColor = .lightGray
        btnRandom.addTarget(self, action: #selector(disband), for: .touchUpInside)
        view.addSubview(btnRandom)
        
        let btnReset = UIButton()
        btnReset.setTitle("复原", for: .normal)
        btnReset.frame = CGRect(x: 120, y: 100, width: 80, height: 40)
        btnReset.backgroundColor = .lightGray
        btnReset.addTarget(self, action: #selector(reset), for: .touchUpInside)
        view.addSubview(btnReset)
        
        let btnCloseIndex = UIButton()
        btnCloseIndex.setTitle("关闭/显示", for: .normal)
        btnCloseIndex.frame = CGRect(x: 220, y: 100, width: 120, height: 40)
        btnCloseIndex.backgroundColor = .lightGray
        btnCloseIndex.addTarget(self, action: #selector(closeShowIndex), for: .touchUpInside)
        view.addSubview(btnCloseIndex)

        
        let width = view.bounds.width - 40
        gameView.frame = CGRect(x: 20, y: 150, width: width, height: width)
        view.addSubview(gameView)
        
        let slider = UISlider()
        slider.minimumValue = 3
        slider.maximumValue = 6
        slider.value = Float(gameView.grade)
        slider.frame = CGRect(x: 20, y: gameView.frame.maxY + 20, width: view.bounds.width - 40, height: 30)
        slider.addTarget(self, action: #selector(gradeChanged(slider:)), for: .valueChanged)
        view.addSubview(slider)
    }
    
    @objc func disband() {
        gameView.disband()
    }
    
    @objc func reset() {
        gameView.reset()
    }
    
    @objc func closeShowIndex() {
        gameView.showIndex(!gameView.showIndex)
    }
    
    @objc func gradeChanged(slider: UISlider) {
        gameView.set(grade: Int(slider.value))
    }
}
