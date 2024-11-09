import Buffer "mo:base/Buffer";
import Text "mo:base/Text";
import Nat "mo:base/Nat";

actor {
  type Card = {
    name : Text;
    element : Text;
    effect : () -> ();
  };

  type Dice = {
    name : Text;
    element : Text;
  };

  type Player = {
    hp : Nat;
    shield : Nat;
    handSize : Nat;
    deck : Buffer.Buffer<Card>;
    gold : Nat;
    dicePool : Buffer.Buffer<Dice>;
  };

  type Action = () -> ();

  type Character = {
    charactorType : Text;
    hp : Nat;
    shiled : Nat;
    actionList : Buffer.Buffer<Action>;
  };

};