using Test
using Solitaire

@testset "individual moves" begin
    Card = Solitaire.Card
    A = Solitaire.A
    B = Solitaire.B

    @testset "move_A" begin
        @test Solitaire.move_A(Card[A,1,2]) == Card[1,A,2]
        @test Solitaire.move_A(Card[1,A,2]) == Card[1,2,A]
        @test Solitaire.move_A(Card[1,2,A]) == Card[1,A,2]
    end

    @testset "move_B" begin
        @test Solitaire.move_B(Card[B,1,2]) == Card[1,2,B]
        @test Solitaire.move_B(Card[1,B,2]) == Card[1,B,2]
        @test Solitaire.move_B(Card[1,2,B]) == Card[1,2,B]
        @test Solitaire.move_B(Card[1,2,B,3]) == Card[1,B,2,3]
    end

    @testset "cut_AB" begin
        @test Solitaire.cut_AB(Card[A,B]) == Card[A,B]
        @test Solitaire.cut_AB(Card[B,A]) == Card[B,A]
        @test Solitaire.cut_AB(Card[1,A,B]) == Card[A,B,1]
        @test Solitaire.cut_AB(Card[A,1,B]) == Card[A,1,B]
        @test Solitaire.cut_AB(Card[A,B,1]) == Card[1,A,B]
        @test Solitaire.cut_AB(Card[1,2,A,3,4,B,5,6]) == Card[5,6,A,3,4,B,1,2]
        @test Solitaire.cut_AB(Card[1,2,B,3,4,A,5,6]) == Card[5,6,B,3,4,A,1,2]
    end

    @testset "cut_bottom" begin
        @test Solitaire.cut_bottom(Card[4,3,2,1]) == Card[3,2,4,1]
        @test Solitaire.cut_bottom(Card[1,4,3,2]) == Card[3,1,4,2]
        @test Solitaire.cut_bottom(Card[4,1,2,3]) == Card[4,1,2,3]
    end

    @testset "value" begin
        @test Solitaire.value(Card[1, 2, 3]) == 2
        @test Solitaire.value(Card[2, 1, 3]) == 3
        @test Solitaire.value(Card[1, 30, 2]) == 30  # no mod26 yet
        @test Solitaire.value(Card[1, A, 32]) == 53  # no skipping yet
    end

    @testset "cut_given" begin
        @test Solitaire.cut_given(Card[1, 2, 3], 1) == Card[2, 1, 3]
        @test Solitaire.cut_given(Card[1, 2, 3], 2) == Card[1, 2, 3]
        @test Solitaire.cut_given(Card[1, 2, 3, 4], 2) == Card[3, 1, 2, 4]
    end
end

@testset "key generator output" begin
    # reference output
    ref = [4, 49, 10, 53, 24, 8, 51, 44, 6, 4, 33, 20, 39, 19, 34, 42]
    iter = Solitaire.DeckIterator(Solitaire.sorted_deck())
    for t in zip(ref, iter)
        @test t[1] == t[2]
    end
end
