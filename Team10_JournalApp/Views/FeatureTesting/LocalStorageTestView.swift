//
//  LocalStorageTest.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 12/2/24.
//

import SwiftUI

struct LocalStorageTestView: View {
    @State var loadedUserProfile: UserProfile?
    @State var fetchedSetting: String = "NOTHING"
    @State var toggleVal: Bool = false
    
    var body: some View {
        let uid = loadedUserProfile?.userId ?? "NIL"
        let key = "CatchUp_useCurrLocation_\(uid)"
        
        VStack {
            Text(loadedUserProfile?.email ?? "[NONE]").padding()
            
            Button("toggle") {
                toggleVal.toggle()
            }
            
            Button("Set Use My Location Setting (\(toggleVal)") {
                UserDefaults.standard.set(toggleVal, forKey: key)
            }
            .padding()
            
            Button("Fetch Use My Location Setting") {
                let res = UserDefaults.standard.bool(forKey: key)
                print(res)
                self.fetchedSetting = "\(res)"
            }
            .padding()
            
            Button("Remove Key") {
                UserDefaults.standard.removeObject(forKey: key)
            }
            
            Button("Clear") {
                self.fetchedSetting = "NOTHING"
            }
            .padding()
            
            Text(fetchedSetting)
                .font(.title)
                .padding()
            
        }
    }
}
