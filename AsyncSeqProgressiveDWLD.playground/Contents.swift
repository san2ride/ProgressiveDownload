import UIKit

extension URL {
    func allLines() async -> Lines {
        Lines(url: self)
    }
}

struct Lines: Sequence {
    
    let url: URL
    
    func makeIterator() -> some IteratorProtocol {
        
        //MARK: downloading the data, split it and create new line. lines creates a subsequence
        let lines = (try? String(contentsOf: url))?.split(separator: "\n") ?? []
        return LinesIterator(lines: lines)
    }
}

struct LinesIterator: IteratorProtocol {
    
    typealias Element = String
    var lines: [String.SubSequence]
    
    //MARK: changing the lines array must be a mutating func
    mutating func next() -> Element? {
        if lines.isEmpty {
            return nil
        }
        return String(lines.removeFirst())
    }
}

let endpointURL = URL(string: "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.csv")!

//MARK: Asynce/Sequence - Unstructured concurrency. No pause, faster.
Task {
    for try await line in endpointURL.lines {
        print(line)
    }
}

/*
//MARK: awaiting for all data to comethrough, then data loads
Task {
    for line in await endpointURL.allLines() {
        print(line)
    }
}
*/
