//
//  GraficaViewController.swift
//  BIV
//
//  Created by Fernando Alonso Pecina on 5/14/19.
//  Copyright © 2019 BIV. All rights reserved.
//

import UIKit
import SwiftCharts
protocol GraficaViewControllerDelegate {
    func cargaAbiertas()
}

class GraficaViewController: UIViewController, CuentaBarDelegate, AbrePosViewControllerDelegate {
    var delegate:GraficaViewControllerDelegate?
    
    @IBOutlet var graficaView: UIView!
    @IBOutlet var valor: UILabel!
    @IBOutlet var pcent: UILabel!
    @IBOutlet var vender: UIButton!
    @IBOutlet var comprar: UIButton!
    @IBOutlet var favButton: UIButton!
    public var ins:String!
    public var fav:String!
    public var displayName:String!
    
    private var customSta: CuentaBar!
    
    var puntos:NSMutableArray!
    var back: UIColor!
    public var openRate: CGFloat!
    func regresate() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            //self.delegate?.cargaAbiertas()
            let preferences = UserDefaults.standard
            preferences.set("-2", forKey: "deboPonerAlgo")
            preferences.synchronize()
            self.navigationController?.popViewController(animated: false)
        }
        
    }
    
    @IBAction func favAction() {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        
        let session = URLSession.init(configuration: config)
        //URLSession.shared.dataTask
        let preferences = UserDefaults.standard
        let toks = preferences.string(forKey: "t") ?? ""
        
        
        let escapedString = toks.replacingOccurrences(of: "+", with: "%2B")
      
        let chismoso = String(format:"https://biv.mx/marcaFavorito_Movil?t=%@&ins=%@",escapedString,self.ins)
        
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
                    if success == 1 {
                        if self.fav=="0" {
                            self.fav = "1"
                        } else {
                            self.fav = "0"
                        }
                        if self.fav == "1" {
                            self.favButton.setImage(UIImage(named: "favL.png"), for: .normal)
                        } else {
                            self.favButton.setImage(UIImage(named: "fav.png"), for: .normal)
                        }
                    }
                   
                    
                }
                
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
    }
    
    var front: UIColor!
    func ponModal() {
        self.navigationController?.navigationBar.tintColor = UIColor.white
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "navigationModalStatus") as! UINavigationController
        nextViewController.modalPresentationStyle = .overCurrentContext
        self.present(nextViewController, animated:true, completion:nil)
    }
    fileprivate var chart: Chart? // arc
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    public func empiezaAActualizarte () {
        
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        
        let session = URLSession.init(configuration: config)
        //URLSession.shared.dataTask
        guard let url = URL(string: "https://biv.mx/instrumentoMovil?instrumento="+self.ins) else {return}
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
                guard let jsonArray = jsonResponse as? [[String: Any]] else {
                    return
                }
                let valorString  = jsonArray[0]["CF"] as? String
                DispatchQueue.main.async {
                    if valorString != self.valor.text {
                        self.valor.layer.backgroundColor = self.back.cgColor
                        UIView.animate(withDuration: 1.0, delay: 0.0, options:[.curveEaseOut, .autoreverse], animations: {
                            self.valor.layer.backgroundColor = self.front.cgColor
                        }, completion:nil)
                    }
                    self.valor.text = valorString
                }
                let valorFloat  = jsonArray[0]["C"] as! CGFloat
                let pcentFloat = ((valorFloat*100) / self.openRate)-100
                //let pcentFloat = (pcentAux as NSString).floatValue
                let twoDecimalPlaces = String(format: "%.2f", pcentFloat)
                let string2 = "%"
                let nuevoPcent = twoDecimalPlaces+string2
                DispatchQueue.main.async {
                    if pcentFloat > 0.0 {
                        self.pcent.textColor = UIColor.green
                    } else {
                        self.pcent.textColor = UIColor.red
                    }
                    if nuevoPcent != self.pcent.text {
                        self.pcent.layer.backgroundColor = self.back.cgColor
                        UIView.animate(withDuration: 1.0, delay: 0.0, options:[.curveEaseOut, .autoreverse], animations: {
                            self.pcent.layer.backgroundColor = self.front.cgColor
                        }, completion:nil)
                        self.pcent.text = nuevoPcent
                    }
                }
                
                
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { // Change `2.0` to the desired number of seconds.
                    self.empiezaAActualizarte()
                }
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
    }
    
    @IBAction func comprarAction () {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "navigationAbrePos") as! UINavigationController
        let abrePos = nextViewController.viewControllers[0] as! AbrePosViewController
        abrePos.tipo = "Comprar"
        abrePos.ins = ins
        abrePos.delegate = self
        abrePos.displayName = displayName
        
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @IBAction func venderAction () {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "navigationAbrePos") as! UINavigationController
        let abrePos = nextViewController.viewControllers[0] as! AbrePosViewController
        abrePos.tipo = "Vender"
        abrePos.ins = ins
        abrePos.displayName = displayName
        
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customSta = CuentaBar()
        customSta.empiezaARecibirUpdates()
        customSta.delegate = self
        self.navigationItem.rightBarButtonItem = customSta
        
        back = UIColor.init(red: 81.0/255.0, green: 78.0/255.0, blue: 101.0/255.0, alpha: 1.0)
        front = UIColor.init(red: 21.0/255.0, green: 20.0/255.0, blue: 43.0/255.0, alpha: 1.0)
        self.title = self.displayName
        let indicador = UIActivityIndicatorView(style: .whiteLarge)
        indicador.center = self.view.center
        indicador.startAnimating()
        graficaView.addSubview(indicador)
        if fav == "1" {
            self.favButton.setImage(UIImage(named: "favL.png"), for: .normal)
        } else {
            self.favButton.setImage(UIImage(named: "fav.png"), for: .normal)
        }
        
        
        valor.text = ""
        pcent.text = ""
        vender.layer.cornerRadius=10
        comprar.layer.cornerRadius=10
        
        //addSlideMenuButton()
        let labelSettings = ChartLabelSettings(font: ExamplesDefaults.labelFont)
        
        var readFormatter = DateFormatter()
        readFormatter.dateFormat = "dd.MM.yyyy"
        
        var displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "MMM dd"
        
        let date = {(str: String) -> Date in
            return readFormatter.date(from: str)!
        }
        
        let calendar = Calendar.current
        puntos = NSMutableArray()
        let dateWithComponents = {(day: Int, month: Int, year: Int) -> Date in
            var components = DateComponents()
            components.day = day
            components.month = month
            components.year = year
            return calendar.date(from: components)!
        }
        
        func filler(_ date: Date) -> ChartAxisValueDate {
            let filler = ChartAxisValueDate(date: date, formatter: displayFormatter)
            filler.hidden = true
            return filler
        }
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
                
                let rate  = jsonArray["rate"] as? [Dictionary<String,Any>]
                //var i = 0
                let limite = (rate?.count ?? 4) / 4
                //print(limite)
                var mayorGlobal = 0.0
                var menorGlobal = 987654.32
                let empiezo = 480
                for i in empiezo...limite {//480
                    let i1 = (i-1)*4
                    let i2 = i1 + 1
                    let i3 = i1 + 2
                    let i4 = i1 + 3
                    var mayor = 0.0
                    var menor = 987654.32
                    let Dt1 = rate?[i1]["Dt"] as! String
                    let dt1v = (Dt1 as NSString).doubleValue
                    let C1 = rate?[i1]["C"] as! Double
                    let C2 = rate?[i2]["C"] as! Double
                    let C3 = rate?[i3]["C"] as! Double
                    let C4 = rate?[i4]["C"] as! Double
                    if C1 <= C2 &&  C1 <= C3 && C1 <= C4 {
                        menor = C1
                    }
                    if C2 <= C2 &&  C2 <= C3 && C2 <= C4 {
                        menor = C2
                    }
                    if C3 <= C2 &&  C3 <= C2 && C3 <= C4 {
                        menor = C3
                    }
                    if C4 <= C2 &&  C4 <= C2 && C4 <= C1 {
                        menor = C4
                    }
                    if C1 >= C2 &&  C1 >= C3 && C1 >= C4 {
                        mayor = C1
                    }
                    if C2 >= C1 &&  C2 >= C3 && C2 >= C4 {
                        mayor = C2
                    }
                    if C3 >= C1 &&  C3 >= C2 && C3 >= C4 {
                        mayor = C3
                    }
                    if C4 >= C1 &&  C4 >= C2 && C4 >= C4 {
                        mayor = C4
                    }
                    if mayor > mayorGlobal {
                        mayorGlobal = mayor
                    }
                    if menor < menorGlobal {
                        menorGlobal = menor
                    }
                    let date = NSDate(timeIntervalSince1970: dt1v )
                    let verQueOnda = ChartPointCandleStick(date: date as Date, formatter: displayFormatter, high: mayor, low: menor, open: C1, close: C4)
                    self.puntos.add(verQueOnda)
                }//for limite
                
                
                let diff = mayorGlobal - menorGlobal
                let cuan = diff / 7.0
                let yValues = stride(from: menorGlobal, through: mayorGlobal, by: cuan).map {ChartAxisValueDouble(Double($0), labelSettings: labelSettings)}
                
                let Dt1 = rate?[(empiezo-1)*4]["Dt"] as! String
                let Dt2000 = rate?[1999]["Dt"] as! String
                
                
                let dt1v = (Dt1 as NSString).doubleValue
                
                let dt2v = (Dt2000 as NSString).doubleValue
                
                let date1 = NSDate(timeIntervalSince1970: dt1v )
                let date2 = NSDate(timeIntervalSince1970: dt2v )
                
                
                let xGeneratorDate = ChartAxisValuesGeneratorDate(unit: .minute, preferredDividers:2, minSpace: 1, maxTextSize: 12)
                let xLabelGeneratorDate = ChartAxisLabelsGeneratorDate(labelSettings: labelSettings, formatter: displayFormatter)
                let firstDate = date1//date("01.10.2015")
                let lastDate = date2//date("31.10.2015")
                
                
                let xModel = ChartAxisModel(lineColor: UIColor.white, firstModelValue: firstDate.timeIntervalSince1970, lastModelValue: lastDate.timeIntervalSince1970, axisTitleLabel: ChartAxisLabel(text: "Fechas", settings: labelSettings), axisValuesGenerator: xGeneratorDate, labelsGenerator: xLabelGeneratorDate, labelsConflictSolver: nil, leadingPadding: ChartAxisPadding.none, trailingPadding: ChartAxisPadding.none, labelSpaceReservationMode: AxisLabelsSpaceReservationMode.current, clipContents: true)
                
              
                
                
                
                
                let yModel = ChartAxisModel(axisValues: yValues, lineColor: UIColor.white, axisTitleLabel: ChartAxisLabel(text: self.displayName, settings: labelSettings.defaultVertical()), labelsConflictSolver: nil, leadingPadding: ChartAxisPadding.none, trailingPadding: ChartAxisPadding.none, labelSpaceReservationMode: AxisLabelsSpaceReservationMode.current, clipContents: true)
                
                
                DispatchQueue.main.async {
                    self.empiezaAActualizarte()
                let chartFrame = ExamplesDefaults.chartFrame(self.graficaView.bounds)
                //chartFrame.size = CGSize(width: chartFrame.size.width , height: chartFrame.size.height-100)
                
                let chartSettings = ExamplesDefaults.chartSettings // for now zoom & pan disabled, layer needs correct scaling mode.
                
                let coordsSpace = ChartCoordsSpaceRightBottomSingleAxis(chartSettings: chartSettings, chartFrame: chartFrame, xModel: xModel, yModel: yModel)
                let (xAxisLayer, yAxisLayer, innerFrame) = (coordsSpace.xAxisLayer, coordsSpace.yAxisLayer, coordsSpace.chartInnerFrame)
                
                let cuaks = self.puntos as! [ChartPointCandleStick]
                
                let chartPointsLineLayer = ChartCandleStickLayer<ChartPointCandleStick>(xAxis: xAxisLayer.axis, yAxis: yAxisLayer.axis, chartPoints: cuaks, itemWidth: Env.iPad ? 10 : 5, strokeWidth: Env.iPad ? 1 : 0.6, increasingColor: UIColor.green, decreasingColor: UIColor.red)
                
                let settings = ChartGuideLinesLayerSettings(linesColor: UIColor.white, linesWidth: ExamplesDefaults.guidelinesWidth)
                let guidelinesLayer = ChartGuideLinesLayer(xAxisLayer: xAxisLayer, yAxisLayer: yAxisLayer, settings: settings)
                
                let dividersSettings =  ChartDividersLayerSettings(linesColor: UIColor.white, linesWidth: ExamplesDefaults.guidelinesWidth, start: Env.iPad ? 7 : 3, end: 0)
                let dividersLayer = ChartDividersLayer(xAxisLayer: xAxisLayer, yAxisLayer: yAxisLayer, settings: dividersSettings)
                
                let chart = Chart(
                    frame: chartFrame,
                    innerFrame: innerFrame,
                    settings: chartSettings,
                    layers: [
                        xAxisLayer,
                        yAxisLayer,
                        guidelinesLayer,
                        dividersLayer,
                        chartPointsLineLayer
                    ]
                )
                
               indicador.removeFromSuperview()
                //let verf = rate?[0]["Dt"] as? String
                //let valorString  = jsonArray["CF"] as? String
                    self.graficaView.addSubview(chart.view)
                    self.chart = chart
                    
                }//dispatch main
                
                
                
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
        
       /* let chartPoints = [
            ChartPointCandleStick(date: date("01.10.2015"), formatter: displayFormatter, high: 40, low: 37, open: 39.5, close: 39),
            ChartPointCandleStick(date: date("02.10.2015"), formatter: displayFormatter, high: 39.8, low: 38, open: 39.5, close: 38.4),
            ChartPointCandleStick(date: date("03.10.2015"), formatter: displayFormatter, high: 43, low: 39, open: 41.5, close: 42.5),
            ChartPointCandleStick(date: date("04.10.2015"), formatter: displayFormatter, high: 48, low: 42, open: 44.6, close: 44.5),
            ChartPointCandleStick(date: date("05.10.2015"), formatter: displayFormatter, high: 45, low: 41.6, open: 43, close: 44),
            ChartPointCandleStick(date: date("06.10.2015"), formatter: displayFormatter, high: 46, low: 42.6, open: 44, close: 46),
            ChartPointCandleStick(date: date("07.10.2015"), formatter: displayFormatter, high: 47.5, low: 41, open: 42, close: 45.5),
            ChartPointCandleStick(date: date("08.10.2015"), formatter: displayFormatter, high: 50, low: 46, open: 46, close: 49),
            ChartPointCandleStick(date: date("09.10.2015"), formatter: displayFormatter, high: 45, low: 41, open: 44, close: 43.5),
            ChartPointCandleStick(date: date("11.10.2015"), formatter: displayFormatter, high: 47, low: 35, open: 45, close: 39),
            ChartPointCandleStick(date: date("12.10.2015"), formatter: displayFormatter, high: 45, low: 33, open: 44, close: 40),
            ChartPointCandleStick(date: date("13.10.2015"), formatter: displayFormatter, high: 43, low: 36, open: 41, close: 38),
            ChartPointCandleStick(date: date("14.10.2015"), formatter: displayFormatter, high: 42, low: 31, open: 38, close: 39),
            ChartPointCandleStick(date: date("15.10.2015"), formatter: displayFormatter, high: 39, low: 34, open: 37, close: 36),
            ChartPointCandleStick(date: date("16.10.2015"), formatter: displayFormatter, high: 35, low: 32, open: 34, close: 33.5),
            ChartPointCandleStick(date: date("17.10.2015"), formatter: displayFormatter, high: 32, low: 29, open: 31.5, close: 31),
            ChartPointCandleStick(date: date("18.10.2015"), formatter: displayFormatter, high: 31, low: 29.5, open: 29.5, close: 30),
            ChartPointCandleStick(date: date("19.10.2015"), formatter: displayFormatter, high: 29, low: 25, open: 25.5, close: 25),
            ChartPointCandleStick(date: date("20.10.2015"), formatter: displayFormatter, high: 28, low: 24, open: 26.7, close: 27.5),
            ChartPointCandleStick(date: date("21.10.2015"), formatter: displayFormatter, high: 28.5, low: 25.3, open: 26, close: 27),
            ChartPointCandleStick(date: date("22.10.2015"), formatter: displayFormatter, high: 30, low: 28, open: 28, close: 30),
            ChartPointCandleStick(date: date("25.10.2015"), formatter: displayFormatter, high: 31, low: 29, open: 31, close: 31),
            ChartPointCandleStick(date: date("26.10.2015"), formatter: displayFormatter, high: 31.5, low: 29.2, open: 29.6, close: 29.6),
            ChartPointCandleStick(date: date("27.10.2015"), formatter: displayFormatter, high: 30, low: 27, open: 29, close: 28.5),
            ChartPointCandleStick(date: date("28.10.2015"), formatter: displayFormatter, high: 32, low: 30, open: 31, close: 30.6),
            ChartPointCandleStick(date: date("29.10.2015"), formatter: displayFormatter, high: 35, low: 31, open: 31, close: 33)
        ]*/
        
       
        
        //  self.chart = chart
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

