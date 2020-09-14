import UIKit

enum ProductTypeEnum {
    case Suit
    case Dress
    case Hat
    
    var product: Product {
        switch self {
            case .Suit: return Product(description: "Suit Armani", price: 400.0)
            case .Dress: return Product(description: "Dress D&G  ", price: 900.0)
            case .Hat: return Product(description: "Hat Lacoste", price: 50.0)
        }
    }
    
    func getPromotion(quantity: Int) -> SellItem? {
        switch self {
        case .Suit:
            return quantity > 2 ? SellItem(product: Product(description: " Discount ", price: -50), quantity: quantity) : nil
        case .Dress:
            return quantity > 4 ? SellItem(product: Product(description: " Véu Free ", price: 0.0), quantity: Int(quantity / 5)) : nil
        case .Hat:
            return quantity > 1 ? SellItem(product: Product(description: " Hat Free ", price: 0.0), quantity: Int(quantity / 2)) : nil
        }
    }
}

class Product{
    var description: String
    var price: Double
    
    init(description: String, price: Double) {
        self.description = description
        self.price = price
    }
}

class SellItem {
    var product: Product
    var quantity: Int
    init(product: Product, quantity: Int){
        self.product = product
        self.quantity = quantity
    }
    func totalByItem() -> Double{
        return product.price * Double(quantity)
    }
}

class Sell {
    var sellTotal: Double = 0
    private var sellItems = [SellItem]()

    func add(productTypeEnum: ProductTypeEnum, quantity: Int) {
        let sellItem = SellItem(product: productTypeEnum.product, quantity: quantity)
        sellItems.append(sellItem)
        if let sellItemPromotion = productTypeEnum.getPromotion(quantity: quantity) {
            sellItems.append(sellItemPromotion)
        }
    }
    
    func printSell() {
        print("\r")
        print("Your Cart:")
        print("------------------")
        for i in 0 ..< self.sellItems.count {
            print("  \(sellItems[i].product.description)\t R$\t \(sellItems[i].product.price)\t x \(sellItems[i].quantity)\t = R$ \(sellItems[i].totalByItem())")
            self.sellTotal += sellItems[i].totalByItem()
        }
        print("------------------")
        print("Purcahse Total: R$ \(self.sellTotal)")
    }
}

class Seller {
    private var name: String
    private var idade: Int
    private var cpf: String
    private var accountBalance: Double
    private var sell = Sell()
    
    init(name: String, idade: Int, cpf: String, accountBalance: Double) {
        self.name = name
        self.idade = idade
        self.cpf = cpf
        self.accountBalance = accountBalance
    }
    
    private func updateAccountBalance(accountBalance: Double) {
        self.accountBalance = self.accountBalance + accountBalance
    }
    
    func getAccountBalance() -> Double {
        return accountBalance
    }
    
    /*
    func vender(quantidadeDePecas: Int, tipoDePeca: String) {
        if quantidadeDePecas >= 3 && tipoDePeca == "Terno" {
            let descontoTerno = terno - (quantidadeDePecas * 50)
            setAccountBalance(accountBalance: self.getAccountBalance() + descontoTerno)
        } else if quantidadeDePecas < 3 && tipoDePeca == "Terno" {
            setAccountBalance(accountBalance: self.getAccountBalance() + (terno * quantidadeDePecas))
        }
        
        if quantidadeDePecas >= 5 && tipoDePeca == "vestido" {
            print("parabens voce ganhou um Véu de brinde")
            vendaVestido = quantidadeDePecas * vestido
            setAccountBalance(accountBalance: self.getAccountBalance() + vendaVestido)
        } else if quantidadeDePecas < 5 && tipoDePeca == "vestido" {
            vendaVestido = quantidadeDePecas * vestido
            setAccountBalance(accountBalance: self.getAccountBalance() + vendaVestido)
        }
        
        if quantidadeDePecas == 2 && tipoDePeca == "bone" {
            print("parabens voce ganhou um boné de brinde")
            setAccountBalance(accountBalance: self.getAccountBalance() + bone)
        }
    }*/
    
    func addSell(productTypeEnum: ProductTypeEnum, quantity: Int) {
        self.sell.add(productTypeEnum: productTypeEnum, quantity: quantity)
    }
    
    func executeSell() {
        self.sell.printSell()
        self.updateAccountBalance(accountBalance: self.sell.sellTotal)
        print("\rAccountBalance: \(self.getAccountBalance())")
        self.sell = Sell()
    }
}

let seller = Seller(name: "Mario", idade: 22, cpf: "123.456.789-00", accountBalance: 0)
print("AccountBalance: \(seller.getAccountBalance())")

seller.addSell(productTypeEnum: ProductTypeEnum.Suit, quantity: 1)
seller.addSell(productTypeEnum: ProductTypeEnum.Dress, quantity: 1)
seller.addSell(productTypeEnum: ProductTypeEnum.Hat, quantity: 1)
seller.executeSell()

seller.addSell(productTypeEnum: ProductTypeEnum.Suit, quantity: 3)
seller.addSell(productTypeEnum: ProductTypeEnum.Dress, quantity: 5)
seller.addSell(productTypeEnum: ProductTypeEnum.Hat, quantity: 4)
seller.executeSell()

