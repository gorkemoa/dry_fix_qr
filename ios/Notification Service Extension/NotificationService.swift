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
            
            let tmpDirectory = NSTemporaryDirectory()
            let tmpFile = "file://".appending(tmpDirectory).appending(url.lastPathComponent)
            let tmpUrl = URL(string: tmpFile)!
            
            try? FileManager.default.moveItem(at: location, to: tmpUrl)
            
            if let attachment = try? UNNotificationAttachment(identifier: "", url: tmpUrl, options: nil) {
                completion(attachment)
            } else {
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
