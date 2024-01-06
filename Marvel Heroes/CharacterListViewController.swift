//
//  HeroesListViewController.swift
//  Marvel Heroes
//
//  Created by Nuno Miguel Mendonça on 17/11/2021.
//

import UIKit

class CharacterListViewController: UIViewController {

    private let vcFactory: ViewControllerFactory

    private let limit: Int = 20
    private var maxNumberOfCharacters: Int?

    private let debouncer = Debouncer(timeInterval: 0.5)

    private let searchController = UISearchController()
    private let transition = PopAnimator()

    private var dataSource: CharacterListDataSourceProtocol

    private var askedForNewCharacters: Bool = false
    private var lessThanTwentyEntries = false
    private var lastSearchedWord = ""
    private var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    private var isFiltering: Bool {
        if searchController.isActive && !isSearchBarEmpty {
            listView.isFilterOn = true
            return true
        } else {
            listView.isFilterOn = false
            return false
        }
    }

    private var lastCharacterCellSelected: CharacterCell?

    private var listView: CharacterListUIView
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Sets Glass navigation bar
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.delegate = self
        title = "Marvel Super Heroes"

        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Super Heroes"
        definesPresentationContext = true

        view.addSubview(listView)
        listView.pin(to: view)

        dataSource.getCharacters(from: 0, until: limit)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listView.renewFavouriteArray(favourites: dataSource.getFavouritesArray())
        listView.refreshView()
    }

    init(vcFactory: ViewControllerFactory, dataSource: CharacterListDataSourceProtocol) {
        self.vcFactory = vcFactory
        self.dataSource = dataSource
        self.listView = CharacterListUIView(favourites: self.dataSource.getFavouritesArray())
        super.init(nibName: nil, bundle: nil)
        self.dataSource.delegate = self
        self.listView.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // For Search Bar -- does the filter.
    private func filterContentForSearchText(_ searchText: String, name: String? = nil) {
        debouncer.renewInterval()
        debouncer.handler = {
            self.listView.filteredArray = []
            self.lessThanTwentyEntries = false
            self.dataSource.getFilteredCharacter(fromPosition: 0, with: searchText, until: self.limit)
        }
    }

}

//For Search Bar
extension CharacterListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if !searchController.isActive {
            listView.refreshView()
        }
        guard let searchText = searchController.searchBar.text else {
            return
        }
        guard searchText != "" else {
            return
        }
        filterContentForSearchText(searchText)
    }

}

extension CharacterListViewController: CharacterListDataSourceDelegate {
    func charactersDataSource(_ dataSource: CharacterListDataSource, didFetchCharacters: [CharacterModel]) {
        askedForNewCharacters = true
        listView.appendNewCharacters(with: didFetchCharacters)
        maxNumberOfCharacters = dataSource.maxNumberOfCharacter
        listView.stopLoading()
        askedForNewCharacters = false
    }

    func filteredCharactersDataSource(_ dataSource: CharacterListDataSource, didFetchFilteredCharacters: [CharacterModel], with searchText: String) {
        askedForNewCharacters = true
        if lastSearchedWord == searchText {
            listView.filteredArray += didFetchFilteredCharacters
        } else {
            listView.filteredArray = didFetchFilteredCharacters
        }
        lastSearchedWord = searchText
        lessThanTwentyEntries = didFetchFilteredCharacters.count < 20
        listView.stopLoading()
        listView.refreshView()
        askedForNewCharacters = false
    }

}

extension CharacterListViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.originFrame = lastCharacterCellSelected?.characterImageView.frame ?? CGRect.zero
        return transition
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }


}

extension CharacterListViewController: UINavigationControllerDelegate {
    func navigationController(
          _ navigationController: UINavigationController,
          animationControllerFor operation: UINavigationController.Operation,
          from fromVC: UIViewController,
          to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            return self.transition
        }

}

extension CharacterListViewController: CharacterListUIViewDelegate{

    func toggledFavourite(_ characterListUIView: CharacterListUIView?, character: inout CharacterModel) {
        dataSource.toggleFavourite(character: character)
        listView.renewFavouriteArray(favourites: dataSource.getFavouritesArray())
    }

    func askedForMoreCharacters(_ characterListUIView: CharacterListUIView, indexPath: IndexPath) {
        if askedForNewCharacters == false{
            if isFiltering {
                guard indexPath.row == listView.filteredArray.count - 1  else {
                    return
                }
                guard let searchText = searchController.searchBar.text else {
                    return
                }
                guard lessThanTwentyEntries == false else {
                    return
                }
                let index = listView.filteredArray.count
                listView.startLoading()
                dataSource.getFilteredCharacter(fromPosition: index, with: searchText, until: self.limit)
            } else {
                guard indexPath.row == listView.characterArray.count - 1  else {
                    return
                }
                if listView.characterArray.count < maxNumberOfCharacters ?? 1 {
                    let index = listView.characterArray.count
                    listView.startLoading()
                    dataSource.getCharacters(from: index, until: limit)
                }
            }
        }
    }

    func tapedOnACharacter(_ characterListUIView: CharacterListUIView, indexPath: IndexPath) {
        let detailsVC: DetailsViewController
        switch indexPath.section {
        case 0:
            detailsVC = vcFactory.createDetailVC(character: dataSource.getFavouritesArray()[indexPath.row])
        case 1:
            if isFiltering{
                detailsVC = vcFactory.createDetailVC(character: listView.filteredArray[indexPath.row])
                } else {
                    detailsVC = vcFactory.createDetailVC(character: listView.characterArray[indexPath.row])
                }
        default:
            return
        }
        detailsVC.transitioningDelegate = self
        //present(detailsVC, animated: true, completion: nil)
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}
