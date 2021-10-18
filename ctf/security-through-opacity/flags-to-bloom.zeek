# redef exit_only_after_terminate = T;

module GLOBAL;
# export {
#   global add_flag: event(flag: string);
#   global bf = bloomfilter_basic_init(0.0000001, 500000);
# }

# event add_flag(flag: string) {
#   bloomfilter_add(GLOBAL::bf, flag);
#   print "flag addded";
# }

# event zeek_done() {
#   print Broker::data(GLOBAL::bf);
# }

event zeek_init() {
  local bf2 = bloomfilter_basic_init(0.0000001, 500000);
  bloomfilter_add(bf2, "aaaa");
  print bloomfilter_internal_state(bf2);
  # print Broker::data(bf2);
  for (i in bf2)
  {
    print bf2[i];
  }

  # Broker::subscribe("/topic/test");
  # Broker::listen("127.0.0.1", 9999/tcp);
}
