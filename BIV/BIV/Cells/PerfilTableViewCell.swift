//
//  PerfilTableViewCell.swift
//  BIV
//
//  Created by Fernando Alonso Pecina on 4/5/19.
//  Copyright © 2019 BIV. All rights reserved.
//

import UIKit
protocol PerfilTableViewCellDelegate {
    
    func ponElegirImagen(_ sender:Int)
    func ponEscribirTexto(_ sender:Int)
}
class PerfilTableViewCell: UITableViewCell {
    @IBOutlet var titulo: UILabel!
    @IBOutlet var valor: UILabel!
    @IBOutlet var icono: UIImageView!
    @IBOutlet var boton: UIButton!
    public var tipo: Int!
    
   
    
    var delegatePerfil:PerfilTableViewCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    public func actualizaUI() {
        // Initialization code
        let preferences = UserDefaults.standard
        var key: String!
        key = ""
        if tipo == 0 {
            titulo.text="Su nombre:"
            icono.image = UIImage.init(named: "nombre.png")
            key = "nombre"
        }
        if tipo == 1 {
            icono.image = UIImage.init(named: "correo.png")
            titulo.text="Su correo electrónico:"
            key = "correo"
            boton.isHidden = true
        }
        if tipo == 2 {
            titulo.text="Su dirección:"
            icono.image = UIImage.init(named: "direccion.png")
            key = "direccion"
        }
        if tipo == 3 {
            titulo.text="Su número de celular:"
            icono.image = UIImage.init(named: "telefono.png")
            key = "celular"
        }
        if tipo == 4 {
            titulo.text="Su CLABE:"
            icono.image = UIImage.init(named: "clabe.png")
            key = "CLABE"
        }
        if tipo == 5 {
            titulo.text="Su RFC:"
            icono.image = UIImage.init(named: "rfc.png")
            key = "RFC"
        }
        let keyValue = preferences.string(forKey: key) ?? ""
        valor.text = keyValue
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func editarFunction(sender: UIButton) {
        if tipo == 0 || tipo == 2 || tipo == 4 {//nombre, direccion clabe
            delegatePerfil?.ponElegirImagen(tipo)
        } else if tipo == 3 || tipo == 5 { //celular, rfc
            delegatePerfil?.ponEscribirTexto(tipo)
        }
    }
    
    
}
