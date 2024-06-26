# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=aarch64 -mcpu=tsv110 --instruction-info=0 --resource-pressure=0 --timeline --iterations=1 < %s | FileCheck %s

# LLVM-MCA-BEGIN madd nobypass
mul  x0, x1, x2
add  x0, x0, x1
add  x0, x0, x1
add  x0, x0, x1
# LLVM-MCA-END

# LLVM-MCA-BEGIN madd bypass
mul  x0, x1, x2
madd x0, x1, x2, x0
madd x0, x1, x2, x0
madd x0, x0, x0, x0
# LLVM-MCA-END

# CHECK:      [0] Code Region - madd nobypass

# CHECK:      Iterations:        1
# CHECK-NEXT: Instructions:      4
# CHECK-NEXT: Total Cycles:      10
# CHECK-NEXT: Total uOps:        4

# CHECK:      Dispatch Width:    4
# CHECK-NEXT: uOps Per Cycle:    0.40
# CHECK-NEXT: IPC:               0.40
# CHECK-NEXT: Block RThroughput: 1.0

# CHECK:      Timeline view:
# CHECK-NEXT: Index     0123456789

# CHECK:      [0,0]     DeeeeER  .   mul	x0, x1, x2
# CHECK-NEXT: [0,1]     D====eER .   add	x0, x0, x1
# CHECK-NEXT: [0,2]     D=====eER.   add	x0, x0, x1
# CHECK-NEXT: [0,3]     D======eER   add	x0, x0, x1

# CHECK:      Average Wait times (based on the timeline view):
# CHECK-NEXT: [0]: Executions
# CHECK-NEXT: [1]: Average time spent waiting in a scheduler's queue
# CHECK-NEXT: [2]: Average time spent waiting in a scheduler's queue while ready
# CHECK-NEXT: [3]: Average time elapsed from WB until retire stage

# CHECK:            [0]    [1]    [2]    [3]
# CHECK-NEXT: 0.     1     1.0    1.0    0.0       mul	x0, x1, x2
# CHECK-NEXT: 1.     1     5.0    0.0    0.0       add	x0, x0, x1
# CHECK-NEXT: 2.     1     6.0    0.0    0.0       add	x0, x0, x1
# CHECK-NEXT: 3.     1     7.0    0.0    0.0       add	x0, x0, x1
# CHECK-NEXT:        1     4.8    0.3    0.0       <total>

# CHECK:      [1] Code Region - madd bypass

# CHECK:      Iterations:        1
# CHECK-NEXT: Instructions:      4
# CHECK-NEXT: Total Cycles:      12
# CHECK-NEXT: Total uOps:        4

# CHECK:      Dispatch Width:    4
# CHECK-NEXT: uOps Per Cycle:    0.33
# CHECK-NEXT: IPC:               0.33
# CHECK-NEXT: Block RThroughput: 4.0

# CHECK:      Timeline view:
# CHECK-NEXT:                     01
# CHECK-NEXT: Index     0123456789

# CHECK:      [0,0]     DeeeeER   ..   mul	x0, x1, x2
# CHECK-NEXT: [0,1]     D==eeeeER ..   madd	x0, x1, x2, x0
# CHECK-NEXT: [0,2]     D=eeeeE-R ..   madd	x0, x1, x2, x0
# CHECK-NEXT: [0,3]     D=====eeeeER   madd	x0, x0, x0, x0

# CHECK:      Average Wait times (based on the timeline view):
# CHECK-NEXT: [0]: Executions
# CHECK-NEXT: [1]: Average time spent waiting in a scheduler's queue
# CHECK-NEXT: [2]: Average time spent waiting in a scheduler's queue while ready
# CHECK-NEXT: [3]: Average time elapsed from WB until retire stage

# CHECK:            [0]    [1]    [2]    [3]
# CHECK-NEXT: 0.     1     1.0    1.0    0.0       mul	x0, x1, x2
# CHECK-NEXT: 1.     1     3.0    3.0    0.0       madd	x0, x1, x2, x0
# CHECK-NEXT: 2.     1     2.0    2.0    1.0       madd	x0, x1, x2, x0
# CHECK-NEXT: 3.     1     6.0    0.0    0.0       madd	x0, x0, x0, x0
# CHECK-NEXT:        1     3.0    1.5    0.3       <total>
