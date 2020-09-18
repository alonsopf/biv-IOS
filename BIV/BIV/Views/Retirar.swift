//
//  Retirar.swift
//  BIV
//
//  Created by Fernando Alonso Pecina on 5/13/19.
//  Copyright © 2019 BIV. All rights reserved.
//

import UIKit
protocol RetirarDelegate {
    func ponMensajeEnView(_ sender:String)
    func ponHistorialRetirarBoton()
}
class Retirar: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet var primero: UILabel!
    @IBOutlet var segundo: UILabel!
    @IBOutlet var CLABE: UILabel!
    @IBOutlet var textField: UITextField!
    @IBOutlet var retirar: UIButton!
    var delegate:RetirarDelegate?
    
    var can : String!
    
    @IBAction func retirarFunc () {
        self.subviews.forEach({ $0.alpha=0.3})
        
        let indicador = UIActivityIndicatorView(style: .whiteLarge)
        indicador.center = self.center
        indicador.startAnimating()
        
        self.addSubview(indicador)
        
        let preferences = UserDefaults.standard
        
        let toks = preferences.string(forKey: "t") ?? ""
        can = textField.text
        can = can.replacingOccurrences(of: "$", with: "")
        can = can.replacingOccurrences(of: ",", with: "")
        if can == "" || can == "0" {
            self.delegate?.ponMensajeEnView("Escribe una cantidad a retirar")
            return
        }
        
        let escapedString = toks.replacingOccurrences(of: "+", with: "%2B")
        
        let chismoso = String(format: "https://biv.mx/retirarSPEI_Movil?t=%@&cantidad=%@",escapedString,can)
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
                DispatchQueue.main.async {
                    self.subviews.forEach({ $0.alpha=1.0})
                    indicador.removeFromSuperview()
                    if success == 1 {
                        let tienePosicionesAbiertas = jsonArray["tienePosicionesAbiertas"] as! Int
                        
                        if tienePosicionesAbiertas == 1 {
                            self.delegate?.ponMensajeEnView("Necesitas tener todas tus posiciones cerradas para efectuar un retiro")
                            return
                        }
                        
                        self.delegate?.ponMensajeEnView("Retiro exitoso, recuerda que puede tardar hasta 24 horas hábiles")
                    } else {
                        if success == -1 {
                            self.delegate?.ponMensajeEnView("No puedes retirar una cantidad superior a lo que tengas en tu fondo")
                        } else {
                                self.delegate?.ponMensajeEnView("Hubo un error, si crees necesario, contacta a soporte@biv.mx")
                        }
                            
                        
                        
                    }
                }
                
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("Retirar", owner: self, options: nil)
        contentView.fixInView3(self)
        //check Clabe
        self.CLABE.text = ""
        let preferences = UserDefaults.standard
        
        let toks = preferences.string(forKey: "t") ?? ""
        
        let escapedString = toks.replacingOccurrences(of: "+", with: "%2B")
        
        let chismoso = String(format: "https://biv.mx/revisarPayPalSPEI_Movil?t=%@",escapedString)
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
                    let tienePosicionesAbiertas = jsonArray["tienePosicionesAbiertas"] as? String
                    if tienePosicionesAbiertas == "1" {
                        self.delegate?.ponMensajeEnView("Necesitas tener todas tus posiciones cerradas para efectuar un retiro")
                        return
                    }
                    //let tienePaypal = jsonArray["tienePaypal"] as? String
                    //let payerID = jsonArray["payerID"] as? String
                    
                    let tieneSPEI = jsonArray["tieneSPEI"] as? String
                    if tieneSPEI == "0" {
                        self.delegate?.ponMensajeEnView("Necesitas verificar tu CLABE interbancaria para efectuar un retiro")
                        
                        return
                    }
                    let CLABE_String = jsonArray["CLABE"] as? String
                    
                    
                    DispatchQueue.main.async {
                        self.CLABE.text = CLABE_String
                        self.delegate?.ponHistorialRetirarBoton()
                    }
                    
                    
                }
                
                
                
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
    }

}

extension UIView
{
    func fixInView3(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}

