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

"Iterates over deck states."
struct DeckIterator
    state::Deck
end

function Base.iterate(iter::DeckIterator, state::Deck=iter.state)
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

"Generate deck from pass phrase"
function initialize(passphrase::String)
    # convert passphrase to numerical array
    values = [letter - 'A' + 1 for letter in uppercase(passphrase)]
    if !all(1 .≤ values .≤ 26)
        error("Invalid passphrase: Only letters (A-Z) are supported.")
    end

    # start with sorted deck
    deck = sorted_deck()

    # now go through Solitaire steps, but interleave another cut
    iter = DeckIterator(deck)
    for value in values
        _, deck = iterate(iter, deck)
        deck = cut_given(deck, value)
    end

    return deck
end

"Iterates over key stream."
struct KeyGenerator
    iter::DeckIterator
end

function Base.iterate(keygen::KeyGenerator, iter::DeckIterator=keygen.iter)
    value, state = iterate(iter)
    while value in [A, B]
        # skip invalid values (from jokers)
        value, state = iterate(iter, state)
    end
    return value, DeckIterator(state)
end

"Encrypt cleartext with given deck."
function encrypt(cleartext::String, deck::Deck)
    keygen = KeyGenerator(DeckIterator(deck))
    clearnum = [letter - 'A' + 1 for letter in uppercase(cleartext)]
    ciphernum = Int[]
    for t in zip(clearnum, keygen)
        c = t[1] + t[2]
        while c > 26
            c -= 26
        end
        push!(ciphernum, c)
    end
    return String('A' .+ (ciphernum .- 1))
end

"Encrypt cleartext with given passphrase."
function encrypt(cleartext::String, passphrase::String)
    return encrypt(cleartext, initialize(passphrase))
end

"Decrypt ciphertext with given deck."
function decrypt(ciphertext::String, deck::Deck)
    keygen = KeyGenerator(DeckIterator(deck))
    ciphernum = [letter - 'A' + 1 for letter in uppercase(ciphertext)]
    clearnum = Int[]
    for t in zip(ciphernum, keygen)
        c = t[1] - t[2] + 52
        while c > 26
            c -= 26
        end
        push!(clearnum, c)
    end
    return String('A' .+ (clearnum .- 1))
end

"Decrypt ciphertext with given passphrase."
function decrypt(ciphertext::String, passphrase::String)
    return decrypt(ciphertext, initialize(passphrase))
end


end
