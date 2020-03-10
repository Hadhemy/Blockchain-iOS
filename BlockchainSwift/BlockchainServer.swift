
//  Blockchain as an API (This should be implemented as an API on a server.)
//  Thanks to:

import Foundation

class BlockchainServer {
    
    let blockchain = Blockchain()

    // '/transactions/new' endpoint
    func send(sender: String, recipient: String, amount: Int) -> Int {
        return blockchain.createTransaction(sender:sender, recipient:recipient, amount:amount)
    }
    
    // '/mine' endpoint
    func mine(recipient: String, completion: ((Block) -> Void)?) {
        // mine in the background
        DispatchQueue.global(qos: .default).async {
            // We run the proof of work algorithm to get the next proof...
          
            let lastProof = self.blockchain.lastBlock().proof
            let proof = Blockchain.proofOfWork(lastProof: lastProof)
            
            // We must receive a reward for finding the proof.
            // The sender is "0" to signify that this node has mined a new coin.
            
            self.blockchain.createTransaction(sender: "0", recipient: recipient, amount: 1)
            
            // Forge the new Block by adding it to the chain
         
            let block = self.blockchain.createBlock(proof: proof)
            
            DispatchQueue.main.async(execute: {
                completion?(block)
            })
        }
    }
    
    // '/chain' endpoint
    func chain() -> [Block] {
        return blockchain.chain
    }
}
