import Foundation

extension JSONEncoder {
    public static var pretty: JSONEncoder {
        let prettyEncoder = JSONEncoder()
        prettyEncoder.outputFormatting = [.sortedKeys, .prettyPrinted]
        return prettyEncoder
    }
}

extension JSONDecoder {
    public func formatting(_ dateFormatter: DateFormatter) -> JSONDecoder {
        self.dateDecodingStrategy = .formatted(dateFormatter)
        return self
    }

    public func formatting(_ custom: @escaping (String) -> Date) -> JSONDecoder {
        self.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let string = try container.decode(String.self)
            return custom(string)
        }
        return self
    }
}
