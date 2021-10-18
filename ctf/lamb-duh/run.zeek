
local globals = global_ids();

local hash_to_find = "08bf9fc732ea7ad84653bc44714a34b3d9a07f1bdf4daf13c592715c25ec84c6";

for (idx in globals)
    {
    if (find_str(idx, "lambda_") != -1)
        {
        local complete_function = fmt("%s", globals[idx]);

        if (find_str(complete_function, "{") != -1) # has body
            {
            # local body: string = split_string1(fmt("%s", v$value), />/)[1];
            local body: string = split_string1(fmt("%s", complete_function), />/)[1];
            body = split_string1(body, /]/)[0];
            local hash = sha256_hash(body);

            if (hash == hash_to_find)
                {
                print fmt("function name: '%s'", idx);
                print fmt("'%s'", body);
                }
            }
        }
    }

# ---------------------------------------------
# function name: 'RDP::lambda_<2597878830023449760>'
# [type_name=func, exported=F, constant=T, enum_constant=F, option_value=F, redefinable=F, broker_backend=F, value=lambda_<2597878830023449760>\x0a{ \x0areturn (fmt(failure_code-%d, RDP::n));\x0a}]
# -----------
# \x0a{ \x0areturn (fmt(failure_code-%d, RDP::n));\x0a}
# ---------------------------------------------

# const failure_codes = {
#     [0x01] = "SSL_REQUIRED_BY_SERVER",
#     [0x02] = "SSL_NOT_ALLOWED_BY_SERVER",
#     [0x03] = "SSL_CERT_NOT_ON_SERVER",
#     [0x04] = "INCONSISTENT_FLAGS",
#     [0x05] = "HYBRID_REQUIRED_BY_SERVER",
#     [0x06] = "SSL_WITH_USER_AUTH_REQUIRED_BY_SERVER"
# } &default = function(n: count): string { return fmt("failure_code-%d", n); };

local bla: count = 0x05;
print "2";
# print failure_codes[0x05];

function test12345()
function test1234(thingy: count): string {
    return fmt("failure_code-%d", n);
};

# print test(0x05);

# fout:
# HYBRID_REQUIRED_BY_SERVER
# failure_code-HYBRID_REQUIRED_BY_SERVER
