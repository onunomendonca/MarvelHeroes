//
//  DetailCell.swift
//  Marvel Heroes
//
//  Created by Nuno Miguel Mendonça on 24/11/2021.
//

import UIKit

class DetailCell: UITableViewCell {

    var detailImageView = CustomImageview()
    var titleLabel:UILabel = UILabel()
    var descriptionLabel: UILabel = UILabel()
    var cellStack = UIStackView()
    var textStack = UIStackView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configureCellStack()
        configureTextStack()
        configureImageView()

        //detailImageView.backgroundColor = .red

    }

    func configureCellStack(){
        addSubview(cellStack)
        setCellStackConstraints()
        cellStack.axis = .horizontal
        cellStack.spacing = 12.0
        cellStack.alignment = .center
        cellStack.addArrangedSubview(detailImageView)
        //detailImageView.setContentHuggingPriority(.defaultLow, for: .vertical)
        cellStack.addArrangedSubview(textStack)
        //textStack.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }

    func configureTextStack(){
        configureTitleLabel()
        configureDescriptionLabel()
        textStack.addArrangedSubview(titleLabel)
        textStack.addArrangedSubview(descriptionLabel)
        textStack.axis = .vertical
        textStack.spacing = 8.0
        textStack.distribution = .fill
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setDetail(detail: Detail){
        titleLabel.text = detail.title
        descriptionLabel.text = detail.description
        if let url = detail.thumbnail?.url {
            detailImageView.loadImage(from: url)
        }
    }

    func configureImageView(){
        detailImageView.layer.cornerRadius = 10
        detailImageView.clipsToBounds = true
        setImageConstraints()
    }

    func configureTitleLabel(){
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        titleLabel.font = UIFont(name: "Verdana-Bold", size: 14)
    }
    func configureDescriptionLabel(){
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .justified
        descriptionLabel.font = UIFont(name: "Verdana", size: 10)
    }

    func setImageConstraints() {
        detailImageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        detailImageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
    }

    func setCellStackConstraints(){
        cellStack.translatesAutoresizingMaskIntoConstraints = false
        cellStack.topAnchor.constraint(equalTo: topAnchor, constant: 8.0).isActive = true
        cellStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8.0).isActive = true
        cellStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8.0).isActive = true
        cellStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8.0).isActive = true
    }
}
