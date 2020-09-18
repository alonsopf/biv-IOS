//
//  CuentaBar.swift
//  BIV
//
//  Created by Fernando Alonso Pecina on 5/20/19.
//  Copyright © 2019 BIV. All rights reserved.
//

import UIKit
protocol CuentaBarDelegate {
    func ponModal()
}
class CuentaBar: UIBarButtonItem {
    var delegate:CuentaBarDelegate?
    
    var sta:Status!
    
    
    
    override init() {
        super.init()
        
       /* sta = Status(frame: CGRect(x: 0.0, y: -20.0, width: 70.0, height: 30.0))
        super.customView = sta
        sta.sizeToFit()
        sta.layer.cornerRadius = 10.0
        */
        self.title = "" //"$0.00 Real"
        self.tintColor = .green
        //super.init(customView: sta)
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    public func empiezaARecibirUpdates() {
        let preferences = UserDefaults.standard
        let toks = preferences.string(forKey: "t") ?? ""
        //let tipoCuenta = preferences.integer(forKey: "tipoCuenta") ?? 1
        let escapedString = toks.replacingOccurrences(of: "+", with: "%2B")
        
        let chismoso = String(format: "https://biv.mx/openPositionList_Movil?t=%@",escapedString)
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
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])
                
                guard let jsonArray = jsonResponse as? [String: Any] else {
                    return
                }
                let success = jsonArray["success"] as! Int
                if success == 1 {
                    let openPositionList  = jsonArray["openPositionList"] as? [String: Any]
                    let disponible = openPositionList?["Disponible"] as! Double
                    let GanPer = openPositionList?["GanPer"] as! Double
                    preferences.set(GanPer, forKey: "ganPer")
                    preferences.set(disponible, forKey: "disponible")
                    var palabra = "Real"
                    let tipoCuenta = jsonArray["tipoCuenta"] as! Int
                    if tipoCuenta == 0 {
                        palabra = "Demo"
                    }
                    preferences.set(tipoCuenta , forKey: "tipoCuenta")
                    var AbiertasList = 0
                    guard let cuak = openPositionList?["AbiertasList"] as? [Dictionary<String,Any>] else {
                        AbiertasList = 0
                        preferences.set(AbiertasList, forKey: "posAbiertas")
                        preferences.synchronize()
                        DispatchQueue.main.async {
                            self.title = String(format: "$%.02f %@", disponible, palabra)
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {    self.empiezaARecibirUpdates()
                        }
                        return
                    }
                    
                    AbiertasList = cuak.count
                    preferences.set(AbiertasList, forKey: "posAbiertas")
                    preferences.synchronize()
                    DispatchQueue.main.async {
                        self.title = String(format: "$%.02f %@", disponible, palabra)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {    self.empiezaARecibirUpdates()
                    }
                    
                    
                }
                
                
                
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
    }
    @objc func ponAlert() {
         delegate?.ponModal()
      /*  let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let actionOk = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(actionOk)
        self.present(alert, animated: true, completion: nil)*/
    }
    func commonInit() {
        self.action = #selector(ponAlert)
        
        //sta = Status(frame: CGRect(x: 0.0, y: 0.0, width: 100.0, height: 39.0))
        //super.customView = sta
    }
}
