//
//  Depositar.swift
//  BIV
//
//  Created by Fernando Alonso Pecina on 5/8/19.
//  Copyright © 2019 BIV. All rights reserved.
//

import UIKit
protocol DepositarDelegate {
    func ponMensajeReferencia(_ mensaje:String)
    func ponHistorial()
    func ponHistorialBoton()
}
class Depositar: UIView, UIPickerViewDelegate, UIPickerViewDataSource  {
    var delegate:DepositarDelegate?
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        delegate?.ponHistorialBoton()
        historial.isHidden = true
        return 1;
        
    }
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        can = pickerData[row]
        self.mensajeMain.text = String(format:"Selecciona una cantidad, después genera una referencia y haz una transferencia por %@.00 a la CLABE: 044597253000774021 usando la referencia generada.",can)
        
        
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
  /*  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return pickerData[row]
    }
    */
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let string = pickerData[row]
        return NSAttributedString(string: string, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    let kCONTENT_XIB_NAME = "Depositar"
    @IBOutlet var referencia: UILabel!
    @IBOutlet var contentView: UIView!
    @IBOutlet var mensajeMain: UILabel!
    var pickerData: [String] = [String]()
    var can : String!
    var guardaCan : String!
    @IBOutlet var generarReferencia: UIButton!
    @IBOutlet var historial: UIButton!
    @IBOutlet var selecciona: UIPickerView!
    @IBAction func generarReferenciaTaped(_ sender: UIButton) {
        generarReferencia.isEnabled = false
        self.subviews.forEach({ $0.alpha=0.3})
        
        let indicador = UIActivityIndicatorView(style: .whiteLarge)
        indicador.center = self.center
        indicador.startAnimating()
        
        self.addSubview(indicador)
        
        
        let preferences = UserDefaults.standard
        
        let toks = preferences.string(forKey: "t") ?? ""
        self.guardaCan = can
        can = can.replacingOccurrences(of: "$", with: "")
        can = can.replacingOccurrences(of: ",", with: "")
        let escapedString = toks.replacingOccurrences(of: "+", with: "%2B")
        
        let chismoso = String(format: "https://biv.mx/generateSPEI_reference_Movil?t=%@&can=%@",escapedString,can)
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
                }
                if success == 1 {
                    let reference = jsonArray["reference"] as? String
                    
                    
                    DispatchQueue.main.async {
                        self.delegate?.ponMensajeReferencia(String(format:"Realiza una transferencia SPEI de %@ con la referencia %@",self.guardaCan,reference ?? ""))
                        self.referencia.text = reference
                        self.generarReferencia.isEnabled = true
                        
                    }
                    
                    
                }
                
                
                
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
        
    }
    @IBAction func historialTaped(_ sender: UIButton) {
          delegate?.ponHistorial()
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        pickerData = ["$200", "$500", "$1,000", "$2,000", "$4,000", "$6,000", "$8,000", "$10,000", "$20,000", "$40,000", "$80,000", "$100,000", "$200,000", "$400,000"]
        Bundle.main.loadNibNamed(kCONTENT_XIB_NAME, owner: self, options: nil)
        contentView.fixInView(self)
        historial.setTitleColor(UIColor.yellow, for: .normal)
        can="200"
        self.mensajeMain.text = String(format:"Selecciona una cantidad, después genera una referencia y haz una transferencia por $%@.00 a la CLABE: 044597253000774021 usando la referencia generada.",can)
        
        
    }

}

extension UIView
{
    func fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}
