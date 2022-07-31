using UserConfig
using Test

@testset "UserConfig.jl" begin
    # Test the filename conversions
    @test string2key("! User Config Test ^") === "user-config-test"
    @test string2key("! User - Config - Test ^") === "user-config-test"
    @test string2key("123 User Config Test&*!") === "n123-user-config-test"
    @test string2key("%%  123 User Config Test  &*!") === "n123-user-config-test"

    # Test the saving and loading of data
    teststring = "C:\\mypath/myfile.ext"
    testdict = Dict("array"=>randn(3, 4), "string"=>teststring)
    @test localstorestring("user-config-test", "delete") === ""
    @test localstorestring("user-config-test") === ""
    @test localstorestring("user-config-test", teststring) === teststring
    @test localstorestring("user-config-test") === teststring
    @test localstorestring("user-config-test", "delete") === ""
    @test localstore("user-config-test", "delete") === ""
    @test localstore("user-config-test") === ""
    @test localstore("user-config-test", teststring) === teststring
    @test localstore("user-config-test") === teststring
    @test localstore("user-config-test", testdict) == testdict
    @test localstore("user-config-test") == testdict
    @test localstore("user-config-test", "delete") === ""
    @test localstore("user-config-test") === ""

    # Test the interactive methods with a pre-saved strings
    @test localstorestring("My random test folder", teststring) === teststring
    @test localpath("My random test folder", s->true, true) === teststring
    @test localpath("My random test folder", s->true, false) === teststring
    @test localstore("My random test folder", "delete") === ""
end
