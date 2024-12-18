import Foundation
import UIKit

class ActionCell: UITableViewCell {
    private var titleLabel: UILabel?
    private var onTap: (() -> Void)?
    private var imgView: UIImageView?
    
    public func setup(title: String?, onTap: (() -> Void)?, icon: UIImage? = nil, tintColor: UIColor = .white, textColor: UIColor = .white) {
        
        enum Constants {
            static let verticalPadding = 10
            static let horizontalPadding = 10
            static let iconSize = 50
        }

        titleLabel = UILabel()
        titleLabel!.text = title
        titleLabel!.font = .mediumSizeBoldFont
        titleLabel!.textColor = textColor
        titleLabel!.textAlignment = .left
        titleLabel?.sizeToFit()
        
        self.onTap = onTap
        imgView = UIImageView()
        imgView?.image = icon
        imgView?.contentMode = .scaleAspectFit
        imgView?.tintColor = tintColor
        
        addSubview(imgView!)
        imgView!.snp.makeConstraints { make in
            make.left.centerY.equalToSuperview()
            make.width.height.equalTo(titleLabel!.frame.height)
        }
        
        addSubview(titleLabel!)
        titleLabel!.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(imgView!.snp.right).offset(10)
        }
    }
}
