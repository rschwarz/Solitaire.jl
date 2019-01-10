module Solitaire

const Card = Int8
const A = Card(53) # large joker
const B = Card(54) # small joker

const Deck = Vector{Card}

"Full deck of cards (with 2 jokers), sorted in increasing order."
sorted_deck() = Deck(1:54)

"Move A one position, with wrap-around."
function move_A(deck::Deck)
    pos = findfirst(isequal(A), deck)
    if pos == length(deck)
        return vcat(deck[1], A, deck[2:end-1])
    else
        return vcat(deck[1:pos-1], deck[pos+1], A, deck[pos+2:end])
    end
end

"Move B two positions, with wrap-around."
function move_B(deck::Deck)
    pos = findfirst(isequal(B), deck)
    if pos == length(deck)
        return vcat(deck[1:2], B, deck[3:end-1])
    elseif pos == length(deck) - 1
        return vcat(deck[1], B, deck[2:pos-1], deck[pos+1:end])
    else
        return vcat(deck[1:pos-1], deck[pos+1:pos+2], B, deck[pos+3:end])
    end
end

end
