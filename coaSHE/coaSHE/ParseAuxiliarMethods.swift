//
//  ParseAuxiliarMethods.swift
//  coaSHE
//
//  Created by Sidney Orlovski Nogueira on 10/26/15.
//  Copyright © 2015 Carolina Bonturi. All rights reserved.
//
import Parse
import Foundation



class ParseAuxiliarMethods {
    
    static let sharedInstance = ParseAuxiliarMethods()
    
    //Retorna todos os elementos da classe especificada pelo parâmetro pclass (string)
    //Pode ser feita ou não uma ordenação no próprio servidor. Para ordenar passam-se 2 argumentos extras:
    // - SortingParameter: Nome da propriedade do objeto que deve ser levado em consideração na ordenação.
    // - ascendingOrder: Um booleano para dizer se a ordenação deve er feita em ordem crescente ou decrescente. (true = crescente)
    // - queryParameter: Parâmetro a ser passado caso queiramos que algum campo específico seja levado em consideração (por exemplo, pertencer à macroclasse 'Linguagem de programação'. Só funciona se a queryKey também for passada.
    // - queryKey: Chave a ser comparada no campo queryParameter. (EX: No campo Número (queryParameter) da classe Casa(pclass), queremos quem tem o número N(queryKey)).
    func retrieveAllFromClass (pclass : String?, queryParameter: String?, queryKey: String?, sortingParameter: String?, ascendingOrder: Bool?, completion: (retrieveObjects: [PFObject]?) -> Void) {
        if (pclass != nil) {
            let query = PFQuery(className:pclass!)
            if (sortingParameter != nil) {
                if (ascendingOrder == false) {
                    query.orderByDescending(sortingParameter!)
                } else {
                    query.orderByAscending(sortingParameter!)
                }
            }
            
            if ((queryParameter != nil) && (queryKey != nil)) {
                query.whereKey(queryParameter!, equalTo: queryKey!)
            }
            
            
            query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
                if error == nil {
                    if (objects != nil) {
                        completion(retrieveObjects: objects)
                    }

                } else {
                    //TODO
                    print ("Nossa, e agora?")
                }
            }
            
        }
    }
    
    
    
    //Método que será utilizado para criar um usuário utilizando o parse. Os campos "Required" serão: username, password e facetime. Os outros campos serão optional.
    //Esses dados serão salvos em um objeto User_Profile. Após a criação do usuário, devemos criar também um objeto com as competências e um objeto com as relações com outros usuários.
    //Parametros: Nome!, Foto?, título profissional?,Localização?, resumo?, username!, senha!, facetime!
    //Retorno: True se foi criado um novo usuário, false caso contrário.
    //TODO: Implementar diferentes tipos de erros quando um determinado
    func createNewUser(nome: String!, foto: UIImage?, titulo_profissional: String?, localizacao: String?, resumo: String?, username: String!, password: String!, facetime: String!, telefone: String?, completion: (Int)  -> Void) {
        
        //Cria um User.
        let new_user = PFUser()
        new_user.username = username
        new_user.password = password
        
        //Cadastra o usuário
        new_user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo["error"] as? NSString
                // Show the errorString somewhere and let the user try again.
                print(errorString)
                
                //Codigo de erro 202 = username já escolhido.
                if (error.code == 202) {
                    completion(202)
                }
                
            } else {
                
                // Hooray! Let them use the app now.
                
                
                //O nosso User tem um objeto da classe User_Profile, onde guardamos as infos como nome, foto, titulo profissional, loc., resumo...
                //Vamos criar esse objeto e colocá-lo no nosso novo usuário.
                let new_profile = PFObject(className: "User_Profile")
                new_profile["nome"] = nome
                new_profile["facetime"] = facetime
                if (telefone != nil) {
                    new_profile["Telefone"] = telefone
                }
                if (titulo_profissional != nil) {
                    new_profile["titulo_profissional"] = titulo_profissional
                }
                if (localizacao != nil) {
                    new_profile["localizacao"] = localizacao
                }
                if (resumo != nil) {
                    new_profile["resumo"] = resumo
                }
                
                let imageData = UIImagePNGRepresentation((foto)!)
                let imageFile = PFFile(name: "image.png", data: imageData!)
                new_profile["foto"] = imageFile
                new_profile.saveInBackgroundWithBlock({ (succeded, error) -> Void in
                    if succeded == true {
                        
                        let user = PFUser.currentUser()!
                        user["user_profile"] = new_profile
                        user.saveInBackgroundWithBlock({ (success, error) -> Void in
                            if (success) {
                                
                            } else {
                                //TODO: CATCH DO ERROR
                            }
                        })
                        
                    } else {
                        //TODO: FAZER O CATCH DE ERROR!
                    }
                })
                
                
                //O nosso User também tem um objeto da classe User_Competencias, onde guardamos as infos sobre as especialidades do usuário...
                //Vamos criar esse objeto e colocá-lo no nosso novo usuário.
                let new_competencias = PFObject(className: "User_Competencias")
                let mutableArray = []
                new_competencias["competencias"] = mutableArray
                new_profile["user_competencias"] = new_competencias
                //Vamos criar um array vazio para salvar no Parse, de modo que quando quisermos adicionar especialidades, vamos adifionar nesse vetor.
                new_profile.saveInBackgroundWithBlock({ (succeded, error) -> Void in
                    if succeded == true {
                        let user = PFUser.currentUser()!
                        user["user_competencias"] = new_competencias
                        user.saveInBackgroundWithBlock({ (success, error) -> Void in
                            if (success) {
                                completion(0)
                            } else {
                                //TODO:CATCH DO ERRO
                            }
                            
                        })
                        
                    } else {
                        //TODO: CATCH DO ERRO
                    }
                })
                
            }
        }
        
    }
    
    /// TODO: Verificar se userName e senha batem com o parse e fazer login
    static func isValidUser(userName: String, userKey: String) -> Bool {
        return true
    }
    
    
}