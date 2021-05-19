//
//  ViewController.swift
//  CombineExample
//
//  Created by Siddharth on 18/05/21.
//

import Combine
import UIKit

class myCustomTableCell: UITableViewCell{
    private let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemPink
        button.setTitle("Button", for: .normal)
        return button
    }()
    
    let buttonAction = PassthroughSubject<String, Never>()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(button)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
    }
    @objc private func didTapButton(){
        buttonAction.send("Button was pressed")
    }
    
    
    required init(coder:NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        button.frame = CGRect(x: 10, y: 3, width: contentView.frame.width - 20, height: contentView.frame.height - 6)
    }
}

class ViewController: UIViewController, UITableViewDataSource {
    
    private let tableView:UITableView = {
        let table = UITableView()
        table.register(myCustomTableCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    private var models = [String]()
    
    var observers:[AnyCancellable] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.frame = view.bounds
        
        APICaller.shared.fetchCompanies()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion{
                case .finished:
                print("finished")
                case .failure(let error):
                print(error)
                }
            }, receiveValue: { value in
                self.models = value
                self.tableView.reloadData()
            }).store(in: &observers)
        // Do any additional setup after loading the view.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? myCustomTableCell else {
            fatalError()
        }
        //cell.textLabel?.text = models[indexPath.row]
        cell.buttonAction.sink { string in
            print(string)
        }.store(in: &observers)
        return cell
    }

}

