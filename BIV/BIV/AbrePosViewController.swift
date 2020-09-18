//
//  AbrePosViewController.swift
//  BIV
//
//  Created by Fernando Alonso Pecina on 5/21/19.
//  Copyright © 2019 BIV. All rights reserved.
//

import UIKit
protocol AbrePosViewControllerDelegate {
    func regresate()
}
class AbrePosViewController: UIViewController, UITextFieldDelegate, CuentaBarDelegate {
    var delegate:AbrePosViewControllerDelegate?
    @IBOutlet var cantidad: UITextField!
    @IBOutlet var apalancamiento: UISlider!
    @IBOutlet var apalancamientoLabel: UILabel!
    @IBOutlet var TP_Slider: UISlider!
    @IBOutlet var SL_Slider: UISlider!
    @IBOutlet var TP_Switch: UISwitch!
    @IBOutlet var SL_Switch: UISwitch!
    @IBOutlet var TP_Label: UILabel!
    @IBOutlet var SL_Label: UILabel!
    @IBOutlet var comprarVender: UIButton!
    public var ins: String!
    public var displayName: String!
    public var tipo: String!
    public var typeIns: String!
    public var FixCommGlobal: Float!
    public var minInvGlobal: Float!
    public var defaultLimitCoefGlobal: Float!
    private var customSta: CuentaBar!
    @IBAction func close() {
        self.dismiss(animated: true, completion: nil)
    }
    func ponModal() {
        self.navigationController?.navigationBar.tintColor = UIColor.white
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "navigationModalStatus") as! UINavigationController
        nextViewController.modalPresentationStyle = .overCurrentContext
        self.present(nextViewController, animated:true, completion:nil)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .black
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @IBAction func onApalancamiento_Slider() {
        let ver = roundf(apalancamiento.value)
        
        var apa : Float
        apa = 1.0
        if ver == 2 {
            apa = 25.0
        }
        if ver == 3 {
            apa = 50.0
        }
        if ver == 4 {
            apa = 100.0
        }
        let constante :Float
        constante = 100.0
        let ver2 = (cantidad.text! as NSString).floatValue
        let comm = ver2*apa*(FixCommGlobal/constante)
        
        self.apalancamientoLabel.text = String(format: "1:%.0f  Comisión %.2f %%   en pesos: $%.2f",apa, FixCommGlobal , comm)
        
        
        
    }
    
    @IBAction func onTP_Slider() {
        self.TP_Label.text = String(format: "Cerrar con $%.2f de ganancias", TP_Slider.value)
    }
    
    @IBAction func onSL_Slider() {
        self.SL_Label.text = String(format: "Cerrar con $%.2f de pérdidas", SL_Slider.value)
    }
    
