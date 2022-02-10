//
//  MainHomeViewController.swift
//  ChatApp
//
//  Created by Keshav Raj Kashyap on 24/01/22.
//

import UIKit

class MainHomeViewController: UIViewController {
    @IBOutlet weak var btnBackl: UIButton!
    @IBOutlet weak var tableViewMenu: UITableView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var menuBtn: UIButton!
    
    var arrMenu = ["MapScreen","MapViewTwo","profile"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        menuView.isHidden = true
        tableViewMenu.isHidden = true
        menuBtn.isSelected = true
        tableViewMenu.isScrollEnabled = false
        tableViewMenu.register(UINib(nibName: "MenuTableViewCell", bundle: nil), forCellReuseIdentifier: "MenuTableViewCell")

    }
    
    @IBAction func buttonBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonMenu(_ sender: Any) {
        if menuBtn.isSelected == true{
            menuBtn.isSelected = false
            menuView.isHidden = false
            tableViewMenu.isHidden = false
        }else{
            menuBtn.isSelected = true
            menuView.isHidden = true
            tableViewMenu.isHidden = true
        }
    }
    

}

@available(iOS 14.0, *)
extension MainHomeViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath)as! MenuTableViewCell
        cell.lblMenuName.text = arrMenu[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            let nextVc = self.storyboard?.instantiateViewController(withIdentifier: "MapsViewController")as! MapsViewController
            self.navigationController?.pushViewController(nextVc, animated: true)
        }else if indexPath.row == 1{
            let nextVc = self.storyboard?.instantiateViewController(withIdentifier: "MapViewVC")as! MapViewVC
            self.navigationController?.pushViewController(nextVc, animated: true)
        }
        
    }
    
}
