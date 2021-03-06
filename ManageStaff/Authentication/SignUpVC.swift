//
//  SignUpVC.swift
//  ManageStaff
//
//  Created by administrator on 11/28/19.
//  Copyright © 2019 linh. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import Firebase

var imageAvatar:UIImage?
class SignUpVC: UIViewController {

   
    @IBOutlet weak var textfieldEmail: UITextField!
    @IBOutlet weak var textfieldPassword: UITextField!
    @IBOutlet weak var textfieldName: UITextField!
   
    @IBOutlet weak var textfieldPhone: UITextField!
    @IBOutlet weak var imageviewAvatar: UIImageView!
    @IBOutlet weak var textfieldLastName: UITextField!
    @IBOutlet weak var buttonSex: UIButton!
    
    var urlImage = "https://firebasestorage.googleapis.com/v0/b/managestaff-cc156.appspot.com/o/Zjw7LLp3ctNOArBplgmxN8kmjoW2.png?alt=media&token=02a55f39-691b-488a-b15a-a712d36ea484"
    var sex = "Nữ"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        //tap on image
        
        //tap anywhere
        self.dismissKeyboard()
    }
    
    
    @IBAction func tapOnSignUp(_ sender: Any) {
        dismissKeyboardAction()
        //Validate input
        let err = validateInput()
        if !err.isEmpty {
            showError(error: err)
            return
        }
        
        //Create User
        Auth.auth().createUser(withEmail: textfieldEmail.text!, password: textfieldPassword.text!) { (Result, Error) in
            
            //check if error != nil => show error
            if Error != nil {
                self.showError(error: "Failt to create account, try again!")
                return
            }
            
            //store user to database realtime
            
            
            let ref : DatabaseReference!
            ref = Database.database().reference().child("users")
            ref.child(Result!.user.uid).setValue([
                "email": self.textfieldEmail.text!,
                "firstname": self.textfieldName.text!,
                "lastname": self.textfieldLastName.text!,
                "sex": self.sex,
                "phone": self.textfieldPhone.text!,
                "department": "",
                "leaderid": "",
                "role": "Nhân viên",
                "imgurl": self.urlImage,
                "salery": 0
                ])
    
            let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeID") as! ViewController
            homeVC.modalPresentationStyle = .fullScreen
            self.present(homeVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func tapOnSignIn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func tapOnSex(_ sender: Any) {
        if buttonSex.isSelected {
            buttonSex.isSelected = false
            sex = "Nữ"
        }else{
            buttonSex.isSelected = true
            sex = "Nam"
        }
    }
    
    
    
    
    //------FUNCTION HEPLER
    
    func showError(error: String){
       
        
    }
    
    func validateInput() -> String{
        //check empty
        if (textfieldName.text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || textfieldEmail.text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || textfieldPassword.text!.isEmpty || textfieldPhone.text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) {
            return "Please fill all fields!"
        }
        //check email has @
        if !textfieldEmail.text!.contains("@"){
            return "Email is incorrect!"
        }
        
        if !isValidPassword(password: textfieldPassword.text!){
            return """
            Password must contain: 1 number, 1 lower character,
                    1 uppper character and must has at least 8 characters
            """
        }
        //check if phone is not number
        if Int(textfieldPhone.text!) == nil {
            return "Phone must number"
        }
        
        
        return ""
    }
    
    //check password invalid:
    //pass has at least 1 number, 1 lower character, 1 upper character, has at least 8 characters
    func isValidPassword(password: String) -> Bool {
        let passwordRegex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    
    //upload image to cloud
    
    func startLoading(child: SpinnerViewController){
        addChild(child)
        child.view.frame = view.frame
        self.view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    //stop loading view
    func stopLoading(child: SpinnerViewController){
        child.willMove(toParent: nil)
        child.view.removeFromSuperview()
        child.removeFromParent()
    }
    
    
    
    
    func setup(){
        settingForTextField(textfield: textfieldPhone, placeholder: "Điện thoại")
        settingForTextField(textfield: textfieldName, placeholder: "Tên")
        settingForTextField(textfield: textfieldEmail, placeholder: "Email")
        settingForTextField(textfield: textfieldLastName, placeholder: "Họ và tên đệm")
        settingForTextField(textfield: textfieldPassword, placeholder: "Mật khẩu")
        
    }
    
    func settingForTextField(textfield: UITextField, placeholder: String){
        let color = UIColor(red: 187/255, green: 202/255, blue: 215/255, alpha: 1)
        textfield.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: color])
        textfield.addBorder(toSide: .Bottom, withColor: UIColor.white.cgColor, andThickness: 0.7)
    }
    
}


