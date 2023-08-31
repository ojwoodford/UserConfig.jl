module UserConfig
export localstore, localstorestring, string2key, localpath, localstring 

import JLD2 

"""
    localstore(strname, data)      # Store data
    data = localstore(strname)     # Read data
    localstore(strname, "delete")  # Delete data

Store and get user config data defined by `strname`.
"""
function localstore(strname::String, data::Any=nothing)
    fname = joinpath(DEPOT_PATH[1], "config", string(string2key(strname), ".jld2"))
    if isnothing(data)
        # Reading the data
        if isfile(fname)
            return JLD2.read(JLD2.jldopen(fname, "r"), "data")
        end
    elseif data == "delete"
        # Delete the file
        rm(fname, force=true)
    else
        # Writing the data
        dname = dirname(fname)
        if !isdir(dname)
            # Create the directory
            mkdir(dname)
        else
            # Delete any existing file (required for Julia 1.6)
            rm(fname, force=true)
        end
        JLD2.jldsave(fname; data)
        return data
    end
    # Default if file doesn't exist (or was deleted)
    return nothing
end

"""
    localstorestring(strname, strin)      # Store string
    strout = localstorestring(strname)    # Read string
    localstorestring(strname, "delete")   # Delete data

Store and get user config string defined by `strname`.
"""
function localstorestring(strname::String, strin::String="")::String
    fname = joinpath(DEPOT_PATH[1], "config", string(string2key(strname), ".txt"))
    
    if strin == ""
        if !isfile(fname)
            return ""
        end

        # Reading the data
        strout = open(fname, "r") do file
            read(file, String)
        end
        return strout
    end

    if strin == "delete"
        # Delete the file
        rm(fname, force=true)
        return ""
    end

    # Writing the data
    dname = dirname(fname)
    if !isdir(dname)
        mkdir(dname)
    end
    open(fname, "w") do file
        write(file, strin)
    end
    return strin
end

"""
    key = string2key(string)

Convert a string to something suitable as a human-readable key, variable name or filename, by removing spaces and special characters.
"""
function string2key(title::String)
    key = lowercase(title)                   # Make lowercase
    key = replace(key, r"[^(a-z0-9- )]"=>"") # Remove special characters
    key = strip(key)                         # Remove leading and trailing whitespace
    key = replace(key, " "=>"-")             # Convert spaces to hyphens
    key = replace(key, r"-+"=>"-")           # Remove multiple hyphens
    if '0' <= key[1] <= '9'                  # If the string starts with a digit
        key = string('n', key)               # Prefix with an 'n'
    else
        key = string(key)
    end
    return key
end

"""
    path = localpath(title, checkfun, isfolder=false)

Get the path to a local file or folder (if isfolder is true), and ask the user if they haven't given it before.
checkfun(path) is run, and only returns the path if true.
"""
function localpath(title::String, checkfun::Function, isfolder::Bool=false)
    while true
        # Get the stored string
        strout = localstorestring(title)
        if checkfun(strout)
            return strout
        end
        # Ask the user for the path
        if isfolder
            println(string("Enter the complete path to the ", title, " folder:"))
            strout = readline()
            if !isdir(strout)
                throw(DomainError("directory path not entered"))
            end
        else
            println(string("Enter the complete path to the ", title, " file:"))
            strout = readline()
            if !isfile(strout)
                throw(DomainError("file path not entered"))
            end
        end
        if isempty(localstorestring(title, strout))
            throw(DomainError("unable to store string"))
        end
    end
end

"""
    strout = localstring(title, checkfun=s->true)

Get a user specific string, and ask the user if they haven't given it before.
checkfun(string) is run, and only returns the string if true.
"""
function localstring(title::String, checkfun::Function=s->true)
    while true
        # Get the stored string
        strout = localstorestring(title)
        if !isempty(strout) && checkfun(strout)
            return strout
        end
        # Ask the user for the string
        println("Please enter your ", title, ":")
        strout = readline()
        if isempty(localstorestring(title, strout))
            throw(DomainError("unable to store string"))
        end
    end
end

end
