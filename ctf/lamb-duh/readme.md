## lamb-duh

Zeek's scripting language supports anonymous functions, also called closures or lambda functions. Inspecting "information about all global identifiers" one could find a few identifiers for scriptland lambda functions by their v$value. Quite a few lambda function included in the base scripts begin with "lambda_<RANDOM_HASH>" where RANDOM_HASH is a, surprise!, random hash value. With each invocation of Zeek, a lambda function gets a new random name. In fact, this is how those names are generated: https://github.com/zeek/zeek/commit/a1d8a21005cede3ca9655f9795c4e198acb64c89

    for ( ; ; )
        {
        uint64_t h[2];
        internal_md5(d.Bytes(), d.Len(), reinterpret_cast<unsigned char*>(h));

        my_name = "lambda_<" + std::to_string(h[0]) + ">";
        auto fullname = make_full_var_name(current_module.data(), my_name.data());
        auto id = global_scope()->Lookup(fullname.data());

        if ( id )
            // Just try again to make a unique lambda name.  If two peer
            // processes need to agree on the same lambda name, this assumes
            // they're loading the same scripts and thus have the same hash
            // collisions.
            d.Add(" ");
        else
            break;
        }

Why does this happen? For some reason that requires peer Zeek processes to generate unique names for the same lambda function.

The flag of this challenge is the return value of a certain lambda function when passed the value 5 (a count, not an int). The certain lambda function I'm interested in has a body (including it's opening, "{", and closing, "}", braces) with a sha256 value of 08bf9fc732ea7ad84653bc44714a34b3d9a07f1bdf4daf13c592715c25ec84c6.

If that doesn't help. Maybe this will...

    local body: string = split_string1(fmt("%s", v$value), />/)[1];

### hints

All functions, regardless if they are named or anonymous, are known at runtime to the global_ids() bif.
