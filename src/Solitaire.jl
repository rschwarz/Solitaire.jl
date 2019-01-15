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

"Triple cut around the positions of A,B (or B,A)."
function cut_AB(deck::Deck)
    a = findfirst(isequal(A), deck)
    b = findfirst(isequal(B), deck)
    fst, snd = extrema([a, b])
    left, middle, right = deck[1:fst-1], deck[fst:snd], deck[snd+1:end]
    return vcat(right, middle, left)
end

"Cut after count to value of bottom card."
function cut_bottom(deck::Deck)
    bottom = deck[end]
    if bottom in [A, B]
        bottom = 53 # either joker counts the same
    end
    left, middle, right = deck[1:bottom], deck[bottom+1:end-1], deck[end:end]
    return vcat(middle, left, right)
end

"Extract value for key stream out of current state."
function value(deck::Deck)
    top = deck[1]
    if top in [A, B]
        top = 53 # either joker counts the same
    end
    location = (top + 1)
    val = deck[location]
    if val in [A, B]
        val = 53
    end
    return val
end

struct DeckIterator
    state::Deck
end

"Iterate over stream from key generating function."
Base.iterate(deck::DeckIterator) = iterate(deck, deck.state)
function Base.iterate(::DeckIterator, state::Deck)
    # do the steps to advance the state
    state = move_A(state)
    state = move_B(state)
    state = cut_AB(state)
    state = cut_bottom(state)

    # extract value
    v = value(state)

    # never stop iterating!
    return v, state
end

"Cut deck according to given value"
function cut_given(deck::Deck, value::Int)
    @assert 1 ≤ value ≤ length(deck) - 1
    left, middle, right = deck[1:value], deck[value+1:end-1], deck[end:end]
    return vcat(middle, left, right)
end
end
