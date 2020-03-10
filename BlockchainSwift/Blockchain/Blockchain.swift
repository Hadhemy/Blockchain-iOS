


import Foundation

class Blockchain {

    // an initial empty list to store transactions
    private var currentTransactions: [Transaction] = []

    // an initial empty list to store our blockchain
    var chain: [Block] = []

    init() {
        // Create the genesis block
        createBlock(proof: 100, previousHash: "1".data(using: .utf8))

    }
    
    // Creates a new Block and adds it to the chain
    @discardableResult
    func createBlock(proof: Int, previousHash: Data? = nil) -> Block {
        let prevHash: Data
        if let previousHash = previousHash {
            prevHash = previousHash
        } else {
            // Hash of previous Block
            prevHash = lastBlock().hash()
        }
        let block = Block(index: chain.count+1,
                          timestamp: Date().timeIntervalSince1970,
                          transactions: currentTransactions,
                          proof: proof,
                          previousHash: prevHash)
        
        // Reset the current list of transactions
        currentTransactions = []
        
        chain.append(block)
        
        return block
    }

    // Adds a new transaction to the list of transactions
    @discardableResult
    func createTransaction(sender: String, recipient: String, amount: Int) -> Int {
        // Creates a new transaction to go into the next mined Block
        let transaction = Transaction(sender: sender, recipient: recipient, amount: amount)
        currentTransactions.append(transaction)
        
        // Returns the index of the Block that will hold this transaction
        return lastBlock().index + 1
    }
    
    // Returns the last Block in the chain
    func lastBlock() -> Block {
        guard let last = chain.last else {
            fatalError("The chain should have at least one block as a genesis.")
        }
        return last
    }
    
    // Simple Proof of Work Algorithm:
    //   - Find a number p' such that hash(pp') contains leading 4 zeroes, where p is the previous p'
    //   - p is the previous proof, and p' is the new proof
    class func proofOfWork(lastProof: Int) -> Int {
        var proof: Int = 0
        while !validProof(lastProof: lastProof, proof: proof) {
            proof += 1
        }
        return proof
    }
    
    // Validates the Proof:
    //   - Does hash(last_proof, proof) contain 4 leading zeroes?
    class func validProof(lastProof: Int, proof: Int) -> Bool {
        guard let guess = String("\(lastProof)\(proof)").data(using: .utf8) else {
            fatalError()
        }
        let guess_hash = guess.sha256().hexDigest()
        return guess_hash.prefix(4) == "0000"
    }
}

