//
//  DetailsUIView.swift
//  Marvel Heroes
//
//  Created by Nuno Miguel Mendonça on 16/12/2021.
//

import UIKit

protocol DetailsUIViewDelegate: AnyObject {
    func tappedButton( _ detailsView: DetailsUIView)
}

class DetailsUIView: UIView {

    weak var delegate: DetailsUIViewDelegate?

    private let charDescriptionLabel = UILabel()
    
    private let detailsTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .singleLine
        tableView.allowsSelection = false
        return tableView
    }()
    private let rowHeight: CGFloat = 55
    private var character: CharacterModel
    private var buttonFavouriteText: UIButton = UIButton(type: .roundedRect)
    private var detailsModel: DetailsModel?

    private struct Cells {
        static let detailCell = "DetailCell"
    }

    init(frame: CGRect, character: CharacterModel, details: DetailsModel?) {
        self.character = character
        self.detailsModel = details

        super.init(frame: .zero)

        backgroundColor = .systemBackground
        configureTableView()
        configureDescriptionLabel()
        setFavouriteTextButton()
    }

    func updateDetailsModel(detailModel: DetailsModel){
        self.detailsModel = detailModel
    }

    func updateFavoriteStateWith(_ bool:Bool){
        if bool {
            self.buttonFavouriteText.setTitle("FAVOURITE", for: .normal)
            self.buttonFavouriteText.setTitleColor(.white, for: .normal)
            buttonFavouriteText.backgroundColor = UIColor(red: 0.75, green: 0.90, blue: 0.69, alpha: 1.00) // GREEN PASTEL
        } else {
            self.buttonFavouriteText.setTitle("NOT FAVOURITE", for: .normal)
            self.buttonFavouriteText.setTitleColor(.white, for: .normal)
            buttonFavouriteText.backgroundColor = UIColor(red: 1.00, green: 0.41, blue: 0.38, alpha: 1.00) //RED PASTEL
        }
    }

    func updateTableView(){
        detailsTableView.reloadData()
    }

    @objc func buttonPressed(){
        delegate?.tappedButton(self)
    }

    private func setFavouriteTextButton() {
        buttonFavouriteText.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        buttonFavouriteText.layer.cornerRadius = 10
        buttonFavouriteText.clipsToBounds = true
        addSubview(buttonFavouriteText)
        setFavouriteButtonTextDescriptionConstraints()
    }

    private func configureDescriptionLabel(){
        addSubview(charDescriptionLabel)
        setCharDescriptionLabelConstraints()

        charDescriptionLabel.text = character.description
        charDescriptionLabel.textAlignment = .justified
        charDescriptionLabel.numberOfLines = 0
    }

    private func configureTableView(){
        addSubview(detailsTableView)
        setDetailsTableViewConstraints()
        setTableViewDelegates()
        detailsTableView.register(DetailCell.self, forCellReuseIdentifier: Cells.detailCell)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension DetailsUIView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return detailsModel?.comics.count ?? 0
        case 1:
            return detailsModel?.events.count ?? 0
        case 2:
            return detailsModel?.series.count ?? 0
        case 3:
            return detailsModel?.stories.count ?? 0
        default:
            return 0
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.detailCell, for: indexPath) as! DetailCell
        switch indexPath.section{
        case 0:
            guard let comic = detailsModel?.comics[indexPath.row] else {
                return cell
            }
            cell.setDetail(detail: comic)
        case 1:
            guard let events = detailsModel?.events[indexPath.row] else {
                return cell
            }
            cell.setDetail(detail: events)
        case 2:
            guard let series = detailsModel?.series[indexPath.row] else {
                return cell
            }
            cell.setDetail(detail: series)
        case 3:
            guard let stories = detailsModel?.stories[indexPath.row] else {
                return cell
            }
            cell.setDetail(detail: stories)
        default:
            break
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func setTableViewDelegates() {
        detailsTableView.delegate = self
        detailsTableView.dataSource = self

    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Comics"
        case 1:
            return "Events"
        case 2:
            return "Series"
        case 3:
            return "Story"
        default:
            return "Others"
        }
    }
}

extension DetailsUIView {

    func setFavouriteButtonTextDescriptionConstraints(){
        buttonFavouriteText.translatesAutoresizingMaskIntoConstraints = false
        buttonFavouriteText.topAnchor.constraint(equalTo: topAnchor).isActive = true
        buttonFavouriteText.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        buttonFavouriteText.bottomAnchor.constraint(equalTo: charDescriptionLabel.topAnchor, constant: -8.0).isActive = true
    }

    func setCharDescriptionLabelConstraints() {
        charDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        charDescriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        charDescriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        charDescriptionLabel.bottomAnchor.constraint(equalTo: detailsTableView.topAnchor).isActive = true
    }

    func setDetailsTableViewConstraints(){
        detailsTableView.translatesAutoresizingMaskIntoConstraints = false
        detailsTableView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        detailsTableView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        detailsTableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
