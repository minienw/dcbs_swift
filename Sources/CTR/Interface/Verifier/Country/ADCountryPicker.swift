//
/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import Foundation
import UIKit

class Section {
    var countries: [CountryRisk] = []
    var code: String
    
    init(code: String) {
        self.code = code
        self.countries = []
    }
    
    func addCountry(_ country: CountryRisk) {
        countries.append(country)
    }
}

protocol ADCountryPickerDelegate: AnyObject {
    func countryPicker(_ picker: ADCountryPicker, didSelect: CountryRisk)
}

class ADCountryPicker: UITableViewController {
    
    let remoteConfigManager = Services.remoteConfigManager
    
    var searchController: UISearchController!
    var filteredList = [CountryRisk]()
    
    var sections = [Section]()
    
    weak var delegate: ADCountryPickerDelegate?
    
    /// Closure which returns country name and ISO code
    var didSelectCountryClosure: ((CountryRisk) -> Void)?
    
    /// The nav bar title to show on picker view
    open var pickerTitle = "Select a Country"
    
    /// The default current location, if region cannot be determined. Defaults to US
    open var defaultCountryCode = "US"
    
    // The tint color of the close icon in presented pickers. Defaults to black
    open var closeButtonTintColor = UIColor.black
    
    /// The font of the country name list
    open var font = Theme.fonts.subhead
    
    /// Flag to indicate if the navigation bar should be hidden when search becomes active. Defaults to true
    open var hidesNavigationBarWhenPresentingSearch = true
    
    /// The background color of the searchbar. Defaults to lightGray
    open var searchBarBackgroundColor = UIColor.lightGray
    
    var selectingMode: SelectingCountryMode = .departure
    
    convenience init(completionHandler: @escaping ((CountryRisk) -> Void)) {
        self.init()
        self.didSelectCountryClosure = completionHandler
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = pickerTitle
        updateSections()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        createSearchBar()
        tableView.reloadData()
        
        definesPresentationContext = true
        
        if self.presentingViewController != nil {
            
            let bundle = "assets.bundle/"
            let closeButton = UIBarButtonItem(image: UIImage(named: bundle + "close_icon" + ".png",
                                                             in: Bundle(for: ADCountryPicker.self),
                                                             compatibleWith: nil),
                                              style: .plain,
                                              target: self,
                                              action: #selector(self.dismissView))
            closeButton.tintColor = closeButtonTintColor
            self.navigationItem.leftBarButtonItem = nil
            self.navigationItem.leftBarButtonItem = closeButton
        }
        view.backgroundColor = Theme.colors.viewControllerBackground
        tableView.backgroundColor = Theme.colors.viewControllerBackground
        tableView.separatorColor = Theme.colors.separatorGray.withAlphaComponent(0.3)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if selectingMode == .destination {
            remoteConfigManager.setDelegate(delegate: self)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if selectingMode == .destination {
            remoteConfigManager.setDelegate(delegate: nil)
        }
    }
    
    static func countryForCode(code: String) -> CountryRisk? {
        var countries = Services.remoteConfigManager.getConfiguration().countryColors ?? []
        countries.append(CountryRisk.other)
        countries.append(CountryRisk.unselected)
        return countries.first(where: { it in
            it.code == code
        })
    }
    
    func updateSections() {
        // create empty sections
        var sections = [Section]()

        var countries = remoteConfigManager.getConfiguration().countryColors?.filter({ it in
            if it.isColourCode == true {
                return false
            }
            if selectingMode == .destination && it.code != "NL" {
                return false
            }
            return true
        }) ?? []
        if selectingMode == .destination {
            countries.append(.other)
        }
        
        // put each country in a section
        for country in countries {
            if let code = country.section() {
                var section = sections.first { it in
                    it.code == code
                }
                if section == nil {
                    section = Section(code: code)
                    sections.append(section!)
                }
                section?.addCountry(country)
            }
        }
        sections = sections.sorted(by: { it1, it2 in
            it1.code < it2.code
        })
        // sort each section
        for section in sections {
            section.countries = section.countries.sorted(by: { it1, it2 in
                it1.name() ?? "" < it2.name() ?? ""
            })
        }
        
        self.sections = sections
    }
    
    @objc private func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func createSearchBar() {
        if self.tableView.tableHeaderView == nil {
            searchController = UISearchController(searchResultsController: nil)
            searchController.searchResultsUpdater = self
            searchController.hidesNavigationBarDuringPresentation = false
            searchController.searchBar.searchBarStyle = .prominent
            searchController.searchBar.showsCancelButton = false
            searchController.obscuresBackgroundDuringPresentation = false
            
            tableView.tableHeaderView = searchController.searchBar
        }
    }
    
    fileprivate func filter(_ searchText: String) -> [CountryRisk] {
        filteredList.removeAll()
        
        sections.forEach { section -> Void in
            section.countries.forEach({ country -> Void in
                if country.name()?.count ?? 0 >= searchText.count {
                    let result = (country.name() ?? "").compare(searchText, options: [.caseInsensitive, .diacriticInsensitive], range: searchText.startIndex ..< searchText.endIndex)
                    if result == .orderedSame {
                        filteredList.append(country)
                    }
                }
            })
        }
        
        return filteredList
    }
    
    fileprivate func getCountry(_ code: String) -> [CountryRisk] {
        filteredList.removeAll()
        
        sections.forEach { section -> Void in
            section.countries.forEach({ country -> Void in
                if country.code?.count ?? 0 >= code.count {
                    let result = (country.code ?? "").compare(code, options: [.caseInsensitive, .diacriticInsensitive],
                                                      range: code.startIndex ..< code.endIndex)
                    if result == .orderedSame {
                        filteredList.append(country)
                    }
                }
            })
        }
        
        return filteredList
    }
    
    // MARK: - Public method
    
    /// Returns the country name for the given country code
    ///
    /// - Parameter countryCode: ISO code of country to get dialing code for
    /// - Returns: the country name for given country code if it exists
    public func getCountryName(countryCode: String) -> String? {
        return self.getCountry(countryCode).first?.name()
    }
}

// MARK: - Table view data source
extension ADCountryPicker {
    
    override open func numberOfSections(in tableView: UITableView) -> Int {
        if !searchController.searchBar.text!.isEmpty {
            return 1
        }
        return sections.count
    }
    
    open override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52.0
    }
    
    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !searchController.searchBar.text!.isEmpty {
            return filteredList.count
        }
        return sections[section].countries.count
    }
    
    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var tempCell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")
        
