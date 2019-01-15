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

    @testset "value" begin
        @test Solitaire.value(Card[1, 2, 3]) == 2
        @test Solitaire.value(Card[2, 1, 3]) == 3
        @test Solitaire.value(Card[1, 30, 32]) == 4
        @test Solitaire.value(Card[1, A, 32]) == nothing
    end
end
