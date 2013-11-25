 enum readState {
    SYNC1,
    SYNC2,
    LENGTH,
    DATA,
    CHECKSUM
  };

  enum dongleState {
    DISCONNECTED,
    STANDBY,
    CONNECTED
  };
