//
//  ViewController.swift
//  BIV
//
//  Created by Fernando Alonso Pecina on 4/2/19.
//  Copyright © 2019 BIV. All rights reserved.
//

import UIKit
import LocalAuthentication
//import GoogleCast
import CommonCrypto
import SideMenu
extension Data{
    mutating func append2(_ string: String, using encoding: String.Encoding = .utf8) {
        if let data = string.data(using: encoding) {
            append(data)
        }
    }
}
class ViewController: UIViewController,UINavigationControllerDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, PerfilTableViewCellDelegate, DepositarDelegate, RetirarDelegate, InsTableViewCellDelegate, CuentaBarDelegate, ProductosTableViewCellelegate, GraficaViewControllerDelegate, PortafolioTableViewCellDelegate {
    func ponMensajeReferencia(_ mensaje:String){    
        let alert = UIAlertController(title: "BIV", message: mensaje, preferredStyle: .alert)
        
        let actionOk = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(actionOk)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func ponMEnsajito(_ mensaje:String) {
        let alert = UIAlertController(title: "BIV", message: mensaje, preferredStyle: .alert)
        
        let actionOk = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(actionOk)
        self.present(alert, animated: true, completion: nil)
    }
    func recargaTablita() {
        self.cargaCanjePuntos()
    }
    func mensajeErrorPortafolio(_ mensaje:String) {
        let alert = UIAlertController(title: "BIV", message: mensaje, preferredStyle: .alert)
        
        let actionOk = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(actionOk)
        self.present(alert, animated: true, completion: nil)
    }
    func mensajeSuccessPortafolio(_ mensaje:String) {
        let alert = UIAlertController(title: "BIV", message: mensaje, preferredStyle: .alert)
        
        let actionOk = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(actionOk)
        self.present(alert, animated: true, completion: nil)
        self.cargaPortafolio() 
    }
    func ponMensajeEnView(_ sender: String) {
        let alert = UIAlertController(title: "BIV", message: sender, preferredStyle: .alert)
        
        let actionOk = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(actionOk)
        self.present(alert, animated: true, completion: nil)
    }
    func ponModal() {
        self.navigationController?.navigationBar.tintColor = UIColor.white
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "navigationModalStatus") as! UINavigationController
        
        
    //    let modalViewController = storyBoard.instantiateViewController(withIdentifier: "modalStatus") as! ModalStatusViewController
        nextViewController.modalPresentationStyle = .overCurrentContext
        
        //presentViewController(modalViewController, animated: true, completion: nil)
        self.present(nextViewController, animated:true, completion:nil)
        
        //self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    func ponHistorialRetirarBoton() {
        let barHi = UIBarButtonItem(title: "Historial", style: .plain, target: self, action: #selector(histoReti))
        barHi.tintColor = UIColor.white
        customSta = CuentaBar()
        customSta.empiezaARecibirUpdates()
        customSta.delegate = self
        self.navigationItem.rightBarButtonItem = customSta
        self.navigationItem.rightBarButtonItems = [barHi,customSta]
    }
    //, GCKRequestDelegate
    //globales, perdon Giovanny {
    
    private var customSta: CuentaBar!
    private var tipoCuentaGlobal: Int = 0
    private var CLABE: String!
    private var CLABEVerificado: Int!
    private var confirmado: Int!
    private var correoGlobal: String!
    private var direccion: String!
    private var direccionVerificado: Int!
    private var dniVerificado: Int!
    private var nombre: String!
    private var rfc: String!
    private var telefono: String!
    public var puntosDisponibles: Int!
    public var indicadorGlobal: UIActivityIndicatorView!
    
    private var telefonoVerificado: Int!
    //globales, perdon Giovanny }
    
    var correoText: UITextField!
    var imagePicker: UIImagePickerController!
    var passText: UITextField!
    var logo: UIImageView!
    var pala: UILabel!
    var back: UIColor!
    var front: UIColor!
    
    let rightButton  = UIButton(type: .custom)
    let registrarseButton  = UIButton(type: .roundedRect)
    let yaTienesCuentaButton  = UIButton(type: .roundedRect)
    private var displayWidth: CGFloat!
    private var displayHeight: CGFloat!
    private var barHeight: CGFloat!
    private var tipoImagenGlobal: Int!
    
    private var myInsArray: NSMutableArray = []
    private var myPcentArray: NSMutableArray = []
    private var mySymbolArray: NSMutableArray = []
    private var myOpenRateArray: NSMutableArray = []
    //
    private var myGanPerArray: NSMutableArray = []
    private var myPrecioActualArray: NSMutableArray = []
    private var myTPArray: NSMutableArray = []
    private var mySLArray: NSMutableArray = []
    private var myPGArray: NSMutableArray = []
    private var myPCArray: NSMutableArray = []
    private var myCarlosRochaArray: NSMutableArray = []
    private var myLuisMontielArray: NSMutableArray = []
    
    
    
    private var myTableView: UITableView!
    
    //var mediaInformation: GCKMediaInformation!
    
    enum TipoUI {
        case Registrarse
        case IniciarSesion
    }
    enum TipoPortafolio {
        case Abiertas
        case Cerradas
    }
    enum TipoTabla {
        case Perfil
        case Instrumentos
        case Portafolio
        case Cerradas
        case FAQ
        case CanjePuntos
    }
    private var tipoPortafolio: TipoPortafolio!
    private var tipoTabla: TipoTabla!
    private var tipoUI : TipoUI!
    
    func ponHistorialBoton() {//historial de depositos
        let barHi = UIBarButtonItem(title: "Historial", style: .plain, target: self, action: #selector(histoDepo))
        barHi.tintColor = UIColor.white
        customSta = CuentaBar()
        customSta.empiezaARecibirUpdates()
        customSta.delegate = self
        self.navigationItem.rightBarButtonItems = [barHi,customSta]
    }
    @objc func histoDepo () {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "historialDepositosNavigation") as! UINavigationController
        
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @objc func histoReti () {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "historialRetirosNavigation") as! UINavigationController
        
        self.present(nextViewController, animated:true, completion:nil)
    }
    func ponHistorial() {//historial de depositos
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "historialDepositosNavigation") as! UINavigationController
        
        self.present(nextViewController, animated:true, completion:nil)
      /*  dismissKeyboard()
        self.title = "Depositar"
        self.view.subviews.forEach({ $0.removeFromSuperview() })
        var depos : HistorialDepositos!
        depos = HistorialDepositos(frame: CGRect(x: 0.0, y: 0.0, width: displayWidth, height: displayHeight))
        //depos.delegate = self
        self.view.addSubview(depos)
        depos.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        depos.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0.0).isActive = true
        depos.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0.0).isActive = true
        depos.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0.0).isActive = true
        depos.translatesAutoresizingMaskIntoConstraints = false
 */
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let preferences = UserDefaults.standard
        let deboPonerAlgo = preferences.string(forKey: "deboPonerAlgo") ?? "0"
        if deboPonerAlgo == "-3" {
            self.cargaPerfil()
        }
        if deboPonerAlgo == "-2" {
            self.cargaPortafolio()
        }
        if deboPonerAlgo == "-1" {
            self.cargaConjunto(clave: "FAV")
        }
        if deboPonerAlgo == "1" {
            self.cargaConjunto(clave: "CRYPTO")
        }
        if deboPonerAlgo == "2" {
            self.cargaConjunto(clave: "CURRENCY")
        }
        if deboPonerAlgo == "3" {
            self.cargaConjunto(clave: "INDEX")
        }
        if deboPonerAlgo == "4" {
            self.cargaConjunto(clave: "ENERGETICS")
        }
        if deboPonerAlgo == "5" {
            self.cargaConjunto(clave: "METAL")
        }
        if deboPonerAlgo == "6" {
            self.cargaConjunto(clave: "BOND")
        }
        if deboPonerAlgo == "7" {
            self.cargaConjunto(clave: "AGRICULTURE")
        }
        if deboPonerAlgo == "8" {//depositar
            self.cargaDepositar()
        }
        if deboPonerAlgo == "9" {//retirar
            self.cargaRetirar()
        }
        if deboPonerAlgo == "10" {//canje de puntos
            self.cargaCanjePuntos()
        }
        if deboPonerAlgo == "11" {//preguntas frecuentes
            self.cargaFAQ()
        }
        if deboPonerAlgo == "12" {
            self.cargaPortafolioHistorial()
        }
        if deboPonerAlgo == "13" {
            self.inicioGlobal()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.barStyle = .black
        
    }
    func showAlertWithTitle( title:String, message:String ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let actionOk = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(actionOk)
        self.present(alert, animated: true, completion: nil)
    }
    func errorMessage(errorCode:Int) -> String{
        
        var strMessage = ""
        
        switch errorCode {
            
        case LAError.Code.authenticationFailed.rawValue:
            strMessage = "Authentication Failed"
            
        case LAError.Code.appCancel.rawValue:
            strMessage = "User Cancel"
            
        case LAError.Code.systemCancel.rawValue:
            strMessage = "System Cancel"
            
        case LAError.Code.passcodeNotSet.rawValue:
            strMessage = "Please goto the Settings & Turn On Passcode"
            
        case LAError.Code.biometryNotAvailable.rawValue:
            strMessage = "TouchI or FaceID DNot Available"
            
        case LAError.Code.biometryNotEnrolled.rawValue:
            strMessage = "TouchID or FaceID Not Enrolled"
            
        case LAError.Code.biometryLockout.rawValue:
            strMessage = "TouchID or FaceID Lockout Please goto the Settings & Turn On Passcode"
            
        case LAError.Code.appCancel.rawValue:
            strMessage = "App Cancel"
            
        case LAError.Code.invalidContext.rawValue:
            strMessage = "Invalid Context"
            
        default:
            strMessage = ""
            
        }
        return strMessage
    }
    func Authenticate(completion: @escaping ((Bool) -> ())){
        
        //Create a context
        let authenticationContext = LAContext()
        var error:NSError?
        
        //Check if device have Biometric sensor
        let isValidSensor : Bool = authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        
        if isValidSensor {
            //Device have BiometricSensor
            //It Supports TouchID
            
            authenticationContext.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: "Touch / Face ID authentication",
                reply: { [unowned self] (success, error) -> Void in
                    
                    if(success) {
                        // Touch / Face ID recognized success here
                        completion(true)
                    } else {
                        //If not recognized then
                        if let error = error {
                            let strMessage = self.errorMessage(errorCode: error._code)
                            if strMessage != ""{
                                self.showAlertWithTitle(title: "Error", message: strMessage)
                            }
                        }
                        completion(false)
                    }
            })
        } else {
            
            let strMessage = self.errorMessage(errorCode: (error?._code)!)
            if strMessage != ""{
                self.showAlertWithTitle(title: "Error", message: strMessage)
            }
        }
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func sha512(hashString : String) -> String {
        
        let data = hashString.data(using: .utf8)!
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA512_DIGEST_LENGTH))
      //  data.withUnsafeBytes(<#T##body: (UnsafeRawBufferPointer) throws -> ResultType##(UnsafeRawBufferPointer) throws -> ResultType#>)
        data.withUnsafeBytes({
            _ = CC_SHA512($0, CC_LONG(data.count), &digest)
        }) 
        return digest.map({ String(format: "%02hhx", $0) }).joined(separator: "")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == correoText {
            passText.becomeFirstResponder()
        }
        return true
    }
    
    /*func request(_ request: GCKRequest, didFailWithError error: GCKError) {
        print(error)
    }*/
    var expandData = [NSMutableDictionary]()
    var binType = ["aaa","bbb","ccc","ddd","eee"]
    func cargaPortafolioHistorial(){
        dismissKeyboard()
        self.title = "Historial"
        self.view.subviews.forEach({ $0.removeFromSuperview() })
        customSta = CuentaBar()
        customSta.empiezaARecibirUpdates()
        customSta.delegate = self
        self.navigationItem.rightBarButtonItem = customSta
        let indicador = UIActivityIndicatorView(style: .whiteLarge)
        indicador.center = self.view.center
        indicador.startAnimating()
        self.view.addSubview(indicador)
        myInsArray.removeAllObjects()
        myPcentArray.removeAllObjects()
        mySymbolArray.removeAllObjects()
        myOpenRateArray.removeAllObjects()
        
        myGanPerArray.removeAllObjects()
        myPrecioActualArray.removeAllObjects()
        myTPArray.removeAllObjects()
        mySLArray.removeAllObjects()
        myPGArray.removeAllObjects()
        myPCArray.removeAllObjects()
        
        
        
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
                    /*   var palabra = "Real"
                     let tipoCuenta = jsonArray["tipoCuenta"] as! Int
                     if tipoCuenta == 0 {
                     palabra = "Demo"
                     }
                     preferences.set(tipoCuenta , forKey: "tipoCuenta")*/
                    guard let cuak = openPositionList?["CerradasList"] as? [Dictionary<String,Any>] else {
                        DispatchQueue.main.async {
                            
                            indicador.removeFromSuperview()
                            self.showAlertWithTitle(title: "BIV", message: "No tienes posiciones abiertas")
                            self.cargaConjunto(clave: "CRYPTO")
                        }
                        return
                    }
                    
                    
                    for pato in cuak {
                        
                        self.expandData.append(["isOpen":"1","data":["ONCE A WEEK","TWICE A WEEK","EVERY TWO WEEKS","EVERY THREE WEEKS","ONCE A MONTH"],"isSelect":"No"])
                        
                        var palabra = "Compra"
                        let C_V = pato["C_V"] as! String
                        if C_V != "C" {
                            palabra = "Venta"
                        }
                        let Alias = pato["Alias"] as! String
                        let UnixEntrada = pato["UnixEntrada"] as! String
                        let Importe = pato["Importe"] as! String
                        let Apalancamiento = pato["Apalancamiento"] as! String
                        let Comm = pato["Comm"] as! String
                        
                        let PrecioApertura = pato["PrecioApertura"] as! String
                        self.myInsArray.add(String(format: "%@ de %@", palabra, Alias))
                        self.myPcentArray.add(UnixEntrada)
                        
                        self.mySymbolArray.add(String(format: "$%@ x %@  Comisión: $%@",Importe,Apalancamiento, Comm))
                        
                        self.myOpenRateArray.add(String(format:"Precio apertura: %@",PrecioApertura))
                        
                        let GananciasPerdidas = pato["GananciasPerdidas"] as! String
                        let PrecioCierre = pato["PrecioCierre"] as! String
                         let PuntosGenerados = pato["PuntosGenerados"] as! String
                        let PuntosCobrados = pato["PuntosCobrados"] as! String
                        
                        self.myPrecioActualArray.add(String(format:"Precio de cierre: %@",PrecioCierre))
                        self.myGanPerArray.add(GananciasPerdidas)
                        
                        let MotivoCierre = pato["MotivoCierre"] as! String
                        let UnixCerrada = pato["UnixCerrada"] as! String
                        
                        
                        self.myTPArray.add(MotivoCierre)
                        self.mySLArray.add(String(format:"Cierre: %@",UnixCerrada))
                    
                       
                        self.myPGArray.add(String(format:"%@ puntos generados",PuntosGenerados))
                        self.myPCArray.add(String(format:"%@ puntos cobrados",PuntosCobrados))
                    }
                    
                    DispatchQueue.main.async {
                        self.tipoPortafolio = TipoPortafolio.Cerradas
                        self.tipoTabla = TipoTabla.Portafolio
                        self.myTableView = UITableView(frame: CGRect(x: 20, y: self.barHeight+20.0, width: self.displayWidth, height: self.displayHeight - self.barHeight))
                        self.myTableView.register(PortafolioTableViewCell.self, forCellReuseIdentifier: "porCell")
                        self.myTableView.register(UINib(nibName: "PortafolioTableViewCell", bundle: nil), forCellReuseIdentifier: "porCell")
                        
                        self.myTableView.backgroundColor = UIColor.init(displayP3Red: 21.0/255, green: 20.0/255.0, blue: 43.0/255.0, alpha: 1.0)
                        self.myTableView.dataSource = self
                        self.myTableView.delegate = self
                        self.myTableView.separatorStyle = .none
                        self.myTableView.tableFooterView = UIView(frame: CGRect.zero)
                        self.myTableView.sectionFooterHeight = 20.0
                        
                        //myTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20.0).isActive = true
                        
                        
                        self.view.addSubview(self.myTableView)
                        self.myTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
                        self.myTableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20.0).isActive = true
                        self.myTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20.0).isActive = true
                        self.myTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0.0).isActive = true
                        self.myTableView.translatesAutoresizingMaskIntoConstraints = false
                        
                        indicador.removeFromSuperview()
                        //self.myTableView.reloadData()
                    }
                    
                    
                }
                
                
                
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
    }
    func cargaPortafolio(){
        dismissKeyboard()
        self.title = "Portafolio"
        self.view.subviews.forEach({ $0.removeFromSuperview() })
        
        customSta = CuentaBar()
        //customSta.tipoCuenta = tipoCuentaGlobal
        customSta.empiezaARecibirUpdates()
        customSta.delegate = self
        /* let sta = Status(frame: CGRect(x: 0.0, y: 0.0, width: 80.0, height: 30.0))
         sta.sizeToFit()
         sta.layer.cornerRadius = 10.0
         
         
         self.navigationItem.rightBarButtonItem?.customView = sta
         */
        self.navigationItem.rightBarButtonItem = customSta
        
        let indicador = UIActivityIndicatorView(style: .whiteLarge)
        indicador.center = self.view.center
        indicador.startAnimating()
        self.view.addSubview(indicador)
        myInsArray.removeAllObjects()
        myPcentArray.removeAllObjects()
        mySymbolArray.removeAllObjects()
        myOpenRateArray.removeAllObjects()
        
        myGanPerArray.removeAllObjects()
        myPrecioActualArray.removeAllObjects()
        myTPArray.removeAllObjects()
        mySLArray.removeAllObjects()
        myPGArray.removeAllObjects()
        myPCArray.removeAllObjects()
        myCarlosRochaArray.removeAllObjects()
        myLuisMontielArray.removeAllObjects()
        
      
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
                 /*   var palabra = "Real"
                    let tipoCuenta = jsonArray["tipoCuenta"] as! Int
                    if tipoCuenta == 0 {
                        palabra = "Demo"
                    }
                    preferences.set(tipoCuenta , forKey: "tipoCuenta")*/
                    guard let cuak = openPositionList?["AbiertasList"] as? [Dictionary<String,Any>] else {
                        DispatchQueue.main.async {
                            
                            indicador.removeFromSuperview()
                            self.showAlertWithTitle(title: "BIV", message: "No tienes posiciones abiertas")
                            self.cargaConjunto(clave: "CRYPTO")
                        }
                        return
                    }
                    
                    
                    for pato in cuak {
                        
                        self.expandData.append(["isOpen":"1","data":["ONCE A WEEK","TWICE A WEEK","EVERY TWO WEEKS","EVERY THREE WEEKS","ONCE A MONTH"],"isSelect":"No"])
                        
                        var palabra = "Compra"
                        let C_V = pato["C_V"] as! String
                        if C_V != "C" {
                            palabra = "Venta"
                        }
                        
                        let CarlosRocha = pato["CarlosRocha"] as! String
                        self.myCarlosRochaArray.add(CarlosRocha)
                        let luisMontiel = pato["Ins"] as! String
                        self.myLuisMontielArray.add(luisMontiel)
                        
                        
                        
                        let Alias = pato["Alias"] as! String
                        let UnixEntrada = pato["UnixEntrada"] as! String
                        let Importe = pato["Importe"] as! String
                        let Apalancamiento = pato["Apalancamiento"] as! String
                        let Comm = pato["Comm"] as! String
                        
                        let PrecioApertura = pato["PrecioApertura"] as! String
                        self.myInsArray.add(String(format: "%@ de %@", palabra, Alias))
                        self.myPcentArray.add(UnixEntrada)
                        
                        self.mySymbolArray.add(String(format: "$%@ x %@  Comisión: $%@",Importe,Apalancamiento, Comm))
                        
                        self.myOpenRateArray.add(String(format:"Precio apertura: %@",PrecioApertura))
                        
                        let GananciasPerdidas = pato["GananciasPerdidas"] as! String
                        let PrecioActual = pato["PrecioActual"] as! String
                        let TK = pato["TK"] as! String
                        let SL = pato["SL"] as! String
                        let TK_Value = pato["TK_Value"] as! String
                        let SL_Value = pato["SL_Value"] as! String
                        let PuntosGenerados = pato["PuntosGenerados"] as! String
                        let PuntosCobrados = pato["PuntosCobrados"] as! String
                        
                        self.myPrecioActualArray.add(String(format:"Precio actual: %@",PrecioActual))
                        self.myGanPerArray.add(GananciasPerdidas)
                        if TK == "1" {
                            self.myTPArray.add(String(format:"Cerrar con $%@ de ganancias",TK_Value))
                        } else {
                            self.myTPArray.add(String(format:"No cierre automático con ganancias"))
                        }
                        if SL == "1" {
                            self.mySLArray.add(String(format:"Cerrar con $%@ de ganancias",SL_Value))
                        } else {
                            self.mySLArray.add(String(format:"No cierre automático con ganancias"))
                        }
                        self.myPGArray.add(String(format:"%@ puntos generados",PuntosGenerados))
                        self.myPCArray.add(String(format:"%@ puntos cobrados",PuntosCobrados))
                    }
                    
                    DispatchQueue.main.async {
                        self.tipoPortafolio = TipoPortafolio.Abiertas
                        self.tipoTabla = TipoTabla.Portafolio
                        self.myTableView = UITableView(frame: CGRect(x: 20, y: self.barHeight+20.0, width: self.displayWidth, height: self.displayHeight - self.barHeight))
                        self.myTableView.register(PortafolioTableViewCell.self, forCellReuseIdentifier: "porCell")
                        self.myTableView.register(UINib(nibName: "PortafolioTableViewCell", bundle: nil), forCellReuseIdentifier: "porCell")
                        
                        self.myTableView.backgroundColor = UIColor.init(displayP3Red: 21.0/255, green: 20.0/255.0, blue: 43.0/255.0, alpha: 1.0)
                        self.myTableView.dataSource = self
                        self.myTableView.delegate = self
                        self.myTableView.separatorStyle = .none
                        self.myTableView.tableFooterView = UIView(frame: CGRect.zero)
                        self.myTableView.sectionFooterHeight = 20.0
                        
                        //myTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20.0).isActive = true
                        
                        
                        self.view.addSubview(self.myTableView)
                        self.myTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
                        self.myTableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20.0).isActive = true
                        self.myTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20.0).isActive = true
                        self.myTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0.0).isActive = true
                        self.myTableView.translatesAutoresizingMaskIntoConstraints = false
                        
                        indicador.removeFromSuperview()
                       //self.myTableView.reloadData()
                    }
                    
                    
                }
                
                
                
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
    }
    
    
    func ponTablitaDeFAQ(){
        tipoTabla = TipoTabla.FAQ
        myTableView = UITableView(frame: CGRect(x: 20, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        myTableView.register(FAQTableViewCell.self, forCellReuseIdentifier: "faqCell")
        myTableView.register(UINib(nibName: "FAQTableViewCell", bundle: nil), forCellReuseIdentifier: "faqCell")
        
        myTableView.backgroundColor = UIColor.init(displayP3Red: 21.0/255, green: 20.0/255.0, blue: 43.0/255.0, alpha: 1.0)
        myTableView.dataSource = self
        myTableView.delegate = self
        //myTableView.separatorStyle = .none
        myTableView.tableFooterView = UIView(frame: CGRect.zero)
        myTableView.sectionFooterHeight = 20.0
        
        //myTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20.0).isActive = true
        
        
        self.view.addSubview(myTableView)
        myTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        myTableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0.0).isActive = true
        myTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20.0).isActive = true
        myTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0.0).isActive = true
        myTableView.translatesAutoresizingMaskIntoConstraints = false
        
        
    }
    
    func ponTablitaDePuntos(){
        tipoTabla = TipoTabla.CanjePuntos
        myTableView = UITableView(frame: CGRect(x: 20, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        myTableView.register(ProductosTableViewCell.self, forCellReuseIdentifier: "productoCell")
        myTableView.register(UINib(nibName: "ProductosTableViewCell", bundle: nil), forCellReuseIdentifier: "productoCell")
        
        myTableView.backgroundColor = UIColor.init(displayP3Red: 21.0/255, green: 20.0/255.0, blue: 43.0/255.0, alpha: 1.0)
        myTableView.dataSource = self
        myTableView.delegate = self
        //myTableView.separatorStyle = .none
        myTableView.tableFooterView = UIView(frame: CGRect.zero)
        myTableView.sectionFooterHeight = 20.0
        
        //myTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20.0).isActive = true
        
        
        self.view.addSubview(myTableView)
        myTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        myTableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0.0).isActive = true
        myTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20.0).isActive = true
        myTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0.0).isActive = true
        myTableView.translatesAutoresizingMaskIntoConstraints = false
        
        
    }
    func ponTablita(){
        tipoTabla = TipoTabla.Instrumentos
        myTableView = UITableView(frame: CGRect(x: 20, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        myTableView.register(InsTableViewCell.self, forCellReuseIdentifier: "insCell")
        myTableView.register(UINib(nibName: "InsTableViewCell", bundle: nil), forCellReuseIdentifier: "insCell")
        
        myTableView.backgroundColor = UIColor.init(displayP3Red: 21.0/255, green: 20.0/255.0, blue: 43.0/255.0, alpha: 1.0)
        myTableView.dataSource = self
        myTableView.delegate = self
        myTableView.separatorStyle = .none
        myTableView.tableFooterView = UIView(frame: CGRect.zero)
        myTableView.sectionFooterHeight = 20.0
        
        //myTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20.0).isActive = true
        
        
        self.view.addSubview(myTableView)
        myTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        myTableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0.0).isActive = true
        myTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20.0).isActive = true
        myTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0.0).isActive = true
        myTableView.translatesAutoresizingMaskIntoConstraints = false
        
        
    }
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SideMenuManager.default.menuFadeStatusBar = false
        
        
        //self.myTableView.register(InsTableViewCell.self, forCellReuseIdentifier: "perfilCell")
        //self.myTableView.register(UINib(nibName: "PerfilTableViewCell", bundle: nil), forCellReuseIdentifier: "perfilCell")

       /* let castButton = GCKUICastButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        castButton.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: castButton)
        
        let metadata = GCKMediaMetadata()
        metadata.setString("Big Buck Bunny (2008)", forKey: kGCKMetadataKeyTitle)
        metadata.setString("Big Buck Bunny tells the story of a giant rabbit with a heart bigger than " +
            "himself. When one sunny day three rodents rudely harass him, something " +
            "snaps... and the rabbit ain't no bunny anymore! In the typical cartoon " +
            "tradition he prepares the nasty rodents a comical revenge.",
                           forKey: kGCKMetadataKeySubtitle)
        metadata.addImage(GCKImage(url: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/BigBuckBunny.jpg")!,
                                   width: 480,
                                   height: 360))
        let url = URL.init(string: "https://biv.mx/static/232.w.min.png")
        guard let mediaURL = url else {
            print("invalid mediaURL")
            return
        }
        
        let mediaInfoBuilder = GCKMediaInformationBuilder.init(contentURL: mediaURL)
        mediaInfoBuilder.streamType = GCKMediaStreamType.none;
        mediaInfoBuilder.contentType = "image/png"
        mediaInfoBuilder.metadata = metadata;
        
        mediaInformation = mediaInfoBuilder.build()
        
        guard let mediaInfo = mediaInformation else {
            print("invalid mediaInformation")
            return
        }
        
        if let request = GCKCastContext.sharedInstance().sessionManager.currentSession?.remoteMediaClient?.loadMedia(mediaInfo) {
            request.delegate = self
        }
        
        */
        
        
        
        
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard) )
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        self.view.addGestureRecognizer(tap)
        
        myInsArray = NSMutableArray()
        myPcentArray = NSMutableArray()
        mySymbolArray = NSMutableArray()
        myOpenRateArray = NSMutableArray()
        
        myGanPerArray = NSMutableArray()
        myPrecioActualArray = NSMutableArray()
        myTPArray = NSMutableArray()
        mySLArray = NSMutableArray()
        myPGArray = NSMutableArray()
        myPCArray = NSMutableArray()
        myCarlosRochaArray = NSMutableArray()
        myLuisMontielArray = NSMutableArray()
       


        back = UIColor.init(red: 81.0/255.0, green: 78.0/255.0, blue: 101.0/255.0, alpha: 1.0)
        front = UIColor.init(red: 26.0/255.0, green: 22.0/255.0, blue: 53.0/255.0, alpha: 1.0)
        displayWidth = self.view.frame.width
        displayHeight = self.view.frame.height
        barHeight = UIApplication.shared.statusBarFrame.size.height
        inicioGlobal()
        
        
        
        //menu.setBackgroundImage(self.defaultMenuImage(), for: UIControl.State(), style: .done, barMetrics: .default)
    }
    func inicioGlobal() {
        let preferences = UserDefaults.standard
        preferences.set("0", forKey: "deboPonerAlgo")
        let idUsuario = preferences.integer(forKey: "idUsuario")
        let tieneFace = preferences.integer(forKey: "faceID")
        tipoUI = .Registrarse
        if idUsuario == 0 {//needs login
            tipoUI = .Registrarse
            
        } else {//carga formulario y cara
            tipoUI = .IniciarSesion
        }
        ponUI()
        if tieneFace == 1 {
            self.Authenticate { (success) in
                if success {
                    let preferences = UserDefaults.standard
                    let urlString = preferences.string(forKey: "url") ?? ""
                    guard let url = URL(string: urlString) else {return}
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
                            let tok = jsonArray["t"] as! String
                            let preferences = UserDefaults.standard
                            preferences.set(tok, forKey: "t")
                            preferences.synchronize()
                            /*guard let jsonArray = jsonResponse as? [[String: Any]] else {
                             return
                             }*/
                            DispatchQueue.main.async {
                                self.cargaPerfil()
                            }
                        } catch let parsingError {
                            print("Error", parsingError)
                        }
                    }
                    task.resume()
                }
            }
        }
    }
    func cargaRetirar() {
        dismissKeyboard()
        self.title = "Retirar"
        self.view.subviews.forEach({ $0.removeFromSuperview() })
        var reti : Retirar!
        reti = Retirar(frame: CGRect(x: 0.0, y: 0.0, width: displayWidth, height: displayHeight))
        reti.delegate = self
        self.view.addSubview(reti)
        reti.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        reti.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0.0).isActive = true
        reti.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0.0).isActive = true
        reti.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0.0).isActive = true
        reti.translatesAutoresizingMaskIntoConstraints = false
    }
    func cargaDepositar() {
        dismissKeyboard()
        self.title = "Depositar"
        self.view.subviews.forEach({ $0.removeFromSuperview() })
        var depos : Depositar!
        depos = Depositar(frame: CGRect(x: 0.0, y: 0.0, width: displayWidth, height: displayHeight))
        depos.delegate = self
        self.view.addSubview(depos)
        depos.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        depos.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0.0).isActive = true
        depos.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0.0).isActive = true
        depos.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0.0).isActive = true
        depos.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func cargaPerfil() {
        dismissKeyboard()
        self.title = "Perfil"
        self.view.subviews.forEach({ $0.removeFromSuperview() })
        
        customSta = CuentaBar()
        //customSta.tipoCuenta = tipoCuentaGlobal
        customSta.empiezaARecibirUpdates()
        customSta.delegate = self
       /* let sta = Status(frame: CGRect(x: 0.0, y: 0.0, width: 80.0, height: 30.0))
        sta.sizeToFit()
        sta.layer.cornerRadius = 10.0
        
        
        self.navigationItem.rightBarButtonItem?.customView = sta
        */
        self.navigationItem.rightBarButtonItem = customSta
        
        let indicador = UIActivityIndicatorView(style: .whiteLarge)
        indicador.center = self.view.center
        indicador.startAnimating()
        self.view.addSubview(indicador)
        
        let preferences = UserDefaults.standard
        let toks = preferences.string(forKey: "t") ?? ""
        
        
        let escapedString = toks.replacingOccurrences(of: "+", with: "%2B")
        let chismoso = "https://biv.mx/perfilMovil?t="+escapedString
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
                    self.nombre = jsonArray["nombre"] as? String
                    self.rfc = jsonArray["rfc"] as? String
                    preferences.set(self.rfc, forKey: "RFC")
                    
                    self.telefono = jsonArray["telefono"] as? String
                    
                    preferences.set(self.telefono, forKey: "celular")
                    
                    
                    //preferences.set(self.telefono, forKey: "correo")
                    self.telefonoVerificado = jsonArray["CLABEVerificado"] as? Int
                    
                    self.CLABE = jsonArray["CLABE"] as? String
                    self.CLABEVerificado = jsonArray["CLABEVerificado"] as? Int
                    self.confirmado = jsonArray["confirmado"] as? Int
                    //self.correoGlobal = jsonArray["correoGlobal"] as? String
                    self.direccion = jsonArray["direccion"] as? String
                    self.direccionVerificado = jsonArray["direccionVerificado"] as? Int
                    self.dniVerificado = jsonArray["dniVerificado"] as? Int
                    let pendiente = "Pendiente de verificación"
                    
                    if self.CLABEVerificado == 2 {
                        preferences.set(pendiente, forKey: "CLABE")
                    } else if self.CLABEVerificado == 1 {
                        preferences.set(self.CLABE, forKey: "CLABE")
                    }
                    
                    if self.dniVerificado == 2 {
                        preferences.set(pendiente, forKey: "nombre")
                    } else if self.dniVerificado == 1 {
                        preferences.set(self.nombre, forKey: "nombre")
                    }
                    
                    if self.direccionVerificado == 2 {
                        preferences.set(pendiente, forKey: "direccion")
                    } else if self.direccionVerificado == 1 {
                        preferences.set(self.direccion, forKey: "direccion")
                    }
                    preferences.synchronize()
                    DispatchQueue.main.async {
                        self.tipoTabla = TipoTabla.Perfil
                        
                        self.myTableView = UITableView(frame: CGRect(x: 0, y: self.barHeight, width: self.displayWidth, height: self.displayHeight - self.barHeight))
                        self.myTableView.register(InsTableViewCell.self, forCellReuseIdentifier: "perfilCell")
                        self.myTableView.register(UINib(nibName: "PerfilTableViewCell", bundle: nil), forCellReuseIdentifier: "perfilCell")
                        
                        self.myTableView.backgroundColor = UIColor.init(displayP3Red: 21.0/255, green: 20.0/255.0, blue: 43.0/255.0, alpha: 1.0)
                        self.myTableView.dataSource = self
                        self.myTableView.delegate = self
                        self.myTableView.tintColor = UIColor.white
                        //  myTableView.separatorStyle = .none
                        self.myTableView.tableFooterView = UIView(frame: CGRect.zero)
                        self.myTableView.sectionFooterHeight = 20.0
                        
                        //myTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20.0).isActive = true
                        
                        
                        self.view.addSubview(self.myTableView)
                        self.myTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
                        self.myTableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0.0).isActive = true
                        self.myTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0.0).isActive = true
                        self.myTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0.0).isActive = true
                        self.myTableView.translatesAutoresizingMaskIntoConstraints = false
                        indicador.removeFromSuperview()
                    }
                    
                    
                }
              
               
               
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
    }
    
    
    
    func cargaFAQ() {
        self.title = "Preguntas frecuentes"
        customSta = CuentaBar()
        customSta.empiezaARecibirUpdates()
        customSta.delegate = self
        self.navigationItem.rightBarButtonItem = customSta
        dismissKeyboard()
        
        self.view.subviews.forEach({ $0.removeFromSuperview() })
        
        
        myInsArray.removeAllObjects()
        myPcentArray.removeAllObjects()
        
        myInsArray.add("¿De qué forma puedo realizar un depósito?")
        myPcentArray.add("Solamente mediante transferencias electrónicas SPEI.")
        
        myInsArray.add("¿Cuánto tiempo se tardan en acreditar mi depósito?")
        myPcentArray.add("En menos de 24 horas hábiles")
        
        myInsArray.add("¿Dan factura CFDI?")
        myPcentArray.add("Sí, una vez acreditado tu depósito, en la sección de Historial de depósitos, puedes hacer tu facturación en línea.")
        
        myInsArray.add("¿Es seguro utilizar la plataforma BIV en línea?")
        myPcentArray.add("Toda nuestra plataforma está encriptada, usando la tecnología SSL, por lo que todos los datos sensibles están seguros, encriptados de extremo a extremo.")
        
        myInsArray.add("¿Puedo hacer un depósito usando cuenta bancaria que no esté a mi nombre?")
        myPcentArray.add("No, los recursos deben de provenir de una cuenta que esté a tu nombre.")
        
        myInsArray.add("¿De qué forma puedo realizar un retiro?")
        myPcentArray.add("Puedes usar transferencias electrónicas SPEI.")
        
        
        myInsArray.add("¿Cuánto tiempo se tarda el retiro en que esté en mi cuenta?")
        myPcentArray.add("En menos de 12 horas hábiles.")
        
        myInsArray.add("¿Puedo usar una cuenta diferente a la que use para depositar, para retirar dinero?")
        myPcentArray.add("Se podrá retirar en una cuenta diferente, siempre y cuando se certifique que la otra cuenta está también a tu nombre.")
        
        myInsArray.add("¿Qué es cerrar con ganancias (take profit)?")
        myPcentArray.add("Cuando tu posición llegue a la ganancia en pesos seleccionada, se cerrará automáticamente.")
        
        myInsArray.add("¿Qué es cerrar con pérdidas (stop loss)?")
        myPcentArray.add("Cuando tu posición llegue a la pérdida en pesos seleccionada, se cerrará automáticamente.")
        
        myInsArray.add("¿Existen saldos negativos para mi cuenta?")
        myPcentArray.add("No. El mínimo saldo es 0. Hay protección para saldos negativos.")
        
        
        myInsArray.add("¿Para qué sirven los puntos?")
        myPcentArray.add("Los puntos pueden ser canjeados por saldo en tu cuenta con BIV. Cada punto vale $10 MXN. O bien, canjearlo por alguno de los productos.")
        
        
        myInsArray.add("¿Cómo puedo obtener puntos?")
        myPcentArray.add("Cada operación dentro de BIV te genera puntos, mientras mayor sea el importe a invertir, más puntos obtedrás.")
        
        myInsArray.add("¿Puedo retirar el dinero obtenido del canje de los puntos?")
        myPcentArray.add("¡Por supuesto! Puedes retirarlo en cualquier momento.")
        
        self.ponTablitaDeFAQ()
    }
    
    func cargaCanjePuntos() {
        self.title = "Canjear Puntos"
        customSta = CuentaBar()
        customSta.empiezaARecibirUpdates()
        customSta.delegate = self
        self.navigationItem.rightBarButtonItem = customSta
        dismissKeyboard()
       
        self.view.subviews.forEach({ $0.removeFromSuperview() })
        
        let indicador = UIActivityIndicatorView(style: .whiteLarge)
        indicador.center = self.view.center
        indicador.startAnimating()
        self.view.addSubview(indicador)
        
        myInsArray.removeAllObjects()
        myPcentArray.removeAllObjects()
        mySymbolArray.removeAllObjects()
        myOpenRateArray.removeAllObjects()
        myPGArray.removeAllObjects()
        myPCArray.removeAllObjects()
      
        let preferences = UserDefaults.standard
        let toks = preferences.string(forKey: "t") ?? ""
        let escapedString = toks.replacingOccurrences(of: "+", with: "%2B")
        let chismoso = String(format: "https://biv.mx/saldoPuntos_Movil?t=%@", escapedString)
        
        
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
                    //let productos  = jsonArray["productos"] as? [String: Any]
                    guard let cuak = jsonArray["productos"] as? [Dictionary<String,Any>] else {
                        DispatchQueue.main.async {
                            indicador.removeFromSuperview()
                        }
                        return
                    }
                    self.puntosDisponibles = jsonArray["puntosDisponibles"] as? Int
                    let valorPunto = jsonArray["valorPunto"] as! Int
                    
                    self.myInsArray.add("etf.png")
                    self.myPcentArray.add("Canje de efectivo")
                    self.mySymbolArray.add(String(format:"Usted tiene %d puntos, cada punto vale $%d",self.puntosDisponibles,valorPunto ))
                    let valorFinal = self.puntosDisponibles * valorPunto
                    self.myOpenRateArray.add(String(format:"Obtener $%d por %d puntos", valorFinal, self.puntosDisponibles))
                    self.myPGArray.add(String(self.puntosDisponibles))
                    self.myPCArray.add(-1)
                    for pato in cuak {
                        let Foto = pato["Foto"] as! String
                        let Titulo = pato["Titulo"] as! String
                        var Requisitos = pato["Requisitos"] as! String
                        let PuntosProducto = pato["PuntosProducto"] as! String
                        let IdProducto = pato["IdProducto"] as! Int
                        self.myPCArray.add(IdProducto)
                        self.myInsArray.add(Foto)
                        self.myPcentArray.add(Titulo)
                        if Requisitos == "1,4" {
                            Requisitos = "Nombre y correo electrónico verificados"
                        } else {
                            Requisitos = "Nombre y dirección verificados"
                        }
                        self.mySymbolArray.add(String(format:"Requisitos $%@",Requisitos))
                        self.myOpenRateArray.add(String(format:"Obtener por %@ puntos", PuntosProducto))
                        self.myPGArray.add(PuntosProducto)
                    }
                    DispatchQueue.main.async {
                        self.ponTablitaDePuntos()
                        indicador.removeFromSuperview()
                    }
                }
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
    }
    func cargaConjunto(clave : String ) {
        //correoText.resignFirstResponder()
        customSta = CuentaBar()
        //customSta.tipoCuenta = tipoCuentaGlobal
        customSta.empiezaARecibirUpdates()
        customSta.delegate = self
      
        self.navigationItem.rightBarButtonItem = customSta
        dismissKeyboard()
        if clave == "FAV" {
            self.title = "Favoritos"
        }
        if clave == "CRYPTO" {
            self.title = "Criptomonedas"
        }
        if clave == "CURRENCY" {
            self.title = "Divisas"
        }
        if clave == "INDEX" {
            self.title = "Índices"
        }
        if clave == "ENERGETICS" {
            self.title = "Petróleo y Gas"
        }
        if clave == "METAL" {
            self.title = "Metales"
        }
        if clave == "BOND" {
            self.title = "Bonos"
        }
        if clave == "AGRICULTURE" {
            self.title = "Agricultura"
        }
        self.view.subviews.forEach({ $0.removeFromSuperview() })
        
        let indicador = UIActivityIndicatorView(style: .whiteLarge)
        indicador.center = self.view.center
        indicador.startAnimating()
        self.view.addSubview(indicador)
        
        myInsArray.removeAllObjects()
        myPcentArray.removeAllObjects()
        mySymbolArray.removeAllObjects()
        myOpenRateArray.removeAllObjects()
        myPGArray.removeAllObjects()
        let preferences = UserDefaults.standard
        let toks = preferences.string(forKey: "t") ?? ""
        let escapedString = toks.replacingOccurrences(of: "+", with: "%2B")
        let chismoso = String(format: "https://biv.mx/listaMovil?t=%@", escapedString)
        
        
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
                guard let jsonArray = jsonResponse as? [[String: Any]] else {
                    return
                }
                var deboEntrar : Bool
                for ins in jsonArray {
                    let instru = ins["Type"] as! String
                    let Favorite = ins["Favorite"] as! String
                    deboEntrar = false
                    if clave == "FAV" && Favorite == "1" {
                        deboEntrar = true
                    }
                    if instru == clave {
                        deboEntrar = true
                    }
                    if deboEntrar {
                        
                        self.mySymbolArray.add(ins["Symbol"] ?? "")
                        self.myInsArray.add(ins["Alias"] ?? "")
                        self.myPGArray.add(ins["Favorite"] ?? "0")
                        
                        let rate = ins["Rate"] as! CGFloat
                        let openRate = ins["OpenRateDay"] as! CGFloat
                        self.myOpenRateArray.add(openRate)
                        //  let rateFloat = Float (rate)
                        // let openRateFloat = Float (openRate)
                        let pcent = ((rate*100) / openRate)-100
                        
                        self.myPcentArray.add(pcent)
                    }
                }
               
                DispatchQueue.main.async {
                    self.ponTablita()
                    indicador.removeFromSuperview()
                    if clave == "FAV"  {
                        if self.myInsArray.count == 0 {
                            self.cargaConjunto(clave: "CRYPTO")
                            self.showAlertWithTitle(title: "BIV", message: "No tienes favoritos que mostrar.")
                        }
                    }
                }
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
        
        
        
        
    }
    
    func registrarse() {
        //func iniciarsesion
        let pass = sha512(hashString: passText.text ?? "")
        let correo = correoText.text ?? ""
        let urlString = "https://biv.mx/registrarse_Movil?correo="+correo+"&pass="+pass
        
        guard let url = URL(string: urlString) else {return}
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
                        self.iniciarSesion()
                        //self.cargaConjunto(clave: "CRYPTO")
                        //indicador.removeFromSuperview()
                    }
                }
                //let idUsuario = jsonArray["idUsuario"] as! Int
                //let preferences = UserDefaults.standard
                //preferences.set(idUsuario, forKey: "idUsuario")
                
                /*guard let jsonArray = jsonResponse as? [[String: Any]] else {
                    return
                }*/
               
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
        
    }
    
    func iniciarSesion() {
        let pass = sha512(hashString: passText.text ?? "")
        let correo = correoText.text ?? ""
        let urlString = "https://biv.mx/logginMovil?correo="+correo+"&pass="+pass
        guard let url = URL(string: urlString) else {return}
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
                    let tok = jsonArray["t"] as! String
                    self.tipoCuentaGlobal = jsonArray["tipoCuenta"] as! Int
                    
                    let preferences = UserDefaults.standard
                    preferences.set(tok, forKey: "t")
                    preferences.set(correo, forKey: "correo")
                    preferences.set(self.tipoCuentaGlobal, forKey: "self.tipoCuentaGlobal")
                    //var hola AppDelegate
                    preferences.synchronize()
                    DispatchQueue.main.async {
                        preferences.set(1, forKey: "idUsuario")
                        let hola = UIApplication.shared.delegate as! AppDelegate
                        hola.registerForPushNotifications()
                        self.indicadorGlobal.removeFromSuperview()
                        self.cargaPerfil()
                        self.Authenticate { (success1) in
                            if success1 {
                                preferences.set(urlString, forKey: "url")
                                preferences.set(1, forKey: "faceID")
                                preferences.synchronize()
                            }
                        }
                        //indicador.removeFromSuperview()
                    }
                } else {
                    DispatchQueue.main.async {
                         self.indicadorGlobal.removeFromSuperview()
                        self.registrarseButton.isEnabled = true
                        self.view.subviews.forEach({ $0.alpha=1.0})
                        
                         self.showAlertWithTitle(title: "Error", message: "Correo / contraseña incorrecto(s)")
                    }
                }
                
               
                /*guard let jsonArray = jsonResponse as? [[String: Any]] else {
                 return
                 }*/
                
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
    }
    @objc func iniciarORegistrarse() {
        correoText.resignFirstResponder()
        passText.resignFirstResponder()
        self.view.subviews.forEach({ $0.alpha=0.3})
        self.registrarseButton.isEnabled = false
        indicadorGlobal = UIActivityIndicatorView(style: .whiteLarge)
        indicadorGlobal.center = self.view.center
        indicadorGlobal.startAnimating()
        
        self.view.addSubview(indicadorGlobal)
        
        if tipoUI == TipoUI.Registrarse {
            registrarse()
        } else {
            iniciarSesion()
        }
    }
    
    
    @objc func toogleRI() {
        if tipoUI == TipoUI.Registrarse {
            tipoUI = TipoUI.IniciarSesion
        } else {
            tipoUI = TipoUI.Registrarse
        }
        ponUI()
    }
    @objc func tooglePass() {
        passText.isSecureTextEntry.toggle()
        if rightButton.currentImage == UIImage.init(named: "eye.png") {
            rightButton.setImage(UIImage.init(named: "eyeRaya.png"), for: .normal)
        } else {
            rightButton.setImage(UIImage.init(named: "eye.png"), for: .normal)
        }
    }
    func ponUI(){
        self.view.subviews.forEach({ $0.removeFromSuperview() })
        
        if tipoUI == TipoUI.Registrarse {
            self.title = "Regístrate"
        } else {
            self.title = "Iniciar sesión"
        }
        
        //add labels, text fields,  button, and login
        let tercio = displayWidth/3
        if UIDevice.current.userInterfaceIdiom == .pad {
            barHeight=barHeight+10.0
        }
        logo = UIImageView(frame: CGRect.init(x: (displayWidth/4)-(tercio/2), y: (barHeight*2)+20.0, width: tercio, height: tercio))
        if tipoUI == TipoUI.Registrarse {
            logo.image=UIImage(named: "log_biv_2.png")
        } else {
            logo.image=UIImage(named: "log_biv_1.png")
        }
        
        
        self.view.addSubview(logo)
        /* logo.heightAnchor.constraint(equalToConstant: tercio)
         logo.widthAnchor.constraint(equalToConstant: tercio)
         logo.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: (displayWidth/2)-(tercio/2)).isActive = true
         logo.translatesAutoresizingMaskIntoConstraints = false
         */
        //-(tercio/2)
        pala = UILabel(frame: CGRect.init(x: ((displayWidth/2)*1), y: (barHeight*2)+(tercio/2)-13.0+20.0, width: tercio, height: 30.0))
        pala.text = "BIV"
        pala.font = UIFont.boldSystemFont(ofSize: 26.0)
        pala.textAlignment = .left
        pala.textColor = UIColor.white
        self.view.addSubview(pala)
        
        
        
        
        
        passText = UITextField(frame: CGRect.init(x: 15.0, y: (barHeight*3)+tercio+30.0+75.0, width: displayWidth-30.0, height: 60.0))
        passText.backgroundColor = UIColor.black
        
        passText.layer.borderColor = back.cgColor
        passText.layer.borderWidth = 2.0
        passText.layer.cornerRadius=10
        passText.leftViewMode = .always
        passText.textColor = UIColor.white
        passText.borderStyle = .line
        passText.placeholder = "Password"
        passText.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(white: 0.80, alpha: 0.80)])
        passText.keyboardType = .asciiCapable
        passText.returnKeyType = .next
        passText.isSecureTextEntry.toggle()
        
        
        rightButton.setImage(UIImage.init(named: "eye.png"), for: .normal)
        rightButton.addTarget(self, action: #selector(tooglePass), for: .touchUpInside)
        
        registrarseButton.frame = CGRect(x:15.0, y:passText.frame.origin.y+40.0, width:displayWidth-30.0, height:50.0)
        if tipoUI == TipoUI.Registrarse {
            registrarseButton.setTitle("Regístrate", for: .normal)
            registrarseButton.backgroundColor = back
            registrarseButton.setTitleColor(UIColor.white, for: .normal)
        } else {
            registrarseButton.setTitle("Iniciar sesión", for: .normal)
            registrarseButton.backgroundColor = UIColor.white
            registrarseButton.setTitleColor(back, for: .normal)
        }
        
        
        registrarseButton.layer.cornerRadius=10
        self.view.addSubview(registrarseButton)
        let heightConstraint3 = NSLayoutConstraint(item: (registrarseButton) as Any, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)
        
        registrarseButton.addConstraint(heightConstraint3)
        
        registrarseButton.translatesAutoresizingMaskIntoConstraints = false
        registrarseButton.heightAnchor.constraint(equalToConstant: 50.0)
        registrarseButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 15).isActive = true
        registrarseButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -15.0).isActive = true
        let const = (barHeight*2)+tercio+185.0
        registrarseButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: const).isActive = true
        
        
        registrarseButton.addTarget(self, action: #selector(iniciarORegistrarse), for: .touchUpInside)
        
        
        yaTienesCuentaButton.frame = CGRect(x:15.0, y:registrarseButton.frame.origin.y+40.0, width:displayWidth-30.0, height:50.0)
        if tipoUI == TipoUI.Registrarse {
            yaTienesCuentaButton.setTitle("¿Ya tienes cuenta? Inicia sesión", for: .normal)
            yaTienesCuentaButton.backgroundColor = back
            yaTienesCuentaButton.setTitleColor(UIColor.white, for: .normal)
        } else {
            yaTienesCuentaButton.setTitle("¿No tienes cuenta? Regístrate", for: .normal)
            yaTienesCuentaButton.backgroundColor = UIColor.white
            yaTienesCuentaButton.setTitleColor(back, for: .normal)
        }
        
        yaTienesCuentaButton.addTarget(self, action: #selector(toogleRI), for: .touchUpInside)
        
        yaTienesCuentaButton.layer.cornerRadius=10
        
        self.view.addSubview(yaTienesCuentaButton)
        let heightConstraint4 = NSLayoutConstraint(item: (yaTienesCuentaButton) as Any, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)
        
        yaTienesCuentaButton.addConstraint(heightConstraint4)
        
        yaTienesCuentaButton.translatesAutoresizingMaskIntoConstraints = false
        yaTienesCuentaButton.heightAnchor.constraint(equalToConstant: 50.0)
        yaTienesCuentaButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 15).isActive = true
        yaTienesCuentaButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -15.0).isActive = true
        let const2 = (barHeight*2)+tercio+245.0
        yaTienesCuentaButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: const2).isActive = true
        
        
        
        
        
        rightButton.frame = CGRect(x:-20, y:0, width:40, height:40)
        passText.rightViewMode = .always
        passText.rightView = rightButton
        
        
        
        let imageViewPass = UIImageView(frame: CGRect.init(x: 25.0, y: 5.0, width: 35.0, height: 35.0))
        let imagePass = UIImage(named: "pass.png")
        imageViewPass.image = imagePass
        passText.leftView = imageViewPass
        passText.delegate = self
        passText.tintColor = .white
        self.view.addSubview(passText)
        let heightConstraint2 = NSLayoutConstraint(item: (passText) as Any, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60)
        
        passText.addConstraint(heightConstraint2)
        
        passText.topAnchor.constraint(equalTo: self.view.topAnchor, constant: (barHeight*2)+tercio+30.0+75.0).isActive = true
        passText.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 15).isActive = true
        passText.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -15.0).isActive = true
        passText.borderStyle = .roundedRect
        
        passText.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        
        
        correoText = UITextField(frame: CGRect.init(x: 15.0, y: (barHeight*3)+tercio+30.0, width: displayWidth-30.0, height: 60.0))
        correoText.backgroundColor = UIColor.black
        correoText.layer.cornerRadius=10
        correoText.layer.borderColor = back.cgColor
        correoText.layer.borderWidth = 2.0
        correoText.delegate = self
        correoText.tintColor = .white
        correoText.leftViewMode = .always
        correoText.textColor = UIColor.white
        correoText.borderStyle = .line
        correoText.placeholder = "Correo"
        correoText.attributedPlaceholder = NSAttributedString(string: "Correo", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(white: 0.80, alpha: 0.80)])
        correoText.keyboardType = .emailAddress
        correoText.returnKeyType = .next
        let preferences = UserDefaults.standard
        let ver = preferences.string(forKey: "correo") ?? ""
        correoText.text = ver
        
        let imageView = UIImageView(frame: CGRect.init(x: 25.0, y: 5.0, width: 35.0, height: 35.0))
        let image = UIImage(named: "email.png")
        imageView.image = image;
        correoText.leftView = imageView;
        self.view.addSubview(correoText)
        let heightConstraint = NSLayoutConstraint(item: correoText as Any, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60)
        
        correoText.addConstraint(heightConstraint)
        correoText.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 15).isActive = true
        correoText.topAnchor.constraint(equalTo: self.view.topAnchor, constant: (barHeight*2)+tercio+30.0).isActive = true
        correoText.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -15.0).isActive = true
        
        correoText.heightAnchor.constraint(equalToConstant: 60.0)
        // correoText.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0.0).isActive = true
        correoText.translatesAutoresizingMaskIntoConstraints = false
        correoText.borderStyle = .roundedRect
    //    correoText.becomeFirstResponder()
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tipoTabla == TipoTabla.Instrumentos {
            performSegue(withIdentifier: "goToGrafica", sender: nil)
        }
    }
    func cargaAbiertas() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.cargaPortafolio()
        }
    }
    func cargaGraficaInstrumento(_ ins:String, displayName:String, open:CGFloat, fav: String) {
       self.navigationController?.navigationBar.tintColor = UIColor.white
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "goToGrafica") as! GraficaViewController
        nextViewController.ins = ins
        nextViewController.fav = fav
        nextViewController.displayName = displayName
        nextViewController.openRate = open
        nextViewController.delegate = self
        self.navigationController?.pushViewController(nextViewController, animated: true)
        //self.present(nextViewController, animated:true, completion:nil)
    }
    //func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    /*
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tipoTabla == TipoTabla.Instrumentos {
            performSegue(withIdentifier: "goToGrafica", sender: nil)
        }
    }*/
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let FooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 10))
        FooterView.backgroundColor = .clear
        return FooterView
    }
    
    @objc func sectionTapped(_ sender: UITapGestureRecognizer){
        if(self.expandData[(sender.view?.tag)! - 100].value(forKey: "isOpen") as! String == "1"){
            self.expandData[(sender.view?.tag)! - 100].setValue("0", forKey: "isOpen")
        }else{
            self.expandData[(sender.view?.tag)! - 100].setValue("1", forKey: "isOpen")
        }
        self.myTableView.reloadSections(IndexSet(integer: (sender.view?.tag)! - 100), with: .automatic)
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if tipoTabla == TipoTabla.FAQ {
            return myInsArray.count
        }
        if tipoTabla == TipoTabla.Perfil {
            return 6
        }
        if tipoTabla == TipoTabla.Instrumentos || tipoTabla == TipoTabla.CanjePuntos {
            return 1
        }
        if tipoTabla == TipoTabla.Portafolio || tipoTabla == TipoTabla.Cerradas {
            if self.expandData[section].value(forKey: "isOpen") as! String == "1"{
                return 0
            }else{
                if tipoPortafolio == TipoPortafolio.Abiertas {
                    return 10
                }
                return 9
            }
        }
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if tipoTabla == TipoTabla.Instrumentos || tipoTabla == TipoTabla.CanjePuntos {
            return myInsArray.count
        }
        if tipoTabla == TipoTabla.Perfil || tipoTabla == TipoTabla.FAQ {
            return 1
        }
        if tipoTabla == TipoTabla.Portafolio {
            return self.myInsArray.count
        }
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tipoTabla == TipoTabla.Perfil {
            return 93.0
        }
        if tipoTabla == TipoTabla.FAQ {
            return 124.0
        }
        if tipoTabla == TipoTabla.CanjePuntos {
            return 126.0
        }
        return 44.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.expandData[indexPath.section].setValue(String(indexPath.row), forKeyPath: "isSelect")
        self.myTableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            self.expandData[indexPath.section].setValue("1", forKey: "isOpen")
            self.myTableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
        })
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tipoTabla == TipoTabla.Portafolio || tipoTabla == TipoTabla.Cerradas {
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 45))
            let label = UILabel(frame: CGRect(x: 5, y: 9, width: headerView.frame.size.width - 50, height: 27))
            let img = UIImageView(frame: CGRect(x: headerView.frame.size.width-50, y: 9, width: 27, height: 27))
            if self.expandData[section].value(forKey: "isOpen") as! String == "1"{
                img.image = UIImage(named: "drop_down_arrow_black.png")!
            } else {
                img.image = UIImage(named: "drop_up_arrow_black.png")!
            }
            headerView.backgroundColor = front
            headerView.layer.borderWidth = 1.0
            headerView.layer.cornerRadius = 5
            headerView.layer.borderColor = UIColor.black.cgColor
            
            label.text = "\(myInsArray[section])"
            label.textColor = UIColor(red:0/255, green:173/255, blue:250/255, alpha: 1)
            headerView.addSubview(label)
            headerView.addSubview(img)
            headerView.tag = section + 100
            // self.tblFrequency.tableHeaderView = headerView.
            let tapgesture = UITapGestureRecognizer(target: self , action: #selector(self.sectionTapped(_:)))
            headerView.addGestureRecognizer(tapgesture)
            return headerView
        }
        return UIView(frame: CGRect.init(x: 0.0, y: 0.0, width: self.view.frame.width, height: 20.0))
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tipoTabla == TipoTabla.Portafolio {
            return 45
        }
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if tipoTabla == TipoTabla.Portafolio {
            return 10
        }
        return 0
    }
    
    func ponEscribirTexto(_ sender:Int){
        var tituloTexto = "Escribe tu RFC:"
        if sender == 3 {
            tituloTexto = "Escribe tu número de celular:"
        }
        let ac = UIAlertController(title: tituloTexto, message: nil, preferredStyle: .alert)
        //ac.addTextField(configurationHandler: <#T##((UITextField) -> Void)?##((UITextField) -> Void)?##(UITextField) -> Void#>)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Guardar", style: .default) { [unowned ac] _ in
            let answer = ac.textFields![0]
            let res = answer.text?.uppercased()
            var key = "RFC"
            var metodo = "saveRFCMovil"
            if sender == 3 {
                key = "celular"
                metodo = "saveCelularMovil"
            }
            let preferences = UserDefaults.standard
            preferences.set(res, forKey: key)
            
            
            let toks = preferences.string(forKey: "t") ?? ""
            preferences.synchronize()//saveIOS_Token_Movil
            
            let escapedString = toks.replacingOccurrences(of: "+", with: "%2B")
            let chismoso = String(format: "https://biv.mx/%@?t=%@&rfc=%@", metodo,escapedString,res ?? "")
            
            
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
                            self.cargaPerfil()
                        }
                    }
                } catch let parsingError {
                    print("Error", parsingError)
                }
            }
            task.resume()
            
        }
        
        ac.addAction(submitAction)
        
        present(ac, animated: true)
    }
    
    func ponElegirImagen(_ sender:Int){
        imagePicker =  UIImagePickerController()
        tipoImagenGlobal = sender;
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.mediaTypes = ["public.image"]
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    //////////////////
    func uploadFiles(_ imagen: UIImage){
        let preferences = UserDefaults.standard
        let toks = preferences.string(forKey: "t") ?? ""
        let data2: Data = Data()
        let imgData = imagen.jpegData(compressionQuality: 0.69) ?? data2
        /*guard let imgData = imagen.jpegData(compressionQuality: 0.99) else {
            return Data.init(count: 16)
        }*/
        
        if let url = URL(string: "https://biv.mx/uploadFile"){
            var request = URLRequest(url: url)
            let boundary:String = "Boundary-\(UUID().uuidString)"
            
            request.httpMethod = "POST"
            request.timeoutInterval = 15
            request.allHTTPHeaderFields = ["Content-Type": "multipart/form-data; boundary=----\(boundary)"]
          //  var data2: Data = Data()
            //data2 NSData.init(imgData
            
            //data2 = try NSData.init(data: imgData) as Data
            
            
                    var data: Data = Data()
            let str2 = String(tipoImagenGlobal)
            
                     let dic:[String:Any] = [
                        "t":toks,
                        "tipo":str2]
                        //"tipo":tipoImagenGlobal ?? 1]
                     for (key,value) in dic{
                     data.append2("------\(boundary)\r\n")
                     data.append2("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                     data.append2("\(value)\r\n")
                     }
                    data.append2("------\(boundary)\r\n")
            let str3 = String(format: "Name%d", tipoImagenGlobal)
                    //Here you have to change the Content-Type
                    data.append2("Content-Disposition: form-data; name=\"img[]\"; filename=\""+str3+"\"\r\n")
                    //image/jpeg
                    //data.append("Content-Type: application/YourType\r\n\r\n")
                    data.append2("Content-Type: application/jpeg\r\n\r\n")
                  //  data.append(<#T##other: Data##Data#>)
                    data.append(imgData)
                    data.append2("\r\n")
                    data.append2("------\(boundary)--")
                    request.httpBody = data
                
                DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).sync {
                    let config = URLSessionConfiguration.default
                    config.requestCachePolicy = .reloadIgnoringLocalCacheData
                    config.urlCache = nil
                    
                    let session = URLSession.init(configuration: config)
                    
                    //let session = URLSession.shared
                    session.dataTask(with: request, completionHandler: { (dataS, aResponse, error) in
                        if error != nil{
                          //print(error)
                        }else{
                            do{
                                let hola = try JSONSerialization.jsonObject(with: dataS!, options: JSONSerialization.ReadingOptions(rawValue:0)) as! [String:Any]
                                
                                
                                let success = hola["success"] as! Int
                                if success == 1 {
                                    DispatchQueue.main.async {
                                        self.cargaPerfil()
                                    }
                                }
                                
                                
                            } catch let e {
                                print(e)
                            }
                        }
                    }).resume()
                }
            }//do
        //}for
    }
    
    /**/
    //////////////////
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        let originalImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            //imageView.image = originalImage
        uploadFiles(originalImage)
        
        
        
        picker.dismiss(animated: true, completion: nil)
    }
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tipoTabla == TipoTabla.Portafolio {
            let cell = tableView.dequeueReusableCell(withIdentifier: "porCell", for: indexPath as IndexPath) as! PortafolioTableViewCell
           // cell.tipo = indexPath.row
            //cell.delegatePerfil = self
            //cell.actualizaUI()
            //let dataarray = self.expandData[indexPath.section].value(forKey: "data") as! NSArray
            cell.titulo?.text = ""
            cell.valor?.text = ""//dataarray[indexPath.row] as? String
            switch indexPath.row {
            case 0:
                cell.titulo?.text = "\(mySymbolArray[indexPath.section])"
                break;
            case 1:
                cell.titulo?.text = "\(myPcentArray[indexPath.section])"
                break;
            case 2:
                cell.titulo?.text = "\(myOpenRateArray[indexPath.section])"
                break;
            case 3:
                cell.titulo?.text = "\(myPrecioActualArray[indexPath.section])"
                break;
            case 4:
                let ver = (myGanPerArray[indexPath.section] as! NSString).floatValue
                if ver > 0 {
                    cell.valor?.textColor = .green
                } else {
                    cell.valor?.textColor = .red
                }
                cell.valor?.text = "$\(myGanPerArray[indexPath.section])"
                cell.titulo?.text = "Gan. (Pér.):"
                break;
            case 5:
                cell.titulo?.text = "\(myTPArray[indexPath.section])"
                break;
            case 6:
                cell.titulo?.text = "\(mySLArray[indexPath.section])"
                break;
            case 7:
                cell.titulo?.text = "\(myPGArray[indexPath.section])"
                break;
            case 8:
                cell.titulo?.text = "\(myPCArray[indexPath.section])"
                break;
            case 9:
                cell.titulo?.isHidden = true
                cell.valor?.isHidden = true
                cell.delegate = self
                cell.carlosRocha = "\(myCarlosRochaArray[indexPath.section])"
                cell.ins = "\(myLuisMontielArray[indexPath.section])"
                cell.boton?.isHidden = false
                break
            default:
                cell.titulo?.text = "\(myOpenRateArray[indexPath.section])"
                break
            }
        
            
            let selData = self.expandData[indexPath.section].value(forKey: "isSelect") as! NSString
            if selData == "No" {
                //cell.lblImg.image = UIImage(named: "round2")!
            } else {
                if selData.intValue == indexPath.row {
                  //  cell.lblImg.image = UIImage(named: "round1")!
                } else {
                    //cell.lblImg.image = UIImage(named: "round2")!
                }
            }
            return cell
         
        }
        if tipoTabla == TipoTabla.Perfil {
            let cell = tableView.dequeueReusableCell(withIdentifier: "perfilCell", for: indexPath as IndexPath) as! PerfilTableViewCell
            cell.tipo = indexPath.row
            cell.delegatePerfil = self
            cell.actualizaUI()
            return cell
        }
        if tipoTabla == TipoTabla.FAQ {
            let cell = tableView.dequeueReusableCell(withIdentifier: "faqCell", for: indexPath as IndexPath) as! FAQTableViewCell
            cell.pregunta.text = "\(myInsArray[indexPath.row])"
            cell.respuesta.text = "\(myPcentArray[indexPath.row])"
            return cell
        }
        if tipoTabla == TipoTabla.CanjePuntos {
            let cell = tableView.dequeueReusableCell(withIdentifier: "productoCell", for: indexPath as IndexPath) as! ProductosTableViewCell
            cell.puntos = "\(myPGArray[indexPath.section])"
            cell.puntosDisponibles = String(self.puntosDisponibles)
            cell.idProducto = "\(myPCArray[indexPath.section])"
            cell.titulo.text = "\(myPcentArray[indexPath.section])"
            cell.imagen.image = UIImage(named: "\(myInsArray[indexPath.section])")
            cell.requisitos.text = "\(mySymbolArray[indexPath.section])"
            cell.boton.setTitle("\(myOpenRateArray[indexPath.section])", for: .normal)
            cell.delegate = self
            cell.imagen.layer.cornerRadius = 35.0
            cell.boton.layer.cornerRadius = 10.0
             //cell.actualizaUI()
            return cell
        }
        //instrumentos
        let cell = tableView.dequeueReusableCell(withIdentifier: "insCell", for: indexPath as IndexPath) as! InsTableViewCell
        
        cell.delegate = self
        cell.contentView.layer.cornerRadius=10
        cell.fav = "\(myPGArray[indexPath.section])"
        cell.ins = "\(mySymbolArray[indexPath.section])"
        cell.valor?.text = ""
        cell.openRate = self.myOpenRateArray[indexPath.section] as? CGFloat
        cell.backgroundColor = UIColor.init(displayP3Red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        let verPcent = "\(myPcentArray[indexPath.section])"
        
        let pcentFloat = (verPcent as NSString).floatValue
        let twoDecimalPlaces = String(format: "%.2f", pcentFloat)
        
        let string2 = "%"
        if pcentFloat > 0.0 {
            cell.pcent?.textColor = UIColor.green
        }
        cell.pcent?.text = twoDecimalPlaces+string2
        
        
        cell.instrumento?.text = "\(myInsArray[indexPath.section])"
        cell.empiezaAActualizarte()
        cell.actualizaUI()
        return cell
    }
    
}
