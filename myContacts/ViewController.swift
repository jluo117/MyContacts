//
//  ViewController.swift
//  myContacts
//
//  Created by james luo on 4/9/19.
//  Copyright © 2019 james luo. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI
class ViewController: UIViewController , UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate{
    @IBOutlet weak var DogImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var UISearch: UISearchBar!
    
    //Table cell function calls
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if Fail || (indexPath.row + 1).isMultiple(of: 3){
            let cell = tableView.dequeueReusableCell(withIdentifier: "Dog", for: indexPath)
            
            return cell
        }
        let cellIdentifier = "ContactCard"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ContactCard  else {
            fatalError("Error loading contact cards.")
        }
        cell.ContactInfo.text = self.ToLoadContacts[indexPath.row].Name + ": " + self.ToLoadContacts[indexPath.row].Number
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int ) -> Int{
        return ToLoadContacts.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Contacts Below"
    }
    //Search function calls
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == ""{
            searching = false
            ToLoadContacts = allContact
            offset = 0
            parseLoadData()
            self.tableView.reloadData()
            return
        }
        if searching{
            return
        }
        if  self.myContacts[searchBar.text!] == nil{
            ToLoadContacts = []
        }
        else{
            ToLoadContacts = self.myContacts[searchBar.text!]!
            searching = true
        }
        offset = 0
        parseLoadData()
        self.tableView.reloadData()
    }
    //Press Search to end editing
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }

    var myContacts: [String:[Contact]] = [:]
    var ToLoadContacts = [Contact]()
    var Fail = false
    var searching = false
    var allContact = [Contact]()
    var offset = 0 //to handle offset created by the every 3
    override func viewDidLoad() {
        DogImage.isHidden = true
        getContacts()
        parseLoadData()
        if Fail{
            tableView.isHidden = true
            DogImage.isHidden = false
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        super.viewDidLoad()
    }
   

    func getContacts(){
        let contactStore = CNContactStore()
        var contacts = [CNContact]()
        let keys = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactPhoneNumbersKey
            ] as [Any]
        let request = CNContactFetchRequest(keysToFetch: keys as! [CNKeyDescriptor])
        do {
            try contactStore.enumerateContacts(with: request){
                (contact, stop) in
                // Array containing all unified contacts from everywhere
                contacts.append(contact)
                for phoneNumber in contact.phoneNumbers {
                    
                    let number = phoneNumber.value
                   
                    
                        if contact.givenName == "" || number.stringValue == ""{
                            continue
                        }
                        
                        if self.myContacts[contact.givenName] == nil{
                            self.myContacts[contact.givenName] = [Contact(name: contact.givenName, lastName: contact.familyName, number: number.stringValue)]
                        }
                        else{
                            self.myContacts[contact.givenName]?.append(Contact(name: contact.givenName , lastName: contact.familyName, number: number.stringValue))
                        }
                        self.ToLoadContacts.append(Contact(name: contact.givenName, lastName: contact.familyName, number: number.stringValue))
//                        print("\(contact.givenName) \(number.stringValue)")
                    
                    
                }
            }
            
        } catch {
            Fail = true
            return
        }
        allContact = self.ToLoadContacts
    }
    
    
    func parseLoadData(){
        var newContactList = [Contact]()
        for contact in self.ToLoadContacts{
            newContactList.append(contact)
            if (newContactList.count + 1).isMultiple(of: 3){
                newContactList.append(contact)
            }
        }
        self.ToLoadContacts = newContactList
    }
}
