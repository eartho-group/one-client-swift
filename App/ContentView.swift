//
//  ContentView.swift
//  App
//
//  Created by Work on 6/4/22.
//  Copyright © 2022 EarthoOne. All rights reserved.
//

import SwiftUI
import EarthoOne

struct ContentView: View {
    let earthoOne = EarthoOne()
    
    var body: some View {
        HStack {
            Spacer()
            
            Button(
                action: { self.login() },
                label: { Text("Login") }
            )
            Spacer()
            Button(
                action: { self.login() },
                label: { Text("Logout") }
            )
            Spacer()
        }.onOpenURL { URL in
            WebAuthentication.resume(with: URL)
        }
    }
    
    func login() {
        earthoOne.connectWithPopup(
          accessId: "2drlTkv19Alfvu9pEPTP",
          onSuccess: { Credentials in
                        //Send to server
                        Credentials.idToken
              
                        //get user anytime after login
                        let user = earthoOne.getUser()
                        print(user?.displayName)
              
                          //or idtoken
                          let idToken = earthoOne.getIdToken()
              
                    },
          onFailure: { WebAuthError in

          })
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
