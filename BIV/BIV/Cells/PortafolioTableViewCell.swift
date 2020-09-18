//
//  PortafolioTableViewCell.swift
//  BIV
//
//  Created by Fernando Alonso Pecina on 5/28/19.
//  Copyright © 2019 BIV. All rights reserved.
//

import UIKit
protocol PortafolioTableViewCellDelegate {
    func mensajeErrorPortafolio(_ mensaje:String)
    func mensajeSuccessPortafolio(_ mensaje:String)
}

class PortafolioTableViewCell: UITableViewCell {
    var delegate:PortafolioTableViewCellDelegate?
    
    @IBOutlet var valor: UILabel!
    @IBOutlet var titulo: UILabel!
    @IBOutlet var boton: UIButton!
    public var carlosRocha: String!
    public var ins: String!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func cerrarPos() {
        
        self.boton.isEnabled = false
        let preferences = UserDefaults.standard
        let toks = preferences.string(forKey: "t") ?? ""
        let escapedString = toks.replacingOccurrences(of: "+", with: "%2B")
        
        let chismoso = String(format: "https://biv.mx/cerrarPos_Movil?t=%@&carlosRocha=%@&ins=%@",escapedString, self.carlosRocha,self.ins)
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
                        self.delegate?.mensajeSuccessPortafolio("Posición cerrada")
                    } else  {
                        self.boton.isEnabled = true
                        
                        self.delegate?.mensajeErrorPortafolio("Error")
                    }
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
