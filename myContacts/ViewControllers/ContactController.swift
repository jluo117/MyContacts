//
//  ContactController.swift
//  myContacts
//
//  Created by james luo on 4/9/19.
//  Copyright © 2019 james luo. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI
class ContactController: UITableViewController {
    var myContacts: [String:[Contact]] = [:]
    var ToLoadContacts = [Contact]()
    var Fail = false
    override func viewDidLoad() {
        getContacts()
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Contacts below"
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.Fail{
            return 1
        }
        // #warning Incomplete implementation, return the number of rows
        return self.ToLoadContacts.count
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
                    
                    if let number = phoneNumber.value as? CNPhoneNumber, let label = phoneNumber.label {
                        _ = CNLabeledValue<CNPhoneNumber>.localizedString(forLabel: label)
                        if contact.givenName == ""{
                            continue
                        }
                        self.myContacts[contact.givenName]?.append(Contact(name: contact.givenName , lastName: contact.familyName, number: number.stringValue))
                        self.ToLoadContacts.append(Contact(name: contact.givenName, lastName: contact.familyName, number: number.stringValue))
                        print("\(contact.givenName) \(number.stringValue)")
                    }
                    else{
                        print("no number")
                    }
                }
            }
            
        } catch {
            Fail = true
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
