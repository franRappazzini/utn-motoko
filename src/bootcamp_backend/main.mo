import Text "mo:base/Text";
import Principal "mo:base/Principal";
import TrieMap "mo:base/TrieMap";
import Iter "mo:base/Iter";

actor {

  // type alias
  type ID = Principal;

  // type object
  type User = {
    principal : ID;
    username : Text;
    // status : Status;
  };

  // type variant = enum
  type Status = {
    #Aprobado;
    #Desaprobado;
  };

  // key - value = hash map
  let users = TrieMap.TrieMap<ID, User>(Principal.equal, Principal.hash);
  // () => tupla
  stable var usersStable : [(ID, User)] = [];

  public shared (msg) func createUser(username : Text) : async User {

    // if (users.get(msg.caller) != null) {
    // return users.get(msg.caller);
    // };

    switch (users.get(msg.caller)) {
      case (null) {
        // hacer algo = crear user
      };
      case (?u) {
        return u;
      };
    };

    let user : User = {
      principal = msg.caller;
      username = username;
    };

    users.put(msg.caller, user);
    return user;
  };

  public query func getUser(principal : Principal) : async ?User {
    return users.get(principal);
  };

  public query func getUsers() : async [User] {
    let vals = users.vals();
    return Iter.toArray<User>(vals);
  };

  public query func greet(name : Text) : async Text {
    return "Hello, " # name # "!";
  };

  // ---- system methods ----
  system func preupgrade() {
    usersStable := Iter.toArray<(ID, User)>(users.entries());
  };

  system func postupgrade() {
    for (item in usersStable.vals()) {
      users.put(item.0, item.1);
    };
  };

};
