; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --version 4
; RUN: opt -mtriple=amdgcn-amd-amdhsa -S -passes=inline < %s | FileCheck %s
; RUN: opt -mtriple=amdgcn-amd-amdhsa -S -passes='cgscc(inline)' < %s | FileCheck %s

; Ensure that custom metadata survives inlining

define i32 @atomic_xor(ptr addrspace(1) %ptr, i32 %val) {
; CHECK-LABEL: define i32 @atomic_xor(
; CHECK-SAME: ptr addrspace(1) [[PTR:%.*]], i32 [[VAL:%.*]]) {
; CHECK-NEXT:    [[RES:%.*]] = atomicrmw xor ptr addrspace(1) [[PTR]], i32 [[VAL]] monotonic, align 4, !amdgpu.no.fine.grained.memory [[META0:![0-9]+]], !amdgpu.no.remote.memory [[META0]]
; CHECK-NEXT:    ret i32 [[RES]]
;
  %res = atomicrmw xor ptr addrspace(1) %ptr, i32 %val monotonic, !amdgpu.no.fine.grained.memory !0, !amdgpu.no.remote.memory !0
  ret i32 %res
}

define i32 @caller(ptr addrspace(1) %ptr, i32 %val) {
; CHECK-LABEL: define i32 @caller(
; CHECK-SAME: ptr addrspace(1) [[PTR:%.*]], i32 [[VAL:%.*]]) {
; CHECK-NEXT:    [[RES_I:%.*]] = atomicrmw xor ptr addrspace(1) [[PTR]], i32 [[VAL]] monotonic, align 4, !amdgpu.no.fine.grained.memory [[META0]], !amdgpu.no.remote.memory [[META0]]
; CHECK-NEXT:    ret i32 [[RES_I]]
;
  %res = call i32 @atomic_xor(ptr addrspace(1) %ptr, i32 %val)
  ret i32 %res
}

!0 = !{}
;.
; CHECK: [[META0]] = !{}
;.
