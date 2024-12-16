lbi r0, 2
lbi r1, 15
st r1, r0, 0      // .Here should have the value 15
ld r2, r0, 0      // r2 = 15
halt
