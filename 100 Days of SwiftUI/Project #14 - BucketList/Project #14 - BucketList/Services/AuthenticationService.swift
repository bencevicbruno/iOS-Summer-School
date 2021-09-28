//
//  AuthenticationService.swift
//  Project #14 - BucketList
//
//  Created by Bruno Benčević on 9/28/21.
//

import Foundation
import LocalAuthentication

class AuthenticationService {
    func authenticate(onSuccess: @escaping () -> Void, onFail: @escaping (String) -> Void) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "We need to steal, no, unlock your data.\nMessage provided by Facebook :)"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authError in
                if success {
                    onSuccess()
                } else {
                    onFail(authError?.localizedDescription ?? "Unknown error.")
                }
            }
        } else {
            onFail(error?.localizedDescription ?? "Unknown error.")
        }
    }
}
