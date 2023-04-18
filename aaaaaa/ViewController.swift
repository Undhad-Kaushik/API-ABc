//
//  ViewController.swift
//  aaaaaa
//
//  Created by undhad kaushik on 22/03/23.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var tabelvew: UITableView!
    
    var arrData: MainData!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
     nibRegister()
        apiH()
    }
    private func nibRegister(){
        let nibFile: UINib = UINib(nibName: "MyTableViewCell", bundle: nil)
        tabelvew.register(nibFile, forCellReuseIdentifier: "MyTableViewCell")
    }
    private func apiH(){
            AF.request("https://dummyjson.com/posts",method: .get).responseData{  response in
                debugPrint(response)
                if response.response?.statusCode == 200 {
                    guard let apiData = response.data else { return }
                    do{
                        self.arrData = try JSONDecoder().decode(MainData.self, from: apiData)
                        print(self.arrData)
                            self.tabelvew.reloadData()
                    }catch{
                        print(error.localizedDescription)
                    }
                }else{
                    print("Wrong")
                }
            }
        }
}
extension ViewController: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData?.posts.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MyTableViewCell", for: indexPath) as! MyTableViewCell
        cell.nameLabelOne.text = "\(arrData.posts[indexPath.row].id)"
        cell.nameLabelTwo.text = "\(arrData.posts[indexPath.row].title)"
        cell.nameLabelThree.text = "\(arrData.posts[indexPath.row].body)"
        cell.nameLabelFour.text = "\(arrData.posts[indexPath.row].userId)"
        cell.nameLableFive.text = "\(arrData.posts[indexPath.row].tags)"
        cell.layer.borderWidth = 1
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tabelvew.reloadData()
    }
}

struct MainData: Decodable {
    let posts: [Pair]
    let total: Int
    let skip: Int
    let limit: Int
}


struct Pair: Decodable {
    let id: Int
    let title: String
    let body: String
    let userId: Int
    let tags: [String]
    let reactions: Int
}
