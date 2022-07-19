module UserConfig
export localstore, string2key, localpath, localstring 

import NativeFileDialog, JLD2 

"""
    localstore(strname, data)      # Store data
    data = localstore(strname)     # Read data
    localstore(strname, "delete")  # Delete data

Store and get user config data defined by `strname`.
"""
function localstore(strname::String, data::Any="")
    fname = joinpath(DEPOT_PATH[1], "config", string(strname, ".jld2"))
    if data === ""
        # Reading the data
        if isfile(fname)
            try
                return JLD2.read(JLD2.jldopen(fname, "r"), "data")
            catch err
                printstyled(err)
            end
        end
    elseif data === "delete"
        rm(fname, force=true)
    else
        # Writing the data
        try
            dname = dirname(fname)
            if !isdir(dname)
                mkdir(dname)
            end
            JLD2.jldsave(fname; data)
            return data
        catch err
            printstyled(err)
        end
    end
    # Failure case
    return ""
end

"""
    key = string2key(string)

Convert a string to something suitable as a human-readable key, by removing spaces and special characters.
"""
function string2key(title::String)
    key = lowercase(title)                   # Make lowercase
    key = replace(key, r"[^(a-z0-9- )]"=>"") # Remove special characters
    key = strip(key)                         # Remove leading and trailing whitespace
    key = replace(key, " "=>"-")             # Convert spaces to hyphens
    key = replace(key, r"-+"=>"-")           # Remove multiple hyphens
    if '0' <= key[1] <= '9'                  # If the string starts with a digit
        key = string('n', key)                  # Prefix with an 'n'
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
    fname = string2key(title)
    while true
        # Get the stored string
        strout = localstore(fname)
        if checkfun(strout)
            return strout
        end
        # Ask the user for the path
        if isfolder
            strout = NativeFileDialog.pick_folder(string("Select the ", title, " folder"))
            if !isdir(strout)
                throw(DomainError("directory not selected"))
            end
        else
            strout = NativeFileDialog.pick_file(string("Select the ", title, " file"))
            if !isfile(strout)
                throw(DomainError("file not selected"))
            end
        end
        if isempty(localstore(fname, strout))
            throw(DomainError("unable to store string"))
        end
    end
end

"""
    string = localstring(title, checkfun=s->true)

Get a user specific string, and ask the user if they haven't given it before.
checkfun(string) is run, and only returns the string if true.
"""
function localstring(title::String, checkfun::Function=s->true)
    fname = string2key(title)
    while true
        # Get the stored string
        strout = localstore(fname)
        if !isempty(strout) && checkfun(strout)
            return strout
        end
        # Ask the user for the string
        println("Please enter your ", title, ":")
        strout = readline()
        if isempty(localstore(fname, strout))
            throw(DomainError("unable to store string"))
        end
    end
end

end
