/* Copyright 2019 SiFive, Inc */
/* SPDX-License-Identifier: Apache-2.0 */

#define METAL_MSTATUS_MIE_SHIFT 8
#define METAL_MSTATUS_MPP_M     3
#define METAL_MSTATUS_MPP_SHIFT 11

#define METAL_MTVEC_MODE_MASK   3

/* void _metal_trap(int ecode)
 *
 * Trigger a machine-mode trap with exception code ecode
 */
#ifdef __IASMRISCV__
#include "iarMacros.m"
#include "iarCfi.m"

      MODULE  ?trap

      PUBLIC _metal_trap

      SECTION `.text`:CODE:NOROOT(2)
      CODE
 /*.type _metal_trap, @function*/
#else    
 
.global _metal_trap
.type _metal_trap, @function
#endif

_metal_trap:

    /* Store the instruction which called _metal_trap in mepc */
    addi t0, ra, -1
    csrw mepc, t0

    /* Set mcause to the desired exception code */
    csrw mcause, a0

    /* Read mstatus */
    csrr t0, mstatus

    /* Set MIE=0 */
    li t1, -1
    xori t1, t1, METAL_MSTATUS_MIE_SHIFT
    and t0, t0, t1

    /* Set MPP=M */
    li t1, METAL_MSTATUS_MPP_M
    slli t1, t1, METAL_MSTATUS_MPP_SHIFT
    or t0, t0, t1

    /* Write mstatus */
    csrw mstatus, t0

    /* Read mtvec */
    csrr t0, mtvec

    /*
     * Mask the mtvec MODE bits
     * Exceptions always jump to mtvec.BASE regradless of the vectoring mode.
     */
    andi t0, t0, METAL_MTVEC_MODE_MASK

    /* Jump to mtvec */
    jr t0


/*
 * For sanity's sake we set up an early trap vector that just does nothing.
 * If you end up here then there's a bug in the early boot code somewhere.
 */
#ifdef __IASMRISCV__
      SECTION `.text.metal.init.trapvec`:CODE:NOROOT(2)
      CODE
      PUBLIC early_trap_vector
       
early_trap_vector:
    csrr t0, mcause
    csrr t1, mepc
    csrr t2, mtval
    j early_trap_vector

#else
.section .text.metal.init.trapvec
.global early_trap_vector
.align 2
early_trap_vector:
    .cfi_startproc
    csrr t0, mcause
    csrr t1, mepc
    csrr t2, mtval
    j early_trap_vector
    .cfi_endproc
#endif

#ifdef __IASMRISCV__
    END
#endif
