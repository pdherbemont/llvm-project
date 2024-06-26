; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=loop-unroll -unroll-count=2 -S | FileCheck %s

; LoopUnroll should unroll this loop into one big basic block.
define void @latch_exit(ptr nocapture %p, i64 %n) nounwind {
; CHECK-LABEL: @latch_exit(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[MUL10:%.*]] = shl i64 [[N:%.*]], 1
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[I_013:%.*]] = phi i64 [ 0, [[ENTRY:%.*]] ], [ [[TMP16_1:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[ARRAYIDX7:%.*]] = getelementptr double, ptr [[P:%.*]], i64 [[I_013]]
; CHECK-NEXT:    [[TMP16:%.*]] = add nuw nsw i64 [[I_013]], 1
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr double, ptr [[P]], i64 [[TMP16]]
; CHECK-NEXT:    [[TMP4:%.*]] = load double, ptr [[ARRAYIDX]], align 8
; CHECK-NEXT:    [[TMP8:%.*]] = load double, ptr [[ARRAYIDX7]], align 8
; CHECK-NEXT:    [[MUL9:%.*]] = fmul double [[TMP8]], [[TMP4]]
; CHECK-NEXT:    store double [[MUL9]], ptr [[ARRAYIDX7]], align 8
; CHECK-NEXT:    [[ARRAYIDX7_1:%.*]] = getelementptr double, ptr [[P]], i64 [[TMP16]]
; CHECK-NEXT:    [[TMP16_1]] = add i64 [[I_013]], 2
; CHECK-NEXT:    [[ARRAYIDX_1:%.*]] = getelementptr double, ptr [[P]], i64 [[TMP16_1]]
; CHECK-NEXT:    [[TMP4_1:%.*]] = load double, ptr [[ARRAYIDX_1]], align 8
; CHECK-NEXT:    [[MUL9_1:%.*]] = fmul double [[TMP4]], [[TMP4_1]]
; CHECK-NEXT:    store double [[MUL9_1]], ptr [[ARRAYIDX7_1]], align 8
; CHECK-NEXT:    [[EXITCOND_1:%.*]] = icmp eq i64 [[TMP16_1]], [[MUL10]]
; CHECK-NEXT:    br i1 [[EXITCOND_1]], label [[FOR_END:%.*]], label [[FOR_BODY]], !llvm.loop [[LOOP0:![0-9]+]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  %mul10 = shl i64 %n, 1
  br label %for.body

for.body:
  %i.013 = phi i64 [ %tmp16, %for.body ], [ 0, %entry ]
  %arrayidx7 = getelementptr double, ptr %p, i64 %i.013
  %tmp16 = add i64 %i.013, 1
  %arrayidx = getelementptr double, ptr %p, i64 %tmp16
  %tmp4 = load double, ptr %arrayidx
  %tmp8 = load double, ptr %arrayidx7
  %mul9 = fmul double %tmp8, %tmp4
  store double %mul9, ptr %arrayidx7
  %exitcond = icmp eq i64 %tmp16, %mul10
  br i1 %exitcond, label %for.end, label %for.body

for.end:
  ret void
}

; Same as previous test case, but with a non-latch exit. There shouldn't
; be a conditional branch after the first block.
define void @non_latch_exit(ptr nocapture %p, i64 %n) nounwind {
; CHECK-LABEL: @non_latch_exit(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[MUL10:%.*]] = shl i64 [[N:%.*]], 1
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[I_013:%.*]] = phi i64 [ 0, [[ENTRY:%.*]] ], [ [[TMP16_1:%.*]], [[LATCH_1:%.*]] ]
; CHECK-NEXT:    [[ARRAYIDX7:%.*]] = getelementptr double, ptr [[P:%.*]], i64 [[I_013]]
; CHECK-NEXT:    [[TMP16:%.*]] = add nuw nsw i64 [[I_013]], 1
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr double, ptr [[P]], i64 [[TMP16]]
; CHECK-NEXT:    [[TMP4:%.*]] = load double, ptr [[ARRAYIDX]], align 8
; CHECK-NEXT:    [[TMP8:%.*]] = load double, ptr [[ARRAYIDX7]], align 8
; CHECK-NEXT:    [[MUL9:%.*]] = fmul double [[TMP8]], [[TMP4]]
; CHECK-NEXT:    store double [[MUL9]], ptr [[ARRAYIDX7]], align 8
; CHECK-NEXT:    br label [[LATCH:%.*]]
; CHECK:       latch:
; CHECK-NEXT:    [[ARRAYIDX7_1:%.*]] = getelementptr double, ptr [[P]], i64 [[TMP16]]
; CHECK-NEXT:    [[TMP16_1]] = add i64 [[I_013]], 2
; CHECK-NEXT:    [[ARRAYIDX_1:%.*]] = getelementptr double, ptr [[P]], i64 [[TMP16_1]]
; CHECK-NEXT:    [[TMP4_1:%.*]] = load double, ptr [[ARRAYIDX_1]], align 8
; CHECK-NEXT:    [[MUL9_1:%.*]] = fmul double [[TMP4]], [[TMP4_1]]
; CHECK-NEXT:    store double [[MUL9_1]], ptr [[ARRAYIDX7_1]], align 8
; CHECK-NEXT:    [[EXITCOND_1:%.*]] = icmp eq i64 [[TMP16_1]], [[MUL10]]
; CHECK-NEXT:    br i1 [[EXITCOND_1]], label [[FOR_END:%.*]], label [[LATCH_1]]
; CHECK:       latch.1:
; CHECK-NEXT:    br label [[FOR_BODY]], !llvm.loop [[LOOP2:![0-9]+]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  %mul10 = shl i64 %n, 1
  br label %for.body

for.body:
  %i.013 = phi i64 [ %tmp16, %latch ], [ 0, %entry ]
  %arrayidx7 = getelementptr double, ptr %p, i64 %i.013
  %tmp16 = add i64 %i.013, 1
  %arrayidx = getelementptr double, ptr %p, i64 %tmp16
  %tmp4 = load double, ptr %arrayidx
  %tmp8 = load double, ptr %arrayidx7
  %mul9 = fmul double %tmp8, %tmp4
  store double %mul9, ptr %arrayidx7
  %exitcond = icmp eq i64 %tmp16, %mul10
  br i1 %exitcond, label %for.end, label %latch

latch:
  br label %for.body

for.end:
  ret void
}
