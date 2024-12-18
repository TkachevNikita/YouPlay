import Foundation
import UIKit

class DisplayActionsTableView: DraggableViewController, UITableViewDelegate, UITableViewDataSource {
        
    var source: [ActionModel]
    
    private lazy var tableView = UITableView()
        
    private var headerView: UIView
    
    private var heightForRow: CGFloat
    
    private var heightForHeader: CGFloat

    init(source: [ActionModel], headerView: UIView, heightForRow: CGFloat, heightForHeader: CGFloat) {
        self.source = source
        self.heightForRow = heightForRow
        self.headerView = headerView
        self.heightForHeader = heightForHeader
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActionCell", for: indexPath) as! ActionCell
        let image = UIImage(systemName: source[indexPath.row].iconName ?? "")
        cell.setup(title: source[indexPath.row].title, onTap: source[indexPath.row].onTap, icon: image)
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        source[indexPath.row].onTap?()
        dismiss(animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return source.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightForRow
    }

    override func viewDidLoad() {
        view.backgroundColor = .darkGray
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        view.addGestureRecognizer(panGesture)
        
        let slideIndicator = UIView()
        slideIndicator.roundCorners(.allCorners, radius: 10)
        
        view.addSubview(slideIndicator)
        slideIndicator.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
            make.width.equalTo(10)
            make.height.equalTo(5)
        }
        
        tableView.bounces = false
        tableView.register(ActionCell.self, forCellReuseIdentifier: "ActionCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .darkGray
        tableView.allowsMultipleSelection = true
        tableView.separatorColor = .white
        
        view.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.top.equalTo(view.readableContentGuide).offset(50)
            make.left.right.equalTo(view.readableContentGuide)
            make.height.equalTo(heightForHeader)
        }
                
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(50)
            make.bottom.left.right.equalTo(view.readableContentGuide)
        }
    }
}