    @IBAction func cantidadChange() {
        let can = (self.cantidad.text! as NSString).floatValue
        
        let SLTP = can * defaultLimitCoefGlobal
        let maxSLTP = SLTP * 100.0
        let SLTP2 = SLTP * 2.0
        
        self.SL_Slider.minimumValue = SLTP2
        self.SL_Slider.value = SLTP2
        self.SL_Slider.maximumValue = can
        
        
        self.TP_Slider.minimumValue = SLTP
        self.TP_Slider.value = SLTP
        self.TP_Slider.maximumValue = maxSLTP
        
    }
    @IBAction func conprarVenderAction() {
        self.comprarVender.isEnabled = false
        self.view.subviews.forEach({ $0.alpha=0.3})
        
        
        let indicador = UIActivityIndicatorView(style: .whiteLarge)
        indicador.center = self.view.center
        indicador.startAnimating()
        
        self.view.addSubview(indicador)
        
        
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        
        let session = URLSession.init(configuration: config)
        //URLSession.shared.dataTask
        let preferences = UserDefaults.standard
        let toks = preferences.string(forKey: "t") ?? ""
        
        
        let escapedString = toks.replacingOccurrences(of: "+", with: "%2B")
        let ver = roundf(apalancamiento.value)
        
        var apa : Float
        apa = 1.0
        if ver == 2 {
            apa = 25.0
        }
        if ver == 3 {
            apa = 50.0
        }
        if ver == 4 {
            apa = 100.0
        }
        let can = (cantidad.text! as NSString).floatValue
        var TK = "0"
        var SL = "0"
        if TP_Switch.isOn {
            TK = "1"
        }
        if SL_Switch.isOn {
            SL = "1"
        }
        let tipito = String(self.tipo[self.tipo.startIndex])
        let chismoso = String(format:"https://biv.mx/openPosition_Movil?t=%@&ins=%@&tipo=%@&apalancamiento=%.0f&importeAInvertir=%.2f&inputTakeProfit=%.2f&stopLoss=%.2f&comm=%.2f&TK=%@&SL=%@&typeIns=%@",escapedString,self.ins,tipito,apa,can,TP_Slider.value,SL_Slider.value,FixCommGlobal,TK,SL,typeIns)
        
        guard let url = URL(string: chismoso) else {return}
        //print(url.absoluteString)
        let task = session.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do{
                //let ver = String(decoding: dataResponse, as: UTF8.self)
                //print(ver)
                
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])
                guard let jsonArray = jsonResponse as? [String: Any] else {
                    return
                }
                let success = jsonArray["success"] as! Int
                DispatchQueue.main.async {
                    indicador.removeFromSuperview()
                    if success == 1 {
                        self.delegate?.regresate()
                        self.close()
                        
                    }
                    if success == -1 {
                        self.comprarVender.isEnabled = true
                        self.view.subviews.forEach({ $0.alpha=1.0})
                        let SLTP = self.minInvGlobal * self.defaultLimitCoefGlobal
                        let SLTP2 = SLTP * 2.0
                        let mess = String(format: "Revisa tus datos de posición antes de abrirla, el mínimo de inversión es de $%.2f, para cerrar con ganancias, el mínimo de ganancias es de: $%.2f, para cerrar con pérdidas, el mínimo de pérdidas es de $%.2f",self.minInvGlobal, SLTP , SLTP2 )
                        self.showAlertWithTitle(title: "BIV", message: mess)
                    }
                    if success == -2 {
                        self.view.subviews.forEach({ $0.alpha=1.0})
                        self.comprarVender.isEnabled = true
                        
                        let disponible = Float(jsonArray["disponible"] as! CGFloat)
                        let solicitado = Float(jsonArray["solicitado"] as! CGFloat)
                        
                        let mess2 = String(format: "Saldos insuficientes para abrir la operación, tienes: $%.2f y necesitas: $%.2f",disponible, solicitado)
                        self.showAlertWithTitle(title: "BIV", message: mess2)
                    }
                }
               
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
    }
    func showAlertWithTitle( title:String, message:String ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let actionOk = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(actionOk)
        self.present(alert, animated: true, completion: nil)
    }
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        self.view.endEditing(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        customSta = CuentaBar()
        customSta.empiezaARecibirUpdates()
        customSta.delegate = self
        self.navigationItem.rightBarButtonItem = customSta
        
        self.title = self.tipo+" "+self.displayName
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard) )
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        comprarVender.setTitle(self.tipo, for: .normal)
        if self.tipo == "Vender" {
            comprarVender.backgroundColor = UIColor(red: 252.0/255.0, green: 114.0/255.0, blue: 66.0/255.0, alpha: 1.0)
            comprarVender.setImage(UIImage(named: "vender.png"), for: .normal)
        }
        
        comprarVender.layer.cornerRadius = 10.0
        TP_Label.text = ""
        SL_Label.text = ""
        TP_Switch.addTarget(self, action: #selector(onTP_Switch), for: .valueChanged)
        SL_Switch.addTarget(self, action: #selector(onSL_Switch), for: .valueChanged)
        // Do any additional setup after loading the view.
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        
        let session = URLSession.init(configuration: config)
        //URLSession.shared.dataTask
        guard let url = URL(string: "https://biv.mx/instrumento?instrumento="+self.ins) else {return}
        //print(url.absoluteString)
        let task = session.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do{
                //let ver = String(decoding: dataResponse, as: UTF8.self)
                //print(ver)
                
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])
                guard let jsonArray = jsonResponse as? [String: Any] else {
                    return
                }
              
                self.typeIns  = jsonArray["typeIns"] as? String
               /* let limitRateDistance  = jsonArray["limitRateDistance"] as? String
                let distanceSLTP  = jsonArray["distanceSLTP"] as? String
                let apalancamiento  = jsonArray["apalancamiento"] as? String
                 
                 var minInv = resp.minInv;
                 var SLTP = minInv*defaultLimitCoef;
                 var maxSLTP = SLTP * 100;
                 var SLTP2 = SLTP *2;
                */
                let defaultLimitCoef  = jsonArray["defaultLimitCoef"] as? CGFloat
                self.defaultLimitCoefGlobal = Float(defaultLimitCoef ?? 0.3)
                let minInv  = jsonArray["minInv"] as? CGFloat
                self.minInvGlobal = Float(minInv ?? 100.0)
                let SLTP = self.minInvGlobal * self.defaultLimitCoefGlobal
                let maxSLTP = SLTP * 100.0
                let SLTP2 = SLTP * 2.0
                
                
                
                let fixC  = jsonArray["FixComm"] as? CGFloat
                self.FixCommGlobal = Float(fixC ?? 0.1)
                
                DispatchQueue.main.async {
                    self.cantidad.text = String(format: "%.2f", minInv ?? 0.00)
                    //var pesos = importeAInvertir*apa*(comm/100);
                    var comm = (minInv ?? 0.00)*100
                    comm = comm * CGFloat(((self.FixCommGlobal ?? 0.0)/100))
                    self.apalancamientoLabel.text = String(format: "1:100  Comisión %.2f %%    en pesos: $%.2f", self.FixCommGlobal ?? 0.1, comm)
                    self.SL_Slider.minimumValue = SLTP2
                    self.SL_Slider.value = SLTP2
                    self.SL_Slider.maximumValue = Float(minInv ?? 100.0)
                    
                    
                    self.TP_Slider.minimumValue = SLTP
                    self.TP_Slider.value = SLTP
                    self.TP_Slider.maximumValue = maxSLTP
                    
                    
                    
                    
                }
             
                
                
                
                
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
    }
    @objc func onTP_Switch () {
        if TP_Switch.isOn {
            TP_Slider.isEnabled = true
            
            
            self.TP_Label.text = String(format: "Cerrar con $%.2f de ganancias", TP_Slider.value)
        } else {
            TP_Label.text = ""
            TP_Slider.isEnabled = false
        }
    }
    
    @objc func onSL_Switch () {
        if SL_Switch.isOn {
            SL_Slider.isEnabled = true
            self.SL_Label.text = String(format: "Cerrar con $%.2f de pérdidas", SL_Slider.value)
        } else {
            SL_Label.text = ""
            SL_Slider.isEnabled = false
        }
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
