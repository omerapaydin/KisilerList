//
//  KisiEkleViewController.swift
//  KisilerList
//
//  Created by Ömer on 29.04.2025.
//

import UIKit
import CoreData

class KisiEkleViewController: UIViewController {

    @IBOutlet weak var numLabel: UITextField!
    @IBOutlet weak var adLabel: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func ekle(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newAdd = NSEntityDescription.insertNewObject(forEntityName: "Entity", into: context)
        
        newAdd.setValue(adLabel.text, forKey: "kisi_ad")
        newAdd.setValue(numLabel.text, forKey: "kisi_num")
        
        
        NotificationCenter.default.post(name: NSNotification.Name("reload"), object: nil)
        self.navigationController?.popViewController(animated: true)
        
        
        
        do{
            try context.save()
        }catch {
            print("error")
        }
        
        
    }
    

}
