import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            // Görsel URL'sini farklı anahtarlarda arıyoruz
            var imageURLString: String?
            
            // 1. Doğrudan data içindeki "image" anahtarı
            if let url = bestAttemptContent.userInfo["image"] as? String {
                imageURLString = url
            }
            // 2. fcm_options içindeki "image" anahtarı (Firebase standartı)
            else if let fcmOptions = bestAttemptContent.userInfo["fcm_options"] as? [String: Any],
                      let url = fcmOptions["image"] as? String {
                imageURLString = url
            }
            // 3. Bildirim içeriğindeki görsel (eğer varsa)
            else if let url = bestAttemptContent.userInfo["gorsel"] as? String {
                imageURLString = url
            }
            
            // Eğer bir URL bulunduysa indir
            if let urlString = imageURLString, let imageURL = URL(string: urlString) {
                downloadImage(from: imageURL) { (attachment) in
                    if let attachment = attachment {
                        bestAttemptContent.attachments = [attachment]
                    }
                    contentHandler(bestAttemptContent)
                }
            } else {
                // URL yoksa bildirimi olduğu gibi göster
                contentHandler(bestAttemptContent)
            }
        }
    }

    private func downloadImage(from url: URL, completion: @escaping (UNNotificationAttachment?) -> Void) {
        let task = URLSession.shared.downloadTask(with: url) { (location, response, error) in
            guard let location = location else {
                completion(nil)
                return
            }
            
            // Rastgele bir isim ve .jpg uzantısı ile geçici dosya oluştur
            // Bu, URL'de dosya uzantısı olmasa bile iOS'un bunu görsel olarak tanımasını sağlar
            let tmpDirectory = FileManager.default.temporaryDirectory
            let fileName = UUID().uuidString + ".jpg"
            let tmpUrl = tmpDirectory.appendingPathComponent(fileName)
            
            do {
                // Eğer hedefte dosya varsa (ki rastgele isimle imkansız) temizle
                if FileManager.default.fileExists(atPath: tmpUrl.path) {
                    try FileManager.default.removeItem(at: tmpUrl)
                }
                
                try FileManager.default.moveItem(at: location, to: tmpUrl)
                
                // Attachment oluştur
                let attachment = try UNNotificationAttachment(identifier: fileName, url: tmpUrl, options: nil)
                completion(attachment)
            } catch {
                completion(nil)
            }
        }
        task.resume()
    }

    override func serviceExtensionTimeWillExpire() {
        if let contentHandler = contentHandler, let bestAttemptContent = bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
}

