jal .test1

jal .test2
jal .test3
jal .test4
halt


.test1:

jalr r7, 0

.test2:
lbi r3, 255 //c
slbi r3, 255
jalr r7, 0

.test3:

jalr r7, 0

.test4:

jalr r7, 0
