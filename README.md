# UserConfig

[![Build Status](https://github.com/ojwoodford/UserConfig.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/ojwoodford/UserConfig.jl/actions/workflows/CI.yml?query=branch%3Amain)

This package provides helper functions to get, store and retrieve user-specific data to/from disk.

The functions are currently:
### localstore
```
    localstore(strname, data)      # Store data
    data = localstore(strname)     # Read data
    localstore(strname, "delete")  # Delete data
```
