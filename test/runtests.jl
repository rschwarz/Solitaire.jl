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
end
