//
//  RecommendNumViewController.swift
//  LuckyStrike
//
//  Created by 수현 on 2022/02/04.
//

import UIKit
import SnapKit


class RecommendNumViewController: UIViewController {

    var numbers: [Int] = []

    private let popUpView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()

    let topStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .clear
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 8.0
        return stackView
    }()

    let bottomStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .clear
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 8.0
        return stackView
    }()

    private let anotherNumbersBtn: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(UIColor.systemBlue, for: .normal)
        btn.setTitle("다른 번호", for: .normal)
        btn.layer.cornerRadius = 10
        btn.backgroundColor = .white
        btn.addTarget(self, action: #selector(anotherNumbers(_:)), for: .touchUpInside)
        return btn
    }()

    private let dismissBtn: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(UIColor.systemBlue, for: .normal)
        btn.setTitle("나가기", for: .normal)
        btn.layer.cornerRadius = 10
        btn.backgroundColor = .white
        btn.addTarget(self, action: #selector(didTapDismissBtn(_:)), for: .touchUpInside)
        return btn
    }()

    let labelArr: [UILabel] = {
        var labelArr = [UILabel]()

        for _ in 0...5 {
            let labels = UILabel()

            labels.textColor = .black
            labels.textAlignment = .center
            labels.layer.cornerRadius = 15
            labels.layer.masksToBounds = true
            labelArr.append(labels)
        }

        return labelArr
    }()


    override func viewDidLoad() {
        super.viewDidLoad()

        randomNumber()

        view.backgroundColor = UIColor.white.withAlphaComponent(0.8)

        view.addSubview(popUpView)
        PopUpViewAutoLayout()

        popUpView.addSubview(topStackView)
        topStackViewAutoLayout()

        for i in 0...5 {
            topStackView.addArrangedSubview(labelArr[i])
        }


        popUpView.addSubview(bottomStackView)
        bottomStackViewAutoLayout()

        bottomStackView.addArrangedSubview(anotherNumbersBtn)
        bottomStackView.addArrangedSubview(dismissBtn)
    }

    func randomNumber() {
        while numbers.count < 7 {
            let number = Int.random(in: 1...45)
            if !numbers.contains(number) {
                numbers.append(number)
            }
        }

        let sortedNums = numbers.sorted()
        for i in 0...5 {
            labelArr[i].text = "\(sortedNums[i])"
        }

        let numberColor = [UIColor.systemYellow, UIColor.systemBlue,
                           UIColor.systemRed, UIColor.systemGray, UIColor.systemGreen]
        for i in 0...5 {
            labelArr[i].backgroundColor = numberColor[sortedNums[i]/10]
        }
    }

    func PopUpViewAutoLayout() {
        popUpView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(400)
            make.height.equalTo(150)
        }
    }

    func topStackViewAutoLayout() {
        topStackView.snp.makeConstraints { make in
            make.size.height.equalTo(45)
            make.leading.equalTo(popUpView.snp.leading).offset(5)
            make.trailing.equalTo(popUpView.snp.trailing).offset(-5)
            make.top.equalTo(popUpView.snp.top).offset(15)
        }
    }

    func bottomStackViewAutoLayout() {
        bottomStackView.snp.makeConstraints { make in
            make.leading.equalTo(popUpView.snp.leading).offset(5)
            make.trailing.equalTo(popUpView.snp.trailing).offset(-5)
            make.top.equalTo(topStackView.snp.bottom).offset(25)
            make.bottom.equalTo(popUpView.snp.bottom).offset(-20)
        }
    }

    @objc func didTapDismissBtn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    @objc func anotherNumbers(_ sender: UIButton) {


        var numbers: [Int] = []

        while numbers.count < 7 {
            let number = Int.random(in: 1...45)
            if !numbers.contains(number) {
                numbers.append(number)
            }
        }

        let sortedNums = numbers.sorted()

        for i in 0...5 {
            labelArr[i].text = "\(sortedNums[i])"
        }

        let numberColor = [UIColor.systemYellow, UIColor.systemBlue,
                           UIColor.systemRed, UIColor.systemGray, UIColor.systemGreen]
        for i in 0...5 {
            labelArr[i].backgroundColor = numberColor[sortedNums[i]/10]
        }


    }


}
