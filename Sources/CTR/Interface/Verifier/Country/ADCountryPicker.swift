//
/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import Foundation
import UIKit
import SnapKit

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

class ADCountryPicker: UIViewController {
    
    let remoteConfigManager = Services.remoteConfigManager
    
    let businessRulesManager = Services.businessRulesManager
    
    var filteredList = [CountryRisk]()
    
    var sections = [Section]()
    
    weak var delegate: ADCountryPickerDelegate?
    
    /// Closure which returns country name and ISO code
    var didSelectCountryClosure: ((CountryRisk) -> Void)?
    
    /// The nav bar title to show on picker view
    var pickerTitle = "Select a Country"
    
    /// The default current location, if region cannot be determined. Defaults to US
    var defaultCountryCode = "US"
    
    // The tint color of the close icon in presented pickers. Defaults to black
    var closeButtonTintColor = UIColor.black
    
    /// The font of the country name list
    var font = Theme.fonts.subhead
    
    /// Flag to indicate if the navigation bar should be hidden when search becomes active. Defaults to true
    var hidesNavigationBarWhenPresentingSearch = true
    
    /// The background color of the searchbar. Defaults to lightGray
    var searchBarBackgroundColor = UIColor.lightGray
    
    var selectingMode: SelectingCountryMode = .departure
    
    var tableView: UITableView = {
        let view = UITableView()
        view.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        view.backgroundColor = Theme.colors.viewControllerBackground
        view.separatorColor = Theme.colors.separatorGray.withAlphaComponent(0.3)
        return view
    }()
    
    var searchBar: UISearchBar = {
        let view = UISearchBar()
        view.autocapitalizationType = .sentences
        view.placeholder = "accessibility_search".localized()
        view.accessibilityLabel = "accessibility_search".localized()
        return view
    }()
    
    convenience init(completionHandler: @escaping ((CountryRisk) -> Void)) {
        self.init()
        self.didSelectCountryClosure = completionHandler
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = pickerTitle
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        createLayout()
        updateSections()

        view.backgroundColor = Theme.colors.viewControllerBackground
        tableView.reloadData()
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
    
    private func createLayout() {
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints { it in
            it.leading.trailing.top.equalToSuperview()
        }
        view.addSubview(tableView)
        tableView.snp.makeConstraints { it in
            it.leading.trailing.bottom.equalToSuperview()
            it.top.equalTo(searchBar.snp.bottom)
        }
    }
    
    private func updateSections() {
        // create empty sections
        var sections = [Section]()

        var countries = remoteConfigManager.getConfiguration().countryColors?.filter({ it in
            if it.isColourCode == true {
                return false
            }
            if selectingMode == .destination && !businessRulesManager.getAllRules().contains(where: { rule in
                if let code = it.code {
                    return code.lowercased().starts(with: rule.countryCode.lowercased())
                } else {
                    return false
                }
            }) {
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
    
    private func filter(_ searchText: String) -> [CountryRisk] {
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
    
    private func getCountry(_ code: String) -> [CountryRisk] {
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
    
    /// Returns the country name for the given country code
    ///
    /// - Parameter countryCode: ISO code of country to get dialing code for
    /// - Returns: the country name for given country code if it exists
    public func getCountryName(countryCode: String) -> String? {
        return self.getCountry(countryCode).first?.name()
    }
    
    static func countryForCode(code: String) -> CountryRisk? {
        var countries = Services.remoteConfigManager.getConfiguration().countryColors ?? []
        countries.append(CountryRisk.other)
        countries.append(CountryRisk.unselected)
        return countries.first(where: { it in
            it.code == code
        })
    }
}

// MARK: - Table view data source
extension ADCountryPicker: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if searchBar.text?.isEmpty == false {
            return 1
        }
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !searchBar.text!.isEmpty {
            return filteredList.count
        }
        return sections[section].countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var tempCell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")
        
        if tempCell == nil {
            tempCell = UITableViewCell(style: .default, reuseIdentifier: "UITableViewCell")
        }
        
        let cell: UITableViewCell! = tempCell
        
        var country: CountryRisk?
        if searchBar.text?.isEmpty == false {
            country = filteredList[(indexPath as NSIndexPath).row]
        } else {
            country = sections[(indexPath as NSIndexPath).section].countries[(indexPath as NSIndexPath).row]
            
        }
        
        cell.textLabel?.font = self.font
        cell.textLabel?.text = (country?.name() ?? "")
        cell.textLabel?.accessibilityTraits = .button
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if !sections[section].countries.isEmpty {
            if searchBar.text?.isEmpty == false {
                return nil
            }
            return sections[section].code
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let country: CountryRisk!
        if searchBar.text?.isEmpty == false {
            country = filteredList[(indexPath as NSIndexPath).row]
        } else {
            country = sections[(indexPath as NSIndexPath).section].countries[(indexPath as NSIndexPath).row]
        }
        delegate?.countryPicker(self, didSelect: country)
        didSelectCountryClosure?(country)
    }
    
    func update() {
        self.updateSections()
        self.tableView.reloadData()
    }
    
}

// MARK: - UISearchDisplayDelegate
extension ADCountryPicker: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        _ = filter(searchBar.text ?? "")
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        AccessibilityUtility.requestFocus(to: searchBar)
    }
}

extension ADCountryPicker: RemoteConfigManagerDelegate {
    func configWasUpdated() {
        OperationQueue.main.addOperation {
            self.update()
        }
    }
}
