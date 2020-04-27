//
//  ViewController.swift
//  ARCLearning
//
//  Created by Ivan Tyurin on 21.04.2020.
//  Copyright © 2020 Ivan Tyurin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
	override func viewDidLoad() {
        super.viewDidLoad()
        
		runScenario()
    }
	
	func runScenario() {
		let user = User("Jon")
		let iPhone = Phone(model: "iPhone XS2")
		let subscription = CarrierSubscription(
			name: "TeTePhone",
			countryCode: "0032",
			number: "88005553535",
			user: user)
		
		user.add(iPhone)
		iPhone.provision(carrierSubscription: subscription)
		
		print(subscription.completeNumber)
		
		let greetingMaker: () -> String
		do {
			let mermaid = WWDCGreeting(who: "caffeinated mermaid")
			greetingMaker = mermaid.greetingMaker
		}

		print(greetingMaker())
	}

}

class User {
	let name: String
	var subsciptions: [CarrierSubscription] = []
	private(set) var phones: [Phone] = []
	
	func add(_ phone: Phone) {
		phones.append(phone)
		phone.owner = self
	}
	
	init(_ name: String) {
		self.name = name
		print("User \(name) created!")
	}
	
	deinit {
		print("Deallocating user: \(name)")
	}
}

class Phone {
	let model: String
	var carrierSubscription: CarrierSubscription?
	weak var owner: User?
	
	func provision(carrierSubscription: CarrierSubscription) {
		self.carrierSubscription = carrierSubscription
	}
	
	func decomission() {
		carrierSubscription = nil
	}
	
	init(model: String) {
		self.model = model
		print("Phone model is \(model)")
	}
	
	deinit {
		print("Phone \(model) deallocated")
	}
}

class CarrierSubscription {
	let name: String
	let countryCode: String
	let number: String
	unowned let user: User
	lazy var completeNumber: () -> String = { [unowned self] in
		return self.countryCode + " " + self.number
	}
	
	init(name: String, countryCode: String, number: String, user: User) {
		self.name = name
		self.countryCode = countryCode
		self.number = number
		self.user = user
		
		user.subsciptions.append(self)
		
		print("CarrierSubscription \(name) is installed")
	}
	
	deinit {
		print("Deallocating CarrierSubscription named: \(name)")
	}
}

class WWDCGreeting {
	let who: String
	
	init(who: String) {
		self.who = who
	}
	
	lazy var greetingMaker: () -> String = { [weak self] in
		guard let self = self else { return "No greetingavailable"}
		return "Hello \(self.who)."
	}
}
