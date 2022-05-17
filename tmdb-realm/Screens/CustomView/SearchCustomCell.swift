//
//  SearchCustomCell.swift
//  tmdb-realm
//
//  Created by Emre Beytullah Marsak  on 13.05.2022.
//

import UIKit

class SearchCustomCell: UITableViewCell {
    
    var titleLabel = UILabel()
    var releaseDate = UILabel()
    var poster = UIImageView()
    var voteAverage = UILabel()
    let voteSymbol = UIImageView()
    let alreadyFavoritedButton = UIButton()

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
        titleLabel.text = nil
        releaseDate.text = nil
        voteAverage.text = nil
    }
    
    private func configSubviews() {
        let subviews = [titleLabel, releaseDate, poster, voteAverage, voteSymbol, alreadyFavoritedButton]
        subviews.forEach { addSubview($0) }
        subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        titleLabel.numberOfLines = 2
        titleLabel.lineBreakStrategy = .standard
        
        poster.contentMode = .scaleAspectFill
        
        releaseDate.font = UIFont.italicSystemFont(ofSize: 14)
        
        voteSymbol.image = UIImage(systemName: "heart.square")?.withTintColor(.systemGray2, renderingMode: .alwaysOriginal)
        voteAverage.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        
        var btnConfig = UIButton.Configuration.gray()
        btnConfig.cornerStyle = .capsule
        btnConfig.baseForegroundColor = UIColor.systemPink
        btnConfig.buttonSize = .mini
        btnConfig.contentInsets = .zero
        btnConfig.title = "On your list!"
        alreadyFavoritedButton.configuration = btnConfig
        
        let padding: CGFloat = 10
        
        NSLayoutConstraint.activate([
            
            poster.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            poster.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            poster.widthAnchor.constraint(equalToConstant: 70),
            poster.heightAnchor.constraint(equalToConstant: 116),
            
            titleLabel.topAnchor.constraint(equalTo: poster.topAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: poster.trailingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            
            releaseDate.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 2),
            releaseDate.bottomAnchor.constraint(equalTo: poster.bottomAnchor),
            
            voteSymbol.leadingAnchor.constraint(equalTo: alreadyFavoritedButton.trailingAnchor, constant: padding),
            voteSymbol.bottomAnchor.constraint(equalTo: poster.bottomAnchor),
            voteSymbol.trailingAnchor.constraint(equalTo: voteAverage.leadingAnchor, constant: -4),
            
            voteAverage.bottomAnchor.constraint(equalTo: poster.bottomAnchor),
            voteAverage.leadingAnchor.constraint(equalTo: voteSymbol.trailingAnchor),
            voteAverage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            
            alreadyFavoritedButton.leadingAnchor.constraint(equalTo: releaseDate.trailingAnchor, constant: padding),
            alreadyFavoritedButton.trailingAnchor.constraint(equalTo: voteSymbol.leadingAnchor, constant: -padding),
            alreadyFavoritedButton.bottomAnchor.constraint(equalTo: poster.bottomAnchor, constant: 0)
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
