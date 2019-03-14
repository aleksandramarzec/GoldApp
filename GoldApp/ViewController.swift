//
//  ViewController.swift
//  GoldApp
//
//  Created by AIR on 12.03.2019.
//  Copyright © 2019 AIR. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let baseURL = "https://xml.dgcsc.org/samples/SampleGoldJBE.json"
    
    let currencyArray = ["AUD", "BRL", "CHF", "CAD", "CNY", "COP", "GBP", "HKD", "IDR", "INR", "JPY", "KWD", "MXN", "MYR", "NZD", "PEN", "PHP", "RUB", "SEK", "SGD", "TRY", "USD", "VUV", "ZAR"]
    
    var currencySelected = ""
    let currencySymbol = ["ƒ", "£", "RD$", "$", "Q", "Ft", "﷼", "₪", "J$", "$", "C$", "₦", "zł", "lej", "Дин", "₨", "CHF", "$U", "₫", "dgj", "₴", "₭", "cos", "cos2" ]
    var finalURL = ""
    
    @IBOutlet weak var goldInPriceLabel: UILabel!
    
    @IBOutlet var currencyPicker: UIPickerView!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        finalURL = baseURL
        print(finalURL)
        currencySelected = currencyArray[row]
        getGoldData(url: finalURL)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
    }
    
    func getGoldData(url: String) {
        
        Alamofire.request(url, method: .get)
        .responseJSON { response in
            if response.result.isSuccess {
                print("Yes, we have it, Got the gold data")
                let goldJSON:JSON = JSON(response.result.value!)
                let cos = goldJSON["GoldPrice"].dictionary
                let cos2 = cos?["\(self.currencySelected)"]?.dictionary
                let cos3 = cos2?["bid"]?.string
                self.updateGoldData(name: cos3)
            } else {
                print("Error: \(String(describing: response.result.error))")
                self.goldInPriceLabel.text = "Connection Issue"
            }
        }
    }
    
    func updateGoldData(name: String?) {
        if let goldResult = name {
            goldInPriceLabel.text = "\(currencySelected)\(goldResult)"
        } else {
            goldInPriceLabel.text = "Price Unavaliable"
        
        }
    }
}




