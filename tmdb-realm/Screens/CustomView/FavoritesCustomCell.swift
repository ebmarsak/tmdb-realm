//
//  FavoritesCustomCell.swift
//  tmdb-realm
//
//  Created by Emre Beytullah Marsak  on 12.05.2022.
//

import UIKit

class FavoritesCustomCell: UITableViewCell {
    
    var id: Int = -1
    let titleLabel = UILabel()
    let poster = UIImageView()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        poster.image = nil
    }
    
    private func configSubviews() {
        let subviews = [titleLabel, poster]
        subviews.forEach { addSubview($0) }
        subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        
        let padding: CGFloat = 10
        
        NSLayoutConstraint.activate([
            poster.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            poster.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            poster.widthAnchor.constraint(equalToConstant: 60),
            poster.heightAnchor.constraint(equalToConstant: 92),
            
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: poster.trailingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding)
        ])
    }
    
    func getPosterFromURL(posterPath: String) {
        NetworkManager.shared.getPosterImage(posterPath: posterPath) { image in
            DispatchQueue.main.async {
                self.poster.image = image
            }
        }
    }
}