        if tempCell == nil {
            tempCell = UITableViewCell(style: .default, reuseIdentifier: "UITableViewCell")
        }
        
        let cell: UITableViewCell! = tempCell
        
        let country: CountryRisk!
        if !searchController.searchBar.text!.isEmpty {
            country = filteredList[(indexPath as NSIndexPath).row]
        } else {
            country = sections[(indexPath as NSIndexPath).section].countries[(indexPath as NSIndexPath).row]
            
        }
        
        cell.textLabel?.font = self.font
        
        cell.textLabel?.text = (country.name() ?? "")
        
        return cell
    }
    
    override open func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if !sections[section].countries.isEmpty {
            if !searchController.searchBar.text!.isEmpty {
                if let section = filteredList.first?.section() {
                    return section
                }
                
                return ""
            }
            
            return sections[section].code
        }
        
        return ""
    }
    
    override open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
    func update() {
        self.updateSections()
        self.tableView.reloadData()
    }
    
}

// MARK: - Table view delegate
extension ADCountryPicker {
    
    override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let country: CountryRisk!
        if !searchController.searchBar.text!.isEmpty {
            country = filteredList[(indexPath as NSIndexPath).row]
        } else {
            country = sections[(indexPath as NSIndexPath).section].countries[(indexPath as NSIndexPath).row]
        }
        delegate?.countryPicker(self, didSelect: country)
        didSelectCountryClosure?(country)
    }
}

// MARK: - UISearchDisplayDelegate
extension ADCountryPicker: UISearchResultsUpdating {
    
    public func updateSearchResults(for searchController: UISearchController) {
        _ = filter(searchController.searchBar.text!)
        
        if self.hidesNavigationBarWhenPresentingSearch == false {
            searchController.searchBar.showsCancelButton = false
        }
        tableView.reloadData()
    }
}

extension ADCountryPicker: RemoteConfigManagerDelegate {
    func configWasUpdated() {
        OperationQueue.main.addOperation {
            self.update()
        }
    }
}
