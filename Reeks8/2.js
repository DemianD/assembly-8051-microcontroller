const stack = [];
const memory = {};
const callable = {};

const normalize = addr => {
  if (addr === "Acc") {
    return "A";
  }

  if (typeof addr === "string" && addr.startsWith("R")) {
    return `0${addr[1]}H`;
  }

  return addr;
};

const push = addr => {
  addr = normalize(addr);
  stack.push(memory[addr]);
};

const pop = addr => {
  addr = normalize(addr);
  memory[addr] = stack.pop();
};

const SP = () => stack.length - 1;

const mov = (addr, value, fromStack) => {
  addr = normalize(addr);

  if (typeof value === "string" && value.startsWith("@")) {
    value = normalize(value.substr(1));
    value = fromStack ? stack[memory[value]] : memory[value];
  }
  if (value === "B" || value === "A") {
    memory[addr] = memory[value];
  }
  else {
    memory[addr] = value;
  }
};

const call = label => {
  stack.push("PC2 " + label);
  stack.push("PC1 " + label);

  callable[label]();
};

const jmp = label => {
  callable[label]();
};

const dec = addr => {
  addr = normalize(addr);
  memory[addr]--;
};

const inc = addr => {
  addr = normalize(addr);
  memory[addr]++;
};

const mul = (A, B) => {
  memory["A"] = memory["A"] * memory["B"]
};

const jnz = label => {
  if (memory["A"]) {
    jmp(label);
    return false;
  }
  return true;
};

const ret = () => {
  stack.pop();
  stack.pop();
};

callable.fac = () => {
  log("fac: ");
  push("00H");
  
  mov("R0", SP());
  
  dec("R0");
  dec("R0");
  dec("R0");
  
  mov("A", "@R0", true);
  
  if(jnz("rec")) {
    mov("B", 1);
  
    pop("00H");
    log("fac: ");
    
    ret();
  }
};

callable.rec = () => {
  dec("A");
  
  push("Acc");  

  call("fac");
  log("rec: ");
  
  pop("Acc");

  inc("A");
  mul("A", "B");
  mov("B", "A");
  pop("00H");
  ret();
};

const log = (prefix = "") => {
  if(stack.length !== 0) {
    console.log(prefix, stack.reduce((acc, el) => acc = `${acc}     ${el}`));
  }
  else {
    console.log(prefix, "stack empty");
  }
  console.log(prefix, memory);
  console.log("-------------");
};

mov("R0", 4);
push("00H");
log();
call("fac");
log();
