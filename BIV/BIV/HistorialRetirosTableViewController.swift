//
//  HistorialRetirosTableViewController.swift
//  BIV
//
//  Created by Fernando Alonso Pecina on 5/13/19.
//  Copyright © 2019 BIV. All rights reserved.
//

import UIKit

class HistorialRetirosTableViewController: UITableViewController {
    @IBAction func close () {
        self.dismiss(animated: true, completion: nil)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96.0
    }
    private var fechaArray: NSMutableArray = []
    private var valorArray: NSMutableArray = []
    private var facturaArray: NSMutableArray = []
    private var tipoArray: NSMutableArray = []
    private var idArray: NSMutableArray = []
    private var MatchFacturacionArray: NSMutableArray = []
    private var statusArray: NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        self.title = "Historial de retiros"
        self.tableView.register(HistorialDepositosTableViewCell.self, forCellReuseIdentifier: "historialDepositos")
        self.tableView.register(UINib(nibName: "HistorialDepositosTableViewCell", bundle: nil), forCellReuseIdentifier: "historialDepositos")
        fechaArray = NSMutableArray()
        MatchFacturacionArray = NSMutableArray()
        idArray = NSMutableArray()
        valorArray = NSMutableArray()
        facturaArray = NSMutableArray()
        tipoArray = NSMutableArray()
        statusArray = NSMutableArray()
        let preferences = UserDefaults.standard
        let toks = preferences.string(forKey: "t") ?? ""
        let escapedString = toks.replacingOccurrences(of: "+", with: "%2B")
        
        let chismoso = String(format: "https://biv.mx/historialDeRetirosMovil?t=%@",escapedString)
        guard let url = URL(string: chismoso) else {return}
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        
        let session = URLSession.init(configuration: config)
        
        let task = session.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do{
                // let ver = String(decoding: dataResponse, as: UTF8.self)
                // print(ver)
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])
                guard let jsonArray = jsonResponse as? [[String: Any]] else {
                    return
                }
                
                for ins in jsonArray {
                    let AMOUNT = ins["AMOUNT"] as! String
                    let UnixEntrada = ins["TimeEntrada"] as! String
                    let Tipo = ins["Tipo"] as! String
                    let UUID = ins["Status"] as! String
                    let IDe = ins["ID"] as! String
                    let Status = ins["Status"] as! String
                    let MatchFacturacion = ins["MatchFacturacion"] as! String
                    self.fechaArray.add(UnixEntrada)
                    self.idArray.add(IDe)
                    self.MatchFacturacionArray.add(MatchFacturacion)
                    self.valorArray.add(AMOUNT)
                    self.facturaArray.add(UUID)
                    self.tipoArray.add(Tipo)
                    self.statusArray.add(Status)
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
                
                
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fechaArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historialDepositos", for: indexPath as IndexPath) as! HistorialDepositosTableViewCell
        var palabra = " - Pagada";
        if("\(statusArray[indexPath.row])"=="0")
        {
            palabra = " - En proceso";
        }
        cell.valor.text = "$"+"\(valorArray[indexPath.row])"+palabra
        cell.fecha.text = "\(fechaArray[indexPath.row])"
        let tipo = "\(tipoArray[indexPath.row])"
        if tipo != "SPEI" {
            //cell.icono.image = UIImage.init(named: "applePay.png")
        }
        cell.boton.isHidden = true
        /*let UUID = "\(facturaArray[indexPath.row])"
        if UUID == "0" {
            cell.UUID = UUID
            cell.boton.setTitle("   Ver factura   ", for: .normal)
        } else {
            let match1 = "\(MatchFacturacionArray[indexPath.row])"
            cell.match1 = match1
            let ide = "\(idArray[indexPath.row])"
            cell.ide = ide
            cell.tipo = tipo
        }
        */
        return cell
    }
}
