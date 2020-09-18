//
//  InsTableViewCell.swift
//  AKSwiftSlideMenu
//
//  Created by Fernando Alonso Pecina on 3/29/19.
//  Copyright © 2019 Kode. All rights reserved.
//

import UIKit
protocol InsTableViewCellDelegate {
    func cargaGraficaInstrumento(_ ins:String, displayName:String, open:CGFloat, fav:String)
}
class InsTableViewCell: UITableViewCell {
    var delegate:InsTableViewCellDelegate?
    
    @IBOutlet var instrumento: UILabel!
    @IBOutlet var valor: UILabel!
    @IBOutlet var pcent: UILabel!
    public var openRate: CGFloat!
    var rate: CGFloat!
    var ins: String!
    var fav: String!
    var back: UIColor!
    var front: UIColor!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        back = UIColor.init(red: 81.0/255.0, green: 78.0/255.0, blue: 101.0/255.0, alpha: 1.0)
        front = UIColor.init(red: 26.0/255.0, green: 22.0/255.0, blue: 53.0/255.0, alpha: 1.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @objc func activaDelegate() {
        delegate?.cargaGraficaInstrumento(ins,displayName: instrumento.text ?? "", open: self.openRate, fav:self.fav)
    }
    public func actualizaUI() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(activaDelegate) )
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        self.addGestureRecognizer(tap)
        
        if instrumento.text?.count ?? 0 > 20 {
            instrumento.font = UIFont.systemFont(ofSize: 12.0)
            instrumento.numberOfLines = 2
            instrumento.text = instrumento.text?.replacingOccurrences(of: "/", with: "/\n")
        }
        /*
        if instrumento.text?.count ?? 0 > 40 {
            instrumento.font = UIFont.systemFont(ofSize: 8.0)
            instrumento.numberOfLines = 2
            instrumento.text = instrumento.text?.replacingOccurrences(of: "/", with: "/\n")
        }*/
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
}
