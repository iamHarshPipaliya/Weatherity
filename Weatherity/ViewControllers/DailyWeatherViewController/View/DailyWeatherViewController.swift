//
//  DailyWeatherViewController.swift
//  Weatherity
//
//  Created by Harsh on 29/01/2022.
//

import UIKit



class DailyWeatherViewController: UIViewController {

    //MARK: - Properties
    @IBOutlet weak var tableViewWeatherList: UITableView! {
        didSet {
            guard let tableView = self.tableViewWeatherList else {  return }
            tableView.registerNib(WeatherTableViewCell.self)
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    var weatherViewModel = WeatherViewModel()
    
    // MARK: ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        dailyWeatherAPICall()
    }
    
    
    //MARK: - UIButton Actions
    @IBAction func btnSettingsAction(_ sender: UIBarButtonItem) {
        let settingsTableVC = SettingsTableViewController.instantiate(fromAppStoryboard: .Main)
        settingsTableVC.delegate = self
        self.present(settingsTableVC, animated: true, completion: nil)
    }
    
    
    //MARK: - Other Mehods
    func dailyWeatherAPICall() {
        self.weatherViewModel.getDailyWeatherAPI { (status, message) in
            switch (status) {
            case .success:
                self.tableViewWeatherList.reloadData()
//                self.tableViewMyOrder.setEmptyMessage(msgDataNotFound, self.myOrdersViewModel.arrMyOrders?.count ?? 0)
            case .noInternet:
            //                self.loadNoInternetNoData {
            //                    self.myOrderListAPICall()
            //                }
                break

            default:
//                self.popupAlert("", message, [ButtonTitles.Ok], [nil])
                break;
            }
        }
    }
}

//MARK: - UITableView DataSource & Delegate
extension DailyWeatherViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherViewModel.arrDailyWeather?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClassIdentifier: WeatherTableViewCell.self, for: indexPath)
        cell.initWeatherData(weatherViewModel.arrDailyWeather![indexPath.row])
        return cell
    }
}

//MARK: - SettingsTableViewControllerDelegate
extension DailyWeatherViewController: SettingsTableViewControllerDelegate {
    func refreshTempUnit() {
        self.tableViewWeatherList.reloadData()
    }
}