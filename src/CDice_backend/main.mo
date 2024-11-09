import Buffer "mo:base/Buffer";
import Text "mo:base/Text";
import HashMap "mo:base/HashMap";
import Iter "mo:base/Iter";
import Principal "mo:base/Principal";
import Result "mo:base/Result";

actor GameStorage {
    // Define types with shareable data
    public type Card = {
        name : Text;
        element : Text;
        effect : Text;  // Store effect as description text
    };

    public type Dice = {
        name : Text;
        element : Text;
    };

    public type PlayerView = {
        hp : Nat;
        shield : Nat;
        handSize : Nat;
        deck : [Card];
        gold : Nat;
        dicePool : [Dice];
    };

    // Internal player type for storage
    private type PlayerState = {
        var hp : Nat;
        var shield : Nat;
        var handSize : Nat;
        deck : Buffer.Buffer<Card>;
        var gold : Nat;
        dicePool : Buffer.Buffer<Dice>;
    };

    public type Error = {
        #PlayerNotFound;
        #InvalidOperation;
    };

    // Store players by their Principal ID
    private let players = HashMap.HashMap<Principal, PlayerState>(
        10,
        Principal.equal,
        Principal.hash
    );

    // Convert PlayerState to PlayerView
    private func toPlayerView(state : PlayerState) : PlayerView {
        {
            hp = state.hp;
            shield = state.shield;
            handSize = state.handSize;
            deck = Buffer.toArray(state.deck);
            gold = state.gold;
            dicePool = Buffer.toArray(state.dicePool);
        }
    };

    // Initialize a new player
    public shared(msg) func createPlayer() : async Result.Result<PlayerView, Error> {
        let deck = Buffer.Buffer<Card>(10);
        let dicePool = Buffer.Buffer<Dice>(6);
        
        let newPlayer = {
            var hp = 100;
            var shield = 0;
            var handSize = 5;
            deck = deck;
            var gold = 0;
            dicePool = dicePool;
        };
        
        players.put(msg.caller, newPlayer);
        #ok(toPlayerView(newPlayer));
    };

    // Get player data
    public shared query(msg) func getPlayer() : async Result.Result<PlayerView, Error> {
        switch (players.get(msg.caller)) {
            case (?player) { #ok(toPlayerView(player)) };
            case null { #err(#PlayerNotFound) };
        }
    };

    // Add card to player's deck
    public shared(msg) func addCardToDeck(card : Card) : async Result.Result<(), Error> {
        switch (players.get(msg.caller)) {
            case (?player) {
                player.deck.add(card);
                #ok(());
            };
            case null { #err(#PlayerNotFound) };
        }
    };

    // Add dice to player's pool
    public shared(msg) func addDiceToDicePool(dice : Dice) : async Result.Result<(), Error> {
        switch (players.get(msg.caller)) {
            case (?player) {
                player.dicePool.add(dice);
                #ok(())
            };
            case null { #err(#PlayerNotFound) };
        }
    };

    // Update player's gold
    public shared(msg) func updateGold(amount : Nat) : async Result.Result<(), Error> {
        switch (players.get(msg.caller)) {
            case (?player) {
                player.gold := amount;
                #ok(())
            };
            case null { #err(#PlayerNotFound) };
        }
    };

    // Update player's HP
    public shared(msg) func updateHP(amount : Nat) : async Result.Result<(), Error> {
        switch (players.get(msg.caller)) {
            case (?player) {
                player.hp := amount;
                #ok(())
            };
            case null { #err(#PlayerNotFound) };
        }
    };

    // Update player's shield
    public shared(msg) func updateShield(amount : Nat) : async Result.Result<(), Error> {
        switch (players.get(msg.caller)) {
            case (?player) {
                player.shield := amount;
                #ok(())
            };
            case null { #err(#PlayerNotFound) };
        };
    };
};