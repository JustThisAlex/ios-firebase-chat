//
//  RoomsTableViewController.swift
//  Firebase Chat
//
//  Created by Alexander Supe on 26.02.20.
//  Copyright © 2020 Alexander Supe. All rights reserved.
//

import UIKit

class RoomsTableViewController: UITableViewController {
    let contr = ChatController.shared
    var rooms: [Room] = [] { didSet { tableView.reloadData(); print("yes") } }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contr.fetchRooms { (rooms) in
            guard let rooms = rooms else { return }
            self.rooms = rooms
        }
        
    }
    @IBAction func addRoom(_ sender: Any) {
        contr.createRoom(messages: [], title: "Room \(rooms.count+1)")
        contr.fetchRooms { (rooms) in
            guard let rooms = rooms else { return }
            self.rooms = rooms
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = rooms[indexPath.row].title
        return cell
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailViewController {
            destination.room = rooms[tableView.indexPathForSelectedRow?.row ?? 0]
        }
    }

}
