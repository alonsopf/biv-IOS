//
//  HistorialDepositosTableViewCell.swift
//  BIV
//
//  Created by Fernando Alonso Pecina on 5/9/19.
//  Copyright © 2019 BIV. All rights reserved.
//

import UIKit
protocol HistorialDepositosTableViewCellDelegate {
    func muestraAlert(_ sender:String)
}
class HistorialDepositosTableViewCell: UITableViewCell {
    @IBOutlet var fecha: UILabel!
    @IBOutlet var valor: UILabel!
    @IBOutlet var icono: UIImageView!
    @IBOutlet var boton: UIButton!
    public var UUID:String!
    public var match1:String!
    public var ide:String!
    public var tipo:String!
    var delegate:HistorialDepositosTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        UUID = ""
        match1 = ""
        ide = ""
        tipo = ""
        // Initialization code
    }
    @IBAction func facturaOMuestraUUID () {
        if UUID.count > 10 {
            let u = String(format: "https://biv.mx/static/facturas/%@.pdf", UUID)
            guard let url = URL(string: u) else { return }
            UIApplication.shared.open(url)
        } else {
            self.boton.isEnabled = false
            let preferences = UserDefaults.standard
            let toks = preferences.string(forKey: "t") ?? ""
            let escapedString = toks.replacingOccurrences(of: "+", with: "%2B")
            
            let chismoso = String(format: "https://biv.mx/facturarMovil?t=%@&match=%@&ide=%@&tipo=%@",escapedString, match1,ide,tipo)
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
                    let ver = String(decoding: dataResponse, as: UTF8.self)
                    print(ver)
                    let jsonResponse = try JSONSerialization.jsonObject(with:
                        dataResponse, options: [])
                    
                    guard let jsonArray = jsonResponse as? [String: Any] else {
                        return
                    }
                    let success = jsonArray["success"] as! Int
                    if success == -15 {
                        self.delegate?.muestraAlert("Por favor, primero confirma tu correo electrónico, puedes confirmar tu correo desde la página web: https://biv.mx/")
                    } else if success == 1 {
                        let pdf = jsonArray["pdf"] as! String
                        let u = String(format: "https://biv.mx/%@", pdf)
                        guard let url = URL(string: u) else { return }
                        DispatchQueue.main.async {
                            UIApplication.shared.open(url)
                        }
                    } else  if success == -11 {
                        self.delegate?.muestraAlert("El depósito supero los 30 días naturales disponibles para facturación")
                    } else {
                        self.delegate?.muestraAlert("Hubo un error inesperado, favr de contactar a soporte@biv.mx")
                    }
                    
                   
                    
                   
                    
                    
                    
                } catch let parsingError {
                    print("Error", parsingError)
                }
            }
            task.resume()
            
            
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
