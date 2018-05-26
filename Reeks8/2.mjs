import { log, push, mov, SP, dec, jnz, pop, ret, callable, call, inc, mul } from "../modules/index";

callable.fac = () => {
  push("00H");

  mov("R0", SP());

  dec("R0");
  dec("R0");
  dec("R0");

  mov("A", "@R0", true);

  if (jnz("rec")) {
    mov("B", 1);
    pop("00H");
    ret();
  }
};

callable.rec = () => {
  dec("A");

  push("Acc");

  call("fac");

  pop("Acc");

  inc("A");
  mul("A", "B");
  mov("B", "A");
  pop("00H");
  ret();
};

mov("R0", 4);
push("00H");
call("fac");
log();
