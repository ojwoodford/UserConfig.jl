using UserConfig
using Test

@testset "UserConfig.jl" begin
    # Test the filename conversions
    @test string2key("! User Config Test ^") === "user-config-test"
    @test string2key("123 User Config Test&*!") === "n123-user-config-test"

    # Test the saving and loading of data
    teststring = "C:\\mypath/myfile.ext"
    testdict = Dict("array"=>randn(3, 4), "string"=>teststring)
    @test localstore("user-config-test", "delete") === ""
    @test localstore("user-config-test") === ""
    @test localstore("user-config-test", teststring) === teststring
    @test localstore("user-config-test") === teststring
    @test localstore("user-config-test", testdict) == testdict
    @test localstore("user-config-test") == testdict
    @test localstore("user-config-test", "delete") === ""
    @test localstore("user-config-test") === ""

    # Don't test the interactive methods
end
