$include (c8051f120.inc)

cseg at 0000H
  jmp main

cseg at 0050H

main:
  clr EA
  mov WDTCN, #0DEh
  mov WDTCN, #0DAh
  setb EA

  mov R0, #10d
  push 00h
  call fac
  mov SP, #07h

  jmp $

fac:
  push 00h
  mov R0, SP
  dec R0
  dec R0
  dec R0

  mov A, @R0

  jnz rec
  mov B, #01d

  pop 00h
  ret

rec:
  dec A
  push Acc
  call fac
  pop Acc
  inc A
  mul AB
  mov B,A
  pop 00h
  ret