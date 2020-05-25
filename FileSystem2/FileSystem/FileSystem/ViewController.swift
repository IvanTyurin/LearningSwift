//
//  ViewController.swift
//  FileSystem
//
//  Created by Ivan Tyurin on 25.05.2020.
//  Copyright © 2020 Ivan Tyurin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let fileManager = FileManager.default
    let tempDir = NSTemporaryDirectory()
    let fileName = "test.txt"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func checkDir() -> String? {
        do {
            let filesInDirectory = try fileManager.contentsOfDirectory(atPath: tempDir)
            let files = filesInDirectory

            if files.count > 0 {
                if files.first == fileName {
                    print(fileName + " found")
                    return files.first
                } else {
                    print(fileName + " not found")
                    return nil
                }
            }
        } catch let error as NSError { print(error) }
        return nil
    }

    @IBAction func createFileButtonTapped(_ sender: UIButton) {
        let path = (tempDir as NSString).appendingPathComponent(fileName)
        let contentsOfFile = "Text string for humans"

        do {
            try contentsOfFile.write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
            print("Lile \(path) created in temp directory")
        } catch let error as NSError { print("File creating error: \(error)") }
    }

    @IBAction func readFileButtonTapped(_ sender: UIButton) {
        let filesDirectory = checkDir() ?? "Empty"
        let path = (tempDir as NSString).appendingPathComponent(filesDirectory)

        do {
            let contentsInFile = try NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue) as String
            print("Content: " + contentsInFile)
        } catch let error as NSError { print(error) }
    }

    @IBAction func deleteFileButtonTapped(_ sender: UIButton) {
        let filesDirectory = checkDir() ?? "Empty"
        do {
            let path = (tempDir as NSString).appendingPathComponent(filesDirectory)
            try fileManager.removeItem(atPath: path)
            print("File deleted!")
        } catch let error as NSError { print(error) }
    }

    @IBAction func showButtonTapped(_ sender: UIButton) {
        let myDirectory = checkDir() ?? "Empty"
        print("Content: \(myDirectory)")
    }
}

