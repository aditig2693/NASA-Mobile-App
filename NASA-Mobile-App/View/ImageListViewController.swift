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
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName:"ImageListViewCell", bundle: nil), forCellReuseIdentifier:"ImageListViewCell")
        downloadData()
        setUpSearchController()
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
    }
    
    
    
    @objc private func downloadData(){
        isLoading = true
        viewModel.getNASAItems(endPoint: searchString ?? "", completion: { success, error in
            if success {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                self.isLoading = false
            } else if let error = error {
                self.isLoading = false
                print("Error fetching NASA items: \(error.localizedDescription)")
            }
        })
        
    }
    
    func setUpSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Image Name"
        searchController.searchBar.delegate = self
        searchController.definesPresentationContext = true
        
    }
}

extension ImageListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell:ImageListViewCell = tableView.dequeueReusableCell(withIdentifier: "ImageListViewCell", for: indexPath) as? ImageListViewCell {
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
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        // Load new data if user scrolled to bottom and not already loading
        if offsetY > contentHeight - scrollView.frame.height, !isLoading {
            downloadData()
        }
    }
}

extension ImageListViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.isSeachEnabled = true
        searchTimer?.invalidate()
        searchString = searchText
        searchTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(ImageListViewController.downloadData) , userInfo: nil, repeats: false)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.isSeachEnabled = false
        viewModel.currentPage = 1
        searchString = ""
        downloadData()
    }
}
