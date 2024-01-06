//
//  DetailsViewController.swift
//  Marvel Heroes
//
//  Created by Nuno Miguel Mendonça on 23/11/2021.
//

import UIKit

class DetailsViewController: UIViewController {

    private let character: CharacterModel
    private var detailsModel: DetailsModel?
    private var dataSource: DetailsDataSourceProtocol
    private var button: UIBarButtonItem = UIBarButtonItem()
    private var detailsView: DetailsUIView

    init(character: CharacterModel, dataSource: DetailsDataSourceProtocol) {
        self.character = character
        self.dataSource = dataSource
        self.detailsView = DetailsUIView(frame: CGRect.zero,character: character, details: detailsModel)

        super.init(nibName: nil, bundle: nil)

        view.addSubview(self.detailsView)

        self.dataSource.delegate = self
        self.detailsView.delegate = self

        dataSource.getDetailsData(for: character)

        configureNavBarTitle()
        configureNavFavouriteButton()
        configureDetailsViewConstraints()


    }

    private func configureNavBarTitle(){
        if let url = character.thumbnail?.url {
            let characterImageview:CustomImageview = CustomImageview()
            characterImageview.loadImage(from: url)
            setTitle(character.name, withImageView: characterImageview)
        }
    }

    private func configureNavFavouriteButton() {
        var favImg: UIImage?

        if dataSource.isCharacterFavourite(character: character) {
            favImg = UIImage(systemName: "star.fill")
        } else {
            favImg = UIImage(systemName: "star")
        }

        self.button.image = favImg
        self.button.style = .plain
        self.button.target = self
        self.button.action = #selector(self.didTapButton)

        detailsView.updateFavoriteStateWith(dataSource.isCharacterFavourite(character: character))

        navigationItem.rightBarButtonItem = button
    }

    @objc private func didTapButton(){

        dataSource.toggleFavourite(character: character)
        let isFavourite = dataSource.isCharacterFavourite(character: character)
        detailsView.updateFavoriteStateWith(isFavourite)
        if isFavourite {
            self.button.image = UIImage(systemName: "star.fill")
        } else {
            self.button.image = UIImage(systemName: "star")
        }


    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension DetailsViewController: DetailsDataSourceDelegate, DetailsUIViewDelegate {
    func tappedButton(_ detailsView: DetailsUIView) {
        didTapButton()
    }

    func detailsDataSource(_ dataSource: DetailsDataSource, didFetchDetails: DetailsModel) {
        self.detailsModel = didFetchDetails
        detailsView.updateDetailsModel(detailModel: didFetchDetails)
        detailsView.updateTableView()
    }
}

private extension DetailsViewController {
    func configureDetailsViewConstraints(){
        detailsView.translatesAutoresizingMaskIntoConstraints = false

        // Cool trick to avoid having to do ".isActive = true" in every constraint
        NSLayoutConstraint.activate([

            detailsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 4.0),
            detailsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8.0),
            detailsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8.0),
            detailsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8.0),
        ])
    }
}
