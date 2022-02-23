//
//  GoToResultViewController.swift
//  LuckyStrike
//
//  Created by 수현 on 2022/02/04.
//

import UIKit
import SnapKit
import SwiftSoup

class GoToResultViewController: UIViewController {
    
    let qrCodeScanBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Scan", for: .normal)
        btn.backgroundColor = .yellow
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.addTarget(self, action: #selector(qrCodeScanBtnTapped(_:)), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        crawlLotteryWinNum()
        
        self.view.addSubview(qrCodeScanBtn)
        qrCodeScanBtnAutoLayout()
    }
    
    @objc func qrCodeScanBtnTapped(_ sender: UIButton) {
        let vc = QRCodeScanViewController()
        present(vc, animated: true, completion: nil)
    }
    
    func qrCodeScanBtnAutoLayout() {
        qrCodeScanBtn.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    
    func crawlLotteryWinNum() {
        
//        let urlStr = "https://www.dhlottery.co.kr/common.do?method=main"
        let urlStr = "https://search.naver.com/search.naver?where=nexearch&sm=top_hty&fbm=1&ie=utf8&query=%EB%A1%9C%EB%98%90"
        guard let myURL = URL(string: urlStr) else { return }
        
        do {
            let html = try String(contentsOf: myURL, encoding: .utf8)
            let doc: Document = try SwiftSoup.parse(html)
            let lottoTitleAndDate = try doc.select("._lotto-btn-current").select("a").text().components(separatedBy: " ")
            let lottoWinNum = try doc.select(".num_box").select("span").text().components(separatedBy: " ")
            
            print(lottoTitleAndDate)
            print(lottoWinNum)
        } catch Exception.Error(let type, let message){
            print("Message: \(message)")
        } catch {
            print("crawl error")
        }
    }


    
}



