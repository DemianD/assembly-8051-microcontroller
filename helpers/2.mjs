import { printStack, printMemory, push, mov, SP, dec, jnz, pop, ret, callable, call, inc, mul } from "./index";

callable.fac = () => {
  push("00H");
  
  mov("R0", SP());
  
  dec("R0");
  dec("R0");
  dec("R0");
  
  mov("A", "@R0", true);
  printStack();
  printMemory();

  if (jnz("rec")) {
    console.log('\n\n');
    mov("B", 1);
    pop("00H");
    ret();
  }
};

callable.rec = () => {
  
  dec("A");
  
  push("Acc");
  
  call("fac");

  printStack();
  
  pop("Acc");
  inc("A");

  printStack();
  printMemory();

  mul("A", "B");
  mov("B", "A");
  pop("00H");

  ret();
};

  printStack();
  printMemory();

mov("R0", 3);
push("00H");
printStack();

call("fac");
printStack();

  printMemory();