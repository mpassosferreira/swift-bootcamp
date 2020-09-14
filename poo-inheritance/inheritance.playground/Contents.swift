import UIKit

class PaymentMethod {
    
    var active: Bool
    
    init(active: Bool) {
        self.active = active
    }
    
    func process(value: Double) -> Bool {
        print("Processing payment R$ \(value) ...")
        if active {
            print("Payment success.")
            return true
        } else {
            print("Payment failed.")
            return false
        }
    }
    
    func isProccessedOK() -> Bool {
        if active {
            print("Payment success.")
            return true
        } else {
            print("Payment failed.")
            return false
        }
    }
}

class CreditCard: PaymentMethod {
    
    var number: Int
    var cvm: Int
    var expireDate: String
    
    init(number: Int, cvm: Int, expireDate: String, active: Bool) {
        self.number = number
        self.cvm = cvm
        self.expireDate = expireDate
        super.init(active: active)
    }
    
    func printDetail() {
        print(" CreditCard details number: \(self.number) expireDate: \(self.expireDate)")
    }
}

class AccountDebit: PaymentMethod {
    
    var branch: Int
    var account: Int
    
    init(branch: Int, account: Int, active: Bool) {
        self.branch = branch
        self.account = account
        super.init(active: active)
    }
    
    func printDetail() {
        print(" AccountDebit details branch: \(self.branch) account: \(self.account)")
    }
}

class Bill: PaymentMethod {
    
    var barCode: String
    var dueDate: String
    
    init(barCode: String, dueDate: String, active: Bool){
        self.barCode = barCode
        self.dueDate = dueDate
        super.init(active: active)
    }
    
    func printDetail() {
        print(" Bill details barCode: \(self.barCode) dueDate: \(self.dueDate)")
    }
}

class User {
    
    var name: String
    var cpf: String
    var birthDate: String
    var phone: String
    var email: String
    var address: String
    
    init(name: String, cpf: String, birthDate: String, phone: String, email: String, address: String){
        self.name = name
        self.cpf = cpf
        self.birthDate = birthDate
        self.phone = phone
        self.email = email
        self.address = address
        print("New user created.")
    }
    
    func signIn() {
        print("User logged in.")
    }
    
    func updateProfile() {
        print("Profile updated.")
    }
    
    func changeAddress(address: String){
        self.address = address
    }
    
    func changeEmail (email: String){
        self.email = email
    }
    
    func changePhone (phone: String){
        self.phone = phone
    }
}

class Customer: User {
   
    var paymentMethods = [PaymentMethod]()
    var discount: Double?
    
    init(name: String, cpf: String, birthDate: String, phone: String, email: String, address: String, discount: Double) {
        self.discount = discount
        super.init(name: name, cpf: cpf, birthDate: birthDate, phone: phone, email: email, address: address)
        print("Welcome \(name), You got \(discount)% discount to be used in your first Purchase. ")
    }
    
    func addPaymentMethod(paymentMethod: PaymentMethod) {
        print("Adding payment method...")
        paymentMethods.append(paymentMethod)
    }
    
    func getAllPaymentMethods() -> Array<PaymentMethod> {
        print("Well done. You got \(paymentMethods.count) payment methods. Let's use them!")
        return paymentMethods
    }
    
}

class Deliverer: User {
    
    var cnh: Int
    
    init(name: String, cpf: String, birthDate: String, phone: String, email: String, address: String, cnh: Int) {
        self.cnh = cnh
        super.init(name: name, cpf: cpf, birthDate: birthDate, phone: phone, email: email, address: address)
    }
    
    func markPurchaseDelivered(purchase: Purchase) {
        purchase.delivered = true
        print("Purchase Delivered!")
    }
}

class Product {
    
    var id: Int
    var brand: String
    var description: String
    var price: Double
    
    init(id: Int, brand: String, description: String, price: Double){
        self.id = id
        self.brand = brand
        self.description = description
        self.price = price
    }
}

class PurchaseItem {
    
    var product: Product
    var quantity: Int
    
    init(product: Product, quantity: Int){
        self.product = product
        self.quantity = quantity
    }
    
    func updateQuantity(quantity: Int) {
        print("Quantity Updated")
        self.quantity = quantity
    }
}

class Purchase {
    
