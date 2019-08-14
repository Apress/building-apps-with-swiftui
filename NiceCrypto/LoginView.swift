//
//  LoginView.swift
//  NiceCrypto
//
//  Created by Mehul Mohan on 17/07/19.
//  Copyright © 2019 Mehul Mohan. All rights reserved.
//

import SwiftUI
import Combine

struct ServerMessage: Decodable {
    let status, message: String
}

class HttpAuth: BindableObject {
    var didChange = PassthroughSubject<HttpAuth, Never>()
    
    var authenticated = false {
        didSet {
            didChange.send(self)
        }
    }
    
    func checkDetails(username: String, password: String) {
        guard let url = URL(string: "https://ef68c556.ngrok.io/login") else { return }
        
        let body = ["username": username, "password": password]
        
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = finalBody
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            
            let finalData = try! JSONDecoder().decode(ServerMessage.self, from: data)
            
            if finalData.status == "ok" {
                DispatchQueue.main.async {
                    self.authenticated = true
                }
            }
        }.resume()
    }
}

struct RootView: View {
    
    @State private var manager = HttpAuth()
    
    var body: some View {
        VStack {
            if manager.authenticated {
                ContentView()
            } else {
                LoginView(manager: $manager)
            }
        }
    }
}

struct LoginView : View {
    
    @State private var username: String = ""
    @State private var password: String = ""
    
    @Binding var manager: HttpAuth
    
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Your username", text: $username)
                SecureField("Your Password", text: $password)
                
                HStack {
                    Spacer()
                    Button(action: {
                        self.manager.checkDetails(username: self.username, password: self.password)
                    }) {
                        Text("Login")
                            .color(Color.white)
                            .padding([.trailing, .leading], 20)
                            .padding([.top, .bottom], 15)
                            .background(Color.red)
                            .cornerRadius(10)
                        
                        
                    }
                    Spacer()
                }
            }.navigationBarTitle(Text("NiceCrypto"))
        }
    }
}
