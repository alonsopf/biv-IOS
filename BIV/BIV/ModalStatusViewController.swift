//
//  ModalStatusViewController.swift
//  BIV
//
//  Created by Fernando Alonso Pecina on 5/20/19.
//  Copyright © 2019 BIV. All rights reserved.
//

import UIKit

class ModalStatusViewController: UIViewController {
    @IBOutlet var disponible: UILabel!
    @IBOutlet var disponibleValor: UILabel!
    @IBOutlet var ganPer: UILabel!
    @IBOutlet var ganPerValor: UILabel!
    @IBOutlet var posAbiertas: UILabel!
    @IBOutlet var posAbiertasValor: UILabel!
    @IBOutlet var cambiarADemoReal: UIButton!
    
    @IBAction func cambiarADemoRealAction() {
        let preferences = UserDefaults.standard
        
        let toks = preferences.string(forKey: "t") ?? ""
        
        let escapedString = toks.replacingOccurrences(of: "+", with: "%2B")
        
        let chismoso = String(format: "https://biv.mx/tipoCuenta_Movil?t=%@",escapedString)
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
                    
                   
                    DispatchQueue.main.async {
                      self.dismiss(animated: true, completion: nil)
                        
                    }
                    
                    
                }
                
                
                
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
    }
    @IBAction func close() {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.view.backgroundColor = .clear
       // self.view.isOpaque = false
        let preferences = UserDefaults.standard
        let disponibleValue = preferences.double(forKey: "disponible")
        disponibleValor.text = String(format: "$%.02f", disponibleValue)
        
        let ganPerValue = preferences.double(forKey: "ganPer")
        ganPerValor.text = String(format: "$%.02f", ganPerValue)
        
        let posAbiertasValue = preferences.integer(forKey: "posAbiertas")
        posAbiertasValor.text = String(format: "%d", posAbiertasValue)
        ganPerValor.textColor = .green
        posAbiertasValor.textColor = .green
        if ganPerValue < 0.00 {
            ganPerValor.textColor = .red
            posAbiertasValor.textColor = .red
        }
        let tipoCuenta = preferences.integer(forKey: "tipoCuenta")
        if tipoCuenta == 1 { //es real
            cambiarADemoReal.setTitle("   Cambiar a Demo   ", for: .normal)
        } else {
            cambiarADemoReal.setTitle("   Cambiar a Real   ", for: .normal)
        }
        cambiarADemoReal.layer.cornerRadius = 10.0
        
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
