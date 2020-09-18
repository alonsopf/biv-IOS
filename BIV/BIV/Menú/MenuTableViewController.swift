//
//  BIV
//
//  Created by Fernando Alonso Pecina on 4/2/19.
//  Copyright © 2019 BIV. All rights reserved.
//

import UIKit
protocol MenuTableViewControllerDelegate {
    
    func ponCatalogo(_ sender:String)
    
}

class MenuTableViewController: UITableViewController {
    var arrayMenuOptions = [Dictionary<String,String>]()
    var delegate:MenuTableViewControllerDelegate?
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.barStyle = .black
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let preferences = UserDefaults.standard
        preferences.set("0", forKey: "deboPonerAlgo")
        preferences.synchronize()
        
        self.tableView.register(InsTableViewCell.self, forCellReuseIdentifier: "cellMenu")
        self.tableView.register(UINib(nibName: "MenuTableViewCell", bundle: nil), forCellReuseIdentifier: "cellMenu")
        
        
        arrayMenuOptions.append(["title":"Perfil", "icon":"perfil.png"])
        arrayMenuOptions.append(["title":"Portafolio", "icon":"portafolio.png"])
        arrayMenuOptions.append(["title":"Favoritos", "icon":"fav.png"])
        arrayMenuOptions.append(["title":"Criptomonedas", "icon":"bit.png"])
        
        arrayMenuOptions.append(["title":"Divisas", "icon":"divisas.png"])
        arrayMenuOptions.append(["title":"Índices", "icon":"indice.png"])
        arrayMenuOptions.append(["title":"Petróleo y Gas", "icon":"petroleo.png"])
        arrayMenuOptions.append(["title":"Metales", "icon":"metales.png"])
        arrayMenuOptions.append(["title":"Bonos", "icon":"acciones.png"])
        arrayMenuOptions.append(["title":"Agricultura", "icon":"agricultura.png"])
        //arrayMenuOptions.append(["title":"ETFs", "icon":"etf.png"])
        arrayMenuOptions.append(["title":"Depositar", "icon":"depositar.png"])
        arrayMenuOptions.append(["title":"Retirar", "icon":"retirar.png"])
        arrayMenuOptions.append(["title":"Canjear Puntos", "icon":"puntos.png"])
        arrayMenuOptions.append(["title":"Preguntas Frecuentas", "icon":"faq.png"])
        arrayMenuOptions.append(["title":"Historial", "icon":"history.png"])
        arrayMenuOptions.append(["title":"Cerrar Sesión", "icon":"salir"])
        
        self.tableView.separatorStyle = .none
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let preferences = UserDefaults.standard
        if indexPath.row == 0 {//perfil
            preferences.set("-3", forKey: "deboPonerAlgo")
        }
        if indexPath.row == 1 {//portafolio
            preferences.set("-2", forKey: "deboPonerAlgo")
        }
        if indexPath.row == 2 {//favoritos
            preferences.set("-1", forKey: "deboPonerAlgo")
        }
            
        
        
        if indexPath.row == 3 {
            preferences.set("1", forKey: "deboPonerAlgo")
            delegate?.ponCatalogo("crypto")
        }
        if indexPath.row == 4 {//DIVISAS
            preferences.set("2", forKey: "deboPonerAlgo")
        }
        if indexPath.row == 5 {//INDICES
            preferences.set("3", forKey: "deboPonerAlgo")
        }
        if indexPath.row == 6 {//PETROLEO Y GAS
            preferences.set("4", forKey: "deboPonerAlgo")
        }
        if indexPath.row == 7 {//METALES
            preferences.set("5", forKey: "deboPonerAlgo")
        }
        if indexPath.row == 8 {//BONOS
            preferences.set("6", forKey: "deboPonerAlgo")
        }
        if indexPath.row == 9 {//AGRICULTURA
            preferences.set("7", forKey: "deboPonerAlgo")
        }
        if indexPath.row == 10 {//depositar
            preferences.set("8", forKey: "deboPonerAlgo")
        }
        if indexPath.row == 11 {//retirar
            preferences.set("9", forKey: "deboPonerAlgo")
        }
        if indexPath.row == 12 {//canjear puntos
            preferences.set("10", forKey: "deboPonerAlgo")
        }
        if indexPath.row == 13 {//preguntas frecuentes
            preferences.set("11", forKey: "deboPonerAlgo")
        }
        if indexPath.row == 14 {//historial de posiciones
            preferences.set("12", forKey: "deboPonerAlgo")
        }
        if indexPath.row == 15 {//cerrar sesion
            preferences.set("13", forKey: "deboPonerAlgo")
        }
        preferences.synchronize()
        dismiss(animated: true, completion: nil)
        //   print("Value: \(myArray[indexPath.section])")
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMenuOptions.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellMenu", for: indexPath as IndexPath) as! MenuTableViewCell
        
       
        cell.titulo.text = arrayMenuOptions[indexPath.row]["title"]!
        cell.imagen.image = UIImage(named: arrayMenuOptions[indexPath.row]["icon"]!)
        
        
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
