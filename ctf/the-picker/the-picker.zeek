
redef exit_only_after_terminate = T;

module Lock;
export {
  # A pin is essentially an arc on a circle with a start and stop angle
  type Pin: record {
    start: int;
    stop: int;
  };

  # A tumbler is a circle
  type Tumbler: record {
    # It spins either in the clockwise or counter-clockwise direction.
    direction: bool;

    # Each tumbler rotates a certain distance each time it is spinned.
    distance: count;

    # Each tumbler causes a spin to occur every ttime
    ttime: interval;

    # Each tumbler has some number of Pins
    pins: vector of Lock::Pin;
  };

  # An event which spins a lock's tumblers
  global spin: event(tumbler: Lock::Tumbler);

  # An event which attempts to pick the lock. This requires syzygy of some combination
  #  of tumblers' pins.
  global pick: event(lock: vector of Lock::Tumbler);

  # Global counters for the number of spins and the amount of time which has passed.
  global spins: count = 0;
  global ticks: interval = 0secs;
}

event Lock::spin(tumbler: Lock::Tumbler) {
  local distance: count = tumbler$distance;
  local pins: vector of Lock::Pin = tumbler$pins;
  local direction: int = tumbler$direction ? 1 : -1;

  for (idx in pins) {
    local p: Lock::Pin = pins[idx];
    p$start = (p$start + (distance * direction)) % 360;
    if (p$start < 0) { p$start += 360; }
    p$stop = (p$stop + (distance * direction)) % 360;
    if (p$stop < 0) { p$stop += 360; }
  }
  tumbler$pins = pins;
  Lock::spins += 1;

  schedule tumbler$ttime { Lock::spin(tumbler) };
}

# This function starts the spinning of the lock's tumblers and ensures the tumblers keep spinning
function start_spinning(lock: vector of Lock::Tumbler) {
  for (idx in lock) {
    local t: Lock::Tumbler = lock[idx];
    schedule t$ttime { Lock::spin(t) };
  }
}

global last_spin = 0;

# (t2p1$start >= t1p1$start && t2p1$stop <= t1p1$stop)

  # t1p1  10   15     190   195   195-190 = 5
  # t2p2  350  20     170   200   200-170 = 30
  #
  # 200-195 = 5
  # 170-190 = -20
  #
  # t2p2  350  20     170   200   200-170 = 30
  # t1p1  10   15     190   195   195-190 = 5

function match(pin1: Lock::Pin, pin2: Lock::Pin): bool
    {
    local x1 = ( pin1$start + 180 ) % 360;
    local y1 = ( pin1$stop + 180 ) % 360;
    local x2 = ( pin2$start + 180 ) % 360;
    local y2 = ( pin2$stop + 180 ) % 360;

    if ((x2 <= x1 && y2 >= y1) || (x1 <= x2 && y1 >= y2))
        {
        return T;
        }

    return F;
    }

