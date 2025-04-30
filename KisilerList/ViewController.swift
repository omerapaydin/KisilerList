//
//  ViewController.swift
//  KisilerList
//
//  Created by Ömer on 29.04.2025.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchView: UISearchBar!

    var kisiAdArray = [String]()
    var kisiNumArray = [String]()
    var aramaYapiliyorMu = false
    var aramaSonucuUlkeler = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self

        searchView.delegate = self

        getData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name(rawValue: "reload"), object: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetay" {
           
        }
        if segue.identifier == "toGuncelle" {
           
        }
    }



    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if aramaYapiliyorMu {
            return aramaSonucuUlkeler.count
        } else {
            return kisiAdArray.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "kisiCell", for: indexPath) as! KisiCellTableViewCell

        if aramaYapiliyorMu {
            cell.kisiLabel.text = aramaSonucuUlkeler[indexPath.row]
        } else {
            cell.kisiLabel.text = kisiAdArray[indexPath.row]
        }

        return cell
    }

   

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toDetay", sender: indexPath.row)
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        let silAction = UITableViewRowAction(style: .destructive, title: "Sil") { (action, indexPath) in
            print("Sil tıklandı \(self.kisiAdArray[indexPath.row])")
        }

        let guncelleAction = UITableViewRowAction(style: .normal, title: "Güncelle") { (action, indexPath) in
            print("Güncelle tıklandı \(self.kisiAdArray[indexPath.row])")
        }

        return [silAction, guncelleAction]
    }

  

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            aramaYapiliyorMu = false
        } else {
            aramaYapiliyorMu = true
            aramaSonucuUlkeler = kisiAdArray.filter { $0.lowercased().contains(searchText.lowercased()) }
        }

        tableView.reloadData()
    }

    

    @objc func getData() {
        kisiAdArray.removeAll(keepingCapacity: false)
        kisiNumArray.removeAll(keepingCapacity: false)

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        let data = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity")

        do {
            let results = try context.fetch(data)

            for result in results as! [NSManagedObject] {
                if let kisiAdi = result.value(forKey: "kisi_ad") as? String {
                    self.kisiAdArray.append(kisiAdi)
                }

                if let kisiNumarasi = result.value(forKey: "kisi_num") as? String {
                    self.kisiNumArray.append(kisiNumarasi)
                }
            }

            self.tableView.reloadData()

        } catch {
            print("Veri çekme hatası")
        }
    }
}
