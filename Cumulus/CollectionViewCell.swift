//
//  CollectionViewCell.swift
//  Cumulus
//
//  Created by Adam Cahall on 11/21/21.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    private var timeLabel = UILabel()
    private var titleLabel = UILabel()
    private var locationLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        contentView.backgroundColor = .gray
        
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.textColor = .black
        timeLabel.backgroundColor = .white

        contentView.addSubview(timeLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .black
        titleLabel.backgroundColor = .white

        contentView.addSubview(titleLabel)
        
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.textColor = .black
        locationLabel.backgroundColor = .white

        contentView.addSubview(locationLabel)
    
    
        setupConstraints()
    }
    
    func configure(for event: Event) {
        timeLabel.text = event.time
        titleLabel.text = event.title
        locationLabel.text = event.location
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 29)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: timeLabel.topAnchor, constant: 17),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 29)
        ])
        
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 22),
            locationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 29)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