event Lock::pick(lock: vector of Lock::Tumbler) {
  ####
  #
  # YOU MAY IT USEFUL TO FILL OUT THIS EVENT'S BODY
  #
  ####
  if (last_spin != Lock::spins)
    {
      last_spin = Lock::spins;
    }
  else
    {
    Lock::ticks += 1msec;
    schedule 1msec { Lock::pick(lock) };
    return;
    }

  # print fmt("lock, Lock::spins: %s, pick_count: %s", Lock::spins, pick_count);
  # pick_count = pick_count + 1;

  # for (idx in lock) {
  #   local tumbler = lock[idx];
  #   print fmt("tumbler %s", idx);
  #   print tumbler;
  # }
  # print "";

  local pin_1 = "0"; # index of correct pin on tumbler 1,2,3,4
  local pin_2 = "?";
  local pin_3 = "?";
  local pin_4 = "?";

  local t1p1 = lock[0]$pins[0];
  local t2p1 = lock[1]$pins[0];
  local t2p2 = lock[1]$pins[1];
  local t3p1 = lock[2]$pins[0];
  local t3p2 = lock[2]$pins[1];
  local t3p3 = lock[2]$pins[2];
  local t4p1 = lock[3]$pins[0];
  local t4p2 = lock[3]$pins[1];
  local t4p3 = lock[3]$pins[2];
  local t4p4 = lock[3]$pins[3];

  # tumbler2 pins matches tumbler1
  if ((match(t2p1, t1p1) == T) || (match(t2p2, t1p1) == T))
      {
      if (match(t2p1, t1p1) == T)
          {
          pin_2 = "0";
          }
      else
          {
          pin_2 = "1";
          }
      }
  else
      {
      Lock::ticks += 1msec;
      schedule 1msec { Lock::pick(lock) };
      return;
      }

  # tumbler3 pins matches tumbler1
  if ((match(t3p1, t1p1) == T) || (match(t3p2, t1p1) == T) || (match(t3p3, t1p1) == T))
      {
      if ((match(t3p1, t1p1) == T))
          {
          pin_3 = "0";
          }
      else if ((match(t3p2, t1p1) == T))
          {
          pin_3 = "1";
          }
      else
          {
          pin_3 = "2";
          }
      }
  else
      {
      Lock::ticks += 1msec;
      schedule 1msec { Lock::pick(lock) };
      return;
      }

  # one the tumbler4 pins matches
  if ((match(t4p1, t1p1) == T) || (match(t4p2, t1p1) == T) || (match(t4p3, t1p1) == T) || (match(t4p4, t1p1) == T))
      {
      if ((match(t4p1, t1p1) == T))
          {
          pin_4 = "0";
          }
      else if ((match(t4p2, t1p1) == T))
          {
          pin_4 = "1";
          }
      else if ((match(t4p3, t1p1) == T))
          {
          pin_4 = "2";
          }
      else
          {
          pin_4 = "3";
          }
      }
  else
      {
      Lock::ticks += 1msec;
      schedule 1msec { Lock::pick(lock) };
      return;
      }

  # wrong: 44-0100, 158-0123, 10-0101
  print fmt("pincode = '%s-%s%s%s%s'", Lock::spins, pin_1, pin_2, pin_3, pin_4);
  print t1;
  print t2;
  print t3;
  print t4;

  # pick again
  Lock::ticks += 1msec;
  schedule 1msec { Lock::pick(lock) };
}

event zeek_init() {
  # 1, 5 degree pins
  local p0_0: Lock::Pin = [$start=0, $stop=5];
  local t0: Lock::Tumbler = [$direction=F, $distance=10, $ttime=347msecs, $pins=vector(p0_0)];

  # 2, 35 degree pins
  local p1_0: Lock::Pin = [$start=90, $stop=125];
  local p1_1: Lock::Pin = [$start=120, $stop=175];
  local t1: Lock::Tumbler = [$direction=T, $distance=15, $ttime=457msecs, $pins=vector(p1_0, p1_1)];

  # 3, 35 degree pins
  local p2_0: Lock::Pin = [$start=40, $stop=75];
  local p2_1: Lock::Pin = [$start=70, $stop=105];
  local p2_2: Lock::Pin = [$start=100, $stop=135];
  local t2: Lock::Tumbler = [$direction=F, $distance=45, $ttime=701msecs, $pins=vector(p2_0, p2_1, p2_2)];

  # 4, 40 degree pins
  local p3_0: Lock::Pin = [$start=205, $stop=245];
  local p3_1: Lock::Pin = [$start=265, $stop=305];
  local p3_2: Lock::Pin = [$start=325, $stop=5];
  local p3_3: Lock::Pin = [$start=30, $stop=70];
  local t3: Lock::Tumbler = [$direction=T, $distance=35, $ttime=1571msecs, $pins=vector(p3_0, p3_1, p3_2, p3_3)];

  # a lock is a set of concentric tumblers.
  # tumblers are circles.
  # pins are conceptually circle arcs.
  local lock = vector(t0, t1, t2, t3);

  # Start spinning the lock's tumblers.
  Lock::start_spinning(lock);

  # If the lock spins for longer than 60 secs, you've missed the first pin alignment.
  # When should you try picking the lock? There's no time like the present.
  schedule 0msec { Lock::pick(lock) };
}
