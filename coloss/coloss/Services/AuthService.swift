
import Firebase


protocol AuthService {
    var userID: String? { get }
    var isAnonymous: Bool { get }
    func login(email: String, password: String, completion: @escaping (Result<Bool, Error>) -> ())
   // func loginWithDefaults(completion: @escaping (Result<Bool, Error>) -> ())
    func registrateAnonymous(completion: @escaping (Result<Bool, Error>) -> ())
    func registrate(email: String, password: String, completion: @escaping (Result<Bool, Error>) -> ())
    func linkAnonymous(email: String, password: String, completion: @escaping (Result<Bool, Error>) -> ())
    func logout()
}


enum NetworkError: Error {
  case invalidRequestError(String)
  case transportError(Error)
  case serverError(statusCode: Int)
  case noData
  case decodingError(Error)
  case encodingError(Error)
}

enum AuthError: Error {
    case noAuth
    case encodingError(Error)
}

struct AuthServiceImpl: AuthService {
    
    var userID: String? {
        Auth.auth().currentUser?.uid
        
    }
    
    var isAnonymous: Bool {
        return Auth.auth().currentUser?.isAnonymous ?? false ? true : false
    }
    
    
    func login(email: String, password: String, completion: @escaping (Result<Bool, Error>) -> ()){
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            guard let errorg = error else {
                completion(.success(true))
           //     KeyChain().savePassword(password)
                return
            } 
            completion(.failure(errorg))
        }
    }
    
    func loginWith(credential: Credentials, completion: @escaping (Result<Bool, Error>) -> ()){
//        let defaults = KeyChain()
        if  let user = Auth.auth().currentUser
        {
            let credential = EmailAuthProvider.credential(withEmail: credential.login, password: credential.password)
            user.reauthenticate(with: credential) { (result, error) in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(true))
                }
            }
        } else {
            completion(.success(false))
        }
    }
    
    func registrate(email: String, password: String, completion: @escaping (Result<Bool, Error>) -> ()){
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            guard let error = error else {
              //  KeyChain().savePassword(password)
                completion(.success(true))
                return
            }
           
            completion(.failure(error))
        }
        
    }
    
    func registrateAnonymous(completion: @escaping (Result<Bool, Error>) -> ()){
        Auth.auth().signInAnonymously { authResult, error in
            guard let error = error else {
                completion(.success(true))
                return
            }
            completion(.failure(error))
        }
    }
    
    func linkAnonymous(email: String, password: String, completion: @escaping (Result<Bool, Error>) -> ()){
      if let user = Auth.auth().currentUser {
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        user.link(with: credential, completion: { (newUser, error) in
          if let error = error {
              completion(.failure(error))
          } else {
           //   KeyChain().savePassword(password)
              completion(.success(true))
          }
        })
      } else {
          completion(.success(false))
      }
    }
    
 
    func logout() {
        do {
          try Auth.auth().signOut()
         //   KeyChain().deletePassword()
        } catch (let error) {
            print (error.localizedDescription)
        }
    }
    
    func resetPassword(email: String, completion: @escaping (Result<Bool, Error>) -> ()) {
      Auth.auth().sendPasswordReset(withEmail: email) { error in
        if let error = error {
            completion(.failure(error))
        } else {
            completion(.success(true))
        }
      }
    }
    
    func delete(completion: @escaping (Result<Bool, Error>) -> ()) {
        let user = Auth.auth().currentUser

        user?.delete { error in
          if let error = error {
              completion(.failure(error))
          } else {
        //      KeyChain().deletePassword()
              completion(.success(true))
          }
        }
    }
}


struct Credentials {
        public var login: String
        public var password: String
        
        public init(login: String, password: String) {
            self.login = login
            self.password = password
        }
    }
