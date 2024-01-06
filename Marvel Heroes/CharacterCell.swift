//
//  HeroCell.swift
//  Marvel Heroes
//
//  Created by Nuno Miguel Mendonça on 17/11/2021.
//

import UIKit

class CharacterCell: UITableViewCell {
    
    var characterImageView = CustomImageview()
    var characterNameLabel:UILabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        //Add subview to the view
        addSubview(characterImageView)
        addSubview(characterNameLabel)

        configureImageView()
        configureNameLabel()

        setImageConstraints()
        setNameLabelConstraints()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(character: CharacterModel) {
        characterNameLabel.text = character.name
        if let url = character.thumbnail?.url {
            characterImageView.loadImage(from: url)
        }
    }

    func configureImageView(){
        characterImageView.layer.cornerRadius = 10
        characterImageView.clipsToBounds = true
    }

    func configureNameLabel(){
        characterNameLabel.numberOfLines = 0 //Wrap the text
        characterNameLabel.adjustsFontSizeToFitWidth = true //Shrink the font size
    }

    func setImageConstraints() {
        characterImageView.translatesAutoresizingMaskIntoConstraints = false
        characterImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        characterImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        characterImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        characterImageView.widthAnchor.constraint(equalTo: characterImageView.heightAnchor, multiplier: 16/9).isActive = true
    }

    func setNameLabelConstraints() {
        characterNameLabel.translatesAutoresizingMaskIntoConstraints = false
        characterNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        characterNameLabel.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: 20).isActive = true
        characterNameLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        characterNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
    }
}
