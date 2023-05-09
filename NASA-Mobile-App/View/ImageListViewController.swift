//
//  ImageListViewController.swift
//  NASA-Mobile-App
//
//  Created by Aditi Patil on 07/05/2023.
//

import UIKit
import Alamofire

class ImageListViewController: UITableViewController {
    
    let viewModel = ImageViewModel()
    var searchController = UISearchController(searchResultsController: nil)
    var searchTimer: Timer? = nil
    var searchString: String? = ""
    var isLoading = false
    var emptyView = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName:AppConstants.imageListViewCell, bundle: nil), forCellReuseIdentifier:AppConstants.imageListViewCell)
        setupEmptyView()
        setUpSearchController()
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        downloadData()
    }
    
    
    
    @objc private func downloadData(){
        isLoading = true
        viewModel.getNASAItems(searchString: searchString ?? "", completion: { response in
            switch response {
            case .success:
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                self.isLoading = false
            case .failure(error: let error):
                self.isLoading = false
                print("Error fetching NASA items: \(error.localizedDescription)")
            }
        })
        
    }
    
    func setUpSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = AppConstants.searchBarPlaceHolder
        searchController.searchBar.delegate = self
        searchController.definesPresentationContext = true
        
    }
    
    func setupEmptyView() {
        let messageLabel = UILabel()
        messageLabel.text = AppConstants.emptyViewMessage
        messageLabel.textAlignment = .center
        self.emptyView.addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        // Set the label's center anchor to be equal to the view's center anchor
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: self.emptyView.centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: self.emptyView.centerYAnchor)
        ])
        
        // Set constraints for the label's leading and trailing anchors
        NSLayoutConstraint.activate([
            messageLabel.leadingAnchor.constraint(greaterThanOrEqualTo: self.emptyView.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.emptyView.trailingAnchor, constant: -20)
        ])
        self.tableView.backgroundView = self.emptyView
    }
    
}

extension ImageListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell:ImageListViewCell = tableView.dequeueReusableCell(withIdentifier: AppConstants.imageListViewCell, for: indexPath) as? ImageListViewCell {
            let item = viewModel.items[indexPath.row]
            cell.configure(item: item)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: AppConstants.showImageDetailsSegue, sender: viewModel.items[indexPath.row])
    }
    
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        // Load new data if user scrolled to bottom and not already loading
        if offsetY > contentHeight - scrollView.frame.height, !isLoading {
            viewModel.currentPage += 1
            downloadData()
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == AppConstants.showImageDetailsSegue {
            if let detailViewController = segue.destination as? ImageDetailViewController {
                guard let data = sender as? NASAItem else {
                    return
                }
                detailViewController.imageDetailItem = data
            }
        }
        
    }
    
    
}

extension ImageListViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchString = searchText
        resetData()
    }
    
    func resetData() {
        viewModel.items.removeAll()
        viewModel.currentPage = 1
        searchTimer?.invalidate()
        searchTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(ImageListViewController.downloadData) , userInfo: nil, repeats: false)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.currentPage = 1
        searchString = ""
        downloadData()
    }
}
