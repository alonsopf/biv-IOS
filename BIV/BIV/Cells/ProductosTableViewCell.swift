//
//  ProductosTableViewCell.swift
//  BIV
//
//  Created by Fernando Alonso Pecina on 5/29/19.
//  Copyright © 2019 BIV. All rights reserved.
//

import UIKit
protocol ProductosTableViewCellelegate {
    func ponMEnsajito(_ mensaje:String)
    func recargaTablita()
}
class ProductosTableViewCell: UITableViewCell {
    var delegate:ProductosTableViewCellelegate?
    @IBOutlet var titulo: UILabel!
    @IBOutlet var requisitos: UILabel!
    @IBOutlet var boton: UIButton!
    @IBOutlet var imagen: UIImageView!
    public var puntos:String!
    public var puntosDisponibles: String!
    public var idProducto:String!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func adquirir() {
        self.boton.isEnabled = false
        let preferences = UserDefaults.standard
        let toks = preferences.string(forKey: "t") ?? ""
        let escapedString = toks.replacingOccurrences(of: "+", with: "%2B")
        
        var chismoso = String(format: "https://biv.mx/canjearPuntos_Movil?t=%@&puntos=%@",escapedString, self.puntos)
        if self.idProducto != "-1" {
            chismoso = String(format: "https://biv.mx/canjeaPuntosProducto_Movil?t=%@&idProducto=%@",escapedString, self.idProducto)
        }
        let entero = (self.puntos as NSString).intValue
        let enteroDisponibles = (self.puntosDisponibles as NSString).intValue
        if entero > enteroDisponibles {
            self.delegate?.ponMEnsajito("Necesitas más puntos para adquirir este producto")
            return
        }
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
                DispatchQueue.main.async {
                    if success == 1 {
                        self.delegate?.ponMEnsajito("Producto canjeado")
                    } else  {
                        self.boton.isEnabled = true
                       self.delegate?.ponMEnsajito("Error")
                    }
                    self.delegate?.recargaTablita()
                }
                
                
                
                
                
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
