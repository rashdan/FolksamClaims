//
//  API.swift
//  AVAudioTest
//
//  Created by Johan Torell on 2021-10-27.
//

import Alamofire
import Foundation

// fileprivate url = "172.29.140.22"
private let url = "localhost"

// MARK: - S2TAnswer

internal struct S2TAnswer: Codable {
    let text: String
    let ner, pos: [Entity]
    let sam: SAMAnswer

    private enum CodingKeys: String, CodingKey { case text, ner, pos, sam }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        if let _ner = try? values.decode([Entity].self, forKey: .ner) {
            ner = _ner
        } else {
            ner = []
        }

        if let _pos = try? values.decode([Entity].self, forKey: .pos) {
            pos = _pos
        } else {
            pos = []
        }

        if let _text = try? values.decode(String.self, forKey: .text) {
            text = _text
        } else {
            text = ""
        }

        if let _sam = try? values.decode(SAMAnswer.self, forKey: .sam) {
            sam = _sam
        } else {
            sam = SAMAnswer()
        }
    }
}

// MARK: - Ner

internal struct Entity: Codable, Hashable {
    let entityGroup: String
    let score: Double
    let word: String
    let start, end: Int

    enum CodingKeys: String, CodingKey {
        case entityGroup = "entity_group"
        case score, word, start, end
    }
}

internal struct SAMAnswer: Codable {
    var triggers: [String] = []
    var flow: String = ""
}

internal class S2TAPI {
    private func getAudioFileURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docDirectory = paths[0]
        let audioFilename = docDirectory.appendingPathComponent("recording.m4a")
        return audioFilename
    }

    func sendRecordedfFile(completionHandler: @escaping (S2TAnswer) -> Void) {
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(self.getAudioFileURL(), withName: "file", fileName: "recording.m4a", mimeType: "application/octet-stream")
        }, to: "http://\(url):8000/file").validate(statusCode: 200 ... 200).responseDecodable(of: S2TAnswer.self) { response in
            guard let value = response.value else {
                print("error?")
                return
            }
            completionHandler(value)
        }
        .uploadProgress { progress in
            print("Upload Progress: \(progress.fractionCompleted)")
        }
    }

//    func send2() {
//        var semaphore = DispatchSemaphore (value: 0)
//
//        let parameters = [
//            [
//                "key": "file",
//                "src": getAudioFileURL().absoluteString,
//                "type": "file"
//            ]] as [[String : Any]]
//
//        let boundary = "Boundary-\(UUID().uuidString)"
//        var body = ""
//        var error: Error? = nil
//        for param in parameters {
//            if param["disabled"] == nil {
//                let paramName = param["key"]!
//                body += "--\(boundary)\r\n"
//                body += "Content-Disposition:form-data; name=\"\(paramName)\""
//                if param["contentType"] != nil {
//                    body += "\r\nContent-Type: \(param["contentType"] as! String)"
//                }
//                let paramType = param["type"] as! String
//                if paramType == "text" {
//                    let paramValue = param["value"] as! String
//                    body += "\r\n\r\n\(paramValue)\r\n"
//                } else {
//                    let paramSrc = param["src"] as! String
//                    do {
//                        let fileData = try NSData(contentsOfFile:paramSrc, options:[]) as Data
//                        let fileContent = String(data: fileData, encoding: .utf8)!
//                        body += "; filename=\"\(paramSrc)\"\r\n"
//                          + "Content-Type: \"content-type header\"\r\n\r\n\(fileContent)\r\n"
//                    } catch(let e) {
//                        print(e)
//                    }
//
//                }
//            }
//        }
//        body += "--\(boundary)--\r\n";
//        let postData = body.data(using: .utf8)
//
//        var request = URLRequest(url: URL(string: "http://127.0.0.1:8000/file")!,timeoutInterval: Double.infinity)
//        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//
//        request.httpMethod = "POST"
//        request.httpBody = postData
//
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data else {
//                print(String(describing: error))
//                semaphore.signal()
//                return
//            }
//            print(String(data: data, encoding: .utf8)!)
//            semaphore.signal()
//        }
//
//        task.resume()
//        semaphore.wait()
//    }
}