    var number: Int
    var createDate: String
    var customer: Customer
    var deliveryDate: String?
    var deliverer: Deliverer?
    var delivered: Bool = false
    var purchaseItems = [PurchaseItem]()
    var selectedPaymentMethod: PaymentMethod?
    var isPuchasePaid = false
    
    init(number: Int, customer: Customer, createDate:String) {
        self.number = number
        self.customer = customer
        self.createDate = createDate
    }
    
    func selectPaymentMethod(paymentMethod: PaymentMethod) {
        print("PaymentMethod selected.")
        self.selectedPaymentMethod = paymentMethod
    }
    
    func selectDeliverer(deliverer: Deliverer) {
        print("Deliverer selected.")
        self.deliverer = deliverer
    }
    
    func addPurchaseItem(purchaseItem: PurchaseItem) {
        print(" \(purchaseItem.product.description) \(purchaseItem.product.brand) added.")
        purchaseItems.append(purchaseItem)
    }
    
    func removePurchaseItem(purchaseItem: PurchaseItem) {
        print("PurchaseItem removed")
        purchaseItems = purchaseItems.filter(){$0.product.id != purchaseItem.product.id}
    }
    
    func finish() -> Double {
        var total: Double = 0
        print("------------------")
        print("Pedido: \(self.number)")
        print("------------------")
        print("Your Cart:")
        print(" Quantity Product Brand     Price")
        for i in 0 ..< self.purchaseItems.count {
            print(" \(purchaseItems[i].quantity)        \(purchaseItems[i].product.description)    \(purchaseItems[i].product.brand) R$ \(purchaseItems[i].product.price)")
            total = total + purchaseItems[i].product.price
        }
        print("")
        print("                  Subtotal: R$ \(total)")
        if let gotDiscount = customer.discount {
            let dicountValue = total * (gotDiscount/100)
            print("                  Discount: R$  \(dicountValue)")
            total = total - dicountValue
        }
        print("                     Total: R$ \(total)")
        return total
    }
}


// Here we start testing the concepts.
// Creating a customer, all new customers get 10% discount
let customer = Customer(name: "Felipe", cpf: "123.456.789.00", birthDate: "23/02/1990", phone: "99999-8888", email: "felipe@gmail.com", address: "Av. Paulista, 121", discount: 10.0)
customer.signIn()
customer.updateProfile()

// Setting up payments methods a customer, all new customers get 10% discount
let payment1 = AccountDebit(branch: 9999, account: 99998888, active: false)
customer.addPaymentMethod(paymentMethod: payment1)
payment1.printDetail()
let payment2 = CreditCard(number: 1111, cvm: 111, expireDate: "2021", active: true)
customer.addPaymentMethod(paymentMethod: payment2)
payment2.printDetail()
customer.getAllPaymentMethods()

// Setting up products l methods a customer, all new customers get 10% discount
print("Loading products informations...")
let prod0 = Product(id: 1, brand: "Pilão    ", description: "Café", price: 10.0)
let prod1 = Product(id: 2, brand: "Nespresso", description: "Café", price: 20.0)

// Open a purchase
print("Let's buy some coffee")
let purchase = Purchase(number: 0001, customer: customer, createDate: "09/09/2020")
let purchaseItem1 = PurchaseItem(product: prod0, quantity: 1)
purchase.addPurchaseItem(purchaseItem: purchaseItem1)
let purchaseItem2 = PurchaseItem(product: prod1, quantity: 1)
purchase.addPurchaseItem(purchaseItem: purchaseItem2)
print("Purchase done, let's prepare payment.")
let total = purchase.finish()
print("Let's pay that now!")

// Payment proccess
purchase.selectPaymentMethod(paymentMethod: payment2)
purchase.isPuchasePaid = ((purchase.selectedPaymentMethod?.process(value: total)) != nil)

// Delivery proccess
if purchase.isPuchasePaid {
    print("Searching deliverers for you...")
    let deliverer = Deliverer(name: "Marcio", cpf: "312.456.789.00", birthDate: "21/02/1998", phone: "99999-7777", email: "marcos@gmail.com", address: "Av. Paulista, 212", cnh: 444444)
    purchase.selectDeliverer(deliverer: deliverer)
    deliverer.markPurchaseDelivered(purchase: purchase)
    if purchase.delivered {
        print("Would you consider to give some tips to \(deliverer.name)?")
    }
}
