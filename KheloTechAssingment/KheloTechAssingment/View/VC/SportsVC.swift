//
//  SportsVC.swift
//  KheloIndiaAssingment
//
//  Created by Abhinav on 25/10/24.
//
import UIKit

class SportsVC: UIViewController {
    
    @IBOutlet weak var sportsTableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    private var filterView:FilterView!
    
    @IBOutlet weak var btnFilter: UIButton!
    private let networkManager = NetworkHandler()
    private let dbManager = DatabaseManager()
    private var viewModel: SportsListViewModel?
    private var sportsList = [Datum]()
    private var filteredData = [Datum]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearchController()
        fetchSportsList()
    }
    
    private func setupSearchController() {
        setConstrainstainsts()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Enter Sports Name"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.delegate = self
        searchController.searchBar.layoutMargins = UIEdgeInsets.zero
        
        //        sportsTableView.tableHeaderView = searchController.searchBar
        
    }
    
    private func setupFilterView() {
        filterView = FilterView()
        view.addSubview(filterView)
        filterView.frame = view.bounds
        
    }
    
    private func setConstrainstainsts(){
        headerView.addSubview(searchController.searchBar)
        /*
         searchController.searchBar.translatesAutoresizingMaskIntoConstraints = false
         //        searchController.searchBar.frame = headerView.bounds
         searchController.searchBar.topAnchor.constraint(equalTo: headerView.topAnchor).isActive = true
         searchController.searchBar.leadingAnchor.constraint(equalTo: headerView.leadingAnchor).isActive = true
         searchController.searchBar.trailingAnchor.constraint(equalTo: headerView.trailingAnchor).isActive = true
         searchController.searchBar.heightAnchor.constraint(equalTo: headerView.heightAnchor).isActive = true
         */
        searchController.searchBar.frame = CGRect(x: 0, y: 0, width: headerView.bounds.size.width, height: headerView.bounds.size.height)
    }
    
    private func setupTableView(){
        sportsTableView.delegate = self
        sportsTableView.dataSource = self
        
        let cellNib = UINib(nibName: "SportsTableListCell", bundle: nil)
        sportsTableView.register(cellNib, forCellReuseIdentifier: "SportsTableListCell")
        sportsTableView.separatorStyle = .none
        sportsTableView.backgroundColor = .systemGray6
        
    }
    
    private func fetchSportsList() {
        viewModel = SportsListViewModel(networkManager: networkManager, dbManager: dbManager)
        let backgroundQueue = DispatchQueue(label: "com.KheloTech.sportsListThread", attributes: .concurrent)
        
        backgroundQueue.async { [weak self] in
            self?.viewModel?.getSportsList(completion: { [weak self] data in
                guard let self = self, let sportsList = data else {
                    //error
                    return
                }
                self.updateSportsList(with: sportsList)
            })
        }
    }
    
    private func updateSportsList(with data: [Datum]) {
        sportsList = data
        filteredData = sportsList
        print(filteredData.count)
        DispatchQueue.main.async { [weak self] in
            self?.sportsTableView.reloadData()
        }
    }
    
    private func deleteSpecificUser(data: Datum, completion: @escaping (Bool) -> Void) {
        viewModel?.deleteSpecificUser(sport: data) { [weak self] updatedData in
            guard let self = self, let updatedSportsList = updatedData else {
                completion(false)
                return
            }
            
            self.sportsList = updatedSportsList
            self.filteredData = updatedSportsList
            completion(true)
        }
    }
    
    private func filterdData(text:String){
        filteredData.removeAll()
        for i in sportsList {
            if let name = i.sportName {
                if name.lowercased().contains(text) {
                    filteredData.append(i)
                }
            }
        }
        sportsTableView.reloadData()
    }
    
    private func getSortedNameList(){
        viewModel?.getDataBySortedNames(completion: { [weak self] data in
            guard let sortedList = data else {
                return
            }
            self?.updateSportsList(with: sortedList)
        })
    }
    
    private func getSortedIDList(){
        viewModel?.getDataBysortedID(completion: { [weak self] data in
            guard let sortedList = data else {
                return
            }
            self?.updateSportsList(with: sortedList)
        })
    }
    
    
    @IBAction func filterAction(_ sender: Any) {
        
        let alert = UIAlertController(title: "Choose Filter", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Filer By Name", style: .default, handler: { [weak self] _ in
            
            self?.getSortedNameList()
        }))
        
        alert.addAction(UIAlertAction(title: "Filer By ID", style: .default, handler: { [weak self] _ in
            
            self?.getSortedIDList()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = btnFilter
            popoverController.sourceRect = btnFilter.bounds
        }
        
        present(alert, animated: true, completion: nil)
    }
}


extension SportsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SportsTableListCell", for: indexPath) as! SportsTableListCell
        cell.lbl1.text = "Sports Name : " + (filteredData[indexPath.row].sportName ?? "")
        cell.lbl2.text = "Sports ID : " + String(describing: filteredData[indexPath.row].sportID ?? 0)
        cell.lbl3.text = "NSRS ID : " + String(describing:filteredData[indexPath.row].nsrsSportID ?? 0)
        cell.lbl4.text = "Status : " + String(describing:filteredData[indexPath.row].status ?? "inactive")
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let sportToDelete = sportsList[indexPath.row]
            deleteSpecificUser(data: sportToDelete) { [weak self] success in
                if success {
                    DispatchQueue.main.async {
                        self?.sportsTableView.deleteRows(at: [indexPath], with: .automatic)
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.size.height * 0.17
    }
}

extension SportsVC: UISearchResultsUpdating,UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard var searchText = searchController.searchBar.text, !searchText.isEmpty else {
            filteredData = sportsList
            sportsTableView.reloadData()
            return
        }
        searchText = searchText.lowercased()
        print(searchText)
        filterdData(text: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchController.searchBar.frame = CGRect(x: 0, y: 0, width: self.headerView.bounds.width * 0.80, height: self.headerView.bounds.height)
    }
}
