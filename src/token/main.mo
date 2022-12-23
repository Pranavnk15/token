import Principal  "mo:base/Principal";
import HashMap "mo:base/HashMap";
import Debug "mo:base/Debug";
import Iter "mo:base/Iter";



actor Token {

let owner : Principal = Principal.fromText("3vznt-wj2rl-duwvq-xdbup-pz6wu-tcpua-32zhd-jrt5v-uiwt7-yypmg-fqe");
// the tokens that we will first create will be assigned into the owners account that is me.

let totalSupply : Nat = 1000000000;
// it the total supply of the total number of tokens

let symbol : Text = "NOCT";
//IT THE SHORT SYMBOL OF OUR TOKEN FOR LIKE "ETH" FOR "ETHEREUM"

private stable var balanceEntries: [(Principal, Nat)] = [];


private var balances = HashMap.HashMap<Principal, Nat>(1, Principal.equal, Principal.hash);
// balances will give the information that who owns how much of our tokens
// in this we will be using the hashMAps
// in this we provide three inputs the first one is the initial size of the hasahmap
// next input is that how are we going to check the equality of keys that are being inputed 

// balances.put(owner, totalSupply);
//the dot put is going to insert he value which we will supply corresponding value of key
//and if there exits a value then the value is overwritten
// in this we will put all the totalSupply into lesiure balances of the owner

//to check who owns how much of tokens
public query func balanceOf(who: Principal) : async Nat {
    let balance : Nat = switch (balances.get(who)) {
        case null 0 ;
        case (?result) result;
    };

  return balance;
};

public query func getSymbol() : async Text {
    return symbol;
};

public shared(msg) func payOut() : async Text {
   // Debug.print(debug_show(msg.caller));
   if (balances.get(msg.caller) == null) {
    let amount = 10000;
    let result = await transfer(msg.caller, amount);
    return result;

   } else {
    return "Already Claimed";
   }
   
};

public shared(msg) func transfer(to: Principal, amount: Nat) : async Text {
    let fromBalance = await balanceOf(msg.caller);
    if(fromBalance > amount ) {
        let newFromBalance: Nat = fromBalance - amount;
        balances.put(msg.caller, newFromBalance);

        let toBalance = await balanceOf(to);
        let newTOBalance = toBalance + amount;
        balances.put(to, newTOBalance);

        return "Success";
    } else {
        return "Insufficient Funds"
    }
   
};

system func preupgrade() {
    balanceEntries:= Iter.toArray(balances.entries());
};

system func postupgrade() {
    balances := HashMap.fromIter<Principal, Nat>(balanceEntries.vals(), 1, Principal.equal, Principal.hash);
    if(balances.size() < 1) {
        balances.put(owner, totalSupply);
    }
    
};

};