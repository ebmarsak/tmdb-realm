//
//  MovieCustomCell.swift
//  tmdb-realm
//
//  Created by Emre Beytullah Marsak  on 9.05.2022.
//

import UIKit

class MovieCustomCell: UITableViewCell {
    
    let titleLabel = UILabel()
    var popularity = UILabel()
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
    
    override func prepareForReuse() {
        poster.image = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configSubviews() {
        addSubview(poster)
        addSubview(titleLabel)
        addSubview(popularity)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        popularity.translatesAutoresizingMaskIntoConstraints = false
        poster.translatesAutoresizingMaskIntoConstraints = false
        
        poster.translatesAutoresizingMaskIntoConstraints = false
        poster.layer.cornerRadius = 10
        poster.clipsToBounds = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 3
        titleLabel.lineBreakStrategy = .standard
        
        let padding: CGFloat = 10.0
        
        NSLayoutConstraint.activate([
            poster.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            poster.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            poster.widthAnchor.constraint(equalToConstant: 162),
            poster.heightAnchor.constraint(equalToConstant: 288),
            
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: poster.trailingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),

            popularity.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding),
            popularity.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 0),
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
