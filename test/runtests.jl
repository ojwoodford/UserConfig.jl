using UserConfig
using Test

@testset "UserConfig.jl" begin
    # Test the filename conversions
    @test string2key("! User Config Test ^") == "user-config-test"
    @test string2key("! User - Config - Test ^") == "user-config-test"
    @test string2key("123 User Config Test&*!") == "n123-user-config-test"
    @test string2key("%%  123 User Config Test  &*!") == "n123-user-config-test"

    # Test the saving and loading of string data
    teststring = "C:\\mypath/myfile.ext"
    @test localstorestring("user-config-test", "delete") == ""
    @test localstorestring("user-config-test") == ""
    @test localstorestring("user-config-test", teststring) == teststring
    @test localstorestring("user-config-test") == teststring
    @test localstorestring("user-config-test", "delete") == ""

    # Test the saving and loading of abitrary data
    @test localstore("user-config-test", "delete") === nothing
    @test localstore("user-config-test") === nothing
    @test localstore("user-config-test", teststring) == teststring
    @test localstore("user-config-test") == teststring
    testdict = Dict("array"=>[1 2 3; 4 5 6], "string"=>teststring)
    @test localstore("user-config-test", testdict) == testdict
    @test localstore("user-config-test") == testdict
    @test localstore("user-config-test", "delete") === nothing
    @test localstore("user-config-test") === nothing

    # Test the interactive methods with a pre-saved strings
    @test localstorestring("My random test folder", teststring) == teststring
    @test localpath("My random test folder", s->true, true) == teststring
    @test localpath("My random test folder", s->true, false) == teststring
    @test localstorestring("My random test folder", "delete") == ""
end
