import Foundation
import UIKit
import SnapKit
import MarqueeLabel
import Kingfisher
import ESTMusicIndicator

protocol MoreActionsTappedDelegate: AnyObject {
    func onMoreActionsTapped(cell: UITableViewCell)
}

class MediaFileCell: UITableViewCell {
    
    private(set) var file: MediaFileUIProtocol?
    
    weak var delegate: MoreActionsTappedDelegate?
    
    private var nameLabel: MarqueeLabel!
    
    private var authorLabel: MarqueeLabel!
    
    private var durationLabel: UILabel!
    
    private(set) var moreActionsButton: UIButton?
    
    private(set) var imgView: UIImageView!
    
    private var indicator: ESTMusicIndicatorView?
    
    public var isPlaying: Bool = false {
        didSet {
            playState = isPlaying ? .playing : .paused
        }
    }
    
    public var playState: ESTMusicIndicatorViewState = .stopped {
        didSet {
            if playState == .stopped {
                removeIndicator()
            }
            if indicator == nil {
                addIndicator()
            }
            DispatchQueue.main.async {
                self.indicator?.state = self.playState
            }
        }
    }
    
    public func setup(file: MediaFileUIProtocol,
                      backgroundColor: UIColor,
                      imageCornerRadius: CGFloat = 0,
                      fadeLength: CGFloat = 20,
                      animationDuration: CGFloat = 6,
                      supportsMoreActions: Bool = false,
                      contextMenuActions: [UIAction]? = nil) {
        self.file = file
        
        nameLabel = MarqueeLabel(frame: .zero, duration: animationDuration, fadeLength: 0)
        nameLabel.animationDelay = 2
        nameLabel.fadeLength = fadeLength
        nameLabel.text = file.title
        nameLabel.textColor = .white
        nameLabel.font = .boldSystemFont(ofSize: 20)
        
        authorLabel = MarqueeLabel(frame: .zero, duration: animationDuration, fadeLength: 0)
        authorLabel.animationDelay = 2
        authorLabel.fadeLength = fadeLength
        authorLabel.text = file.author
        authorLabel.textColor = .gray
        authorLabel.font = .boldSystemFont(ofSize: 15)
        
        durationLabel = UILabel()
        let duration = file.duration.stringTime
        durationLabel.text = duration
        durationLabel.textAlignment = .right
        durationLabel.textColor = .gray
        
        imgView = UIImageView(image: nil)
        imgView.kf.setImage(with: file.imageURL)
        imgView.contentMode = .scaleToFill
        imgView.layer.cornerRadius = imageCornerRadius
        imgView.clipsToBounds = true
        
        
        addSubview(imgView)
        imgView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(contentView.readableContentGuide)
            make.height.equalToSuperview().multipliedBy(0.95)
            make.width.equalToSuperview().dividedBy(5)
        }
        
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.height.equalToSuperview().dividedBy(2.5)
            make.left.equalTo(imgView.snp.right).offset(contentView.bounds.width / 15)
            make.top.equalTo(imgView)
            make.width.equalToSuperview().multipliedBy(0.6)
        }
        
        addSubview(durationLabel)
        durationLabel.snp.makeConstraints { make in
            make.right.equalTo(nameLabel)
            make.bottom.equalTo(imgView)
        }
        
        addSubview(authorLabel)
        authorLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel)
            make.right.equalTo(durationLabel.snp.left).offset(-10)
            make.bottom.equalTo(imgView)
        }
        
        if supportsMoreActions {
            let image = UIImage(named: "Dots")
            moreActionsButton = UIButton()
            moreActionsButton?.setImage(image, for: .normal)
            moreActionsButton?.tintColor = .white
            moreActionsButton?.addTarget(self, action: #selector(onMoreActionsTap), for: .touchUpInside)
            addSubview(moreActionsButton!)
            moreActionsButton!.snp.makeConstraints { make in
                make.right.centerY.equalToSuperview()
                make.width.height.equalTo(50)
            }
        }
        
        contentView.backgroundColor = backgroundColor
    }
    
    @objc private func onMoreActionsTap() {
        delegate?.onMoreActionsTapped(cell: self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                self?.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
            }, completion: { [weak self] finished in
                UIView.animate(withDuration: 0.2) {
                    self?.transform = .identity
                }
            })
        }
    }
    
    public func didSelect() {
        tintColor = .green
        isSelected = true
        accessoryType = .checkmark
    }
    
    public func didDeselect() {
        isSelected = false
        accessoryType = .none
    }
    
    override func prepareForReuse() {
        isSelected = false
        super.prepareForReuse()
        nameLabel.removeFromSuperview()
        authorLabel.removeFromSuperview()
        durationLabel.removeFromSuperview()
        imgView.removeFromSuperview()
        moreActionsButton?.removeFromSuperview()
        indicator?.removeFromSuperview()
        nameLabel = nil
        authorLabel = nil
        durationLabel = nil
        imgView = nil
        moreActionsButton = nil
        indicator = nil
    }
    
    private func addIndicator() {
        indicator = ESTMusicIndicatorView(frame: .zero)
        indicator?.tintColor = .white
        indicator?.backgroundColor = .black
        indicator?.layer.opacity = 0.7
        indicator?.layer.cornerRadius = imgView.layer.cornerRadius
        addSubview(indicator!)
        indicator!.snp.makeConstraints({ make in
            make.left.right.top.bottom.equalTo(imgView)
        })
    }
    
    private func removeIndicator() {
        indicator?.removeFromSuperview()
        indicator = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        indicator?.state = playState
    }
}

