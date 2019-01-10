using Test
using Solitaire

@testset "individual moves" begin
    Card = Solitaire.Card
    A = Solitaire.A

    @testset "move_A" begin
        @test Solitaire.move_A(Card[A,1,2]) == Card[1,A,2]
        @test Solitaire.move_A(Card[1,A,2]) == Card[1,2,A]
        @test Solitaire.move_A(Card[1,2,A]) == Card[1,A,2]
    end
end
