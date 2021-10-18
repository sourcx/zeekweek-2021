const failure_codes = {
    [0x01] = "SSL_REQUIRED_BY_SERVER",
    [0x02] = "SSL_NOT_ALLOWED_BY_SERVER",
    [0x03] = "SSL_CERT_NOT_ON_SERVER",
    [0x04] = "INCONSISTENT_FLAGS",
    [0x05] = "HYBRID_REQUIRED_BY_SERVER",
    [0x06] = "SSL_WITH_USER_AUTH_REQUIRED_BY_SERVER"
} &default = function(n: count): string { return fmt("failure_code-%d", n); };

function test(n: count): string {
    return fmt("failure_code-%d", n);
};

print test(0x05);
