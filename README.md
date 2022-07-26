# UserConfig

[![Build Status](https://github.com/ojwoodford/UserConfig.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/ojwoodford/UserConfig.jl/actions/workflows/CI.yml?query=branch%3Amain)

This package provides helper functions to get, store and retrieve user-specific data to/from disk. All data is stored in the `[HOME]/.julia/config/` folder.

The functions are currently:
### string2key
```julia
    key = string2key(string)
```
A utility function to convert a string to something suitable as a human-readable key, variable name or filename, by removing spaces and special characters. These keys are used as filenames by the functions below.

### localstore
```julia
    localstore(strname, data)      # Store data
    data = localstore(strname)     # Read data
    localstore(strname, "delete")  # Delete data
```
Store and get user data defined by `strname`. Data can be of any type, and is stored in a .jld2 file, the filename of which is `string2key(strname).jld2`; `strname` should therefore be a suitably unique string.

### localstorestring
```julia
    localstorestring(strname, strin)     # Store data
    strout = localstorestring(strname)   # Read data
    localstorestring(strname, "delete")  # Delete data
```
Store and get a user string defined by `strname`. The string is stored in a .txt file, the filename of which is `string2key(strname).txt`; `strname` should therefore be a suitably unique string.

### localpath
```julia
    path = localpath(title, checkfun, isfolder=false)
```
Get the path to a local file or folder (if `isfolder` is true), and ask the user if they haven't given it before. `checkfun(path)` is run, and only returns the path if true. The path is stored in a .txt file, the filename of which is `string2key(title).txt`; `title` should therefore be a suitably unique string.

### localstring
```julia
    strout = localstring(title, checkfun=s->true)
```
Get a user specific string (e.g. their Github username), and ask the user if they haven't given it before. checkfun(string) is run, and only returns the string if true. The string is stored in a .txt file, the filename of which is `string2key(title).txt`; `title` should therefore be a suitably unique string.


