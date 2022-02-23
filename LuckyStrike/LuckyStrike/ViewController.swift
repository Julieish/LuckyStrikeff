//
//  ViewController.swift
//  LuckyStrike
//
//  Created by 수현 on 2022/02/03.
//

import UIKit
import SnapKit
import Alamofire
import CoreLocation

public let DEFAULT_POSITION = MTMapPointGeo(latitude: 37.576568, longitude: 127.029148)
class ViewController: UIViewController, MTMapViewDelegate, UISearchBarDelegate, CLLocationManagerDelegate {
    
    let myAPIkey = "6a5448afff050d840d01301931dc2311"
    
    var locationManager = CLLocationManager()
    var currentLocLatitude: String = "37.576568"
    var currentLocLongitude: String = "127.029148"
    
    var mapView: MTMapView?
    var mapPoint1: MTMapPoint?
    var poiItem1: MTMapPOIItem?
    var dataSource = [Document]()
    var nameAndAddress = [[String]]()
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.backgroundColor = .clear
        searchBar.barTintColor = .clear
        searchBar.searchTextField.backgroundColor = .white
        searchBar.isTranslucent = true
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        return searchBar
    }()
    let currentLocButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("", for: .normal)
        btn.backgroundColor = .clear
        btn.setImage(UIImage(named: "my_location.png"), for: .normal)
        btn.tintColor = .red
        btn.setBackgroundImage(UIImage(named: "location"), for: .normal)
        btn.addTarget(self, action: #selector(updateCurrentLocationBtnTapped(_:)), for: .touchUpInside)
        return btn
    }()
    let CheckWinBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("당첨확인", for: .normal)
        btn.addTarget(self, action: #selector(goToResultPage(_:)), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .red
        return btn
    }()
    let NearStoreLocBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("근처판매점", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .orange
        btn.addTarget(self, action: #selector(findNearShopPage(_:)), for: .touchUpInside)
        return btn
    }()
    let RecommendNumberBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("번호추천", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .yellow
        btn.addTarget(self, action: #selector(recommendNumBtnTapped(_:)), for: .touchUpInside)
        return btn
    }()
    let bottomStackView: UIStackView = {
        let stckView = UIStackView()
        stckView.backgroundColor = .clear
        stckView.alignment = .fill
        stckView.distribution = .fillEqually
        stckView.axis = .horizontal
        stckView.spacing = 8
        return stckView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView = MTMapView(frame: self.view.bounds)
        
        if let mapView = mapView {
            mapView.delegate = self
            mapView.baseMapType = .standard
            mapView.setMapCenter(MTMapPoint(geoCoord: DEFAULT_POSITION), zoomLevel: 4, animated: true)
            
            mapView.showCurrentLocationMarker = true
            mapView.currentLocationTrackingMode = .onWithoutHeading
            
//            self.mapPoint1 = MTMapPoint(geoCoord: MTMapPointGeo(latitude: 37.585568, longitude: 127.019148))
//            poiItem1 = MTMapPOIItem()
//            poiItem1?.markerType = MTMapPOIItemMarkerType.redPin
//            poiItem1?.mapPoint = mapPoint1
//            poiItem1?.itemName = "tmp"
//            mapView.add(poiItem1)
            self.view.addSubview(mapView)
        }
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
        self.view.addSubview(searchBar)
        searchBarAutoLayout()
        
        bottomStackView.addArrangedSubview(CheckWinBtn)
        bottomStackView.addArrangedSubview(NearStoreLocBtn)
        bottomStackView.addArrangedSubview(RecommendNumberBtn)
        
        self.view.addSubview(bottomStackView)
        bottomStackViewAutoLayout()
        
        self.view.addSubview(currentLocButton)
        currentLocBtnAutoLayout()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        } else {
            print("location service off")
        }
    }
    
   func searchBarAutoLayout() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
    }
    
    func currentLocBtnAutoLayout() {
        currentLocButton.translatesAutoresizingMaskIntoConstraints = false
        currentLocButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        currentLocButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        currentLocButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        currentLocButton.bottomAnchor.constraint(equalTo: bottomStackView.topAnchor, constant: -20).isActive = true
    }
    
    func bottomStackViewAutoLayout() {
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        bottomStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        bottomStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        bottomStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            print(text)
        }
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    
    func parseLocationCSV(url: URL) {
        do {
            let data = try Data(contentsOf: url)
            let dataEncoded = String(data: data, encoding: .windowsCP1250)

            if let dataArr = dataEncoded?.components(separatedBy: "\n").map({$0.components(separatedBy: ",")}) {
                for item in dataArr {
                    if nameAndAddress.count < 50 {
                        nameAndAddress.append(item)
                    }
                }
            }
        } catch {
            print("Error")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didUpdateLocations")
        if let location = locations.first {
            currentLocLatitude = String(location.coordinate.latitude)
            currentLocLongitude = String(location.coordinate.longitude)
            print("위도 : \(currentLocLatitude)")
            print("경도 \(currentLocLongitude)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    @objc func updateCurrentLocationBtnTapped(_ sender: UIButton) {
        mapView?.currentLocationTrackingMode = .onWithoutHeading
    }
    
    @objc func recommendNumBtnTapped(_ sender: UIButton) {
        let vc = RecommendNumViewController()
        vc.modalPresentationStyle = .formSheet
        present(vc, animated: true, completion: nil)
    }
    
    @objc func loadAddressFromCSV(_ sender: UIButton) {
        let path = Bundle.main.path(forResource: "nameAndAddress", ofType: ".csv")!
        parseLocationCSV(url: URL(fileURLWithPath: path))
        print(nameAndAddress)
    }
    
    @objc func goToResultPage(_ sender: UIButton) {
        let vc = GoToResultViewController()
        present(vc, animated: true, completion: nil)
    }
    
    func convertCoordToAddress() {
        var dataSource = [Document]()
        let url = "https://dapi.kakao.com/v2/local/geo/coord2address.json"
        let headers: HTTPHeaders = [
            "Authorization" : "KakaoAK \(myAPIkey)"
        ]
        
        let parameters : [String: Any] = [
            "x": currentLocLongitude,
            "y": currentLocLatitude
        ]
        let request = AF.request(url,
                   method: .get,
                   parameters: parameters,
                   encoding: URLEncoding.default,
                   headers: headers)
        request.validate(statusCode: 200..<500).responseDecodable(of: NearStoreResult.self) { response in
                
            switch response.result {
            case .success(let res):
                let resultData = String(data: response.data!, encoding: .utf8)
                
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: res, options: .prettyPrinted)
                    let json = try JSONDecoder().decode(NearStoreResult.self, from: jsonData)
                    self.dataSource = json.documents
                } catch (let error) {
                    print(error)
                }
                print(self.dataSource[0].roadAddress)
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
    
    @objc func findNearShopPage(_ sender: UIButton) {
        

    }
}

