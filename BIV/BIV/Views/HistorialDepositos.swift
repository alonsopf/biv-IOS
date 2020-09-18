//
//  HistorialDepositos.swift
//  BIV
//
//  Created by Fernando Alonso Pecina on 5/9/19.
//  Copyright © 2019 BIV. All rights reserved.
//

import UIKit

class HistorialDepositos: UIView, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historialDepositos", for: indexPath as IndexPath) as! HistorialDepositosTableViewCell
        cell.valor.text = "$200"
        cell.fecha.text = "10/05/2019"
        return cell
    }
    
    let kCONTENT_XIB_NAME2 = "HistorialDepositos"
    @IBOutlet var contentView: UIView!
    @IBOutlet var tableView: UITableView!
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
        Bundle.main.loadNibNamed(kCONTENT_XIB_NAME2, owner: self, options: nil)
        contentView.fixInView2(self)
        tableView.register(HistorialDepositosTableViewCell.self, forCellReuseIdentifier: "historialDepositos")
        tableView.register(UINib(nibName: "HistorialDepositosTableViewCell", bundle: nil), forCellReuseIdentifier: "historialDepositos")
    }

}

extension UIView
{
    func fixInView2(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}

