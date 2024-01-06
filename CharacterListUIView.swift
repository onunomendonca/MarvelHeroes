//
//  CharacterListUIView.swift
//  Marvel Heroes
//
//  Created by Nuno Miguel Mendonça on 17/12/2021.
//

import UIKit

protocol CharacterListUIViewDelegate: AnyObject {
    func askedForMoreCharacters( _ characterListUIView: CharacterListUIView, indexPath: IndexPath)
    func tapedOnACharacter( _ characterListUIView: CharacterListUIView, indexPath: IndexPath)
    func toggledFavourite( _ characterListUIView: CharacterListUIView?, character: inout CharacterModel)
}

class CharacterListUIView: UIView {

    weak var delegate: CharacterListUIViewDelegate?

    private let tableView = UITableView()
    private let spinner = UIActivityIndicatorView(style: .large)

    private let rowHeight:CGFloat = 100

    var characterArray: [CharacterModel] = []
    var filteredArray: [CharacterModel] = []
    var displayedFavourites: [CharacterModel]

    var isFilterOn: Bool = false

    private struct Cells {
        static let characterCell = "CharacterCell"
    }

    init(favourites: [CharacterModel]) {
        self.displayedFavourites = favourites
        super.init(frame: CGRect.zero)
        backgroundColor = .systemBackground
        addSubview(tableView)
        spinner.frame = CGRect(x: 0.0, y: 0.0, width: tableView.bounds.width, height: 70)
        tableView.tableFooterView = spinner

        configureTableView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setTableViewDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func configureTableView(){
        setTableViewDelegates()
        tableView.rowHeight = rowHeight
        tableView.register(CharacterCell.self, forCellReuseIdentifier: Cells.characterCell)
        tableView.pin(to: self)
    }

    private func isCharacterFavourite(character: CharacterModel) -> Bool {
        guard let _ = displayedFavourites.firstIndex(of: character) else {
            return false
        }
        return true
    }

}

//Table View Settings and Funcs.
extension CharacterListUIView: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return displayedFavourites.count
        case 1:
            if isFilterOn {
                return filteredArray.count
            }
            return characterArray.count
        default:
            return 0
        }
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.characterCell) as! CharacterCell
        let character: CharacterModel
        switch indexPath.section{
        case 0:
            if displayedFavourites.count > 0 {
                character = displayedFavourites[indexPath.row]
                cell.set(character: character)
            }
        case 1:
            if isFilterOn {
                character = filteredArray[indexPath.row]
            } else {
                character = characterArray[indexPath.row]
            }
            cell.set(character: character)

        default:
            return cell
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.tapedOnACharacter(self, indexPath: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            guard displayedFavourites.count > 0 else {
                return nil
            }
            return "Favourites"
        case 1:
            guard displayedFavourites.count > 0 else {
                return nil
            }
            return "Super Heroes List"
        default:
            return "Others"
        }
    }

    //LAST CELL: ASK FOR MORE CHARACTERS.
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        delegate?.askedForMoreCharacters(self, indexPath: indexPath)
    }

    // Favourite system
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var character: CharacterModel
        if indexPath.section == 0 {
            character = displayedFavourites[indexPath.row]
        } else if indexPath.section == 1 && isFilterOn {
            character = filteredArray[indexPath.row]
        } else {
            character = characterArray[indexPath.row]
        }
        let action = UIContextualAction(style: .normal, title: nil) { [weak self] (action, view, completionHandler) in
            self?.delegate?.toggledFavourite(self, character: &character)
            completionHandler(true)
        }
            if isCharacterFavourite(character: character) {
                action.image = UIImage(systemName: "star.slash")
            } else {
                action.image = UIImage(systemName: "star.fill")
            }

            action.backgroundColor = .systemYellow
            return UISwipeActionsConfiguration(actions: [action])
    }

}

extension CharacterListUIView {
    func appendNewCharacters(with characters: [CharacterModel]) {
        if isFilterOn {
            filteredArray += characters
        } else {
        characterArray += characters
        }
        refreshView()
    }

    func refreshView(){
        tableView.reloadData()
    }

    func startLoading() {
        spinner.startAnimating()
    }

    func stopLoading() {
        spinner.stopAnimating()
    }

    func renewFavouriteArray(favourites: [CharacterModel]){
        displayedFavourites = favourites
        refreshView()
    }
}
